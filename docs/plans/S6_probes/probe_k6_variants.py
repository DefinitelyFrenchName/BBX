#!/usr/bin/env python3
"""bbx-30, S6 step 3 probe (read-only): K6's rule over three scopes and grammars, to rule R67 from counts.
A — the plan's scope: every register shape but history, ledger, census, proposal, readout, kept-run; the plan's rule.
B — A without the queue, generated and fixture shapes; the plan's rule.
C — B, and a token is a path claim only when its first segment is a top-level entry of the tree or it carries a
    lineage prefix; any other token is counted as not a path claim.
Regexes and lineage prefixes are bbx-28's (probe_bbx_refined.py), unchanged; a path resolves among the tracked files
and their directories, never through the working tree, whose ignored files differ by host (G95). Run from the BBX root."""
import re
import subprocess

ALL = set(subprocess.run(["git", "ls-files"], capture_output=True, text=True, check=True).stdout.split())
DIRS = {"/".join(q.split("/")[:i]) for q in ALL for i in range(1, q.count("/") + 1)}
TOP = {p.split("/", 1)[0] for p in ALL}
reg = open("docs/documents.toml", encoding="utf-8").read()
rows = re.findall(r'^\[d\d+\]\nfile = "([^"]+)"\nshape = "([^"]+)"', reg, re.M)
LINEAGE = ("lib/py/bbh/", "tools/", "tests/", "selftest/", "example/", "docs/project/", ".claude/", "lua/", "roms/",
           "build/", "skill/blackbox-harness", "docs/game/", "bin/bbh", "drivers/fake.sh", "drivers/mame.sh",
           "lib/sh/masked", "lib/sh/enumerate", "docs/config.md", "docs/conventions.md", "docs/doc_shape.tsv",
           "docs/hygiene.md", "docs/gate_contract.md", "docs/doctrine.md")
PATH = re.compile(r"`((?:[A-Za-z0-9_.\-]+/)+[A-Za-z0-9_.\-]+)(?::(\d+)(?:[-–](\d+))?)?`")
A_SKIP = {"history", "ledger", "census", "proposal", "readout", "kept-run"}
B_SKIP = A_SKIP | {"queue", "generated", "fixture"}
print("tree top-level entries=%d: %s" % (len(TOP), " ".join(sorted(TOP))))

def run(label, skip, rooted):
    scope = sorted(f for f, s in rows if s not in skip)
    tot = res = lin = unrooted = 0
    bad = []
    for f in scope:
        for n, line in enumerate(open(f, encoding="utf-8", errors="replace"), 1):
            for m in PATH.finditer(line):
                p = m.group(1).rstrip(".")
                if any(c in p for c in "<>*{}$~") or p.startswith(("http", "/", "github.com")):
                    continue
                tot += 1
                if p in ALL or p in DIRS:
                    res += 1
                elif p.startswith(LINEAGE):
                    lin += 1
                elif rooted and p.split("/", 1)[0] not in TOP:
                    unrooted += 1
                else:
                    bad.append("%s:%d %s" % (f, n, p))
    print("%s pages=%d tokens=%d resolve=%d lineage=%d not_a_path_claim=%d unresolved=%d"
          % (label, len(scope), tot, res, lin, unrooted, len(bad)))
    for b in bad:
        print("    " + b)

run("A", A_SKIP, False)
run("B", B_SKIP, False)
run("C", B_SKIP, True)
print("positive control: C reads a planted rooted dead path as unresolved: %s; an unrooted token as not a claim: %s"
      % ("gates" in TOP and "gates/no_such_gate.sh" not in ALL, "subject" not in TOP))
print("resolution controls: the tracked directory `fixture/docset` resolves=%s; an untracked `build` resolves=%s"
      % ("fixture/docset" in DIRS, "build" in ALL or "build" in DIRS))
