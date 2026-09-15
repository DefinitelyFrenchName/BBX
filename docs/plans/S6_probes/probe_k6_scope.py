#!/usr/bin/env python3
"""bbx-30, S6 step 3 probe (read-only): K6's population as ruled (R64, docs/plans/S6.md §5 K6) — the pages
whose shape in docs/documents.toml is none of history, ledger, census, proposal, readout, kept-run — and what
the plan's rule reads there at HEAD: a backticked path with a directory part resolves in the tree or starts
with a lineage prefix; a file:line to a BBX file is within its length; a cited G/X/R id is defined.
The path and id regexes, the skipped characters and the lineage prefixes are bbx-28's
(docs/plans/S6_probes/probe_bbx_refined.py and probe_bbx_prose.py), unchanged, but for one change (G95): a path
resolves among the tracked files and their directories, never through the working tree, whose ignored files differ
by host. Run from the BBX root."""
import re
import subprocess

ALL = set(subprocess.run(["git", "ls-files"], capture_output=True, text=True, check=True).stdout.split())
DIRS = {"/".join(q.split("/")[:i]) for q in ALL for i in range(1, q.count("/") + 1)}
SKIP_SHAPES = {"history", "ledger", "census", "proposal", "readout", "kept-run"}
reg = open("docs/documents.toml", encoding="utf-8").read()
rows = re.findall(r'^\[d\d+\]\nfile = "([^"]+)"\nshape = "([^"]+)"', reg, re.M)
print("register tables=%d rows_read=%d (positive control: HANDOFF.md read as map: %s)"
      % (len(re.findall(r"^\[d\d+\]$", reg, re.M)), len(rows), ("HANDOFF.md", "map") in rows))
scope = sorted(f for f, s in rows if s not in SKIP_SHAPES)
print("K6 scope pages=%d: %s" % (len(scope), " ".join(scope)))
LINEAGE = ("lib/py/bbh/", "tools/", "tests/", "selftest/", "example/", "docs/project/", ".claude/", "lua/", "roms/",
           "build/", "skill/blackbox-harness", "docs/game/", "bin/bbh", "drivers/fake.sh", "drivers/mame.sh",
           "lib/sh/masked", "lib/sh/enumerate", "docs/config.md", "docs/conventions.md", "docs/doc_shape.tsv",
           "docs/hygiene.md", "docs/gate_contract.md", "docs/doctrine.md")
PATH = re.compile(r"`((?:[A-Za-z0-9_.\-]+/)+[A-Za-z0-9_.\-]+)(?::(\d+)(?:[-–](\d+))?)?`")
tot = res = lin = 0
unresolved, past = [], []
fl = 0
for f in scope:
    for n, line in enumerate(open(f, encoding="utf-8", errors="replace"), 1):
        for m in PATH.finditer(line):
            p = m.group(1).rstrip(".")
            if any(c in p for c in "<>*{}$~") or p.startswith(("http", "/", "github.com")):
                continue
            tot += 1
            if p in ALL or p in DIRS:
                res += 1
                if m.group(2) and p in ALL:
                    fl += 1
                    last = int(m.group(3) or m.group(2))
                    nl = sum(1 for _ in open(p, encoding="utf-8", errors="replace"))
                    if last > nl:
                        past.append("%s:%d cites %s (file has %d lines)" % (f, n, m.group(0), nl))
                continue
            if p.startswith(LINEAGE):
                lin += 1
                continue
            unresolved.append("%s:%d %s" % (f, n, p))
print("tokens_with_dir=%d resolve=%d lineage_prefix=%d unresolved=%d" % (tot, res, lin, len(unresolved)))
for u in unresolved:
    print("  unresolved " + u)
print("file:line to BBX files=%d past_end=%d" % (fl, len(past)))
for x in past:
    print("  past-end " + x)
gdef = set(int(x) for x in re.findall(r"^## G(\d+) ", open("docs/gotchas.md").read(), re.M))
xdef = set(int(x) for x in re.findall(r"^X(\d+)\t", open("docs/retractions.tsv").read(), re.M))
rdef = set(int(x) for x in re.findall(r"\bR(\d+)\b", open("DECISIONS.md").read()))
und = []
cited = 0
for f in scope:
    for n, line in enumerate(open(f, encoding="utf-8", errors="replace"), 1):
        for kind, num in re.findall(r"(?<![A-Za-z0-9_\-])([GXR])(\d{1,3})(?![A-Za-z0-9_])", line):
            cited += 1
            if int(num) not in {"G": gdef, "X": xdef, "R": rdef}[kind]:
                und.append("%s:%d %s%s" % (f, n, kind, num))
print("ids cited=%d undefined=%d (defined G=%d X=%d R=%d)" % (cited, len(und), len(gdef), len(xdef), len(rdef)))
for u in und:
    print("  undefined " + u)
print("positive controls: `gates/controls.sh` resolves=%s; `gates/no_such_gate.sh` resolves=%s; G999 defined=%s"
      % ("gates/controls.sh" in ALL, "gates/no_such_gate.sh" in ALL, 999 in gdef))
print("resolution controls: the tracked directory `fixture/docset` resolves=%s; an untracked `build` resolves=%s"
      % ("fixture/docset" in DIRS, "build" in ALL or "build" in DIRS))
