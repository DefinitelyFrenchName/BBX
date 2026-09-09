#!/usr/bin/env python3
"""close_sweeps.py — the close ritual's sweeps as a check (HANDOFF.md, step 8; BBX-22, BBX-24).

    python3 -m bbx.close_sweeps <root> [--retractions docs/retractions.tsv] [--defaults docs/defaults.md]

Three sweeps over the tree under <root> (every *.md *.sh *.py *.toml *.txt
*.tsv file, skipping .git/, build/ and scratch/):

  retraction   every row of the retractions register (a wording BBX once stated
               and later corrected) must appear ONLY in the files the row allows
               — the ledgers, where history is the point. A hit anywhere else is
               a corrected claim still stated as current (BBX-22: grep the
               claim's wording across the tree and show the empty result).
  deferral     TODO, TBD, FIXME, XXX-style deferrals appear nowhere except the
               lines that name the sweep itself. A deferral is work promised in
               prose (CLAUDE.md §6.4: nothing evaporates into prose).
  defaults     every citation of a defaults-register row (`D<n>` next to the
               word defaults, or `(D<n>` in a parenthesis) names a row that
               exists; rows are unique. A default cited but never registered is
               a default nobody can veto (BBX-24, [BBH-84]).

The retractions register (docs/retractions.tsv): `id <TAB> pattern (Python
regex) <TAB> retracted on <TAB> allowed in (comma-separated paths or dir/
prefixes) <TAB> why`. Lines starting with # are comments.

Findings are printed as `ERROR: <sweep> <what> <path>:<line>`; the summary line
is parsed by field name:
    close_sweeps=<root> files=<n> retractions=<rows> retraction_hits=<n> deferrals=<n> defaults_rows=<n> citations=<n> unresolved=<n> errors=<n>
Exit 0 when errors=0, 1 otherwise, 2 when the register or the root is unreadable.
First written at bbx-2 (2026-09-10); until then the sweeps were hand-run at every close.
"""
import os
import re
import sys

EXTS = (".md", ".sh", ".py", ".toml", ".txt", ".tsv")
SKIP_DIRS = {".git", "build", "scratch", "__pycache__"}
DEFERRAL = re.compile(r"\b(TODO|TBD|FIXME)\b")
# the sweep's own two files name every pattern they hunt (their controls plant them): never swept
SELF = ("lib/py/bbx/close_sweeps.py", "gates/close_sweeps.sh")
# lines allowed to name the deferral words beyond SELF: the ritual's text
DEFERRAL_ALLOW = SELF + ("HANDOFF.md",)
# files that cite the LINEAGE's ids (bbh's D-rows, VampireSaved's D.2): never read as BBX defaults
D_CITE_SKIP = ("docs/census/", "docs/bins/", "CLAUDE.md")
D_CITE = re.compile(r"(?:defaults\.md[^\n]{0,24}?\bD(\d+)\b|\(D(\d+)\b|\bD(\d+)(?=[,;)]| row| added| re-measured| re-measure| the))")
D_ROW = re.compile(r"^\| D(\d+) \|")


def walk(root):
    for dirpath, dirnames, filenames in os.walk(root):
        dirnames[:] = sorted(d for d in dirnames if d not in SKIP_DIRS)
        for f in sorted(filenames):
            if f.endswith(EXTS):
                yield os.path.relpath(os.path.join(dirpath, f), root)


def read_retractions(path):
    rows = []
    for n, line in enumerate(open(path, encoding="utf-8"), 1):
        if not line.strip() or line.startswith("#"):
            continue
        cells = line.rstrip("\n").split("\t")
        if len(cells) < 4:
            raise ValueError(f"{path}:{n}: expected 5 tab-separated cells, got {len(cells)}")
        rid, pattern, date, allowed = cells[0], cells[1], cells[2], cells[3]
        rows.append((rid, re.compile(pattern), date, [a.strip() for a in allowed.split(",") if a.strip()]))
    return rows


def allowed(path, allow_list):
    return any(path == a or (a.endswith("/") and path.startswith(a)) for a in allow_list)


def main(argv=None):
    argv = list(sys.argv[1:] if argv is None else argv)
    retr = "docs/retractions.tsv"
    defaults = "docs/defaults.md"
    if "--retractions" in argv:
        i = argv.index("--retractions"); retr = argv[i + 1]; del argv[i:i + 2]
    if "--defaults" in argv:
        i = argv.index("--defaults"); defaults = argv[i + 1]; del argv[i:i + 2]
    if len(argv) != 1:
        print("usage: close_sweeps.py <root> [--retractions FILE] [--defaults FILE]", file=sys.stderr)
        return 2
    root = argv[0]
    try:
        rows = read_retractions(os.path.join(root, retr))
        files = list(walk(root))
        defaults_text = open(os.path.join(root, defaults), encoding="utf-8").read().split("\n")
    except (OSError, ValueError) as e:
        print(f"close_sweeps={root} error=unreadable detail={e}")
        return 2
    errors = []
    retraction_hits = deferrals = citations = unresolved = 0
    # defaults rows
    d_rows = {}
    for n, line in enumerate(defaults_text, 1):
        m = D_ROW.match(line)
        if m:
            k = int(m.group(1))
            if k in d_rows:
                errors.append(f"ERROR: defaults duplicate-row D{k} {defaults}:{n}")
            d_rows[k] = n
    for rel in files:
        try:
            text = open(os.path.join(root, rel), encoding="utf-8", errors="replace").read()
        except OSError:
            continue
        if rel in SELF:
            continue
        for n, line in enumerate(text.split("\n"), 1):
            for rid, rx, date, allow in rows:
                if rx.search(line) and not allowed(rel, allow):
                    retraction_hits += 1
                    errors.append(f"ERROR: retraction {rid} (retracted {date}) still stated in {rel}:{n}")
            if DEFERRAL.search(line) and rel not in DEFERRAL_ALLOW:
                deferrals += 1
                errors.append(f"ERROR: deferral {DEFERRAL.search(line).group(1)} in {rel}:{n}")
            if rel != defaults and not any(rel == s or rel.startswith(s) for s in D_CITE_SKIP):
                for m in D_CITE.finditer(line):
                    k = int(next(g for g in m.groups() if g))
                    citations += 1
                    if k not in d_rows:
                        unresolved += 1
                        errors.append(f"ERROR: defaults cited-not-registered D{k} in {rel}:{n}")
    for e in errors:
        print(e)
    print(f"close_sweeps={root} files={len(files)} retractions={len(rows)} retraction_hits={retraction_hits} "
          f"deferrals={deferrals} defaults_rows={len(d_rows)} citations={citations} unresolved={unresolved} errors={len(errors)}")
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main())
