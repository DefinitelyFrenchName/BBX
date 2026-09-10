#!/bin/sh
# compare_dispatch.sh — the one dispatcher runs every temporal class in both directions from its spec line, refuses a baseset/mask mismatch, an unknown class and a kind with no family, and takes its mask default from the profile
# Ground truth for lib/sh/compare.sh (abstraction C2, C4; R23). Cases lifted from bbh selftest/test_masked_compare.sh at
# f675710 (lineage: VampireSaved's tests/test_masked_compare.sh, verbatim cases — it caught a real bug in the original
# lift there: the diverge spec's temp-file STEM); BBX adds the kind dispatch (`compare_check`: the family comes from the
# kind, never the spec line) and the profile-resolved mask default. Synthetic logs, no instrument. Portable, ~2 s (1.6 s measured 2026-09-10).
# Usage: gates/compare_dispatch.sh        (BBX_CONFIG is unset inside: the frame-driven profile is in force)
# MUST-FIRE: known-bad: mask-mismatch — a set running a different mask than its basis, and a mask-carrying set citing a record-less basis, must each be REFUSED before any class runs, or two logs over different byte sets get compared
# MUST-FIRE: known-bad: unknown-class — a spec line whose class is not in the vocabulary must FAIL naming it, or a typo reads as a skip
# MUST-FIRE: known-bad: no-family-kind — compare_check on a kind the profile's table does not carry must FAIL naming the kind, or a kind nobody registered compares as something
# NOT-ASSERTED: the suite's dispatch around this library (which file is read, how many runs, the .sha1 and .diverge kinds' own paths): S2 step 3
# NOT-ASSERTED: anything about a real log or a real mask: every log is synthesized and the masks are strings the guard compares, never applied
#
set -eu
BBX_HOME="$(cd "$(dirname "$0")/.." && pwd)"; export BBX_HOME
PYTHONPATH="$BBX_HOME/lib/py"; export PYTHONPATH
unset BBX_CONFIG BBH_CONFIG BBX_MASK_DEFAULT 2>/dev/null || true
. "$BBX_HOME/lib/sh/compare.sh"
rc=0
ok()   { printf '  ok    %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1"; rc=1; }
W="$(mktemp -d)"; trap 'rm -rf "$W"' EXIT INT TERM
MASKSTR="043c-043d,7f00-8000"
ROOT="$W/expected"; mkdir -p "$ROOT/basis/logs" "$ROOT/theset"
printf '%s\n' "$MASKSTR" > "$ROOT/basis/MASK"; printf '%s\n' "$MASKSTR" > "$ROOT/theset/mask"
mk() { python3 -m bbx._mklog "$@"; }
mk "$ROOT/basis/logs/case.log" 400; mk "$W/same" 400; mk "$W/onebyte" 400 7; mk "$W/flick" 400 100,200; mk "$W/flick3" 400 100,200,300
mk "$W/window" 400 100-104; mk "$W/comp" 400 100-150,200; mk "$W/comp2" 400 100-150,200,300; mk "$W/late" 400 42-400; mk "$W/early" 400 10-400
check() {  # check <label> <want-rc> <name> <spec> <runmask> <log> [want-substring]
    _l="$1"; _w="$2"; _n="$3"; _s="$4"; _m="$5"; _lg="$6"; _want="${7:-}"
    if out=$(compare_temporal "$ROOT/theset" "$_n" "$_s" "$_m" "$_lg" 2>&1); then _rc=0; else _rc=$?; fi
    if [ "$_rc" != "$_w" ]; then fail "$_l (rc=$_rc want $_w): $(printf '%s' "$out" | tr '\n' ' ' | cut -c1-120)"; return; fi
    if [ -n "$_want" ] && ! printf '%s' "$out" | grep -q "$_want"; then fail "$_l (rc ok, but the verdict did not mention '$_want'): $(printf '%s' "$out" | tr '\n' ' ' | cut -c1-120)"; return; fi
    ok "$_l"
}
echo "== exact =="
check "bit-identical passes"                 0 case "exact basis -" "$MASKSTR" "$W/same"     "PASS masked-exact"
check "one differing frame fails"            1 case "exact basis -" "$MASKSTR" "$W/onebyte"  "FAIL masked live-state"
echo "== flicker (frozen inventory, drift either way is loud) =="
check "the frozen inventory passes"          0 case "flicker basis 2 100,200" "$MASKSTR" "$W/flick"  "PASS masked-flicker"
check "a GROWN inventory fails"              1 case "flicker basis 2 100,200" "$MASKSTR" "$W/flick3" "FAIL masked-flicker"
check "a SHRUNK inventory fails too"         1 case "flicker basis 2 100,200" "$MASKSTR" "$W/onebyte" "FAIL masked-flicker"
check "bit-identical is not a silent pass"   1 case "flicker basis 2 100,200" "$MASKSTR" "$W/same"    "FAIL masked-flicker"
echo "== diverge (the regression lock for the spec-stem bug) =="
check "divergence at the frozen frame"       0 case "diverge basis 42" "$MASKSTR" "$W/late"  "PASS"
check "an EARLIER onset fails"               1 case "diverge basis 42" "$MASKSTR" "$W/early"
check "no divergence at all fails"           1 case "diverge basis 42" "$MASKSTR" "$W/same"
compare_temporal "$ROOT/theset" case "diverge basis 42" "$MASKSTR" "$W/late" | grep -q "NO-BASE-LOG" && fail "a healthy diverge spec printed NO-BASE-LOG (the stem bug is back)" || ok "a healthy diverge spec finds its base log"
echo "== window =="
check "one contiguous run at the frozen onset" 0 case "window basis 100 104" "$MASKSTR" "$W/window" "PASS masked-window"
check "a drifting onset fails"                 1 case "window basis 110 114" "$MASKSTR" "$W/window"
check "bit-identical FAILS (the class asserts the divergence exists)" 1 case "window basis 100 104" "$MASKSTR" "$W/same"
echo "== composite (strict conjunction; adds no tolerance) =="
check "frozen flicker + frozen window passes" 0 case "composite basis 200 100-150" "$MASKSTR" "$W/comp"  "PASS masked-composite"
check "an unaccounted extra run fails"        1 case "composite basis 200 100-150" "$MASKSTR" "$W/comp2"
check "bit-identical fails"                   1 case "composite basis 200 100-150" "$MASKSTR" "$W/same"
echo "== CONTROL mask-mismatch: the baseset/mask invariant, both shapes =="
mkdir -p "$ROOT/oldbasis/logs"; cp "$ROOT/basis/logs/case.log" "$ROOT/oldbasis/logs/case.log"
o1=$(compare_temporal "$ROOT/theset" case "exact basis -" "043c-043d,dead-beef,7f00-8000" "$W/same" 2>&1) && o1="exit0:$o1" || true
o2=$(compare_temporal "$ROOT/theset" case "exact oldbasis -" "$MASKSTR" "$W/same" 2>&1) && o2="exit0:$o2" || true
case "$o1" in "FAIL mask mismatch: this set runs"*) case "$o2" in "FAIL mask mismatch: oldbasis has no MASK record"*) echo "CONTROL FIRED: mask-mismatch — a differing mask and a record-less basis are each refused before any class runs";; *) fail "CONTROL DEAD: mask-mismatch — record-less basis: $(printf '%s' "$o2" | head -1)";; esac;; *) fail "CONTROL DEAD: mask-mismatch — differing mask: $(printf '%s' "$o1" | head -1)";; esac
echo "== CONTROL unknown-class =="
o=$(compare_temporal "$ROOT/theset" case "sortof basis -" "$MASKSTR" "$W/same" 2>&1) && fail "CONTROL DEAD: unknown-class — 'sortof' passed" || { [ "$o" = "FAIL unknown .masked class 'sortof'" ] && echo "CONTROL FIRED: unknown-class — $o" || fail "CONTROL DEAD: unknown-class — '$o'"; }
echo "== the kind dispatch (R23): the family comes from the kind =="
o=$(compare_check "$ROOT/theset" case masked "exact basis -" "$MASKSTR" "$W/same") && [ "$o" = "PASS masked-exact" ] && ok "kind masked -> the temporal family, same verdict text" || fail "compare_check masked: '$o'"
o=$(compare_check "$ROOT/theset" case masked "flicker basis 2 100,200" "$MASKSTR" "$W/flick3") && fail "compare_check passed a grown inventory" || { case "$o" in "FAIL masked-flicker: got 'FLICKER 3 100,200,300'"*) ok "…and FAILs through the same path";; *) fail "compare_check flicker: '$o'";; esac; }
f="$(python3 -m bbx.expectations family masked)" && [ "$f" = temporal ] && ok "the profile's table names masked's family: temporal" || fail "family of masked: '$f'"
python3 -m bbx.expectations family sortof > "$W/fam" 2>&1 && fail "an unregistered kind has a family" || { [ "$(cat "$W/fam")" = "-" ] && ok "an unregistered kind has none ('-', exit 1)" || fail "unregistered family: $(cat "$W/fam")"; }
echo "== CONTROL no-family-kind =="
o=$(compare_check "$ROOT/theset" case weird "exact basis -" "$MASKSTR" "$W/same") && fail "CONTROL DEAD: no-family-kind — kind 'weird' compared" || { case "$o" in "FAIL kind 'weird' has no comparator family"*) echo "CONTROL FIRED: no-family-kind — $(printf '%s' "$o" | cut -c1-70)";; *) fail "CONTROL DEAD: no-family-kind — '$o'";; esac; }
echo "== compare_mask_for: the set's file, else the profile's default, else the env the runners export =="
[ "$(compare_mask_for "$ROOT/theset")" = "$MASKSTR" ] && ok "a set with a mask file reports it" || fail "a set with a mask file did not report it"
mkdir -p "$ROOT/nomask"
[ "$(compare_mask_for "$ROOT/nomask")" = "043c-043d,4182-41a2,7f00-8000" ] && ok "a set without one falls back to the frame-driven profile's default (bbh's literal, [suite].mask_default)" || fail "the default moved: $(compare_mask_for "$ROOT/nomask")"
m2="$(BBX_MASK_DEFAULT=aa-bb sh -c '. "$BBX_HOME/lib/sh/compare.sh"; compare_mask_for "$1"' _ "$ROOT/nomask")"
[ "$m2" = "aa-bb" ] && ok "BBX_MASK_DEFAULT (from [suite].mask_default, exported by the runners) overrides it" || fail "the env default was ignored: '$m2'"
printf '[project]\nkind = "self"\n' > "$W/self.toml"
m3="$(BBX_CONFIG="$W/self.toml" sh -c '. "$BBX_HOME/lib/sh/compare.sh"; compare_mask_for "$1"' _ "$ROOT/nomask")"
[ "$m3" = "" ] && ok "a kind with no mask concept has an EMPTY default, not bbh's literal (BBX-24: the biased default stays in its profile)" || fail "kind self mask default: '$m3'"

echo
[ "$rc" = 0 ] && echo "PASS: the one dispatcher holds every class both ways, refuses what it must, and takes the family from the kind" || { echo "FAIL: see above"; exit 1; }
