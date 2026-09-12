#!/bin/sh
# suite.sh — the suite's verdicts mean what they say on the fake machine: every printed line in its own words, a perturbed expectation turns it RED, nondeterminism and a failed run are named before any class, the environment is scrubbed, the kept run counts a short observation apart from a divergence, and a loosened threshold is refused at the entrance
# Ground truth for bin/bbx-run-suite (abstraction C3, C4, E2; R23, R25, R26). Sections 1-8 lifted from bbh
# selftest/test_suite_dispatch.sh, lifted at f675710 — THE DISPATCH LOOP'S FIRST ROM-FREE GROUND TRUTH (the lineage could only
# prove its loop by running MAME) — on a COPY of bbh's example/ taken from a plain clone at the baseline (D20), the fake
# driver and machine being that clone's (R26: the frame-driven kind's drivers are bbh's). Sections 9-12 are BBX's: the
# kept run and its FINDING column, the finding vocabulary, R25 at the entrance, R26's driver home. Static tier
# (BBX_BBH_HOME); python start-up dominated, ~25 suite runs.
# Usage: BBX_BBH_HOME=~/Developer/blackbox-harness gates/suite.sh     (~60 s measured 2026-09-10: 25 suite runs; static tier)
# SKIP: BBX_BBH_HOME unset or not a bbh tree (exit 0; asserts nothing).
# READ-ONLY (R18, R20): bbh is read from a plain clone at the baseline under TMPDIR; the example is COPIED out of it before
# anything is perturbed or frozen; PYTHONDONTWRITEBYTECODE=1 for the whole gate.
# MUST-FIRE: perturbed-copy: perturbed-expectations — a perturbed .sha1, a perturbed .masked spec and a perturbed .diverge frame must each turn the suite RED with the expected text, or a frozen expectation is decoration
# MUST-FIRE: known-bad: nondeterministic — FAKE_NONDET=1 must read NONDETERMINISTIC and RED before any class is consulted, or BBX-14 is prose
# MUST-FIRE: known-bad: hermetic-scrub — a POKES in the caller's shell must NOT reach the driver through the suite while it demonstrably moves the log when the driver is called directly, or the caller's shell is part of the expectation
# MUST-FIRE: known-bad: short-vs-diverged — a FAIL-SHORT folded into bbh's FAIL line must be kept as finding `short`, never `diverged`, or BBX-4 is lost in the kept run
# MUST-FIRE: known-bad: loosened-at-the-entrance — a consumer config with flicker_max = 3 and no rulings entry must make the suite print the one REFUSED line and exit 3 before any scenario runs, or R25 stops at the comparators
# NOT-ASSERTED: any driver but the fake: a MAME or FBNeo driver is bbh's and untested here (bbh's own F8 rows)
# NOT-ASSERTED: the .sha1 kind's evidence: it is `self` class by construction (E4) and the register that says so is gates/provenance.sh's
# NOT-ASSERTED: the readout's reading of a kept suite run: gates/readout.sh reads the suite screen, gates/docset_suite.sh its coverage lines
#
set -eu
BBX_HOME="$(cd "$(dirname "$0")/.." && pwd)"; export BBX_HOME
PYTHONPATH="$BBX_HOME/lib/py"; export PYTHONPATH
PYTHONDONTWRITEBYTECODE=1; export PYTHONDONTWRITEBYTECODE
B_SRC="${BBX_BBH_HOME:-}"
[ -n "$B_SRC" ] && [ -x "$B_SRC/bin/bbh-run-static" ] || { echo "SKIP: BBX_BBH_HOME is not a bbh tree (${B_SRC:-unset}); the suite needs bbh's fake driver"; exit 0; }
B_SRC="$(cd "$B_SRC" && pwd)"
. "$BBX_HOME/lib/sh/baseline.sh"          # THE ONE DEFINITION (R43): this gate read f675710 for six sittings while its header said "the baseline" (G32)
BASELINE="$(bbx_baseline)"
rc=0
ok()   { printf '  ok    %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1"; rc=1; }
T="$(mktemp -d)"; trap 'rm -rf "$T"' EXIT INT TERM
B="$T/bbh"; { git clone -q --no-checkout "$B_SRC" "$B" && git -C "$B" checkout -q "$BASELINE"; } || { echo "SETUP-FAIL: could not clone $B_SRC at $BASELINE"; exit 1; }
FR="$T/ex"; cp -R "$B/example" "$FR"
export FAKE_ROOT="$FR"; BBX_BBH_HOME="$B"; export BBX_BBH_HOME; BBH_HOME="$B"; export BBH_HOME
unset BBX_CONFIG BBH_CONFIG FAKE_ROMPATH MASK_RANGES DUMPS POKES SNAP_FRAMES VIDEO_OUT INPUT_OUT TAIL_FRAMES INPUT_INJECT_TEST NO_INPUT_CHECK FAKE_BUILD FAKE_NONDET FAKE_CRASH_AT SUITE_ONLY 2>/dev/null || true
# every suite run is kept under ONE fixed dir (suite_ runs inside a command substitution, so nothing it sets reaches the
# parent — this gate's own first defect, 2026-09-10: a per-run variable, unbound in the parent, and the parameter abort
# under an armed EXIT trap exited 0 — bbh [BBH-14]'s shape, which the classifier reads as FAIL)
LOGDIR="$T/last"; : > "$T/runs"
suite_() { img="$1"; shift; rm -rf "$LOGDIR"; echo x >> "$T/runs"; FAKE_ROMPATH="$FR/roms/$img" "$BBX_HOME/bin/bbx-run-suite" --config "$FR/bbh.toml" --log "$LOGDIR" "$@" 2>&1; }
has() { printf '%s\n' "$1" | grep -q -- "$2"; }
row() { awk -F'\t' -v s="$1" '$1 == s { print $5 }' "$LOGDIR/results.tsv"; }   # the FINDING of one scenario, by field
runv() { grep '^verdict=' "$LOGDIR/run.txt" | cut -d= -f2; }

echo "== 1. the four registered images are GREEN, each verdict in its own words =="
o=$(suite_ base) && s=0 || s=$?
[ "$s" = 0 ] && has "$o" "^SUITE GREEN$" && [ "$(printf '%s\n' "$o" | grep -c ' PASS$')" = 6 ] && ok "base: 6 x 'PASS' (.sha1), SUITE GREEN, exit 0" || fail "base: rc=$s $(printf '%s' "$o" | tail -3)"
has "$o" "^build fingerprint -> expectation set 'base'$" && ok "the resolved set is announced" || fail "no fingerprint line"
[ "$(runv)" = GREEN ] && [ "$(row 01_idle)" = pass ] && [ "$(grep -c 'pass$' "$LOGDIR/results.tsv")" = 6 ] && ok "kept: run.txt verdict=GREEN, results.tsv 6 rows, finding pass (kind sha1)" || fail "kept base: $(runv) $(cat "$LOGDIR/results.tsv" | tr '\n' ';')"
o=$(suite_ attract) && s=0 || s=$?
[ "$s" = 0 ] && has "$o" "^05_attract .*PASS (diverges from base at exactly 900)$" && ok "attract: the .diverge KIND — 'PASS (diverges from base at exactly 900)'" || fail "attract: rc=$s $(printf '%s' "$o" | grep 05_)"
grep -q '^05_attract	diverge	diverge	PASS (diverges from base at exactly 900)	pass$' "$LOGDIR/results.tsv" && ok "kept: the .diverge row names its kind and class" || fail "kept attract: $(grep 05_ "$LOGDIR/results.tsv")"
o=$(suite_ build-a) && s=0 || s=$?
[ "$s" = 0 ] && has "$o" "^per-set mask: ff00-10000$" && ok "build-a: exit 0, the per-set mask announced" || fail "build-a rc=$s"
for want in "^01_idle .*PASS masked-exact$" \
            "^02_coin_start .*PASS masked-window (divergent frames 100, runs 1, window 260..359, 261 identical after)$" \
            "^03_press .*PASS masked-flicker (FLICKER 2 100,250 — frozen inventory)$" \
            "^04_both .*PASS masked-composite (divergent frames 101 in 2 run(s): flicker 220, windows 260-359, 261 identical after)$" \
            "^05_attract .*PASS (diverges from base/masked at exactly 900)$" \
            "^06_other_set .*SKIP (targets the other image; covered by its own suite)$"; do
    has "$o" "$want" && ok "$(printf '%s' "$want" | sed 's/^\^//; s/ \.\*/: /; s/\$$//' | cut -c1-90)" || fail "missing: $want"
done
[ "$(cut -f2,3 "$LOGDIR/results.tsv" | tail -n +2 | tr '\n' ' ')" = "masked	exact masked	window masked	flicker masked	composite masked	diverge skip	- " ] && [ "$(row 06_other_set)" = skip ] && ok "kept: kind and class per row (masked: exact, window, flicker, composite, diverge; skip)" || fail "kept build-a: $(cut -f2,3,5 "$LOGDIR/results.tsv" | tr '\n' ';')"
o=$(suite_ build-b) && s=0 || s=$?
[ "$s" = 0 ] && has "$o" "set 'build-b'" && ok "build-b: the dual-key twin resolves to ITS OWN set (whole-set key) and is GREEN" || fail "build-b rc=$s"

echo "== 2. the unregistered image =="
o=$(suite_ hook) && s=0 || s=$?
[ "$s" = 1 ] && has "$o" "^UNREGISTERED build: whole-set" && has "$o" "^unregistered build fingerprint — see message above$" && ok "roms/hook: exit 1, UNREGISTERED named, the suite's own line" || fail "hook: rc=$s $o"
[ "$(runv)" = UNREGISTERED ] && [ "$(wc -l < "$LOGDIR/results.tsv" | tr -d ' ')" = 1 ] && ok "kept: run.txt verdict=UNREGISTERED, no scenario rows" || fail "kept hook: $(runv)"

echo "== 3. CONTROL perturbed-expectations: a perturbed .sha1, .masked and .diverge each turn the suite RED with the expected text =="
c3=0
old=$(cat "$FR/expected/base/01_idle.sha1"); printf '%s\n' "0000000000000000000000000000000000000000" > "$FR/expected/base/01_idle.sha1"
o=$(suite_ base) && s=0 || s=$?
[ "$s" = 1 ] && has "$o" "^01_idle .*FAIL expected 0000000000000000000000000000000000000000 got $old$" && has "$o" "^SUITE RED$" && [ "$(row 01_idle)" = diverged ] && [ "$(runv)" = RED ] && { ok ".sha1: 'FAIL expected <frozen> got <measured>', SUITE RED, exit 1; kept: diverged, verdict=RED"; c3=$((c3 + 1)); } || fail "sha1 perturbation: rc=$s $(printf '%s' "$o" | grep 01_idle) kept=$(row 01_idle)"
printf '%s\n' "$old" > "$FR/expected/base/01_idle.sha1"
printf 'flicker base/masked 2 100,251\n' > "$FR/expected/build-a/03_press.masked"
o=$(suite_ build-a) && s=0 || s=$?
[ "$s" = 1 ] && has "$o" "^03_press .*FAIL masked-flicker: got 'FLICKER 2 100,250' expected 'FLICKER 2 100,251' (frozen; drift either way is loud" && [ "$(row 03_press)" = diverged ] && { ok ".masked flicker: a moved inventory is a loud FAIL; kept: diverged"; c3=$((c3 + 1)); } || fail "flicker perturbation: $(printf '%s' "$o" | grep 03_press)"
printf 'flicker base/masked 2 100,250\n' > "$FR/expected/build-a/03_press.masked"
printf 'window base/masked 261 359\n' > "$FR/expected/build-a/02_coin_start.masked"
o=$(suite_ build-a) || true
has "$o" "^02_coin_start .*FAIL masked-window:" && ok ".masked window: an onset off by one is a FAIL" || fail "window perturbation: $(printf '%s' "$o" | grep 02_coin)"
printf 'window base/masked 260 359\n' > "$FR/expected/build-a/02_coin_start.masked"
printf 'base 901' > "$FR/expected/attract/05_attract.diverge"
o=$(suite_ attract) && s=0 || s=$?
[ "$s" = 1 ] && has "$o" "^05_attract .*FAIL first divergence at 900 (expected exactly 901 vs base)$" && [ "$(row 05_attract)" = diverged ] && { ok ".diverge: a frame off by one is a FAIL; kept: diverged"; c3=$((c3 + 1)); } || fail "diverge perturbation: $(printf '%s' "$o" | grep 05_)"
printf 'base 900' > "$FR/expected/attract/05_attract.diverge"
[ "$c3" = 3 ] && echo "CONTROL FIRED: perturbed-expectations — .sha1, .masked and .diverge each RED with bbh's text" || fail "CONTROL DEAD: perturbed-expectations — $c3 of 3 perturbations read RED"

echo "== 4. NO-EXPECTATION, PENDING, the mask guard =="
mv "$FR/expected/base/06_other_set.sha1" "$T/keep.sha1"
o=$(suite_ base) && s=0 || s=$?
[ "$s" = 1 ] && has "$o" "^06_other_set .*NO-EXPECTATION (freeze after review, as a STATE.md decision)$" && [ "$(row 06_other_set)" = no-expectation ] && ok "no expectation file: NO-EXPECTATION, a failure; kept: no-expectation" || fail "no-expectation: $(printf '%s' "$o" | grep 06_)"
mv "$T/keep.sha1" "$FR/expected/base/06_other_set.sha1"
printf 'measured: flicker 2 100,250 — awaiting ratification\n' > "$FR/expected/build-a/03_press.pending"
o=$(suite_ build-a) && s=0 || s=$?
[ "$s" = 1 ] && has "$o" "^03_press .*PENDING — not validated$" && has "$o" "^ *measured: flicker 2 100,250 — awaiting ratification$" && [ "$(row 03_press)" = pending ] && ok ".pending: 'PENDING — not validated' + the reason, a FAILURE (never green); kept: pending" || fail "pending: $(printf '%s' "$o" | grep -A1 03_press)"
rm "$FR/expected/build-a/03_press.pending"
printf 'ff00-ff80' > "$FR/expected/build-a/mask"
o=$(suite_ build-a) && s=0 || s=$?
[ "$s" = 1 ] && has "$o" "^01_idle .*FAIL mask mismatch: this set runs$" && has "$o" "but base/masked was frozen under" && [ "$(row 01_idle)" = mask-mismatch ] && ok "a set mask differing from the basis's MASK record: 'FAIL mask mismatch'; kept: mask-mismatch" || fail "mask guard: $(printf '%s' "$o" | grep -A3 01_idle | head -4)"
printf 'ff00-10000' > "$FR/expected/build-a/mask"
mv "$FR/expected/base/masked/MASK" "$T/MASK"
o=$(suite_ build-a) || true
has "$o" "FAIL mask mismatch: base/masked has no MASK record (it predates them)" && ok "a record-less basis cited by a set with its own mask is refused" || fail "record-less basis: $(printf '%s' "$o" | grep 01_idle)"
mv "$T/MASK" "$FR/expected/base/masked/MASK"

echo "== 5. CONTROL nondeterministic; RUN-FAIL =="
o=$(FAKE_NONDET=1 suite_ base) && s=0 || s=$?
if [ "$s" = 1 ] && has "$o" "^01_idle .*NONDETERMINISTIC (first divergent frame below)$" && has "$o" "^SUITE RED$" && [ "$(row 01_idle)" = nondeterministic ]; then echo "CONTROL FIRED: nondeterministic — two differing runs: NONDETERMINISTIC (the diff's first lines follow), RED, kept as nondeterministic"
else fail "CONTROL DEAD: nondeterministic — $(printf '%s' "$o" | grep -A2 01_idle | head -3) kept=$(row 01_idle)"; fi
o=$(FAKE_CRASH_AT=50 suite_ base) && s=0 || s=$?
[ "$s" = 1 ] && has "$o" "^01_idle .*GUARD TRIPPED:$" && has "$o" "^RUN-FAIL$" && [ "$(row 01_idle)" = run-fail ] && ok "a driver that fails (the crash exit): its own lines, then RUN-FAIL; kept: run-fail" || fail "run-fail: $(printf '%s' "$o" | grep -A3 01_idle | head -4)"

echo "== 6. CONTROL hermetic-scrub =="
o=$(POKES="50:1000:ff" suite_ base) && s=0 || s=$?
FAKE_ROMPATH="$FR/roms/base" "$B/drivers/fake.sh" fake "$FR/replays/01_idle.rpl" "$T/h1.log" > /dev/null
FAKE_ROMPATH="$FR/roms/base" POKES="50:1000:ff" "$B/drivers/fake.sh" fake "$FR/replays/01_idle.rpl" "$T/h2.log" > /dev/null
if [ "$s" = 0 ] && ! cmp -s "$T/h1.log" "$T/h2.log"; then echo "CONTROL FIRED: hermetic-scrub — POKES moves the log when the driver is called directly, and the suite under the same POKES is still GREEN"
else fail "CONTROL DEAD: hermetic-scrub — suite rc=$s; direct poke moved the log: $(cmp -s "$T/h1.log" "$T/h2.log" && echo no || echo yes)"; fi

echo "== 7. --freeze =="
sed -i.bak "s/	build-b	/	bb-fresh	/" "$FR/expected/registry.tsv"
o=$(suite_ build-b --freeze) && s=0 || s=$?
[ "$s" = 0 ] && [ "$(printf '%s\n' "$o" | grep -c ' frozen [0-9a-f]\{40\}$')" = 6 ] && [ -f "$FR/expected/bb-fresh/01_idle.sha1" ] && [ -f "$FR/expected/bb-fresh/logs/01_idle.log" ] && [ "$(row 01_idle)" = frozen ] \
    && ok "--freeze on an empty set: 6 x 'frozen <sha>', .sha1 + logs/ written; kept: frozen" || fail "freeze: rc=$s $(printf '%s' "$o" | tail -3); $(ls "$FR/expected/bb-fresh" 2>/dev/null)"
o=$(suite_ build-b) && s=0 || s=$?
[ "$s" = 0 ] && has "$o" "^SUITE GREEN$" && ok "…and the frozen set is GREEN on the next plain run" || fail "post-freeze run: rc=$s"
printf 'ff00-10000' > "$FR/expected/bb-fresh/mask"; printf 'exact base/masked -\n' > "$FR/expected/bb-fresh/01_idle.masked"; rm "$FR/expected/bb-fresh/01_idle.sha1"
printf 'base 42' > "$FR/expected/bb-fresh/02_coin_start.diverge"
o=$(suite_ build-b --freeze) && s=0 || s=$?
has "$o" "^01_idle .*authored .masked expectation — not self-frozen$" && [ ! -f "$FR/expected/bb-fresh/01_idle.sha1" ] && [ "$(row 01_idle)" = authored ] && ok "an authored .masked is left alone by --freeze (no .sha1 written); kept: authored" || fail "freeze vs masked: $(printf '%s' "$o" | grep 01_idle)"
has "$o" "^02_coin_start .*RETIRED 02_coin_start.diverge (base 42)$" && has "$o" "^  -> kept as 02_coin_start.diverge.superseded; the new .sha1 now governs.$" && [ -f "$FR/expected/bb-fresh/02_coin_start.diverge.superseded" ] && [ ! -f "$FR/expected/bb-fresh/02_coin_start.diverge" ] \
    && ok "a self-frozen .diverge is RETIRED to .diverge.superseded (dispatch consults it first)" || fail "retire: $(printf '%s' "$o" | grep -A2 02_coin)"
mv "$FR/expected/registry.tsv.bak" "$FR/expected/registry.tsv"

echo "== 8. SUITE_ONLY, the driver by path, the input demand, the search-path fallback =="
o=$(SUITE_ONLY="01_idle 03_press" suite_ base) && s=0 || s=$?
has "$o" "^FILTERED RUN (SUITE_ONLY) — not a suite verdict$" && [ "$(printf '%s\n' "$o" | grep -c ' PASS$')" = 2 ] && grep -q '^filtered=1$' "$LOGDIR/run.txt" && ok "SUITE_ONLY: FILTERED announced, only the named scenarios run; kept: filtered=1" || fail "SUITE_ONLY: $o"
cp "$B/drivers/fake.sh" "$FR/mydriver.sh"; chmod +x "$FR/mydriver.sh"
o=$(suite_ base --driver ./mydriver.sh) && s=0 || s=$?
[ "$s" = 0 ] && ok "--driver <path> (has a slash): a consumer's own driver, relative to its root" || fail "driver by relative path rc=$s $(printf '%s' "$o" | head -2)"
o=$(suite_ base --driver mydriver) && s=0 || s=$?
[ "$s" = 1 ] && has "$o" "drivers/mydriver.sh' is not executable" && ok "--driver <bare name>: a driver under the driver home — a name that is not one is refused" || fail "bare name rc=$s $o"
o=$(suite_ base --driver "$FR/mydriver.sh") && s=0 || s=$?
[ "$s" = 0 ] && ok "--driver </abs/path>" || fail "driver by absolute path rc=$s"
chmod -x "$FR/mydriver.sh"
o=$(suite_ base --driver ./mydriver.sh) && s=0 || s=$?
[ "$s" = 1 ] && has "$o" "^FAIL: driver .*mydriver.sh' is not executable" && ok "a driver that is not executable is refused at the entrance" || fail "non-exec driver rc=$s $o"
o=$(env -u FAKE_ROOT "$BBX_HOME/bin/bbx-run-suite" --config "$FR/bbh.toml" 2>&1) && s=0 || s=$?
[ "$s" = 1 ] && [ "$o" = "FAIL: set FAKE_ROOT to the reference-input directory" ] && ok "the input variable is demanded: 'FAIL: set FAKE_ROOT …', exit 1" || fail "input demand: rc=$s '$o'"
o=$(env -u FAKE_ROMPATH FAKE_ROOT="$FR/roms/base" "$BBX_HOME/bin/bbx-run-suite" --config "$FR/bbh.toml" 2>&1) && s=0 || s=$?
[ "$s" = 0 ] && has "$o" "set 'base'" && ok "no search-path variable: the input directory is the search path (base resolves)" || fail "rompath fallback rc=$s $(printf '%s' "$o" | head -2)"
o=$(suite_ base nosuch) && s=0 || s=$?
[ "$s" = 1 ] && has "$o" "nosuch.zip not found in rompath" && ok "a positional set name that resolves nowhere fails loudly" || fail "positional set rc=$s $o"

echo "== 9. CONTROL short-vs-diverged: the finding vocabulary (lib/py/bbx/finding.py) =="
f1="$(python3 -m bbx.finding "FAIL masked-flicker: got 'FAIL-SHORT only 1 frames of log after frame 499 < min-converge 60 — the log ends too soon to prove re-convergence' expected 'FLICKER 1 499' (frozen; drift either way is loud — CLAUDE.md §4 standing watch)")"
f2="$(python3 -m bbx.finding "FAIL masked live-state diverged from base/masked")"
f3="$(python3 -m bbx.finding "FAIL masked-flicker: got 'FAIL stretch of 3 frames at frame 100 > max-stretch 2' expected 'FLICKER 2 100,250' (frozen; drift either way is loud — CLAUDE.md §4 standing watch)")"
if [ "$f1" = short ] && [ "$f2" = diverged ] && [ "$f3" = diverged ]; then echo "CONTROL FIRED: short-vs-diverged — a FAIL-SHORT folded into bbh's FAIL line is kept as 'short'; a divergence and an over-long stretch as 'diverged'"
else fail "CONTROL DEAD: short-vs-diverged — short='$f1' diverged='$f2' stretch='$f3'"; fi
for c in "PASS masked-exact:pass" "SKIP (targets the other image):skip" "PENDING — not validated:pending" "NO-EXPECTATION (freeze after review):no-expectation" "NONDETERMINISTIC (first divergent frame below):nondeterministic" "RUN-FAIL:run-fail" "frozen 0123:frozen" "authored .masked expectation — not self-frozen:authored" "FAIL mask mismatch: this set runs:mask-mismatch" "FAIL unknown .masked class 'x':unknown-class" "NO-BASE-LOG /x:no-base-log" "NOT-EVALUATED (schema failed):pending" "authored .truth expectation — not self-frozen:authored" "something else entirely:unclassified"; do
    got="$(python3 -m bbx.finding "${c%:*}")"; [ "$got" = "${c##*:}" ] && ok "'${c%:*}' -> ${c##*:}" || fail "'${c%:*}' -> '$got' (want ${c##*:})"
done

echo "== 10. CONTROL loosened-at-the-entrance (R25) =="
# derived configs live IN the example copy: [project].root = "." resolves against the config file (a config under $T
# would make the copy's registry unreachable — this gate's second defect, 2026-09-10, read as "unregistered build")
cp "$FR/bbh.toml" "$FR/loose.toml"; sed -i.bak 's/^flicker_max = 2$/flicker_max = 3/' "$FR/loose.toml"; grep -q '^flicker_max = 3$' "$FR/loose.toml" || fail "the loosened config was not built"
o=$(FAKE_ROMPATH="$FR/roms/build-a" "$BBX_HOME/bin/bbx-run-suite" --config "$FR/loose.toml" 2>&1) && s=0 || s=$?
if [ "$s" = 3 ] && [ "$o" = "REFUSED: [thresholds].flicker_max = 3 is looser than the frame-driven profile's 2 and [thresholds].rulings names no ruling for it (BBX-13, R25)" ]; then echo "CONTROL FIRED: loosened-at-the-entrance — $o"
else fail "CONTROL DEAD: loosened-at-the-entrance — rc=$s '$o'"; fi
sed -i.bak 's/^flicker_max = 3$/flicker_max = 3\
rulings = { flicker_max = "R-fixture-1" }/' "$FR/loose.toml"; grep -q '^rulings = ' "$FR/loose.toml" || fail "the ruling row was not planted in [thresholds]"
o=$(FAKE_ROMPATH="$FR/roms/build-a" "$BBX_HOME/bin/bbx-run-suite" --config "$FR/loose.toml" 2>&1) && s=0 || s=$?
[ "$s" = 0 ] && has "$o" "^SUITE GREEN$" && ok "…and with its ruling row the same config runs (the loosened value changes no verdict on this fixture)" || fail "with ruling: rc=$s $(printf '%s' "$o" | tail -2)"

echo "== 11. R26: the driver home =="
o=$(env -u BBX_BBH_HOME FAKE_ROMPATH="$FR/roms/base" "$BBX_HOME/bin/bbx-run-suite" --config "$FR/bbh.toml" 2>&1) && s=0 || s=$?
[ "$s" = 1 ] && has "$o" '^FAIL: \[suite\].driver_home is \$BBX_BBH_HOME/drivers and BBX_BBH_HOME is unset' && ok "the frame-driven kind's bare driver name needs BBX_BBH_HOME: FAIL naming it, exit 1" || fail "no BBX_BBH_HOME: rc=$s '$o'"
cp "$FR/bbh.toml" "$FR/home0.toml"; printf '\n[suite]\ndriver_home = "%s"\n' "$T/nowhere" >> "$FR/home0.toml"
python3 -m bbx.config "$FR/home0.toml" get suite.driver_home > /dev/null 2>&1 && fail "a second [suite] table was accepted (the subset must refuse a duplicate table)" || ok "a consumer overrides driver_home in its ONE [suite] table (a second table is refused by the subset)"
sed 's|^driver = "fake".*|driver = "fake"\
driver_home = "'"$T"'/nowhere"|' "$FR/bbh.toml" > "$FR/home.toml"
o=$(FAKE_ROMPATH="$FR/roms/base" "$BBX_HOME/bin/bbx-run-suite" --config "$FR/home.toml" 2>&1) && s=0 || s=$?
[ "$s" = 1 ] && has "$o" "^FAIL: driver '$T/nowhere/fake.sh' is not executable" && ok "a consumer driver_home is where a bare name resolves (here: nowhere, refused by path)" || fail "consumer driver_home: rc=$s '$o'"
sed 's|^driver = "fake".*|driver = "fake"\
driver_home = "'"$B"'/drivers"|' "$FR/bbh.toml" > "$FR/home2.toml"
o=$(env -u BBX_BBH_HOME FAKE_ROMPATH="$FR/roms/base" "$BBX_HOME/bin/bbx-run-suite" --config "$FR/home2.toml" 2>&1) && s=0 || s=$?
[ "$s" = 0 ] && has "$o" "^SUITE GREEN$" && ok "an absolute consumer driver_home needs no BBX_BBH_HOME" || fail "absolute driver_home: rc=$s $(printf '%s' "$o" | tail -1)"

echo "== 12. READ-ONLY: the clone after everything (the example was copied out; the driver and machine ran in place) =="
_dirt="$(git -C "$B" status --porcelain --ignored)"
[ -z "$_dirt" ] && ok "the clone is clean: 0 tracked, untracked or ignored entries" || { fail "the clone was WRITTEN:"; printf '%s\n' "$_dirt" | sed 's/^/        /' | head -8; }
echo "NOTE: suite-runs $(wc -l < "$T/runs" | tr -d " ") (each kept under --log)"

echo
[ "$rc" = 0 ] && echo "PASS: the suite's verdicts mean what they say, ROM-free, and the kept run says what each verdict was a finding of" || { echo "FAIL: see above"; exit 1; }
