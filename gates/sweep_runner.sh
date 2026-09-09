#!/bin/sh
# sweep_runner.sh — the sweep runner's lanes, verdicts, placeholders, anti-orphan check, --strict, the prereq STOP, scope, cadence, timeouts, --resume, the exported env default, the pull queue and clone-per-slot mean what they say
# Ground truth for bin/bbx-run-sweep: a synthetic repo of stub gates with KNOWN verdicts, a
# consumer config, driven through the REAL runner — never a copy of its logic. Lifted from bbh
# selftest/test_run_sweep.sh (S1, 2026-09-09), whose lineage is VampireSaved's
# test_emulator_runner.sh (thirteen sections). The example-consumer section (bbh's §15) lives
# in gates/fidelity_bbh.sh as F14. Sections 15–16 (bbx-2, R19): the --jobs queue is a PULL
# (a worker takes the next gate the moment it frees, measured by start/end stamps in the
# gates' own logs) and [sweep].clone_per_slot gives every slot its own plain clone of HEAD,
# so a gate that writes into its tree never touches the working tree. Portable, ~90 s measured 2026-09-09 on a loaded host.
# Usage: gates/sweep_runner.sh
# MUST-FIRE: shadow-tool: env-default-export — a copy of the runner with the export line removed must leave the gate's MAME_BIN UNSET, or the assertion depends on the environment and not on the export
# MUST-FIRE: known-bad: prereq-stop — a red gate in the prereq lane must STOP the run before any later lane, or a moved instrument's measurements would be read as evidence
# MUST-FIRE: known-bad: serial-order — at --jobs 1 the third short gate must start only AFTER the long one ends, or the stamps cannot tell a queue from a line (the known negative of section 15)
# MUST-FIRE: known-bad: no-clone-dirties — without clone_per_slot the same writing gates must dirty the base tree, or section 16's clean base proves nothing
# NOT-ASSERTED: speed-up on a real consumer: the queue is measured on stub gates with sleeps, not on an instrument-tier suite
# NOT-ASSERTED: a gate that escapes its clone by an absolute path: clone-per-slot pins the cwd, nothing more
# NOT-ASSERTED: portability beyond macOS: mkfifo and exec 8<> are POSIX, not yet run on Linux or WSL
#
set -eu
BBX_HOME="$(cd "$(dirname "$0")/.." && pwd)"; export BBX_HOME
PYTHONPATH="$BBX_HOME/lib/py"; export PYTHONPATH
rc=0
fail() { echo "  FAIL: $*"; rc=1; }
ok()   { echo "  ok: $*"; }
T="$(mktemp -d)"; trap 'rm -rf "$T"' EXIT INT TERM
FR="$T/fakerepo"
mkdir -p "$FR/tests/lib" "$FR/tools" "$FR/build/fake_merged/rompath" "$T/roms"
unset MAME_BIN JTSIM_SCRATCH ROMDIR MERGED 2>/dev/null || true

cat > "$FR/bbx.toml" <<EOF
[project]
root = "."
instrument_word = "emulator"
[registries]
sweep = "tests/ci_emulator.tsv"
[tier]
patterns = ['MAME_BIN']
[sweep]
lanes = ["prereq", "fbneo", "mame", "mister"]
default_lanes = ["prereq", "fbneo", "mame"]
prereq_lane = "prereq"
release_scope = "release"
cadences = ["romset", "bitstream"]
freeze_cadence = "romset"
cadence_drop_note = ["These follow the bitstream, not the romset.", ">> IS THIS FREEZE TARGETING THE CORE?"]
default_timeout = 5400
precondition = 'python3 tools/audit_roms.py "\$ROMDIR" > /dev/null'
precondition_fail_text = "ROM audit FAILED — stop"
input_env = "ROMDIR"
log_dir_prefix = "build/emu_sweep_"
placeholders = { MERGED = "build/fake_merged", DON = "build/fake_don" }
rompath_placeholder_suffix = "_RP"
rompath_suffix = "/rompath"
build_sets = ["vsavjw", "vsavj"]
instruments = [["mame-wide", "MAME_WIDE_BIN", "\$HOME/nowhere/mame"], ["fbneo", "", "\$REPO/emu/fbneo/fbneo"]]
env_defaults = [["MAME_BIN", "mame-wide"]]
scratch_lanes = ["mister"]
scratch_env = "JTSIM_SCRATCH"
scratch_default = "fake-jtsim"
prereq_cite = "[CPE-24]"
EOF
printf '#!/usr/bin/env python3\nimport sys\n' > "$FR/tools/audit_roms.py"; chmod +x "$FR/tools/audit_roms.py"
: > "$FR/tests/ci_portable.txt"; : > "$FR/tests/ci_static.txt"

mk() {  # mk <name> <exit> <line...> — a stub gate the tier classifier calls instrument-tier
    n="$1"; st="$2"; shift 2
    { echo "#!/bin/sh"
      echo ': "${MAME_BIN:-}"   # emulator-tier marker for the classifier'
      echo 'echo "argv: $*"'
      for l in "$@"; do echo "echo '$l'"; done
      echo "exit $st"; } > "$FR/tests/$n.sh"
    chmod +x "$FR/tests/$n.sh"
}
mk g_pass    0 "all good"
mk g_fail    1 "something broke" "FAIL: nope"
mk g_skip    0 "SKIP: no build at build/nope"
mk g_prose   0 "checked 3 things, none had to be skipped"
mk g_skipfail 2 "  SKIPPED: no reference binary" "PARTIAL: the invariant was NOT run"
mk g_out     0 "an out-of-release-scope gate ran"
mk g_args    0 "argument check"
mk g_prereq  0 "the instrument is sound"
printf '#!/bin/sh\n: "${MAME_BIN:-}"\nsleep 30\n' > "$FR/tests/g_slow.sh"; chmod +x "$FR/tests/g_slow.sh"
printf '#!/bin/sh\nexit 0\n' > "$FR/tests/g_noexec.sh"; chmod 644 "$FR/tests/g_noexec.sh"
mk g_orphan  0 "nobody registered me"

reg() { { echo "# fake registry"; for r in "$@"; do printf '%s\n' "$r"; done; } > "$FR/tests/ci_emulator.tsv"; }
row()  { printf '%s\t%s\t%s\tromset\t%s\t%s' "$1" "$2" "$3" "$4" "$5"; }
rowc() { printf '%s\t%s\t%s\t%s\t%s\t%s' "$1" "$2" "$3" "$4" "$5" "$6"; }
run() { (cd "$FR" && ROMDIR="$T/roms" "$BBX_HOME/bin/bbx-run-sweep" --config bbx.toml "$@" 2>&1); }

echo "1. the three verdicts, plus SKIP-in-prose and MISSING"
reg "$(row g_pass mame release - '')" "$(row g_fail mame release - '')" "$(row g_skip mame release - '')" \
    "$(row g_prose mame release - '')" "$(row g_noexec mame release - '')" "$(row g_out mame out - 'momentary: a stub')" \
    "$(row g_args mame release '%MERGED_RP% %DON% EXTRA=1' '')" "$(row g_orphan mame release - '')" "$(row g_skipfail mame release - '')"
out="$(run --log "$T/l1" || true)"
line="$(printf '%s\n' "$out" | grep -E '^PASS ' || true)"
case "$line" in *"PASS 4 "*) ok "PASS counted 4 (g_pass, g_prose, g_args, g_orphan): $line" ;; *) fail "expected PASS 4, got: $line" ;; esac
case "$line" in *"FAIL 2 "*) ok "a SKIP marker with a NON-ZERO exit counts FAIL, not SKIP" ;; *) fail "expected FAIL 2, got: $line" ;; esac
case "$line" in *"SKIP 1 "*) ok "SKIP counted separately from PASS" ;; *) fail "expected SKIP 1, got: $line" ;; esac
case "$line" in *"MISSING 1"*) ok "a non-executable registered gate is MISSING" ;; *) fail "expected MISSING 1, got: $line" ;; esac
printf '%s\n' "$out" | grep -q "g_out" && fail "an \`out\` row ran under the release scope" || ok "the release scope excluded the out-of-scope row"
printf '%s\n' "$out" | grep -qE '^GREEN' && fail "a run with a FAIL printed GREEN" || ok "a run with a FAIL is NOT GREEN"
printf '%s\n' "$out" | grep -q "^== the emulator-tier sweep ==" && ok "the banner uses the consumer's instrument word" || fail "banner: $(printf '%s\n' "$out" | head -1)"
printf '%s\n' "$out" | grep -q "^    MERGED  build/fake_merged        vsavj  ?" && ok "builds under test: a present dir is fingerprinted (no zip -> '?'), the set from build_sets" || fail "builds banner: $(printf '%s\n' "$out" | grep MERGED)"
printf '%s\n' "$out" | grep -q "^    DON     build/fake_don           ABSENT" && ok "…and an absent dir says ABSENT" || fail "absent banner: $(printf '%s\n' "$out" | grep 'DON ')"

echo "2. placeholders reach the gate's argv; VAR=value becomes environment"
grep -q "argv: build/fake_merged/rompath build/fake_don" "$T/l1/g_args.log" 2>/dev/null && ok "%MERGED_RP% and %DON% expanded into argv (the _RP suffix first)" || fail "placeholders: $(grep argv "$T/l1/g_args.log" 2>/dev/null)"
grep -q "cmd: env EXTRA=1 tests/g_args.sh" "$T/l1/g_args.log" 2>/dev/null && ok "a VAR=value token became environment, not a positional" || fail "VAR=value: $(grep cmd: "$T/l1/g_args.log")"
o2b="$(cd "$FR" && ROMDIR="$T/roms" MERGED=build/other "$BBX_HOME/bin/bbx-run-sweep" --config bbx.toml --list --only g_args 2>&1)"
printf '%s\n' "$o2b" | grep -q "build/other/rompath build/fake_don" && ok "an environment variable of the placeholder's name overrides its default" || fail "env override: $o2b"

echo "3. the anti-orphan check, both directions"
mk g_orphan2 0 "no row for me"
out2="$(run --log "$T/l2" || true)"
printf '%s\n' "$out2" | grep -q "g_orphan2" && ok "an instrument-tier gate with no row is reported UNREGISTERED" || fail "the unregistered gate was not reported"
reg "$(row g_pass mame release - '')" "$(row g_gone mame release - '')"
out3="$(run --log "$T/l3" || true)"
printf '%s\n' "$out3" | grep -q "DEAD ROW" && ok "a row whose script is gone is reported DEAD" || fail "a dead registry row was not reported"
rm -f "$FR/tests/g_orphan2.sh"

echo "4. --strict makes SKIP and an unregistered gate fatal"
reg "$(row g_pass mame release - '')" "$(row g_skip mame release - '')"
run --strict --log "$T/l4" >/dev/null 2>&1 && fail "--strict returned 0 with a SKIP present" || ok "--strict is non-zero on SKIP"
run --log "$T/l5" >/dev/null 2>&1 && ok "without --strict the same run is zero (SKIP is reported, not fatal)" || fail "a PASS+SKIP run failed without --strict"
reg "$(row g_pass mame release - '')"
run --strict --log "$T/l5b" >/dev/null 2>&1 && fail "--strict returned 0 with g_orphan unregistered" || ok "--strict is non-zero on an UNREGISTERED gate"

echo "5. a red prereq STOPS the run"
mk g_prereq_bad 1 "the instrument moved" "FAIL: parity lost"
reg "$(row g_prereq_bad prereq release - '')" "$(row g_pass mame release - '')" "$(row g_orphan mame release - '')"
out6="$(run --log "$T/l6" || true)"
if printf '%s\n' "$out6" | grep -q "STOP: the prereq lane is not green" && ! printf '%s\n' "$out6" | grep -q "== mame lane"; then
    echo "CONTROL FIRED: prereq-stop — g_prereq_bad (exit 1) stopped the run before the mame lane"
    ok "the run stopped at the prereq lane"
else
    echo "CONTROL DEAD: prereq-stop — $(printf '%s\n' "$out6" | grep -E 'STOP|== mame' | tr '\n' ' ')"
    fail "a red prereq did not stop the run"
fi
printf '%s\n' "$out6" | grep -q "not evidence (\[CPE-24\])" && ok "…citing the consumer's prereq_cite" || fail "cite: $(printf '%s\n' "$out6" | grep evidence)"
printf '%s\n' "$out6" | grep -q "== mame lane" && fail "the mame lane ran after a red prereq" || ok "no later lane ran after a red prereq"
out7="$(run --keep-going --log "$T/l7" || true)"
printf '%s\n' "$out7" | grep -q "== mame lane" && ok "--keep-going runs the later lanes anyway" || fail "--keep-going did not continue past the prereq lane"

echo "6. --scope all includes the out-of-release-scope rows; --only selects"
reg "$(row g_pass mame release - '')" "$(row g_out mame out - 'momentary: a stub')" "$(row g_orphan mame release - '')"
out8="$(run --scope all --log "$T/l8" || true)"
printf '%s\n' "$out8" | grep -q "g_out .*PASS" && ok "--scope all ran the out-of-scope row" || fail "--scope all did not run the out-of-scope row"
out8b="$(run --scope all --only 'g_o*' --log "$T/l8b" || true)"
[ "$(printf '%s\n' "$out8b" | grep -cE '^  g_(out|orphan) +PASS')" = 2 ] && ! printf '%s\n' "$out8b" | grep -q "g_pass .*PASS" && ok "--only 'g_o*' ran exactly the two matching gates" || fail "--only: $(printf '%s\n' "$out8b" | grep -E '^  g_')"

echo "6b. CADENCE selects independently of scope, and --freeze ASKS the question"
reg "$(row g_pass mame release - '')" "$(rowc g_bits mister release bitstream - 'a bitstream-cadence gate')" "$(row g_orphan mame release - '')"
outc="$(run --lane mame --lane mister --log "$T/lc" || true)"
printf '%s\n' "$outc" | grep -q "g_bits" && ok "cadence=all (the default) runs the bitstream row" || fail "the default cadence did NOT run the bitstream row"
outf="$(run --lane mame --lane mister --freeze --log "$T/lf" || true)"
printf '%s\n' "$outf" | grep -q "g_bits .*PASS" && fail "--freeze RAN a bitstream-cadence gate" || ok "--freeze excluded the bitstream-cadence gate"
printf '%s\n' "$outf" | grep -q "CADENCE: bitstream gates DROPPED" && ok "--freeze NAMED the dropped cadence" || fail "--freeze dropped silently"
printf '%s\n' "$outf" | grep -q "^     g_bits" && ok "…and the dropped gate by name" || fail "dropped gate not named"
printf '%s\n' "$outf" | grep -q "IS THIS FREEZE TARGETING THE CORE?" && ok "…with the consumer's cadence_drop_note" || fail "the note was not printed"
printf '%s\n' "$outf" | grep -q "g_pass .*PASS" && ok "--freeze kept the romset-cadence gate" || fail "--freeze dropped a ROMSET-cadence gate"

echo "7. a gate that overruns --timeout is TIMEOUT, not PASS"
if command -v timeout >/dev/null 2>&1 || command -v gtimeout >/dev/null 2>&1; then
    reg "$(row g_slow mame release - '')" "$(row g_orphan mame release - '')"
    out9="$(run --timeout 2 --log "$T/l9" || true)"
    case "$(printf '%s\n' "$out9" | grep -E '^PASS ' || true)" in *"TIMEOUT 1"*) ok "an overrunning gate is TIMEOUT" ;; *) fail "expected TIMEOUT 1: $(printf '%s\n' "$out9" | grep -E '^PASS ')" ;; esac
    grep -q "TIMEOUT	.*killed after 2s" "$T/l9/results.tsv" && ok "…with the lineage's detail 'killed after 2s'" || fail "detail: $(grep g_slow "$T/l9/results.tsv")"
else
    echo "  note: no timeout(1) — TIMEOUT case not exercised"
fi

echo "8. --lane ACCUMULATES"
reg "$(row g_pass mame release - '')" "$(row g_prereq fbneo release - '')" "$(row g_orphan mame release - '')"
out10="$(run --lane fbneo --lane mame --log "$T/l10" || true)"
printf '%s\n' "$out10" | grep -q "== fbneo lane" && printf '%s\n' "$out10" | grep -q "== mame lane" && ok "two --lane flags select BOTH lanes" || fail "two --lane flags did not select both lanes"
out11="$(run --lane mame --lane mame --log "$T/l11" || true)"
[ "$(printf '%s\n' "$out11" | grep -c '== mame lane')" = 1 ] && ok "a repeated --lane is not run twice" || fail "a repeated --lane ran the lane more than once"
printf '%s\n' "$out10" | grep -q "^  lanes      fbneo mame$" && ok "…in the order given" || fail "lane order: $(printf '%s\n' "$out10" | grep lanes)"

echo "9. a lane WAITS for its own gates (--jobs > 1)"
{ echo '#!/bin/sh'; echo ': "${MAME_BIN:-}"'; echo 'sleep 3'; echo 'echo slow-done'; } > "$FR/tests/g_slow3.sh"; chmod +x "$FR/tests/g_slow3.sh"
reg "$(row g_slow3 fbneo release - '')" "$(row g_pass mame release - '')" "$(row g_orphan mame release - '')"
out12="$(run --jobs 4 --log "$T/l12" || true)"
slow_line="$(printf '%s\n' "$out12" | grep -n 'g_slow3 ' | head -1 | cut -d: -f1)"
mame_line="$(printf '%s\n' "$out12" | grep -n '== mame lane' | head -1 | cut -d: -f1)"
[ -n "$slow_line" ] && [ -n "$mame_line" ] && [ "$slow_line" -lt "$mame_line" ] && ok "a lane's gates finish before the next lane is announced" || fail "lane boundary crossed"
awk -F'\t' 'NR>1 && $1=="g_slow3" && $2=="fbneo"' "$T/l12/results.tsv" | grep -q . && ok "its result is recorded under its OWN lane" || fail "g_slow3 filed wrong"

echo "10. --resume skips gates already in results.tsv"
reg "$(row g_pass mame release - '')" "$(row g_prose mame release - '')" "$(row g_orphan mame release - '')"
run --only g_pass --log "$T/l10r" >/dev/null 2>&1 || true
out10r="$(run --resume --log "$T/l10r" || true)"
printf '%s\n' "$out10r" | grep -q "g_pass .*(resumed: already in results.tsv)" && printf '%s\n' "$out10r" | grep -q "g_prose .*PASS" \
    && [ "$(awk -F'\t' 'NR>1 && $1=="g_pass"' "$T/l10r/results.tsv" | wc -l | tr -d ' ')" = 1 ] && ok "--resume: the done gate is announced as resumed, the rest run, results.tsv keeps one row per gate" || fail "resume: $(printf '%s\n' "$out10r" | grep -E 'g_pass|g_prose')"

echo "11. the runner EXPORTS the env default, and a caller's value wins"
printf '#!/bin/sh\necho "mame_bin=${MAME_BIN:-UNSET}"\nexit 0\n' > "$FR/tests/g_mamebin.sh"; chmod +x "$FR/tests/g_mamebin.sh"
reg "$(row g_mamebin mame release - '')"
out11a="$( (unset MAME_BIN; MAME_WIDE_BIN="$T/fake_wide" run --lane mame --only g_mamebin --log "$T/l11a") )"
grep -q "mame_bin=$T/fake_wide" "$T/l11a/g_mamebin.log" 2>/dev/null && printf '%s' "$out11a" | grep -q "MAME_BIN.*(runner default)" \
    && ok "unset by the caller -> the gate receives the instrument, and the log says 'runner default'" || fail "runner default not delivered: $(grep mame_bin "$T/l11a/g_mamebin.log" 2>/dev/null)"
printf '%s' "$out11a" | grep -q "^    mame-wide  $T/fake_wide   MISSING" && ok "the instruments banner names the override and says MISSING for a path that is not executable" || fail "instruments banner: $(printf '%s' "$out11a" | grep mame-wide)"
out11b="$( MAME_BIN="$T/caller_mame" MAME_WIDE_BIN="$T/fake_wide" run --lane mame --only g_mamebin --log "$T/l11b" )"
grep -q "mame_bin=$T/caller_mame" "$T/l11b/g_mamebin.log" 2>/dev/null && printf '%s' "$out11b" | grep -q "MAME_BIN.*(set by the caller)" \
    && ok "set by the caller -> the caller's value wins, and the log says so" || fail "caller's MAME_BIN not honoured"
# MUST-FIRE CONTROL: a copy of the runner with the export line removed must
# leave the gate UNSET — the assertion depends on the export, not on the env.
sed '/# ENV-DEFAULT-EXPORT$/d' "$BBX_HOME/bin/bbx-run-sweep" > "$T/sweep_noexport"; chmod +x "$T/sweep_noexport"
(cd "$FR" && unset MAME_BIN && ROMDIR="$T/roms" MAME_WIDE_BIN="$T/fake_wide" "$T/sweep_noexport" --config bbx.toml --lane mame --only g_mamebin --log "$T/l11c" >/dev/null 2>&1) || true
if grep -q "mame_bin=UNSET" "$T/l11c/g_mamebin.log" 2>/dev/null; then
    echo "CONTROL FIRED: env-default-export — without the export line the gate reports mame_bin=UNSET"
    ok "the assertion depends on the export, not on the environment"
else
    echo "CONTROL DEAD: env-default-export — $(grep mame_bin "$T/l11c/g_mamebin.log" 2>/dev/null || echo 'no log')"
    fail "control did not fire"
fi
rm -f "$FR/tests/g_mamebin.sh"

echo "12. exit 0 after a SHELL ERROR is FAIL; a teardown segfault line is not"
printf '#!/bin/sh\n: "${MAME_BIN:-}"\necho "tests/g_shellcrash.sh: line 3: FOO: set FOO to a dir OUTSIDE the repo"\nexit 0\n' > "$FR/tests/g_shellcrash.sh"
printf '#!/bin/sh\n: "${MAME_BIN:-}"\necho "PASS: the summary line"\necho "tests/g_segv.sh: line 64:  2444 Segmentation fault: 11  REPLAY=x"\nexit 0\n' > "$FR/tests/g_segv.sh"
chmod +x "$FR/tests/g_shellcrash.sh" "$FR/tests/g_segv.sh"
reg "$(row g_shellcrash mame release - '')" "$(row g_segv mame release - '')"
run --lane mame --log "$T/l12b" >/dev/null 2>&1 || true
v12a="$(awk -F'\t' '$1=="g_shellcrash"{print $4}' "$T/l12b/results.tsv")"; v12b="$(awk -F'\t' '$1=="g_segv"{print $4}' "$T/l12b/results.tsv")"
[ "$v12a" = FAIL ] && ok "a shell-error line with exit 0 is FAIL" || fail "shell-error crash classified '$v12a'"
[ "$v12b" = PASS ] && ok "a teardown segfault line after the summary stays PASS" || fail "the benign segfault shape classified '$v12b'"
rm -f "$FR/tests/g_shellcrash.sh" "$FR/tests/g_segv.sh"

echo "13. a row's 7th column is its timeout; --jobs N on a scratch lane hands each slot its own scratch"
printf '#!/bin/sh\n: "${MAME_BIN:-}"\nsleep 20\necho PASS\n' > "$FR/tests/g_long.sh"; chmod +x "$FR/tests/g_long.sh"
printf '#!/bin/sh\n: "${MAME_BIN:-}"\necho "scratch=${JTSIM_SCRATCH:-UNSET}"\nsleep 2\necho PASS\n' > "$FR/tests/g_slotA.sh"
cp "$FR/tests/g_slotA.sh" "$FR/tests/g_slotB.sh"; chmod +x "$FR/tests/g_slotA.sh" "$FR/tests/g_slotB.sh"
reg "$(rowc g_long mame release romset - 'a slow gate')	2" "$(row g_pass mame release - '')"
run --lane mame --timeout 60 --log "$T/l13a" >/dev/null 2>&1 || true
[ "$(awk -F'\t' '$1=="g_long"{print $4}' "$T/l13a/results.tsv")" = TIMEOUT ] && ok "a 2-second 7th column killed a 20-second gate under a 60-second --timeout" || fail "per-row timeout not applied"
[ "$(awk -F'\t' '$1=="g_pass"{print $4}' "$T/l13a/results.tsv")" = PASS ] && ok "a 6-column row still runs under the global --timeout" || fail "6-column row"
reg "$(rowc g_slotA mister release romset - 'slot a')" "$(rowc g_slotB mister release romset - 'slot b')"
(cd "$FR" && ROMDIR="$T/roms" JTSIM_SCRATCH="$T/scratch" "$BBX_HOME/bin/bbx-run-sweep" --config bbx.toml --lane mister --jobs 2 --log "$T/l13b" > "$T/o13b" 2>&1) || true
sA="$(grep -h '^scratch=' "$T/l13b/g_slotA.log" 2>/dev/null)"; sB="$(grep -h '^scratch=' "$T/l13b/g_slotB.log" 2>/dev/null)"
[ "$sA" = "scratch=$T/scratch" ] && [ "$sB" = "scratch=$T/scratch-slot1" ] && ok "--jobs 2 on the scratch lane: slot 0 keeps the base scratch, slot 1 gets <base>-slot1" || fail "per-slot scratch: A='$sA' B='$sB'"
grep -q "^  scratch    $T/scratch (mister slot 0), $T/scratch-slot1 (slots 1..1)" "$T/o13b" 2>/dev/null || grep -q "^  scratch    $T/scratch (mister slot 0), $T/scratch-slotN (slots 1..1)" "$T/o13b" \
    && ok "…and the banner names the scratch layout" || fail "scratch banner: $(grep scratch "$T/o13b")"
(cd "$FR" && ROMDIR="$T/roms" JTSIM_SCRATCH="$T/scratch" "$BBX_HOME/bin/bbx-run-sweep" --config bbx.toml --lane mister --jobs 1 --log "$T/l13c" >/dev/null 2>&1) || true
[ "$(grep -h '^scratch=' "$T/l13c/g_slotB.log" 2>/dev/null)" = "scratch=$T/scratch" ] && ok "--jobs 1: every gate keeps the caller's scratch" || fail "serial scratch changed"
(cd "$FR" && ROMDIR="$T/roms" "$BBX_HOME/bin/bbx-run-sweep" --config bbx.toml --lane mister --jobs 2 --log "$T/l13d" >/dev/null 2>&1) || true
[ "$(grep -h '^scratch=' "$T/l13d/g_slotA.log" 2>/dev/null)" = "scratch=${TMPDIR:-/tmp}/fake-jtsim" ] && ok "the scratch variable unset: slot 0 gets \${TMPDIR:-/tmp}/<scratch_default>" || fail "scratch default: $(grep -h '^scratch=' "$T/l13d/g_slotA.log" 2>/dev/null)"
rm -f "$FR/tests/g_long.sh" "$FR/tests/g_slotA.sh" "$FR/tests/g_slotB.sh"

echo "14. the precondition hook and the input demand"
printf '#!/usr/bin/env python3\nimport sys; sys.exit(1)\n' > "$FR/tools/audit_roms.py"
reg "$(row g_pass mame release - '')"
out14="$(run --log "$T/l14" || true)"
printf '%s\n' "$out14" | grep -q "^ROM audit FAILED — stop$" && ! printf '%s\n' "$out14" | grep -q "g_pass" && ok "a failing precondition stops the run before any gate, with the consumer's text" || fail "precondition: $(printf '%s\n' "$out14" | head -2)"
printf '#!/usr/bin/env python3\nimport sys\n' > "$FR/tools/audit_roms.py"
out14b="$(cd "$FR" && "$BBX_HOME/bin/bbx-run-sweep" --config bbx.toml --log "$T/l14b" 2>&1)" && fail "no ROMDIR was accepted" || { printf '%s\n' "$out14b" | grep -q "set ROMDIR — every gate here reads the reference input" && ok "the input variable is demanded (after --list, which needs none)" || fail "input demand: $out14b"; }
out14c="$(cd "$FR" && "$BBX_HOME/bin/bbx-run-sweep" --config bbx.toml --list 2>&1)" && printf '%s\n' "$out14c" | grep -q "^lanes=prereq fbneo mame scope=release cadence=all only=\*  (1 gates)$" && ok "--list needs no input and prints the lineage's summary line" || fail "--list: $out14c"

echo "15. --jobs N is a PULL queue: a worker takes the next gate the moment it frees (R19)"
# g_q_slow holds one of two slots for 4 s; three 1-s gates share the other. Under a queue the
# third short gate starts before the slow one ends; under a barrier ([slow,f1] wait [f2,f3])
# or a line it cannot. Stamps come from the gates themselves (date +%s), never from the runner.
printf '#!/bin/sh\n: "${MAME_BIN:-}"\necho "start=$(date +%%s)"\nsleep 4\necho "end=$(date +%%s)"\n' > "$FR/tests/g_q_slow.sh"
for _n in 1 2 3; do printf '#!/bin/sh\n: "${MAME_BIN:-}"\necho "start=$(date +%%s)"\nsleep 1\necho "end=$(date +%%s)"\n' > "$FR/tests/g_q_f$_n.sh"; done
chmod +x "$FR/tests/g_q_slow.sh" "$FR/tests/g_q_f1.sh" "$FR/tests/g_q_f2.sh" "$FR/tests/g_q_f3.sh"
reg "$(row g_q_slow mame release - '')" "$(row g_q_f1 mame release - '')" "$(row g_q_f2 mame release - '')" "$(row g_q_f3 mame release - '')"
stamp() { grep -h "^$2=" "$1" 2>/dev/null | cut -d= -f2; }
run --jobs 2 --log "$T/l15" >/dev/null 2>&1 || true
s_end="$(stamp "$T/l15/g_q_slow.log" end)"; f3_start="$(stamp "$T/l15/g_q_f3.log" start)"
if [ -n "$s_end" ] && [ -n "$f3_start" ] && [ "$f3_start" -lt "$s_end" ]; then
    ok "--jobs 2: the third short gate started at $f3_start, before the slow gate ended at $s_end — a pull, not a batch"
else fail "queue: f3 start='$f3_start' slow end='$s_end' (a barrier or a line would give start >= end)"; fi
[ "$(awk -F'\t' 'NR>1' "$T/l15/results.tsv" | wc -l | tr -d ' ')" = 4 ] && ok "all four rows recorded (order is the workers', keyed by name)" || fail "rows: $(cat "$T/l15/results.tsv")"
# the known negative: --jobs 1 is a line, and the stamps must say so
run --jobs 1 --log "$T/l15s" >/dev/null 2>&1 || true
s_end1="$(stamp "$T/l15s/g_q_slow.log" end)"; f3_start1="$(stamp "$T/l15s/g_q_f3.log" start)"
if [ -n "$s_end1" ] && [ -n "$f3_start1" ] && [ "$f3_start1" -ge "$s_end1" ]; then
    echo "CONTROL FIRED: serial-order — at --jobs 1 the third short gate started at $f3_start1, after the slow gate ended at $s_end1"
else fail "CONTROL DEAD: serial-order — f3 start='$f3_start1' slow end='$s_end1'"; fi

echo "16. [sweep].clone_per_slot: every slot measures its own plain clone of HEAD; the base tree is never written"
printf '#!/bin/sh\n: "${MAME_BIN:-}"\necho "tree=$(pwd -P)"\necho "head=$(git rev-parse --short HEAD)"\necho written > "dirty_$$.txt"\nsleep 1\necho PASS\n' > "$FR/tests/g_c_a.sh"
cp "$FR/tests/g_c_a.sh" "$FR/tests/g_c_b.sh"; chmod +x "$FR/tests/g_c_a.sh" "$FR/tests/g_c_b.sh"
sed '/^\[sweep\]$/a\
clone_per_slot = true' "$FR/bbx.toml" > "$FR/bbx_clone.toml"
reg "$(row g_c_a mame release - '')" "$(row g_c_b mame release - '')"
( cd "$FR" && git init -q && git add -A && git -c user.name=bbx -c user.email=bbx@example.invalid commit -qm "fixture" ) || fail "could not make the fake repo a git repository"
fr_head="$(git -C "$FR" rev-parse --short HEAD)"; fr_real="$(cd "$FR" && pwd -P)"
out16="$(cd "$FR" && ROMDIR="$T/roms" "$BBX_HOME/bin/bbx-run-sweep" --config bbx_clone.toml --lane mame --jobs 2 --log "$T/l16" 2>&1)" || true
ta="$(stamp "$T/l16/g_c_a.log" tree)"; tb="$(stamp "$T/l16/g_c_b.log" tree)"; ha="$(stamp "$T/l16/g_c_a.log" head)"; hb="$(stamp "$T/l16/g_c_b.log" head)"
[ -n "$ta" ] && [ -n "$tb" ] && [ "$ta" != "$tb" ] && [ "$ta" != "$fr_real" ] && [ "$tb" != "$fr_real" ] && ok "two workers, two trees, neither the base: $ta / $tb" || fail "trees: a='$ta' b='$tb' base='$fr_real'"
[ "$ha" = "$fr_head" ] && [ "$hb" = "$fr_head" ] && ok "both clones are at the base's HEAD $fr_head" || fail "heads: a='$ha' b='$hb' base='$fr_head'"
printf '%s\n' "$out16" | grep -q "^  clones     .*plain clones of $fr_head; working tree porcelain=" && ok "the banner names the clones, the commit and the working tree's porcelain" || fail "banner: $(printf '%s\n' "$out16" | grep clones)"
[ -z "$(cd "$FR" && ls dirty_*.txt 2>/dev/null)" ] && ok "the base tree received no file from the writing gates" || fail "base dirtied: $(cd "$FR" && ls dirty_*.txt)"
_cd="$(printf '%s\n' "$out16" | grep '^  clones' | sed -E 's/^  clones     (.*)\/slot0\.\..*/\1/')"
[ -n "$_cd" ] && [ ! -d "$_cd" ] && ok "the clone directory is removed after the run" || fail "clone dir '$_cd' still exists or unparsed"
# the known negative: without clone_per_slot the same gates write into the base
(cd "$FR" && ROMDIR="$T/roms" "$BBX_HOME/bin/bbx-run-sweep" --config bbx.toml --lane mame --jobs 2 --log "$T/l16n" >/dev/null 2>&1) || true
_nd="$(cd "$FR" && ls dirty_*.txt 2>/dev/null | wc -l | tr -d ' ')"
if [ "$_nd" -ge 1 ]; then echo "CONTROL FIRED: no-clone-dirties — without clone_per_slot the two writing gates left $_nd file(s) in the base tree"
else fail "CONTROL DEAD: no-clone-dirties — the base tree stayed clean without clones"; fi
rm -f "$FR"/dirty_*.txt "$FR/tests/g_c_a.sh" "$FR/tests/g_c_b.sh" "$FR"/tests/g_q_*.sh

echo
[ "$rc" = 0 ] && echo "PASS: bbx-run-sweep classifies every ground-truth case correctly" || { echo "FAIL: see above"; exit 1; }
