#!/usr/bin/env python3
"""bbx-28, S6 census: the refined probes over BBX's tree (read-only). Run from the BBX root
with PYTHONPATH=lib/py.

- unresolved backticked paths WITH a directory part, in living pages only
- gate headers quoting a runtime as ~N s / ~N min
- D67's class cell verbatim
- BBX_* environment names with a :- fallback in code vs named in docs/defaults.md
- gate headers carrying a ${VAR:-default} line (bbh header-defaults' population)
- the control declaration regex, BBX's, printed for comparison with bbh's BBH-88
"""
import glob
import os
import re
import subprocess

from bbx import controls as K

ALL = set(subprocess.run(["git", "ls-files"], capture_output=True, text=True, check=True).stdout.split())
md = subprocess.run(["git", "ls-files", "*.md"], capture_output=True, text=True, check=True).stdout.split()
HIST = {"STATE_HISTORY.md", "DECISIONS_HISTORY.md", "docs/gotchas.md", "docs/readout.md", "docs/rulings.md"}
EXCL = ("fixture/", "docs/census/", "docs/bins/", "docs/plans/", "docs/platforms/wsl/", "docs/platforms/linux-native/")
LINEAGE = ("lib/py/bbh/", "tools/", "tests/", "selftest/", "example/", "docs/project/", ".claude/", "lua/", "roms/",
           "build/", "skill/blackbox-harness", "docs/game/", "bin/bbh", "drivers/fake.sh", "drivers/mame.sh",
           "lib/sh/masked", "lib/sh/enumerate", "docs/config.md", "docs/conventions.md", "docs/doc_shape.tsv",
           "docs/hygiene.md", "docs/gate_contract.md", "docs/doctrine.md")
PATH = re.compile(r"`((?:[A-Za-z0-9_.\-]+/)+[A-Za-z0-9_.\-]+)(?::\d+(?:[-–]\d+)?)?`")

print("== unresolved tokens with a directory part, living pages")
pages = [f for f in md if f not in HIST and not f.startswith(EXCL)]
tot = dead = 0
for f in pages:
    for n, line in enumerate(open(f, encoding="utf-8", errors="replace"), 1):
        for m in PATH.finditer(line):
            p = m.group(1).rstrip(".")
            if any(c in p for c in "<>*{}$~") or p.startswith(("http", "/", "github.com")):
                continue
            tot += 1
            if p in ALL or os.path.exists(p) or p.startswith(LINEAGE):
                continue
            dead += 1
            print("  %s:%d %s" % (f, n, p))
print("pages=%d tokens_with_dir=%d unresolved_not_lineage=%d" % (len(pages), tot, dead))

print("== gate headers quoting ~N s / ~N min")
q = [os.path.basename(g) for g in sorted(glob.glob("gates/*.sh"))
     if re.search(r"~\s*\d+(\.\d+)?\s*(s|sec|seconds|min|minutes)\b", "\n".join(K.header_lines(g)))]
print("gates=%d quoting=%d not: %s" % (len(glob.glob("gates/*.sh")), len(q),
      " ".join(sorted(set(os.path.basename(g) for g in glob.glob("gates/*.sh")) - set(q)))))

print("== D67's class cell")
for line in open("docs/defaults.md"):
    if line.startswith("| D67 |"):
        cells = re.split(r"(?<!\\)\|", line.rstrip("\n"))[1:-1]
        print("cells=%d class=%r" % (len(cells), cells[4].strip()))

print("== BBX_* fallbacks in code vs the register")
out = subprocess.run(["git", "grep", "-h", "-o", "-I", "-E", r"\$\{BBX_[A-Z0-9_]+:-", "--", "bin", "lib", "drivers", "gates"],
                     capture_output=True, text=True).stdout.split()
names = sorted(set(re.sub(r"^\$\{|:-$", "", x) for x in out))
reg = open("docs/defaults.md").read()
print("names=%d named=%d not_named: %s" % (len(names), sum(n in reg for n in names), " ".join(n for n in names if n not in reg)))

print("== gate headers with a ${VAR:-default} line")
g = [f for f in sorted(glob.glob("gates/*.sh")) if any(re.search(r"\$\{[A-Za-z0-9_]+:-", l) for l in K.header_lines(f))]
print("gates_with_such_lines=%d of %d; positive control, the reader sees gates/controls.sh's MUST-FIRE lines: %s"
      % (len(g), len(glob.glob("gates/*.sh")), any("MUST-FIRE" in l for l in K.header_lines("gates/controls.sh"))))

print("== BBX's declaration regex (compare bbh e7d6767 lib/sh/controls.sh:53 and BBH-88)")
print(K.DECL.pattern)
