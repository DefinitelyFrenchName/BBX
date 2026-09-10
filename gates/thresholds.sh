#!/bin/sh
# thresholds.sh — the temporal thresholds are declared once, every importer resolves to that declaration, a consumer override reaches the proposer and the enforcers alike, and a LOOSER value without a ruling is refused by every one of them (R25)
# Ground truth for lib/py/bbx/thresholds.py. Sections 1-7 lifted from bbh selftest/test_thresholds.sh at f675710
# (lineage: VampireSaved tests/test_s4_thresholds.sh, GitHub #44 there: four declarations, a comment saying
# "must stay in step", nothing asserting it). Section 8 is BBX's: BBX-13 made a mechanism (R25, 2026-09-10) —
# looser is LARGER flicker_max / flicker_max_total and SMALLER reconverge (docs/defaults.md D24); a looser
# consumer value with no [thresholds].rulings entry makes every importer print one REFUSED line and exit 3.
# No instrument. Portable, ~1 s (1.2 s measured 2026-09-10).
# Usage: gates/thresholds.sh        (BBX_CONFIG is unset inside; each case names its own config)
# MUST-FIRE: known-bad: local-literal — a planted local `FLICKER_MAX = 3` in a file must be caught by the re-declaration check while a comment naming it must not, or the check that keeps the declaration single is blind
# MUST-FIRE: known-bad: loosened-without-ruling — flicker_max 3, reconverge 10 and flicker_max_total 9 with no rulings entry must each be REFUSED (exit 3, one line) by every importer and by the module itself, or BBX-13's "loosened only by ruling" is prose
# MUST-FIRE: shadow-tool: proposer-drift — a shadow copy of the lib whose proposer re-declares FLICKER_MAX locally must make the proposer and the enforcer disagree under a consumer override, and this gate must see the disagreement, or "proposer = enforcer" is not measured
# NOT-ASSERTED: that a ruling id in [thresholds].rulings names a ruling that exists: any non-empty string is accepted here; the consumer's rulings-shape gate is where an id is checked
# NOT-ASSERTED: the values' fitness for any subject: 2 / 60 / 8 are bbh's ratified policy carried in the frame-driven profile (D23), not a measurement of anything here
#
set -eu
BBX_HOME="$(cd "$(dirname "$0")/.." && pwd)"; export BBX_HOME
PYTHONPATH="$BBX_HOME/lib/py"; export PYTHONPATH
unset BBX_CONFIG BBH_CONFIG 2>/dev/null || true
cd "$BBX_HOME"
rc=0
ok()   { printf '  ok    %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1"; rc=1; }
W="$(mktemp -d)"; trap 'rm -rf "$W"' EXIT INT TERM
CONSUMERS="lib/py/bbx/propose_temporal.py lib/py/bbx/compare_composite.py lib/py/bbx/compare_flicker.py lib/py/bbx/compare_window.py"
RX='^[[:space:]]*(FLICKER_MAX|RECONVERGE|MAX_TOTAL)[[:space:]]*='

echo "== 1. one declaration, and with no config its values are the frame-driven profile's (D23: bbh's 2 / 60 / 8) =="
v="$(python3 -m bbx.thresholds)"
[ "$v" = "kind=frame-driven flicker_max=2 reconverge=60 flicker_max_total=8" ] && ok "$v" || fail "defaults: '$v'"

echo "== 2. every consumer resolves to that declaration =="
for f in $CONSUMERS; do grep -Eq '^[[:space:]]*from \.thresholds import' "$f" && ok "$f imports the shared declaration" || fail "$f does not import bbx.thresholds"; done

echo "== 3. NO consumer re-declares a threshold locally =="
for f in $CONSUMERS; do grep -Eq "$RX" "$f" && fail "$f re-declares a threshold locally: $(grep -En "$RX" "$f" | head -1)" || ok "$f declares none locally"; done

echo "== 4. no consumer hard-codes the VALUES as argparse defaults =="
for f in $CONSUMERS; do
    hits="$(grep -En 'add_argument\("--(reconverge|max-stretch|min-converge|max-total)".*default=[0-9]' "$f" || true)"
    [ -z "$hits" ] && ok "$f takes its defaults from the shared declaration" || fail "$f hard-codes a threshold default: $hits"
done

echo "== 5. CONTROL local-literal: a re-introduced literal IS caught, a comment is NOT =="
printf 'FLICKER_MAX = 3\n' > "$W/drifted.py"; printf '# FLICKER_MAX is 2 (see thresholds)\n' > "$W/comment.py"
if grep -Eq "$RX" "$W/drifted.py" && ! grep -Eq "$RX" "$W/comment.py"; then echo "CONTROL FIRED: local-literal — the planted literal is caught, the comment is not"
else fail "CONTROL DEAD: local-literal — literal caught: $(grep -Eq "$RX" "$W/drifted.py" && echo yes || echo no); comment flagged: $(grep -Eq "$RX" "$W/comment.py" && echo yes || echo no)"; fi

echo "== 6. a consumer override (with its ruling rows) reaches the proposer AND the enforcer alike =="
mkdir -p "$W/c"; printf '[thresholds]\nflicker_max = 3\nreconverge = 10\nrulings = { flicker_max = "R-fixture-1", reconverge = "R-fixture-1" }\n' > "$W/c/bbx.toml"
python3 -m bbx._mklog "$W/base.log" 200; python3 -m bbx._mklog "$W/three.log" 200 100-102
prop="$(BBX_CONFIG="$W/c/bbx.toml" python3 -m bbx.propose_temporal "$W/base.log" "$W/three.log" --basis b | grep '^proposed:')"
enf="$(BBX_CONFIG="$W/c/bbx.toml" python3 -m bbx.compare_flicker "$W/base.log" "$W/three.log" || true)"
[ "$prop" = "proposed: flicker b 3 100,101,102" ] && ok "the proposer under flicker_max=3 proposes a flicker" || fail "proposer: '$prop'"
[ "$enf" = "FLICKER 3 100,101,102" ] && ok "the enforcer under the same config accepts the proposal verbatim" || fail "enforcer: '$enf'"
def="$(python3 -m bbx.propose_temporal "$W/base.log" "$W/three.log" --basis b | grep '^proposed:')"
[ "$def" = "proposed: window b 100 102" ] && ok "without the config the same shape is a WINDOW (the profile's 2)" || fail "default proposer: '$def'"

echo "== 7. the consumers compile =="
for f in $CONSUMERS lib/py/bbx/check_diverge.py lib/py/bbx/logfmt.py lib/py/bbx/thresholds.py; do python3 -m py_compile "$f" 2>/dev/null && ok "$f" || fail "$f does not compile"; done

echo "== 8. R25: looser needs a ruling row; tighter needs nothing; a kind with no family is refused =="
refused() {  # refused <config> <key> <v> <p> — every importer and the module print the one line and exit 3
    _c="$1"; _k="$2"; _v="$3"; _p="$4"; _want="REFUSED: [thresholds].$_k = $_v is looser than the frame-driven profile's $_p and [thresholds].rulings names no ruling for it (BBX-13, R25)"; _all=1
    for m in thresholds compare_flicker compare_window compare_composite propose_temporal; do
        case "$m" in thresholds) set -- ;; compare_window) set -- "$W/base.log" "$W/three.log" --onset 100 --end 102 ;; compare_composite) set -- "$W/base.log" "$W/three.log" --flicker - --windows 100-102 ;; *) set -- "$W/base.log" "$W/three.log" ;; esac
        _o="$(BBX_CONFIG="$_c" python3 -m "bbx.$m" "$@" 2>&1)" && _rc=0 || _rc=$?
        [ "$_rc" = 3 ] && [ "$_o" = "$_want" ] || { _all=0; fail "$m under $_k=$_v: exit $_rc, '$_o'"; }
    done
    [ "$_all" = 1 ]
}
mkdir -p "$W/l1" "$W/l2" "$W/l3" "$W/t" "$W/s"
printf '[thresholds]\nflicker_max = 3\n' > "$W/l1/bbx.toml"; printf '[thresholds]\nreconverge = 10\n' > "$W/l2/bbx.toml"; printf '[thresholds]\nflicker_max_total = 9\n' > "$W/l3/bbx.toml"
if refused "$W/l1/bbx.toml" flicker_max 3 2 && refused "$W/l2/bbx.toml" reconverge 10 60 && refused "$W/l3/bbx.toml" flicker_max_total 9 8; then
    echo "CONTROL FIRED: loosened-without-ruling — flicker_max 3, reconverge 10, flicker_max_total 9: five tools × three keys, each one REFUSED line, exit 3"
else fail "CONTROL DEAD: loosened-without-ruling — see above"; fi
printf '[thresholds]\nflicker_max = 1\nreconverge = 100\nflicker_max_total = 4\n' > "$W/t/bbx.toml"
v="$(BBX_CONFIG="$W/t/bbx.toml" python3 -m bbx.thresholds)" && [ "$v" = "kind=frame-driven flicker_max=1 reconverge=100 flicker_max_total=4" ] && ok "tighter on every key needs no ruling: $v" || fail "tighter: '$v'"
v="$(BBX_CONFIG="$W/c/bbx.toml" python3 -m bbx.thresholds)" && [ "$v" = "kind=frame-driven flicker_max=3 reconverge=10 flicker_max_total=8" ] && ok "looser WITH its ruling rows is accepted: $v" || fail "with rulings: '$v'"
printf '[project]\nkind = "self"\n' > "$W/s/bbx.toml"
o="$(BBX_CONFIG="$W/s/bbx.toml" python3 -m bbx.compare_flicker "$W/base.log" "$W/three.log" 2>&1)" && fail "kind self ran a temporal comparator" || { [ "$?" = 3 ] || true; case "$o" in "REFUSED: kind 'self' declares no [thresholds]"*) ok "a kind with no temporal family is REFUSED, not defaulted";; *) fail "kind self: '$o'";; esac; }

echo "== 9. CONTROL proposer-drift: a shadow lib whose proposer re-declares FLICKER_MAX makes the pair disagree, and the gate sees it =="
S="$W/shadow"; mkdir -p "$S/lib/py"; cp -R "$BBX_HOME/lib/py/bbx" "$S/lib/py/bbx"
# the literal goes BEFORE the entry point (appended after `if __name__` it would run after main() — this gate's own first defect, 2026-09-10)
sed -i.bak 's/^if __name__ == "__main__":/FLICKER_MAX = 2   # SHADOW: the drift the lineage paid for (four declarations)\
if __name__ == "__main__":/' "$S/lib/py/bbx/propose_temporal.py"
grep -q '^FLICKER_MAX = 2   # SHADOW' "$S/lib/py/bbx/propose_temporal.py" || fail "CONTROL DEAD: proposer-drift — the shadow was not perturbed (sed matched nothing)"
sp="$(PYTHONPATH="$S/lib/py" BBX_CONFIG="$W/c/bbx.toml" python3 -m bbx.propose_temporal "$W/base.log" "$W/three.log" --basis b | grep '^proposed:')"
se="$(PYTHONPATH="$S/lib/py" BBX_CONFIG="$W/c/bbx.toml" python3 -m bbx.compare_flicker "$W/base.log" "$W/three.log" || true)"
if [ "$sp" = "proposed: window b 100 102" ] && [ "$se" = "FLICKER 3 100,101,102" ] && grep -Eq "$RX" "$S/lib/py/bbx/propose_temporal.py"; then
    echo "CONTROL FIRED: proposer-drift — shadow proposer '$sp' vs enforcer '$se' (section 6 would fail on it), and section 3's check catches the literal"
else fail "CONTROL DEAD: proposer-drift — shadow proposer '$sp', enforcer '$se'"; fi

echo
[ "$rc" = 0 ] && echo "PASS: the thresholds are declared once, cannot drift, and cannot loosen without a ruling" || { echo "FAIL: see above"; exit 1; }
