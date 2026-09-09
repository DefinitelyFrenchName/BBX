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

Before any row runs, the repository's HEAD must start with the recorded one;
otherwise the file describes a tree that no longer exists and every row is
refused ("HEAD moved"). The porcelain line count is reported beside it so a
dirty tree is visible in the readout, never hidden.

Output is one line per row, parsed by field name:
    row=A1 verdict=MATCH expected=190 got=190 exit=0
and one summary line:
    census=bbh.md head=f675710 porcelain=4 rows=79 match=79 mismatch=0 not_recountable=0 nonzero_exit=1

Exit: 0 every recountable row matched and HEAD is current; 1 HEAD moved or a
row mismatched or timed out; 2 the census file or the repository root is
unreadable (could not measure — a different finding from measured wrong).

Lineage: SMS checkdocs.py (quote the claim → derive → compare; coverage
printed), bbh's fidelity mechanism (capture, compare, diff). First BBX tool,
slice S1, 2026-09-09. Ruled R9, R14.
"""
import argparse
import os
import re
import subprocess
import sys

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


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("census")
    ap.add_argument("--root", help="override the repository root recorded on line 2")
    ap.add_argument("--only", help="comma-separated row ids to re-run (the rest are skipped, not counted)")
    ap.add_argument("--timeout", type=int, default=int(os.environ.get("BBX_CENSUS_TIMEOUT", "60")),
                    help="seconds per command (default 60; docs/defaults.md D1)")
    a = ap.parse_args(argv)

    try:
        head, root, rows = parse_census(a.census)
    except (OSError, ValueError) as e:
        print(f"census={os.path.basename(a.census)} error=unreadable detail={e}")
        return 2
    if a.root:
        root = a.root
    if not os.path.isdir(os.path.join(root, ".git")) and not os.path.isfile(os.path.join(root, ".git")):
        print(f"census={os.path.basename(a.census)} error=no-repository root={root}")
        return 2

    full = git(root, "rev-parse", "HEAD")
    porcelain = git(root, "status", "--porcelain").count("\n") + (1 if git(root, "status", "--porcelain") else 0)
    if not full.startswith(head):
        print(f"census={os.path.basename(a.census)} head={head} repo_head={full[:12]} verdict=HEAD-MOVED rows={len(rows)}")
        print("HEAD moved: the census describes a tree that is not the one at the recorded root; nothing recounted")
        return 1

    match = mismatch = not_recountable = nonzero = 0
    not_names = []
    only = set(a.only.split(",")) if a.only else None
    if only:
        rows = [r for r in rows if r[0] in only]
    for rid, count_cell, command_cell in rows:
        kind, expected, command = classify(count_cell, command_cell)
        if kind is None:
            not_recountable += 1
            not_names.append(rid)
            print(f"row={rid} verdict=NOT-RECOUNTABLE count={count_cell!r}")
            continue
        got, status, timed_out = run_row(command, root, a.timeout)
        if timed_out:
            mismatch += 1
            print(f"row={rid} verdict=TIMEOUT expected={expected!r} timeout={a.timeout}")
            continue
        if status != 0:
            nonzero += 1
        if compare(kind, expected, got):
            match += 1
            print(f"row={rid} verdict=MATCH expected={expected!r} got={got!r} exit={status}")
        else:
            mismatch += 1
            print(f"row={rid} verdict=MISMATCH expected={expected!r} got={got[:80]!r} exit={status}")

    print(f"census={os.path.basename(a.census)} head={head} porcelain={porcelain} rows={len(rows)} "
          f"match={match} mismatch={mismatch} not_recountable={not_recountable} nonzero_exit={nonzero} "
          f"path={HERMETIC_PATH}")
    if not_names:
        print(f"not_recountable_ids={','.join(not_names)}")
    return 1 if mismatch else 0


if __name__ == "__main__":
    sys.exit(main())
