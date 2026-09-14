#!/bin/sh
# bbx-28, S6 census: what bbh's tip e7d6767 built past the fidelity baseline
# 10a82d2, read from the clone's object store (no checkout). Usage: sh probe_bbh_tip.sh <clone>
set -u
C="$1"; say() { printf '%s\n' "$*"; }
g() { git -C "$C" "$@"; }
say "== the 13 commits"
g log --reverse --format='%h %ad %s' --date=short 10a82d2..e7d6767 | cut -c1-170
say "== files changed baseline -> tip"
g diff --stat 10a82d2 e7d6767 | tail -40
say "== the controls reader and the runner's mode"
for f in lib/sh/controls.sh bin/bbh-run-static; do say "$f tip_lines=$(g show e7d6767:$f 2>/dev/null | wc -l | tr -d ' ') base_lines=$(g show 10a82d2:$f 2>/dev/null | wc -l | tr -d ' ')"; done
say "-- exec-controls / CONTROL= in bin and lib at the tip"
g grep -n -I -E 'exec-controls|CONTROL=|CONTROL LIES|CONTROL DEAD|REFUSED: CONTROL' e7d6767 -- bin lib | cut -c1-200 | head -30
say "-- the same at the baseline (expect none)"
say "lines=$(g grep -n -I -E 'exec-controls|CONTROL=|CONTROL LIES' 10a82d2 -- bin lib | wc -l | tr -d ' ')"
say "== the grammar rules BBH-88..91 at the tip"
g show e7d6767:skill/blackbox-harness/SKILL.md | /usr/bin/grep -E '^- \[BBH-(88|89|90|91)\]' | cut -c1-400
say "== gates at the tip that honour a CONTROL mode"
say "example gates naming CONTROL: $(g grep -l -I 'CONTROL' e7d6767 -- example/tests | wc -l | tr -d ' ') of $(g ls-tree --name-only e7d6767 example/tests/ | /usr/bin/grep -c '\.sh$')"
say "selftests naming exec-controls: $(g grep -l -I -E 'exec-controls' e7d6767 -- selftest | tr '\n' ' ')"
say "== the tip's example control gate (head)"
g show e7d6767:example/tests/g_control.sh | head -30
