#!/bin/sh
# temporal.sh — the temporal comparison family accepts exactly its frozen shapes and rejects everything laxer, in both directions, on synthetic logs
# Ground truth for lib/py/bbx/compare_flicker.py, compare_window.py, compare_composite.py, check_diverge.py and
# propose_temporal.py (abstraction C1, C3, C5, C6), lifted from bbh's four selftests at f675710 (test_compare_flicker,
# test_compare_window, test_compare_composite; the .diverge kind had no selftest of its own in bbh and gets one here).
# Every case was paid for in the lineage: the END off-by-one (a tail of 59 read as 60), the terminal-stretch exemption
# (a permanent divergence the replay ends inside read as a flicker — GitHub #52 there), min() prefix-comparing a short
# log (issue #3), two zero-frame logs reading EXACT (#54). Synthetic logs, no instrument. Portable, ~3 s (2.7 s measured 2026-09-10).
# Usage: gates/temporal.sh        (BBX_CONFIG is unset inside: the shapes run under the frame-driven profile's thresholds, D23)
# MUST-FIRE: known-bad: window-identical — a bit-identical pair under the window class and under the composite class must FAIL, or an expectation that asserts a divergence EXISTS passes when it vanished
# MUST-FIRE: known-bad: short-is-not-diverged — a divergence the log ends inside must read FAIL-SHORT (the tail of 59 included), never FAIL or FLICKER, or "the replay is too short" and "the build diverged" are one finding (BBX-4)
# MUST-FIRE: known-bad: inventory-drift — an EXTRA and a MISSING flicker frame must each FAIL the composite, or drift in one direction is silent (the standing watch)
# MUST-FIRE: known-bad: diverge-off-by-one — a first divergence at n-1, at n+1 and one absent must each FAIL the frozen constant at n, or "exactly" means "about"
# NOT-ASSERTED: anything about a real log: every shape here is synthesized (fixture class); the classes' fitness for a consumer is that consumer's ratification
# NOT-ASSERTED: the dispatcher's spec line and the suite's dispatch (S2 steps 2 and 3): the comparators are called directly
# NOT-ASSERTED: that the thresholds are right for any subject: they are the frame-driven profile's (D23) and a consumer's override needs R25's ruling row (gates/thresholds.sh)
#
set -eu
BBX_HOME="$(cd "$(dirname "$0")/.." && pwd)"; export BBX_HOME
PYTHONPATH="$BBX_HOME/lib/py"; export PYTHONPATH
unset BBX_CONFIG BBH_CONFIG 2>/dev/null || true
rc=0
ok()   { printf '  ok    %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1"; rc=1; }
W="$(mktemp -d)"; trap 'rm -rf "$W"' EXIT INT TERM
# mklog <path> <n> [divergent: "a,b,c" and "lo-hi" ranges, comma separated] — frames 1..n, "<i> <hash>" then "END n"
mklog() { python3 "$BBX_HOME/lib/py/bbx/_mklog.py" "$@"; }
CF() { python3 -m bbx.compare_flicker "$@"; }
CW() { python3 -m bbx.compare_window "$@"; }
CC() { python3 -m bbx.compare_composite "$@"; }
CD() { python3 -m bbx.check_diverge "$@"; }
PT() { python3 -m bbx.propose_temporal "$@"; }

echo "== 1. flicker: the inventory is exact, the tail is measured to the last FRAME row =="
mklog "$W/base.log" 500; mklog "$W/same.log" 500
out=$(CF "$W/base.log" "$W/same.log") && [ "$out" = "EXACT" ] && ok "identical -> EXACT" || fail "identical: '$out'"
mklog "$W/flick1.log" 500 100
out=$(CF "$W/base.log" "$W/flick1.log") && [ "$out" = "FLICKER 1 100" ] && ok "single-frame flicker -> FLICKER 1 100" || fail "single flicker: '$out'"
mklog "$W/flick2.log" 500 100,101,300
out=$(CF "$W/base.log" "$W/flick2.log") && [ "$out" = "FLICKER 3 100,101,300" ] && ok "2-frame stretch + isolated -> FLICKER 3" || fail "multi flicker: '$out'"
mklog "$W/stretch3.log" 500 100,101,102
out=$(CF "$W/base.log" "$W/stretch3.log") && fail "3-frame stretch accepted: '$out'" || case "$out" in FAIL\ stretch*) ok "3-frame stretch -> FAIL stretch";; *) fail "3-frame stretch wrong reason: '$out'";; esac
mklog "$W/close.log" 500 100,140
out=$(CF "$W/base.log" "$W/close.log") && fail "40-frame gap accepted: '$out'" || case "$out" in FAIL\ only*converged*) ok "insufficient re-convergence -> FAIL";; *) fail "close flickers wrong reason: '$out'";; esac
mklog "$W/persist.log" 500 200-500
out=$(CF "$W/base.log" "$W/persist.log") && fail "persistent divergence accepted" || case "$out" in FAIL*) ok "persistent divergence -> FAIL";; *) fail "persistent: '$out'";; esac
mklog "$W/tail60.log" 500 440
out=$(CF "$W/base.log" "$W/tail60.log") && [ "$out" = "FLICKER 1 440" ] && ok "tail == min-converge (60) -> FLICKER" || fail "tail==60: '$out'"
mklog "$W/short.log" 499
out=$(CF "$W/base.log" "$W/short.log") && fail "length mismatch accepted" || case "$out" in FAIL\ length*) ok "length mismatch -> FAIL length";; *) fail "length: '$out'";; esac
printf 'END 0\n' > "$W/empty.log"; cp "$W/empty.log" "$W/empty2.log"
out=$(CF "$W/empty.log" "$W/empty2.log") && fail "two zero-frame logs read EXACT" || case "$out" in FAIL\ no\ frame*) ok "two zero-frame logs -> FAIL (nothing was compared)";; *) fail "empty: '$out'";; esac
mklog "$W/over.log" 500 20,40,60,80,100,120,140,160,180
out=$(CF "$W/base.log" "$W/over.log") && fail "9 flicker frames accepted over max-total 8" || case "$out" in FAIL\ 9\ divergent*max-total*) ok "9 divergent frames > max-total 8 -> FAIL";; *) fail "max-total: '$out'";; esac
# CONTROL short-is-not-diverged (1/2): the terminal-stretch exemption is gone; the END row is not a converged frame
mklog "$W/tail.log" 500 499; mklog "$W/tail59.log" 500 441
o1=$(CF "$W/base.log" "$W/tail.log") && o1="exit0:$o1" || true
o2=$(CF "$W/base.log" "$W/tail59.log") && o2="exit0:$o2" || true
case "$o1" in FAIL-SHORT*) case "$o2" in FAIL-SHORT*) echo "CONTROL FIRED: short-is-not-diverged — end-of-log flicker '$o1' and tail 59 '$(echo "$o2" | cut -c1-40)…' both FAIL-SHORT";; *) fail "CONTROL DEAD: short-is-not-diverged — tail 59 read '$o2' (END row counted as a converged frame?)";; esac;; *) fail "CONTROL DEAD: short-is-not-diverged — end-of-log flicker read '$o1'";; esac

echo "== 2. window: one contiguous run, a fixed onset, full re-convergence, the end state untouched =="
mklog "$W/b400.log" 400; mklog "$W/window.log" 400 100-104; mklog "$W/scattered.log" 400 100,101,150,151,200
mklog "$W/late.log" 400 120-124; mklog "$W/wtail.log" 400 396-400
check() {  # check <tool> <label> <want-rc> <args...>
    _t="$1"; _l="$2"; _w="$3"; shift 3
    if python3 -m "bbx.$_t" "$@" > "$W/out" 2>&1; then _rc=0; else _rc=$?; fi
    [ "$_rc" = "$_w" ] && ok "$_l" || { fail "$_l (rc=$_rc want $_w): $(tr '\n' ' ' < "$W/out" | cut -c1-160)"; }
}
check compare_window "single contiguous window at the frozen onset -> PASS" 0 "$W/b400.log" "$W/window.log" --onset 100 --end 104
check compare_window "scattered flicker is not a window" 1 "$W/b400.log" "$W/scattered.log" --onset 100 --end 200
check compare_window "a drifting onset is caught" 1 "$W/b400.log" "$W/late.log" --onset 100 --end 104
check compare_window "a window that never re-converges is caught" 1 "$W/b400.log" "$W/wtail.log" --onset 396 --end 400
head -201 "$W/window.log" > "$W/trunc.log"
check compare_window "a truncated log is not prefix-compared" 1 "$W/b400.log" "$W/trunc.log" --onset 100 --end 104
mklog "$W/latebreak.log" 400 100-104,300-400
check compare_window "the full log of a late permanent divergence FAILs" 1 "$W/b400.log" "$W/latebreak.log" --onset 100 --end 104
head -251 "$W/latebreak.log" > "$W/latebreak_trunc.log"
check compare_window "truncating before a permanent divergence does NOT rescue it" 1 "$W/b400.log" "$W/latebreak_trunc.log" --onset 100 --end 104

echo "== 3. composite: the conjunction, stricter than either component =="
N=4000
mklog "$W/c_base.log" $N; mklog "$W/c_ok.log" $N 829,2093,890-1802; mklog "$W/c_extra.log" $N 829,2093,890-1802,3100
mklog "$W/c_missing.log" $N 829,890-1802; mklog "$W/c_late.log" $N 829,2093,891-1802; mklog "$W/c_norec.log" $N 829,2093,890-$N
mklog "$W/c_second.log" $N 829,2093,890-1802,3000-3199; mklog "$W/c_latebreak.log" $N 829,2093,890-1802,3000-$N
head -2200 "$W/c_ok.log" > "$W/c_trunc.log"; echo "END 2200" >> "$W/c_trunc.log"
head -2500 "$W/c_latebreak.log" > "$W/c_latebreak_trunc.log"; echo "END 2500" >> "$W/c_latebreak_trunc.log"
mklog "$W/c_big.log" $N 1,3,5,7,9,11,13,15,17,19,890-1802; mklog "$W/c_close.log" $N 829,885,2093,945-1857
cc() { check compare_composite "$1" "$2" "$W/c_base.log" "$W/$3" --flicker 829,2093 --windows 890-1802; }
cc "exactly the frozen shape -> PASS" 0 c_ok.log
cc "the window onset moves by one frame -> FAIL" 1 c_late.log
cc "the window never re-converges -> FAIL" 1 c_norec.log
cc "an unfrozen second window appears -> FAIL" 1 c_second.log
cc "a truncated log is not prefix-compared -> FAIL" 1 c_trunc.log
cc "a permanent break after the frozen shape -> FAIL" 1 c_latebreak.log
cc "truncating before that break does not rescue it -> FAIL" 1 c_latebreak_trunc.log
check compare_composite "an over-cap flicker inventory (10) is rejected (max-total 8)" 1 "$W/c_base.log" "$W/c_big.log" --flicker 1,3,5,7,9,11,13,15,17,19 --windows 890-1802
check compare_composite "a 55-frame flicker gap passes by DEFAULT (the inter-run rule is policy, off)" 0 "$W/c_base.log" "$W/c_close.log" --flicker 829,885,2093 --windows 945-1857
check compare_composite "--min-converge-flicker 60 rejects the 55-frame gap when asked" 1 "$W/c_base.log" "$W/c_close.log" --flicker 829,885,2093 --windows 945-1857 --min-converge-flicker 60
check compare_composite "with no windows frozen, a long run is rejected (not a loophole)" 1 "$W/c_base.log" "$W/c_ok.log" --flicker 829,2093 --windows -
# CONTROL inventory-drift: extra and missing each FAIL
if ! CC "$W/c_base.log" "$W/c_extra.log" --flicker 829,2093 --windows 890-1802 > "$W/d1" 2>&1 && ! CC "$W/c_base.log" "$W/c_missing.log" --flicker 829,2093 --windows 890-1802 > "$W/d2" 2>&1 \
   && grep -q 'flicker frames \[829, 2093, 3100\], frozen expectation \[829, 2093\]' "$W/d1" && grep -q 'flicker frames \[829\], frozen expectation \[829, 2093\]' "$W/d2"; then
    echo "CONTROL FIRED: inventory-drift — an extra frame (3100) and a missing frame (2093) each FAIL naming the inventory"
else fail "CONTROL DEAD: inventory-drift — extra: $(tr '\n' ' ' < "$W/d1" | cut -c1-100) / missing: $(tr '\n' ' ' < "$W/d2" | cut -c1-100)"; fi
# CONTROL window-identical: a bit-identical pair FAILS the window class and the composite class
if ! CW "$W/b400.log" "$W/b400.log" --onset 100 --end 104 > "$W/i1" 2>&1 && grep -q 'expected a divergent window at frame 100, found none' "$W/i1" \
   && ! CC "$W/c_base.log" "$W/c_base.log" --flicker 829,2093 --windows 890-1802 > "$W/i2" 2>&1 && grep -q 'found no divergence at all' "$W/i2"; then
    echo "CONTROL FIRED: window-identical — a bit-identical pair FAILs the window class and the composite class (the divergence must EXIST)"
else fail "CONTROL DEAD: window-identical — window: $(tr '\n' ' ' < "$W/i1" | cut -c1-80) / composite: $(tr '\n' ' ' < "$W/i2" | cut -c1-80)"; fi

echo "== 4. the frozen first-divergence constant: line-identical through n-1, divergence EXACTLY at n =="
mkdir -p "$W/exp/basis/logs" "$W/spec"; mklog "$W/exp/basis/logs/r.log" 1000; mklog "$W/at900.log" 1000 900-1000
printf 'basis 900' > "$W/spec/r.diverge"
out=$(CD "$W/at900.log" "$W/spec/r.diverge" "$W/exp") && [ "$out" = "PASS (diverges from basis at exactly 900)" ] && ok "first divergence at exactly 900 -> PASS" || fail "at 900: '$out'"
mklog "$W/short999.log" 999 900-999
out=$(CD "$W/short999.log" "$W/spec/r.diverge" "$W/exp") && fail "a short log passed" || [ "$out" = "FAIL length mismatch (1000 vs 999 frames vs basis)" ] && ok "length mismatch -> FAIL (a short log is never a prefix match)" || fail "short: '$out'"
printf 'nosuch 900' > "$W/spec/q.diverge"
out=$(CD "$W/at900.log" "$W/spec/q.diverge" "$W/exp") && fail "a missing base log passed" || case "$out" in NO-BASE-LOG*) ok "a missing base log -> NO-BASE-LOG";; *) fail "no base: '$out'";; esac
# CONTROL diverge-off-by-one: n-1, n+1 and absent each FAIL
mklog "$W/at899.log" 1000 899-1000; mklog "$W/at901.log" 1000 901-1000; mklog "$W/never.log" 1000
o1=$(CD "$W/at899.log" "$W/spec/r.diverge" "$W/exp") && o1="exit0:$o1" || true
o2=$(CD "$W/at901.log" "$W/spec/r.diverge" "$W/exp") && o2="exit0:$o2" || true
o3=$(CD "$W/never.log" "$W/spec/r.diverge" "$W/exp") && o3="exit0:$o3" || true
if [ "$o1" = "FAIL first divergence at 899 (expected exactly 900 vs basis)" ] && [ "$o2" = "FAIL first divergence at 901 (expected exactly 900 vs basis)" ] && [ "$o3" = "FAIL first divergence at None (expected exactly 900 vs basis)" ]; then
    echo "CONTROL FIRED: diverge-off-by-one — 899, 901 and no divergence each FAIL the constant at 900"
else fail "CONTROL DEAD: diverge-off-by-one — '$o1' / '$o2' / '$o3'"; fi

echo "== 5. the proposer: proposes in the vocabulary, never ratifies; a proposed line drops into the enforcer verbatim (C5) =="
p=$(PT "$W/b400.log" "$W/b400.log" --basis b | grep '^proposed:'); [ "$p" = "proposed: exact b -" ] && ok "bit-identical -> exact" || fail "identical: '$p'"
p=$(PT "$W/base.log" "$W/flick2.log" --basis b | grep '^proposed:'); [ "$p" = "proposed: flicker b 3 100,101,300" ] && ok "three flicker frames -> flicker line" || fail "flicker: '$p'"
e=$(CF "$W/base.log" "$W/flick2.log"); [ "$e" = "FLICKER 3 100,101,300" ] && ok "…and the enforcer accepts the proposed inventory verbatim" || fail "enforcer: '$e'"
p=$(PT "$W/b400.log" "$W/window.log" --basis b | grep '^proposed:'); [ "$p" = "proposed: window b 100 104" ] && ok "one long run -> window line" || fail "window: '$p'"
CW "$W/b400.log" "$W/window.log" --onset 100 --end 104 > /dev/null 2>&1 && ok "…and the enforcer accepts the proposed window verbatim" || fail "window enforcer rejected the proposal"
p=$(PT "$W/c_base.log" "$W/c_ok.log" --basis b | grep '^proposed:'); [ "$p" = "proposed: composite b 829,2093 890-1802" ] && ok "flicker + window -> composite line" || fail "composite: '$p'"
p=$(PT "$W/b400.log" "$W/wtail.log" --basis b | grep '^proposed:'); case "$p" in "proposed: NONE — does not re-converge"*) ok "a shape that never re-converges -> NONE, not expressible (C6)";; *) fail "no-reconverge: '$p'";; esac
p=$(PT "$W/base.log" "$W/short.log" --basis b | grep '^shape:'); case "$p" in *"[LENGTH MISMATCH 500 vs 499]") ok "a length mismatch is named in the shape line";; *) fail "mismatch: '$p'";; esac
mklog "$W/t60.log" 500 440
p=$(PT "$W/base.log" "$W/t60.log" --basis b | grep '^proposed:'); [ "$p" = "proposed: flicker b 1 440" ] && ok "a tail of exactly RECONVERGE proposes (the proposer's <= bug, GitHub #53 there, stays fixed)" || fail "tail 60: '$p'"

echo
[ "$rc" = 0 ] && echo "PASS: the temporal family's five checkers and its proposer hold their frozen shapes in both directions" || { echo "FAIL: see above"; exit 1; }
