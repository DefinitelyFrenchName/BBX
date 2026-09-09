#!/usr/bin/env python3
"""recount.py — re-run every count in one census file at the HEAD it was measured at.

A census file (docs/census/<repo>.md) records, on line 1, the repository's HEAD
(`@ <sha>`), on line 2 the repository's local path (the first backtick span
that starts with `/`), and in its `## A. Counts` table one row per count:

    | A<n> | <dimension> | <count> | <command (run from repo root)> |

A row is RECOUNTABLE when its count cell is a plain integer (commas and bold
markers allowed) or a single backtick-quoted string, and its command cell
opens with a backtick-quoted shell pipeline. The pipeline is run with `sh -c`
from the repository root and its stripped stdout is compared to the count.
Every other row is NOT-RECOUNTABLE and is counted and named — never passed.

THE TREE IS NEVER WRITTEN (ruling R18, 2026-09-09: "census and tests should
either work on a clone or, if impossible, make very explicit that no change
to the tree should be done"). The rows do not run in the repository's working
tree: the recorded commit is exported as a SHARED CLONE under TMPDIR
(`git clone --shared --no-checkout` + `checkout <head>`: reads the repository's
objects, writes nothing under its `.git`, never `git worktree add`), every
command runs there, and the clone is removed. So the census stays true of the
commit it names while the repository's own tree moves under other hands (the
first day of BBX saw VampireSaved's porcelain move 373 -> 377 during one
sitting). The recorded HEAD must exist as a commit in the repository;
otherwise nothing is recounted ("HEAD unknown"). A command that names the
repository's absolute path is REFUSED: it is the one way a row could reach
past the clone. `--in-place` runs in the working tree instead (READ-ONLY by
contract, unproved) and then the HEAD must be the recorded one ("HEAD moved").

DRIFT is reported, never fatal: when the repository's tip is not the recorded
HEAD, the rows are run once more on a clone of the tip and the rows whose
value moved are printed as one NOTE-class line (`NOTE: drift ...`), which the
runner lists under "NOTE-class numbers". A moved lineage is a fact about the
lineage; a rotted census (mismatch at the recorded HEAD) is a fact about BBX.
The porcelain line count of the repository's own tree is reported beside the
tip so a dirty tree is visible in the readout, never hidden.

Output is one line per row, parsed by field name:
    row=A1 verdict=MATCH expected=190 got=190 exit=0
and one summary line:
    census=bbh.md head=f675710 tree=clone tip=f6757105dffc ahead=0 porcelain=4 rows=79 match=79 mismatch=0 refused=0 not_recountable=0 nonzero_exit=1

Exit: 0 every recountable row matched at the recorded HEAD and no row was
refused; 1 HEAD unknown (or moved, in place), a row mismatched, timed out or
was refused; 2 the census file or the repository root is unreadable, or the
clone could not be made (could not measure — a different finding from
measured wrong).

Lineage: SMS checkdocs.py (quote the claim → derive → compare; coverage
printed), bbh's fidelity mechanism (capture, compare, diff). First BBX tool,
slice S1, 2026-09-09. Ruled R9, R14.
"""
import argparse
import os
import re
import shutil
import subprocess
import sys
import tempfile

HEAD_RE = re.compile(r"@ ([0-9a-f]{7,40})")
ROOT_RE = re.compile(r"`(/[^`]*)`")
INT_RE = re.compile(r"^[0-9][0-9,]*$")
STR_RE = re.compile(r"^`([^`]*)`$")
CMD2_RE = re.compile(r"^\s*``(.+?)``")
CMD_RE = re.compile(r"^\s*`([^`]+)`")


CELL_SPLIT = re.compile(r"(?<!\\)\|")


def split_cells(line):
    """Split a table row on unescaped pipes and unescape `\\|` in every cell.

    The census grammar (docs/census/README.md): every pipe inside a cell is
    written `\\|`, code spans included; a regex that needs a literal pipe writes
    a bracket expression `[\\|]`; a command containing a backtick is wrapped in a
    double-backtick span. So the reader never has to know where a code span is."""
    return [c.replace("\\|", "|") for c in CELL_SPLIT.split(line)]


def parse_census(path):
    """Return (head, root, rows) where rows are (id, count_cell, command_cell)."""
    with open(path, encoding="utf-8") as f:
        lines = f.read().split("\n")
    if len(lines) < 2:
        raise ValueError("census file shorter than two lines")
    m = HEAD_RE.search(lines[0])
    if not m:
        raise ValueError("line 1 carries no `@ <head>`")
    head = m.group(1)
    m = ROOT_RE.search(lines[1])
    if not m:
        raise ValueError("line 2 carries no backtick-quoted absolute path")
    root = m.group(1)
    rows = []
    in_a = False
    for line in lines:
        if line.startswith("## A."):
            in_a = True
            continue
        if in_a and line.startswith("## "):
            break
        if not in_a or not line.startswith("| A"):
            continue
        cells = split_cells(line)
        if len(cells) != 6:
            rows.append((line.split("|")[1].strip(), None, None))
            continue
        rows.append((cells[1].strip(), cells[3].strip(), cells[4].strip()))
    return head, root, rows


def classify(count_cell, command_cell):
    """Return (kind, expected, command) — kind is 'int', 'str' or None."""
    if count_cell is None:
        return None, None, None
    cmd = CMD2_RE.match(command_cell) or CMD_RE.match(command_cell)
    if not cmd:
        return None, None, None
    command = cmd.group(1)
    bare = count_cell.strip("*").strip()
    if INT_RE.match(bare):
        return "int", int(bare.replace(",", "")), command
    s = STR_RE.match(bare)
    if s:
        return "str", s.group(1), command
    return None, None, None


def git(root, *args):
    return subprocess.run(["git", "-C", root] + list(args), capture_output=True,
                          text=True, timeout=60).stdout.strip()


HERMETIC_PATH = "/usr/bin:/bin:/usr/sbin:/sbin"


def hermetic_env():
    """The environment every census command runs in — the same on every host.

    A count that depends on which program answers to the name `grep` is a
    count about the caller's shell, not about the repository: the first
    recount found the census measured through an interactive shell whose
    `grep` was ugrep (skips ignored files and archives) while `sh -c`
    resolved BSD grep (reads everything), and six counts moved. So the PATH
    is pinned to the system directories (docs/defaults.md D6), the locale is
    fixed, and nothing else from the caller's shell reaches the command
    (bbh [BBH-35])."""
    return {"PATH": HERMETIC_PATH, "LANG": "C.UTF-8", "LC_ALL": "C.UTF-8",
            "HOME": os.environ.get("HOME", "/"), "TMPDIR": os.environ.get("TMPDIR", "/tmp"),
            "PYTHONDONTWRITEBYTECODE": "1"}


def run_row(command, root, timeout):
    """Return (got, exit_status, timed_out)."""
    try:
        p = subprocess.run(["sh", "-c", command], cwd=root, capture_output=True,
                           text=True, timeout=timeout, env=hermetic_env())
    except subprocess.TimeoutExpired:
        return "", None, True
    return p.stdout.strip(), p.returncode, False


def compare(kind, expected, got):
    if kind == "int":
        return INT_RE.match(got or "x") is not None and int(got.replace(",", "")) == expected
    return got == expected


def commit_known(root, head):
    """True when <head> names a commit in the repository (the recorded HEAD exists)."""
    p = subprocess.run(["git", "-C", root, "cat-file", "-e", head + "^{commit}"],
                       capture_output=True, text=True, timeout=60)
    return p.returncode == 0


def make_clone(root, head):
    """A shared clone of <root> checked out at <head>, under TMPDIR; the caller removes it.

    `--shared` borrows the repository's object store through an alternates
    file inside the CLONE; nothing is written under the repository's own
    `.git` (a `git worktree add` would be). Returns (dir, error)."""
    d = tempfile.mkdtemp(prefix="bbx_recount_", dir=os.environ.get("TMPDIR") or "/tmp")
    for cmd in (["git", "clone", "-q", "--shared", "--no-checkout", root, d],
                ["git", "-C", d, "checkout", "-q", head]):
        p = subprocess.run(cmd, capture_output=True, text=True, timeout=600)
        if p.returncode != 0:
            shutil.rmtree(d, ignore_errors=True)
            return None, (p.stderr.strip().splitlines() or ["?"])[-1]
    return d, None


def run_rows(rows, where, root_abs, timeout, quiet=False):
    """Run every row in <where>; return (stats, values) where values maps id -> got."""
    st = {"match": 0, "mismatch": 0, "refused": 0, "not_recountable": 0, "nonzero": 0, "not_names": []}
    values = {}
    for rid, count_cell, command_cell in rows:
        kind, expected, command = classify(count_cell, command_cell)
        if kind is None:
            st["not_recountable"] += 1
            st["not_names"].append(rid)
            quiet or print(f"row={rid} verdict=NOT-RECOUNTABLE count={count_cell!r}")
            continue
        if root_abs and root_abs in command:
            st["refused"] += 1
            quiet or print(f"row={rid} verdict=REFUSED reason=names-the-tree path={root_abs}")
            continue
        got, status, timed_out = run_row(command, where, timeout)
        if timed_out:
            st["mismatch"] += 1
            quiet or print(f"row={rid} verdict=TIMEOUT expected={expected!r} timeout={timeout}")
            continue
        values[rid] = got
        if status != 0:
            st["nonzero"] += 1
        if compare(kind, expected, got):
            st["match"] += 1
            quiet or print(f"row={rid} verdict=MATCH expected={expected!r} got={got!r} exit={status}")
        else:
            st["mismatch"] += 1
            quiet or print(f"row={rid} verdict=MISMATCH expected={expected!r} got={got[:80]!r} exit={status}")
    return st, values


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("census")
    ap.add_argument("--root", help="override the repository root recorded on line 2")
    ap.add_argument("--only", help="comma-separated row ids to re-run (the rest are skipped, not counted; no drift run)")
    ap.add_argument("--in-place", action="store_true",
                    help="run in the repository's working tree instead of a clone (read-only by contract, unproved); "
                         "the HEAD must then be the recorded one")
    ap.add_argument("--timeout", type=int, default=int(os.environ.get("BBX_CENSUS_TIMEOUT", "60")),
                    help="seconds per command (default 60; docs/defaults.md D1)")
    a = ap.parse_args(argv)
    name = os.path.basename(a.census)

    try:
        head, root, rows = parse_census(a.census)
    except (OSError, ValueError) as e:
        print(f"census={name} error=unreadable detail={e}")
        return 2
    if a.root:
        root = a.root
    if not os.path.isdir(os.path.join(root, ".git")) and not os.path.isfile(os.path.join(root, ".git")):
        print(f"census={name} error=no-repository root={root}")
        return 2
    root_abs = os.path.realpath(root)

    full = git(root, "rev-parse", "HEAD")
    porc = git(root, "status", "--porcelain")
    porcelain = len(porc.splitlines())
    only = set(a.only.split(",")) if a.only else None
    if only:
        rows = [r for r in rows if r[0] in only]

    clones = []
    try:
        if a.in_place:
            if not full.startswith(head):
                print(f"census={name} head={head} repo_head={full[:12]} verdict=HEAD-MOVED rows={len(rows)}")
                print("HEAD moved: in place, the census describes a tree that is not the one at the recorded root; nothing recounted")
                return 1
            where, tree = root, "in-place"
        else:
            if not commit_known(root, head):
                print(f"census={name} head={head} repo_head={full[:12]} verdict=HEAD-UNKNOWN rows={len(rows)}")
                print("HEAD unknown: the recorded commit is not in the repository; nothing recounted")
                return 1
            where, err = make_clone(root, head)
            if where is None:
                print(f"census={name} head={head} error=clone-failed detail={err}")
                return 2
            clones.append(where)
            tree = "clone"

        st, values = run_rows(rows, where, root_abs if tree == "clone" else None, a.timeout)

        ahead = 0
        if not full.startswith(head):
            ahead = int(git(root, "rev-list", "--count", f"{head}..{full}") or "0")
        if tree == "clone" and ahead and not only:
            tip, err = make_clone(root, full)
            if tip is None:
                print(f"NOTE: drift census={name} recorded={head} tip={full[:12]} ahead={ahead} rows_moved=? (tip clone failed: {err})")
            else:
                clones.append(tip)
                _, tip_values = run_rows(rows, tip, root_abs, a.timeout, quiet=True)
                moved = [rid for rid in values if tip_values.get(rid) != values[rid]]
                print(f"NOTE: drift census={name} recorded={head} tip={full[:12]} ahead={ahead} "
                      f"rows_moved={len(moved)} ids={','.join(moved) or '-'}")

        print(f"census={name} head={head} tree={tree} tip={full[:12]} ahead={ahead} porcelain={porcelain} "
              f"rows={len(rows)} match={st['match']} mismatch={st['mismatch']} refused={st['refused']} "
              f"not_recountable={st['not_recountable']} nonzero_exit={st['nonzero']} path={HERMETIC_PATH}")
        if st["not_names"]:
            print(f"not_recountable_ids={','.join(st['not_names'])}")
        return 1 if (st["mismatch"] or st["refused"]) else 0
    finally:
        for d in clones:
            shutil.rmtree(d, ignore_errors=True)


if __name__ == "__main__":
    sys.exit(main())
