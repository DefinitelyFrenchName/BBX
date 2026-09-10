#!/bin/sh
# fidelity_bbh_s2.sh — the lifted suite, dispatcher and temporal family reproduce bbh's verdict text byte for byte over the same inputs (F12, F16, F17)
# THE FIDELITY OBLIGATION for slice S2 (CLAUDE.md §7.2; docs/fidelity.md): the generic comparators and the
# original run over the SAME input and their output — every printed line and the exit — is diffed. F17 rows:
# the flicker class (identical, one flicker, a 2-frame stretch + one, a 3-frame stretch, a short gap, a
# persistent divergence, a tail of 60 and of 59, an end-of-log divergence, a length mismatch, two empty logs,
# nine frames over the cap, the 3-frame stretch under a consumer flicker_max = 3); the window class (the
# frozen shape, scattered, a late onset, no re-convergence, a bit-identical pair, a truncation, a late
# permanent break and its truncation); the composite class (the frozen shape, an extra and a missing flicker
# frame, a late onset, no re-convergence, identical, a second window, a truncation, a late break and its
# truncation, an over-cap inventory, the inter-run rule off and on, no windows frozen); the frozen
# first-divergence constant (exactly n, n-1, n+1, absent, a short log, a missing base log); the proposer
# (identical, flicker, window, composite, not re-converging, a length mismatch, a tail of exactly 60, and the
# consumer override with its R25 ruling rows). F16 rows (S2 step 2): F16a every `.masked` spec of bbh's example
# (10: build-a and build-b, five classes each) against logs the FAKE DRIVER writes on the clone, through bbh's
# `masked_check` and BBX's `compare_temporal` (and `compare_check` by kind); F16b the dispatcher's synthetic ground
# truth (every class both ways, the two mask-guard shapes, the unknown class, the mask default with and without the
# runner's variable); F16c the kind enumeration over `example/expected/build-a` and over a tree with a `.pending` and
# an unknown kind. F12 rows (S2 step 3): both suite runners over the same copy of bbh's example — the four registered
# images, the unregistered one, FAKE_NONDET, FAKE_CRASH_AT, a perturbed copy (a wrong .sha1, a deleted expectation, a
# moved inventory, a .pending, a moved .diverge, the mask guard), SUITE_ONLY, a POKES in the environment, the input
# demand, a set that resolves nowhere, and --freeze twice on a copy per side (an empty set; then an authored .masked
# and a .diverge to retire).
# Usage: BBX_BBH_HOME=~/Developer/blackbox-harness gates/fidelity_bbh_s2.sh     (~70 s measured 2026-09-10 with F12, F16 and F17 — F12 is 17 suite pairs; static tier)
# SKIP: BBX_BBH_HOME unset or not a bbh tree (exit 0; asserts nothing).
# READ-ONLY (R18, R20): bbh is measured on a PLAIN LOCAL CLONE of the baseline commit under TMPDIR (BBX_BBH_BASELINE,
# default f675710 — R8; docs/defaults.md D20); after the run the clone must be clean of tracked, untracked AND ignored
# entries, or FAIL. PYTHONDONTWRITEBYTECODE=1 is exported for the whole gate: on this host python writes bytecode to a
# user cache (sys.pycache_prefix, measured 2026-09-10), on Linux it would write __pycache__ INTO the clone and the
# clean check would fail there for a reason that is not bbh's.
# MUST-FIRE: perturbed-copy: verdict-text-f17 — a shadow copy of the bbx lib with one verdict string changed in compare_flicker must make the flicker rows' diff non-empty, or the diff cannot fail
# MUST-FIRE: perturbed-copy: verdict-text-f12 — a shadow copy of bin/bbx-run-suite with the SUITE GREEN line changed must make an F12 pair differ, or the suite-side diff cannot fail
# MUST-FIRE: perturbed-copy: verdict-text-f16 — a shadow copy of lib/sh/compare.sh with one verdict string changed must make an F16a pair differ, or the sh-side diff cannot fail
# NOT-ASSERTED: the kept suite run (--log) — bbh has none, so F12 diffs printed text only; the kept run's ground truth is gates/suite.sh
# NOT-ASSERTED: anything about a real subject: F17's and F16b's inputs are synthesized, F16a's are the fake machine's (fixture class); the shapes are the lineage's paid-for cases and nothing else
# NOT-ASSERTED: bbh's correctness: identical output on both sides is fidelity, not truth
#
set -eu
BBX_HOME="$(cd "$(dirname "$0")/.." && pwd)"; export BBX_HOME
PYTHONDONTWRITEBYTECODE=1; export PYTHONDONTWRITEBYTECODE
unset BBX_CONFIG BBH_CONFIG 2>/dev/null || true
B_SRC="${BBX_BBH_HOME:-}"
[ -n "$B_SRC" ] && [ -x "$B_SRC/bin/bbh-run-static" ] || { echo "SKIP: BBX_BBH_HOME is not a bbh tree (${B_SRC:-unset}); fidelity needs it"; exit 0; }
B_SRC="$(cd "$B_SRC" && pwd)"
BASELINE="${BBX_BBH_BASELINE:-f675710}"   # ruling R8; docs/defaults.md D20
rc=0
ok()   { printf '  ok    %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1"; rc=1; }
T="$(mktemp -d)"; trap 'rm -rf "$T"' EXIT INT TERM
_rb="$(grep -m1 '^- ' "$BBX_HOME/docs/rebaselines.md" 2>/dev/null || echo '- (none recorded)')"
echo "LAST RE-BASELINE: ${_rb#- }"
_tip="$(git -C "$B_SRC" rev-parse --short HEAD)"; _porc="$(git -C "$B_SRC" status --porcelain | wc -l | tr -d ' ')"
git -C "$B_SRC" cat-file -e "$BASELINE^{commit}" 2>/dev/null || { echo "FAIL: baseline $BASELINE is not a commit of $B_SRC (BBX_BBH_BASELINE)"; exit 1; }
B="$T/bbh"
{ git clone -q --no-checkout "$B_SRC" "$B" && git -C "$B" checkout -q "$BASELINE"; } || { echo "SETUP-FAIL: could not clone $B_SRC at $BASELINE under $T"; exit 1; }
_ahead="$(git -C "$B_SRC" rev-list --count "$BASELINE..HEAD" 2>/dev/null || echo '?')"
echo "bbh: $B_SRC tip=$_tip porcelain=$_porc — measured on a plain clone at $BASELINE (R8, R20), ahead=$_ahead"
[ "$_ahead" = 0 ] || echo "NOTE: bbh-drift baseline=$BASELINE tip=$_tip ahead=$_ahead"

W="$T/logs"; mkdir -p "$W"
mk() { python3 "$BBX_HOME/lib/py/bbx/_mklog.py" "$@"; }
# the same files for both sides; one config with its R25 ruling rows (bbh reads the three keys and ignores `rulings`)
mkdir -p "$W/cfg"; printf '[thresholds]\nflicker_max = 3\nreconverge = 10\nrulings = { flicker_max = "F17-fixture", reconverge = "F17-fixture" }\n' > "$W/cfg/bbh.toml"
mk "$W/f_base" 500; mk "$W/f_same" 500; mk "$W/f_1" 500 100; mk "$W/f_2" 500 100,101,300; mk "$W/f_3" 500 100-102; mk "$W/f_close" 500 100,140
mk "$W/f_persist" 500 200-500; mk "$W/f_t60" 500 440; mk "$W/f_t59" 500 441; mk "$W/f_tail" 500 499; mk "$W/f_short" 499; printf 'END 0\n' > "$W/f_empty"; cp "$W/f_empty" "$W/f_empty2"
mk "$W/f_over" 500 20,40,60,80,100,120,140,160,180
mk "$W/w_base" 400; mk "$W/w_win" 400 100-104; mk "$W/w_scat" 400 100,101,150,151,200; mk "$W/w_late" 400 120-124; mk "$W/w_tail" 400 396-400
head -201 "$W/w_win" > "$W/w_trunc"; mk "$W/w_lb" 400 100-104,300-400; head -251 "$W/w_lb" > "$W/w_lbt"
N=4000; mk "$W/c_base" $N; mk "$W/c_ok" $N 829,2093,890-1802; mk "$W/c_extra" $N 829,2093,890-1802,3100; mk "$W/c_miss" $N 829,890-1802
mk "$W/c_late" $N 829,2093,891-1802; mk "$W/c_norec" $N 829,2093,890-$N; mk "$W/c_2nd" $N 829,2093,890-1802,3000-3199; mk "$W/c_lb" $N 829,2093,890-1802,3000-$N
{ head -2200 "$W/c_ok"; echo "END 2200"; } > "$W/c_trunc"; { head -2500 "$W/c_lb"; echo "END 2500"; } > "$W/c_lbt"
mk "$W/c_big" $N 1,3,5,7,9,11,13,15,17,19,890-1802; mk "$W/c_close" $N 829,885,2093,945-1857
mkdir -p "$W/exp/basis/logs" "$W/spec"; mk "$W/exp/basis/logs/r.log" 1000; mk "$W/d_900" 1000 900-1000; mk "$W/d_899" 1000 899-1000; mk "$W/d_901" 1000 901-1000; mk "$W/d_never" 1000; mk "$W/d_short" 999 900-999
printf 'basis 900' > "$W/spec/r.diverge"; printf 'nosuch 900' > "$W/spec/q.diverge"
mk "$W/p_base" 200; mk "$W/p_three" 200 100-102

pairs=0; bad=0
pair() {  # pair <label> <bbh-module> <bbx-module> [BBX_CONFIG=<file>] <args...> — output + exit of both, diffed
    _l="$1"; _ma="$2"; _mb="$3"; shift 3; _cfg=""
    case "${1:-}" in CFG=*) _cfg="${1#CFG=}"; shift ;; esac
    # set +e inside: under set -e a failing comparator would end the subshell before its exit line (this gate's own first defect, 2026-09-10; fidelity_bbh.sh survives the same shape only because its subshell feeds a pipe)
    (set +e; cd "$W" && PYTHONPATH="$B/lib/py" BBH_CONFIG="$_cfg" python3 -m "bbh.$_ma" "$@" 2>&1; echo "exit=$?") > "$T/a.txt"
    (set +e; cd "$W" && PYTHONPATH="${SHADOW_LIB:-$BBX_HOME/lib/py}" BBX_CONFIG="$_cfg" python3 -m "bbx.$_mb" "$@" 2>&1; echo "exit=$?") > "$T/b.txt"
    pairs=$((pairs + 1))
    if diff "$T/a.txt" "$T/b.txt" > "$T/d.txt"; then ok "$_l — identical ($(head -1 "$T/a.txt" | cut -c1-60))"
    else bad=$((bad + 1)); fail "$_l — DIFFERS:"; head -12 "$T/d.txt" | sed 's/^/        /'; fi
}
CFG="CFG=$W/cfg/bbh.toml"
echo "== F17a. the flicker class =="
for c in "identical f_same" "one flicker f_1" "2-stretch+1 f_2" "3-stretch f_3" "short gap f_close" "persistent f_persist" "tail 60 f_t60" "tail 59 f_t59" "end-of-log f_tail" "length f_short" "over cap f_over"; do
    pair "flicker ${c% *}" compare_flicker compare_flicker f_base "${c##* }"; done
pair "flicker two empty logs" compare_flicker compare_flicker f_empty f_empty2
pair "flicker 3-stretch under flicker_max=3" compare_flicker compare_flicker $CFG f_base f_3
echo "== F17b. the window class =="
pair "window frozen shape" compare_window compare_window w_base w_win --onset 100 --end 104
pair "window scattered" compare_window compare_window w_base w_scat --onset 100 --end 200
pair "window late onset" compare_window compare_window w_base w_late --onset 100 --end 104
pair "window never re-converges" compare_window compare_window w_base w_tail --onset 396 --end 400
pair "window bit-identical pair" compare_window compare_window w_base w_base --onset 100 --end 104
pair "window truncated" compare_window compare_window w_base w_trunc --onset 100 --end 104
pair "window late break" compare_window compare_window w_base w_lb --onset 100 --end 104
pair "window late break truncated" compare_window compare_window w_base w_lbt --onset 100 --end 104
pair "window under reconverge=10" compare_window compare_window $CFG w_base w_win --onset 100 --end 104
echo "== F17c. the composite class =="
for c in c_ok c_extra c_miss c_late c_norec c_base c_2nd c_trunc c_lb c_lbt; do pair "composite $c" compare_composite compare_composite c_base "$c" --flicker 829,2093 --windows 890-1802; done
pair "composite over-cap inventory" compare_composite compare_composite c_base c_big --flicker 1,3,5,7,9,11,13,15,17,19 --windows 890-1802
pair "composite inter-run rule off" compare_composite compare_composite c_base c_close --flicker 829,885,2093 --windows 945-1857
pair "composite inter-run rule on" compare_composite compare_composite c_base c_close --flicker 829,885,2093 --windows 945-1857 --min-converge-flicker 60
pair "composite no windows frozen" compare_composite compare_composite c_base c_ok --flicker 829,2093 --windows -
pair "composite under flicker_max=3" compare_composite compare_composite $CFG c_base c_ok --flicker 829,2093 --windows 890-1802
echo "== F17d. the frozen first-divergence constant =="
for c in d_900 d_899 d_901 d_never d_short; do pair "diverge $c" check_diverge check_diverge "$c" spec/r.diverge exp; done
pair "diverge missing base log" check_diverge check_diverge d_900 spec/q.diverge exp
echo "== F17e. the proposer =="
pair "proposer identical" describe_masked_shape propose_temporal w_base w_base --basis b
pair "proposer flicker" describe_masked_shape propose_temporal f_base f_2 --basis b
pair "proposer window" describe_masked_shape propose_temporal w_base w_win --basis b
pair "proposer composite" describe_masked_shape propose_temporal c_base c_ok --basis b
pair "proposer not re-converging" describe_masked_shape propose_temporal w_base w_tail --basis b
pair "proposer length mismatch" describe_masked_shape propose_temporal f_base f_short --basis b
pair "proposer tail of exactly 60" describe_masked_shape propose_temporal f_base f_t60 --basis b
pair "proposer under the override" describe_masked_shape propose_temporal $CFG p_base p_three --basis b
pair "proposer default on the same shape" describe_masked_shape propose_temporal p_base p_three --basis b
echo "  F17: $pairs pairs, $bad differ"

pairsh() {  # pairsh <label> <bbh-sh-snippet> <bbx-sh-snippet> — each sourced in its own sh with its own home; output + exit diffed
    _l="$1"; _a="$2"; _b="$3"
    (set +e; cd "$W"; BBH_HOME="$B" PYTHONPATH="$B/lib/py" sh -c ". \"\$BBH_HOME/lib/sh/masked_compare.sh\"; . \"\$BBH_HOME/lib/sh/enumerate_expectations.sh\"; $_a" 2>&1; echo "exit=$?") > "$T/a.txt"
    (set +e; cd "$W"; BBX_HOME="$BBX_HOME" PYTHONPATH="${SHADOW_LIB:-$BBX_HOME/lib/py}" sh -c ". \"${SHADOW_SH:-$BBX_HOME/lib/sh}/compare.sh\"; . \"\$BBX_HOME/lib/sh/expectation_kinds.sh\"; $_b" 2>&1; echo "exit=$?") > "$T/b.txt"
    pairs=$((pairs + 1))
    if diff "$T/a.txt" "$T/b.txt" > "$T/d.txt"; then ok "$_l — identical ($(head -1 "$T/a.txt" | cut -c1-70))"
    else bad=$((bad + 1)); fail "$_l — DIFFERS:"; head -12 "$T/d.txt" | sed 's/^/        /'; fi
}
echo "== F16a. every .masked spec of bbh's example, against logs the fake driver writes on the clone =="
EX="$B/example"; mkdir -p "$W/runs"; _drv=0
for bld in build-a build-b; do
    _mask="$(cat "$EX/expected/$bld/mask")"
    for spec in "$EX/expected/$bld"/*.masked; do
        name="$(basename "$spec" .masked)"; log="$W/runs/$bld.$name.log"
        BBH_HOME="$B" FAKE_ROMPATH="$EX/roms/$bld" MASK_RANGES="$_mask" "$B/drivers/fake.sh" fake "$EX/replays/$name.rpl" "$log" > "$W/runs/$bld.$name.drv" 2>&1 || { fail "the fake driver failed on $bld/$name: $(head -2 "$W/runs/$bld.$name.drv" | tr '\n' ' ')"; continue; }
        _drv=$((_drv + 1))
        pairsh "F16a $bld/$name ($(cat "$spec"))" \
            "masked_check '$EX/expected/$bld' '$name' '$(cat "$spec")' '$_mask' '$log'" \
            "compare_temporal '$EX/expected/$bld' '$name' '$(cat "$spec")' '$_mask' '$log'"
    done
done
pairsh "F16a build-a/03_press through compare_check by KIND (R23)" \
    "masked_check '$EX/expected/build-a' 03_press '$(cat "$EX/expected/build-a/03_press.masked")' '$(cat "$EX/expected/build-a/mask")' '$W/runs/build-a.03_press.log'" \
    "compare_check '$EX/expected/build-a' 03_press masked '$(cat "$EX/expected/build-a/03_press.masked")' '$(cat "$EX/expected/build-a/mask")' '$W/runs/build-a.03_press.log'"
echo "  F16a: $_drv driver runs"
echo "== F16b. the dispatcher's synthetic ground truth, both implementations =="
MASKSTR="043c-043d,7f00-8000"; R="$W/exp16"; mkdir -p "$R/basis/logs" "$R/theset" "$R/oldbasis/logs" "$R/nomask"
printf '%s\n' "$MASKSTR" > "$R/basis/MASK"; printf '%s\n' "$MASKSTR" > "$R/theset/mask"
mk "$R/basis/logs/case.log" 400; cp "$R/basis/logs/case.log" "$R/oldbasis/logs/case.log"
mk "$W/s_same" 400; mk "$W/s_one" 400 7; mk "$W/s_flick" 400 100,200; mk "$W/s_flick3" 400 100,200,300; mk "$W/s_win" 400 100-104; mk "$W/s_comp" 400 100-150,200; mk "$W/s_comp2" 400 100-150,200,300; mk "$W/s_late" 400 42-400; mk "$W/s_early" 400 10-400
while IFS='|' read -r spec mask log; do
    pairsh "F16b '$spec' on $(basename "$log")" "masked_check '$R/theset' case '$spec' '$mask' '$log'" "compare_temporal '$R/theset' case '$spec' '$mask' '$log'"
done <<CASES
exact basis -|$MASKSTR|$W/s_same
exact basis -|$MASKSTR|$W/s_one
flicker basis 2 100,200|$MASKSTR|$W/s_flick
flicker basis 2 100,200|$MASKSTR|$W/s_flick3
flicker basis 2 100,200|$MASKSTR|$W/s_one
flicker basis 2 100,200|$MASKSTR|$W/s_same
diverge basis 42|$MASKSTR|$W/s_late
diverge basis 42|$MASKSTR|$W/s_early
diverge basis 42|$MASKSTR|$W/s_same
window basis 100 104|$MASKSTR|$W/s_win
window basis 110 114|$MASKSTR|$W/s_win
window basis 100 104|$MASKSTR|$W/s_same
composite basis 200 100-150|$MASKSTR|$W/s_comp
composite basis 200 100-150|$MASKSTR|$W/s_comp2
composite basis 200 100-150|$MASKSTR|$W/s_same
exact basis -|043c-043d,dead-beef,7f00-8000|$W/s_same
exact oldbasis -|$MASKSTR|$W/s_same
sortof basis -|$MASKSTR|$W/s_same
CASES
pairsh "F16b mask_for: a set with a mask file" "masked_mask_for '$R/theset'" "compare_mask_for '$R/theset'"
pairsh "F16b mask_for: a set without one (the profile's default = bbh's literal)" "masked_mask_for '$R/nomask'" "compare_mask_for '$R/nomask'"
pairsh "F16b mask_for: the runner's variable overrides" "BBH_MASK_DEFAULT=aa-bb sh -c '. \"\$BBH_HOME/lib/sh/masked_compare.sh\"; masked_mask_for \"\$1\"' _ '$R/nomask'" "BBX_MASK_DEFAULT=aa-bb sh -c '. \"\$BBX_HOME/lib/sh/compare.sh\"; compare_mask_for \"\$1\"' _ '$R/nomask'"
echo "== F16c. the kind enumeration =="
pairsh "F16c enumerate example/expected/build-a" "enumerate_expectations '$EX/expected/build-a' '$EX' replays" "enumerate_expectations '$EX/expected/build-a' '$EX' replays"
pairsh "F16c enumerate example/expected/attract (a .diverge among .sha1)" "enumerate_expectations '$EX/expected/attract' '$EX' replays" "enumerate_expectations '$EX/expected/attract' '$EX' replays"
E16="$W/enum"; mkdir -p "$E16/root/tests/replays" "$E16/exp"; for r in a b c d e; do : > "$E16/root/tests/replays/$r.rpl"; done
echo "exact basis -" > "$E16/exp/a.masked"; : > "$E16/exp/b.skip"; : > "$E16/exp/c.sha1"; : > "$E16/exp/notareplay.masked"; echo "pending prose" > "$E16/exp/d.pending"; : > "$E16/exp/e.weird"
pairsh "F16c enumerate a tree with a .pending and an unknown kind (non-zero)" "enumerate_expectations '$E16/exp' '$E16/root'" "enumerate_expectations '$E16/exp' '$E16/root'"
echo "  F16+F17: $pairs pairs, $bad differ"

pairsuite() {  # pairsuite <label> <bbh-copy> <bbx-copy> <env...> -- <args...>: both suites, the copies' paths normalised to EX, output + exit diffed
    _l="$1"; _ca="$2"; _cb="$3"; shift 3; _env=""
    while [ $# -gt 0 ] && [ "$1" != "--" ]; do _env="$_env $1"; shift; done; [ $# -gt 0 ] && shift
    _ea="$(printf '%s' "$_env" | sed "s#@COPY@#$_ca#g")"; _eb="$(printf '%s' "$_env" | sed "s#@COPY@#$_cb#g")"
    # the diff head bbh prints after NONDETERMINISTIC is `< <frame> <hash>` / `> <frame> <hash>`; under FAKE_NONDET the
    # hashes are random by design and each side ran its own pair, so those 16-hex tokens (and only those) read HASH
    _nrm='s/^\([<>] [0-9][0-9]* \)[0-9a-f]\{16\}$/\1HASH/'
    (set +e; cd "$_ca"; env FAKE_ROOT="$_ca" $_ea BBH_HOME="$B" "$B/bin/bbh" run-suite --config "$_ca/bbh.toml" "$@" 2>&1; echo "exit=$?") | sed -e "s#$_ca#EX#g" -e "$_nrm" > "$T/a.txt"
    (set +e; cd "$_cb"; env FAKE_ROOT="$_cb" $_eb BBX_BBH_HOME="$B" "$BBX_HOME/bin/bbx-run-suite" --config "$_cb/bbh.toml" "$@" 2>&1; echo "exit=$?") | sed -e "s#$_cb#EX#g" -e "$_nrm" > "$T/b.txt"
    pairs=$((pairs + 1))
    if diff "$T/a.txt" "$T/b.txt" > "$T/d.txt"; then ok "$_l — identical ($(wc -l < "$T/a.txt" | tr -d ' ') lines)"
    else bad=$((bad + 1)); fail "$_l — DIFFERS:"; head -12 "$T/d.txt" | sed 's/^/        /'; fi
}
echo "== F12. the suite: bbh's example through both runners, the same copy for both sides =="
EXA="$T/exA"; cp -R "$B/example" "$EXA"
unset FAKE_ROMPATH MASK_RANGES DUMPS POKES SNAP_FRAMES VIDEO_OUT INPUT_OUT TAIL_FRAMES INPUT_INJECT_TEST NO_INPUT_CHECK FAKE_BUILD FAKE_NONDET FAKE_CRASH_AT SUITE_ONLY 2>/dev/null || true
for img in build-a build-b base attract; do pairsuite "F12a/b roms/$img" "$EXA" "$EXA" FAKE_ROMPATH="$EXA/roms/$img" --; done
pairsuite "F12c roms/hook (unregistered)" "$EXA" "$EXA" FAKE_ROMPATH="$EXA/roms/hook" --
pairsuite "F12d FAKE_NONDET=1 (the NONDETERMINISTIC line and the diff's head)" "$EXA" "$EXA" FAKE_ROMPATH="$EXA/roms/base" FAKE_NONDET=1 --
pairsuite "F12d FAKE_CRASH_AT=50 (RUN-FAIL)" "$EXA" "$EXA" FAKE_ROMPATH="$EXA/roms/base" FAKE_CRASH_AT=50 --
EXP="$T/exP"; cp -R "$B/example" "$EXP"
printf '%s\n' "0000000000000000000000000000000000000000" > "$EXP/expected/base/01_idle.sha1"; rm "$EXP/expected/base/06_other_set.sha1"
printf 'flicker base/masked 2 100,251\n' > "$EXP/expected/build-a/03_press.masked"; printf 'measured: awaiting ratification\n' > "$EXP/expected/build-a/02_coin_start.pending"
printf 'base 901' > "$EXP/expected/attract/05_attract.diverge"
for img in base build-a attract; do pairsuite "F12e perturbed copy, roms/$img (a wrong .sha1, a deleted expectation, a moved inventory, a .pending, a moved .diverge)" "$EXP" "$EXP" FAKE_ROMPATH="$EXP/roms/$img" --; done
printf 'ff00-ff80' > "$EXP/expected/build-a/mask"
pairsuite "F12e the mask guard (set mask differs from the basis record)" "$EXP" "$EXP" FAKE_ROMPATH="$EXP/roms/build-a" --
pairsuite "F12f SUITE_ONLY" "$EXA" "$EXA" FAKE_ROMPATH="$EXA/roms/base" SUITE_ONLY="01_idle 03_press" --
pairsuite "F12f POKES in the environment (the hermetic scrub)" "$EXA" "$EXA" FAKE_ROMPATH="$EXA/roms/base" POKES="50:1000:ff" --
pairsuite "F12f the input demand (FAKE_ROOT empty)" "$EXA" "$EXA" FAKE_ROOT= --
pairsuite "F12f a positional set that resolves nowhere" "$EXA" "$EXA" FAKE_ROMPATH="$EXA/roms/base" -- nosuch
EXF1="$T/exF1"; EXF2="$T/exF2"; cp -R "$B/example" "$EXF1"; cp -R "$B/example" "$EXF2"
for d in "$EXF1" "$EXF2"; do sed -i.bak "s/	build-b	/	bb-fresh	/" "$d/expected/registry.tsv"; rm "$d/expected/registry.tsv.bak"; done
pairsuite "F12f --freeze on an empty set (each side its own copy)" "$EXF1" "$EXF2" FAKE_ROMPATH="@COPY@/roms/build-b" -- --freeze
(cd "$EXF1/expected/bb-fresh" && find . | sort) > "$T/fz1.txt"; (cd "$EXF2/expected/bb-fresh" && find . | sort) > "$T/fz2.txt"
cmp -s "$T/fz1.txt" "$T/fz2.txt" && ok "F12f both freezes wrote the same files ($(wc -l < "$T/fz1.txt" | tr -d ' ') entries)" || fail "F12f the two freezes wrote different files"
for d in "$EXF1" "$EXF2"; do printf 'ff00-10000' > "$d/expected/bb-fresh/mask"; printf 'exact base/masked -\n' > "$d/expected/bb-fresh/01_idle.masked"; rm "$d/expected/bb-fresh/01_idle.sha1"; printf 'base 42' > "$d/expected/bb-fresh/02_coin_start.diverge"; done
pairsuite "F12f --freeze leaves an authored .masked alone and RETIRES a .diverge" "$EXF1" "$EXF2" FAKE_ROMPATH="@COPY@/roms/build-b" -- --freeze
echo "  F12+F16+F17: $pairs pairs, $bad differ"

echo "== MUST-FIRE: a verdict-text change is visible to F16 =="
SH="$T/shadow_sh"; mkdir -p "$SH"; cp "$BBX_HOME/lib/sh/compare.sh" "$SH/compare.sh"
sed -i.bak 's/echo "PASS masked-exact"/echo "PASS masked-exact."/' "$SH/compare.sh"
if cmp -s "$SH/compare.sh" "$BBX_HOME/lib/sh/compare.sh"; then echo "CONTROL DEAD: verdict-text-f16 — the shadow copy was not perturbed (sed matched nothing)"; fail "control could not be built"
else
    _pb=$pairs; _bb=$bad
    SHADOW_SH="$SH" pairsh "shadow: F16a build-a/01_idle" "masked_check '$EX/expected/build-a' 01_idle 'exact base/masked -' '$(cat "$EX/expected/build-a/mask")' '$W/runs/build-a.01_idle.log'" "compare_temporal '$EX/expected/build-a' 01_idle 'exact base/masked -' '$(cat "$EX/expected/build-a/mask")' '$W/runs/build-a.01_idle.log'" > "$T/shadow16.out" 2>&1 || true
    if [ "$bad" -gt "$_bb" ]; then echo "CONTROL FIRED: verdict-text-f16 — one changed verdict string in compare.sh, the pair differs: $(grep '^[<>]' "$T/d.txt" | tr '\n' ' ' | cut -c1-80)"; bad=$_bb; rc=0; ok "the F16 diff can fail"
    else echo "CONTROL DEAD: verdict-text-f16 — a changed verdict string produced an empty diff"; fail "the diff cannot fail"; fi
    pairs=$_pb
fi

echo "== MUST-FIRE: a verdict-text change is visible to F12 =="
SB="$T/shadow_bin"; mkdir -p "$SB/bin"; ln -s "$BBX_HOME/lib" "$SB/lib"; cp "$BBX_HOME/bin/bbx-run-suite" "$SB/bin/bbx-run-suite"; chmod +x "$SB/bin/bbx-run-suite"
sed -i.bak 's/echo "SUITE GREEN"/echo "SUITE GREEN."/' "$SB/bin/bbx-run-suite"
if cmp -s "$SB/bin/bbx-run-suite" "$BBX_HOME/bin/bbx-run-suite"; then echo "CONTROL DEAD: verdict-text-f12 — the shadow copy was not perturbed (sed matched nothing)"; fail "control could not be built"
else
    _pb=$pairs; _bb=$bad; _keep_home="$BBX_HOME"
    BBX_HOME="$SB" pairsuite "shadow: F12 roms/base" "$EXA" "$EXA" FAKE_ROMPATH="$EXA/roms/base" -- > "$T/shadow12.out" 2>&1 || true
    BBX_HOME="$_keep_home"
    if [ "$bad" -gt "$_bb" ]; then echo "CONTROL FIRED: verdict-text-f12 — one changed line in the suite runner, the pair differs: $(grep '^[<>]' "$T/d.txt" | tr '\n' ' ' | cut -c1-80)"; bad=$_bb; rc=0; ok "the F12 diff can fail"
    else echo "CONTROL DEAD: verdict-text-f12 — a changed SUITE GREEN line produced an empty diff"; fail "the diff cannot fail"; fi
    pairs=$_pb
fi

echo "== MUST-FIRE: a verdict-text change is visible to F17 =="
S="$T/shadow"; mkdir -p "$S/lib/py"; cp -R "$BBX_HOME/lib/py/bbx" "$S/lib/py/bbx"
sed -i.bak 's/print("EXACT")/print("EXACT.")/' "$S/lib/py/bbx/compare_flicker.py"
if cmp -s "$S/lib/py/bbx/compare_flicker.py" "$BBX_HOME/lib/py/bbx/compare_flicker.py"; then echo "CONTROL DEAD: verdict-text-f17 — the shadow copy was not perturbed (sed matched nothing)"; fail "control could not be built"
else
    _pb=$pairs; _bb=$bad
    SHADOW_LIB="$S/lib/py" pair "shadow: flicker identical" compare_flicker compare_flicker f_base f_same > "$T/shadow.out" 2>&1 || true
    if [ "$bad" -gt "$_bb" ]; then echo "CONTROL FIRED: verdict-text-f17 — one changed verdict string, the pair differs: $(grep '^[<>]' "$T/d.txt" | tr '\n' ' ' | cut -c1-80)"; bad=$_bb; rc=0; ok "the F17 diff can fail"
    else echo "CONTROL DEAD: verdict-text-f17 — a changed verdict string produced an empty diff"; fail "the diff cannot fail"; fi
    pairs=$_pb
fi

echo "== READ-ONLY: the clone after the run (R18, R20) =="
_dirt="$(git -C "$B" status --porcelain --ignored)"
if [ -z "$_dirt" ]; then ok "the clone is clean after the run: 0 tracked, untracked or ignored entries"
else fail "the clone was WRITTEN by this gate:"; printf '%s\n' "$_dirt" | sed 's/^/        /' | head -12; fi
echo "NOTE: bbh-source tip=$_tip porcelain=$_porc untouched-by-construction=clone"

echo
[ "$rc" = 0 ] && [ "$bad" = 0 ] && echo "PASS: BBX's suite, dispatcher and temporal family reproduce bbh's verdict text over $pairs pairings (F12, F16, F17)" || { echo "FAIL: see above"; exit 1; }
