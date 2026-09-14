#!/usr/bin/env python3
"""bbx-28, S6 census probes over BBX's tree (read-only). Run from the BBX root.

P2 defaults: the class column against a candidate grammar; code defaults with no row.
P4 prose references: backticked repo paths, file:line citations, G/X/R ids.
P5 gate headers: Usage/default lines, quoted runtimes.
Every count is printed with its population, and each probe carries a positive control.
"""
import os
import re
import subprocess

def tracked(pattern):
    return subprocess.run(["git", "ls-files", pattern], capture_output=True, text=True, check=True).stdout.split()

ALL = set(subprocess.run(["git", "ls-files"], capture_output=True, text=True, check=True).stdout.split())

# ---------------- P2 defaults
print("== P2 defaults: the class column against a candidate grammar")
CLASS = r"(principled|reference-calibrated|arbitrary)"
PART = CLASS + r"(\s*\([^()]*(\([^()]*\)[^()]*)*\))?"
GRAMMAR = re.compile(r"^" + PART + r"(\s*/\s*" + PART + r")*$")
rows = [l for l in open("docs/defaults.md").read().splitlines() if re.match(r"^\| D\d+ \|", l)]
ok, bad = 0, []
for l in rows:
    cells = re.split(r"(?<!\\)\|", l)[1:-1]
    rid = cells[0].strip()
    if len(cells) != 6:
        # take the class as the second-to-last cell when a stray pipe split an earlier cell
        c = cells[-2].strip()
    else:
        c = cells[4].strip()
    if GRAMMAR.match(c):
        ok += 1
    else:
        bad.append((rid, c[:100]))
print("rows=%d parse=%d fail=%d" % (len(rows), ok, len(bad)))
for rid, c in bad:
    print("  FAIL %s: %s" % (rid, c))
print("positive control: 'principled-ish' parses? %s ; 'arbitrary (x) / nonsense' parses? %s" % (
    bool(GRAMMAR.match("principled-ish")), bool(GRAMMAR.match("arbitrary (x) / nonsense"))))

print("== P2 code defaults: keys of lib/py/bbx/config.py DEFAULTS named in docs/defaults.md")
import sys
sys.path.insert(0, "lib/py")
from bbx import config as C
defaults_text = open("docs/defaults.md").read()
keys = []
for sec, tab in C.DEFAULTS.items():
    if isinstance(tab, dict):
        for k in tab:
            keys.append("[%s].%s" % (sec, k))
named = [k for k in keys if k in defaults_text or ("`%s`" % k.split(".", 1)[1]) in defaults_text]
exact = [k for k in keys if k in defaults_text]
print("DEFAULTS sections=%d keys=%d named_as_[sec].key=%d named_by_key_alone_or_full=%d" % (len(C.DEFAULTS), len(keys), len(exact), len(named)))
print("keys named nowhere (neither [sec].key nor `key`):")
for k in keys:
    if k not in named:
        print("  " + k)

# ---------------- P4 prose references
print("== P4 backticked repo paths in tracked markdown")
PATH = re.compile(r"`((?:[A-Za-z0-9_.\-]+/)+[A-Za-z0-9_.\-]+|[A-Za-z0-9_\-]+\.(?:md|sh|py|toml|tsv|txt))(?::(\d+)(?:[-–](\d+))?)?`")
HIST = {"STATE_HISTORY.md", "DECISIONS_HISTORY.md", "docs/gotchas.md", "docs/readout.md", "docs/retractions.tsv"}
LINEAGE = ("lib/py/bbh/", "lib/sh/masked", "tools/", "tests/", "selftest/", "example/", "docs/project/", ".claude/", "lua/", "roms/", "build/", "skill/blackbox-harness", "docs/game/", "bin/bbh", "drivers/fake.sh", "drivers/mame.sh")
tot = live = dead_hist = dead_lineage = dead_other = 0
fl_tot = fl_bad = 0
dead_by_file = {}
for f in tracked("*.md"):
    if f.startswith("fixture/"):
        continue
    for n, line in enumerate(open(f, encoding="utf-8", errors="replace"), 1):
        for m in PATH.finditer(line):
            p = m.group(1).rstrip(".")
            if any(ch in p for ch in "<>*{}$~") or p.startswith(("http", "/")):
                continue
            tot += 1
            exists = p in ALL or os.path.isdir(p) or os.path.exists(p)
            if exists:
                live += 1
                if m.group(2) and os.path.isfile(p):
                    fl_tot += 1
                    last = int(m.group(3) or m.group(2))
                    nlines = sum(1 for _ in open(p, encoding="utf-8", errors="replace"))
                    if last > nlines:
                        fl_bad += 1
                        print("  file:line past the end: %s:%d cites %s (file has %d lines)" % (f, n, m.group(0), nlines))
                continue
            if f in HIST:
                dead_hist += 1
            elif p.startswith(LINEAGE) or f.startswith(("docs/census/", "docs/bins/")):
                dead_lineage += 1
            else:
                dead_other += 1
                dead_by_file.setdefault(f, []).append((n, p))
print("tokens=%d resolve_in_BBX=%d unresolved_in_history_or_ledger_pages=%d unresolved_lineage_prefix_or_census_bins=%d unresolved_other=%d" % (tot, live, dead_hist, dead_lineage, dead_other))
print("file:line citations to BBX files=%d past_end=%d" % (fl_tot, fl_bad))
for f, hits in sorted(dead_by_file.items()):
    print("  %s: %d — %s" % (f, len(hits), ", ".join("%d:%s" % h for h in hits[:6])))
print("positive control: `gates/controls.sh` resolves? %s ; `gates/no_such_gate.sh` resolves? %s" % ("gates/controls.sh" in ALL, "gates/no_such_gate.sh" in ALL))

print("== P4 ids cited vs defined")
gdef = set(int(x) for x in re.findall(r"^## G(\d+) ", open("docs/gotchas.md").read(), re.M))
xdef = set(int(x) for x in re.findall(r"^X(\d+)\t", open("docs/retractions.tsv").read(), re.M))
rdef = set(int(x) for x in re.findall(r"\bR(\d+)\b", open("DECISIONS.md").read()))
cite = {"G": {}, "X": {}, "R": {}}
for f in tracked("*.md") + tracked("*.tsv") + tracked("*.sh") + tracked("*.py"):
    if f.startswith("fixture/") or f.startswith("docs/census/") or f.startswith("docs/bins/"):
        continue
    for n, line in enumerate(open(f, encoding="utf-8", errors="replace"), 1):
        for kind, num in re.findall(r"(?<![A-Za-z0-9_\-])([GXR])(\d{1,3})(?![A-Za-z0-9_])", line):
            cite[kind].setdefault(int(num), []).append("%s:%d" % (f, n))
for kind, defined in (("G", gdef), ("X", xdef), ("R", rdef)):
    und = sorted(k for k in cite[kind] if k not in defined)
    print("%s: defined=%d (max %d) cited_ids=%d undefined_cited=%s" % (kind, len(defined), max(defined), len(cite[kind]), ["%s%d@%s" % (kind, k, cite[kind][k][0]) for k in und][:12]))

# ---------------- P5 gate headers
print("== P5 gate headers: Usage/default lines and quoted runtimes")
sys.path.insert(0, "lib/py")
from bbx import controls as K
usage = runtime = 0
rt_gates = []
for g in sorted(tracked("gates/*.sh")):
    head = K.header_lines(g) if hasattr(K, "header_lines") else []
    text = "\n".join(head)
    if re.search(r"(?im)^#\s*(usage|default)", text):
        usage += 1
    if re.search(r"~\s*\d+\s*(s|sec|min)\b|\b\d+\s*(s|min)\b\s*(on this host|runtime)|runtime", text, re.I):
        runtime += 1
        rt_gates.append(os.path.basename(g))
print("gates=%d header_reader=%s with_usage_or_default_line=%d quoting_a_runtime=%d" % (len(tracked("gates/*.sh")), hasattr(K, "header_lines"), usage, runtime))
print("  runtime-quoting gates: %s" % " ".join(rt_gates))
