"""demand_after_trap.py — no gate may carry a `${VAR:?msg}` DEMAND after its
EXIT trap.

    python3 -m bbx.demand_after_trap <gates-dir> [--lib <subdir>] [--skip <name>]…
    bbx demand-after-trap <gates-dir> [--lib <subdir>] [--skip <name>]…

WHY. On macOS bash 3.2 — /bin/sh AND /bin/bash — a parameter-expansion abort
(`${VAR:?}` on an unset VAR) exits the shell with status 0 once an EXIT trap
is armed; without the trap it exits 1, and a trap written to preserve `$?`
still returns 0 because `$?` is already 0 when the trap runs. VampireSaved's
M16 release run recorded a 65-minute simulator gate as `PASS 0s`: it died at
a demand eight lines after `trap 'rm -rf "$W"' EXIT`, and the runner's
exit-status-first classifier read the 0. The classifier now also fails an
exit-0 log carrying the shell's own `<script>.sh: line N: NAME: message`
(lib/sh/classify.sh); this scanner removes the CAUSE: once a trap is armed a
demand is written as an explicit test —
    [ -n "${X:-}" ] || { echo "FAIL: set X"; exit 1; }
Demands BEFORE the trap (the usual top-of-file `${ROMDIR:?set ROMDIR}`) exit
1 correctly and are allowed.

SCOPE: every *.sh in the gates dir and in its lib subdir, and every other
file there whose first line is a shell shebang. A `${VAR:?…}` inside a heredoc
that writes a STUB SCRIPT runs in the stub's own shell (no trap) and is
allowed — heredoc bodies are skipped. Prints `file:line: text` per hit; exit 1
if any.

Lifted from bbh lib/py/bbh/demand_after_trap.py at 10a82d2 (S6 step 3, ruled
R63), its patterns and hit lines verbatim, with two deltas, each carried by a
control in gates/trap_lint.sh and diffed over F19b's inputs: (1) a gates dir
that is not a directory, or a `--lib` subdir named on the command line and
absent, is REFUSED, exit 2, where bbh scans nothing and exits 0 — a lint that
is green on a missing directory goes green on rot (BBX-8); (2) a file without
a `.sh` name is read when its first line is a shell shebang, as BBX's bin/
runners are, where bbh reads `*.sh` only. BBX's own incident of the shape is
G18. The patterns and the two deltas: docs/defaults.md D83.
"""
import pathlib
import re
import sys

TRAP = re.compile(r"(^|[;&|]\s*)trap\b.*\bEXIT\b")
DEMAND = re.compile(r"\$\{[A-Za-z_][A-Za-z0-9_]*:\?")
HEREDOC = re.compile(r"<<-?\s*['\"]?(\w+)['\"]?")
SHEBANG = re.compile(r"^#!\s*(?:\S*/)?(?:env\s+)?(?:ba|da|k|z)?sh(?:\s|$)")   # BBX's second delta (D83)


def shell_files(d):
    """The files of one directory the scan reads: every *.sh, as bbh reads them, and (BBX's second delta) every
    other regular file whose first line is a shell shebang."""
    d = pathlib.Path(d)
    out = set(d.glob("*.sh"))
    if d.is_dir():
        for f in d.iterdir():
            if f in out or not f.is_file():
                continue
            try:
                with open(f, "rb") as fh:
                    first = fh.readline(200).decode("utf-8", "replace")
            except OSError:
                continue
            if SHEBANG.match(first):
                out.add(f)
    return sorted(out)


def scan(root, lib="lib", skip=()):
    root = pathlib.Path(root)
    files = sorted(set(shell_files(root)) | set(shell_files(root / lib)))
    hits = []
    for f in files:
        if f.name in skip:
            continue
        trap_line = None
        heredoc_end = None
        for n, line in enumerate(f.read_text(encoding="utf-8", errors="replace").splitlines(), 1):
            if heredoc_end is not None:
                if line.strip() == heredoc_end:
                    heredoc_end = None
                continue
            m = HEREDOC.search(line)
            if m and not line.lstrip().startswith("#"):
                heredoc_end = m.group(1)
            if trap_line is None and TRAP.search(line) and not line.lstrip().startswith("#"):
                trap_line = n
                continue
            if trap_line is not None and DEMAND.search(line) and not line.lstrip().startswith("#"):
                hits.append(f"{f.relative_to(root)}:{n}: {line.strip()[:100]}")
    return hits


def main(argv):
    if not argv:
        print(__doc__, file=sys.stderr)
        return 2
    root = argv[0]
    lib = "lib"
    lib_named = False
    skip = []
    i = 1
    while i < len(argv):
        if argv[i] == "--lib" and i + 1 < len(argv):
            lib = argv[i + 1]
            lib_named = True
            i += 2
        elif argv[i] == "--skip" and i + 1 < len(argv):
            skip.append(argv[i + 1])
            i += 2
        else:
            print(f"bbx demand_after_trap: bad argument {argv[i]!r}", file=sys.stderr)
            return 2
    # BBX's first delta (D83): a directory that is not there is refused, never scanned as empty
    missing = [p for p in [root] + ([str(pathlib.Path(root) / lib)] if lib_named else []) if not pathlib.Path(p).is_dir()]
    if missing:
        for p in missing:
            print(f"bbx demand_after_trap: {p} is not a directory", file=sys.stderr)
        return 2
    hits = scan(root, lib, skip)
    for h in hits:
        print(h)
    return 1 if hits else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
