#!/bin/sh
# adapters.sh — THE TWO FRAMEWORK ADAPTERS end to end: an external test framework and BBX ITSELF are
# subjects of this harness, each driven by a driver of the command-line kind over the same core, each GREEN
# twice on its fixture with every printed line frozen here; the framework's verdict is an OBSERVATION (a
# case that FAILS by design and a gate row that reads FAIL both PASS against a truth that expects them,
# and a truth that expects otherwise turns RED); a run that observed NOTHING is DISCARDED, never a PASS; a
# framework whose two runs disagree is NONDETERMINISTIC before any class, on both sides; the self subject's
# identity is the HARNESS's own tree at HEAD, and a registry that does not name it refuses before any
# scenario runs; and a placeholder or a program the grammar does not have is REFUSED.
# Ground truth for drivers/unittest.sh, drivers/gates.sh and lib/py/bbx/adapters.py (docs/plans/S4.md §8.5;
# §3 "D7" and "R14"; §5's adapter rows; R37, R38, R15, R14; D58), and for the two fixtures fixture/unittest/
# and fixture/selfgates/ (each a consumer of the command-line PROFILE with its own driver, D45). The suites
# run on the TREE's fixtures (read-only: --log under TMPDIR; every fixture file checksummed before and
# after) for the positive checks and on COPIES under TMPDIR for every control, each perturbation proven
# applied before its assertion. Every printed line of both green runs is frozen here and classified by
# finding.py (C4 with no ancestor: the gate is the freeze).
# WHAT THE SELF SUBJECT IS: the synthetic consumer fixture/selfgates/subject/stubs, whose stub gates are
# written from a design, driven by BBX's OWN static runner through its OWN dispatcher — so bin/bbx and
# bin/bbx-run-static are executed by a gate of the command-line kind (R14's self-validation clause).
# No instrument. Portable, ~96 s (real 95.72 measured 2026-09-11 on this host: 14 suite runs plus 5 direct
# driver runs and two generator checks, python start-up dominated).
# Usage: gates/adapters.sh
# MUST-FIRE: known-bad: nondeterministic-before-any-class — a copied unittest package whose case NAME carries the clock (its registry refrozen so the identity resolves) must read NONDETERMINISTIC on its scenario with no kind evaluated (kept: kind `-`, finding nondeterministic, RED), and a copied selfgates stub whose VERDICT flips between runs must read the same through the gates adapter, or BBX-14 is prose on both sides
# MUST-FIRE: known-bad: framework-verdict-is-an-observation — the truth log of the scenario holding the designed FAIL, copied with `case:ok:` at that index, must make its pairing alone FAIL naming the index (kept: diverged, RED) while every other pairing passes; and the same for the gate row that reads FAIL, or a framework's red is being judged instead of reported (R37, BBX-2, BBX-5)
# MUST-FIRE: known-bad: nothing-ran — a copied package whose module holds no test must make the driver exit 1 on `Ran 0 tests` with no log written, and the suite read RUN-FAIL for that scenario with nothing compared, or a green over nothing is a PASS (BBX-7)
# MUST-FIRE: perturbed-copy: the-self-subject-both-ways — a selfgates copy with one registered stub DELETED must move that row to MISSING and FAIL its truth pairing at that index, and a copy with the anti-orphan file REGISTERED must grow the inventory and FAIL the same pairing, or the runner's verdict words are not being read row by row (BBX-9, R14)
# MUST-FIRE: known-bad: identity-before-any-scenario — a selfgates copy whose registry names a key the harness does not have must make the suite exit 1 as UNREGISTERED with no scenario row kept, and the row restored must be GREEN again, or a harness that moved would be compared against expectations nobody reviewed (R38, [BBH-67])
# MUST-FIRE: known-bad: refusals — a gates scenario carrying `{rompath}` must make the driver print REFUSED naming the placeholder and exit 3 with no log, and one naming a program that is not a file under $BBX_HOME/bin must do the same, or the driver fills in or looks up what the scenario did not say (D58)
# NOT-ASSERTED: the frameworks' own correctness: identical tokens mean the framework reported the same thing, never that what it reported is true — and this gate's fixtures are written to report specific verdicts, so nothing here says a test suite or a gate battery is any good
# NOT-ASSERTED: the DETAIL behind any verdict: a traceback, a gate's printed lines and the `detail` and `seconds` columns of a kept run are outside the observation (the seconds column moved between runs of the same six stubs at bbx-18, which is why it is not mapped)
# NOT-ASSERTED: that an UNCOMMITTED edit to bin, lib or drivers moves the self subject's identity: it does not — the key is of the COMMIT (R38), and the kept run's `porcelain` line is what sees a dirty tree
# NOT-ASSERTED: the ORPHAN direction of BBX-9 on the self subject: the anti-orphan file in the fixture is NAMED by the runner and appears in no token, because the runner exits 0 on an orphan (measured bbx-18, G34) — the verdict that direction needs is R45's
# NOT-ASSERTED: the controls contract of the runner (`enforce`): the synthetic consumer sets it false, and gates/controls.sh is its ground truth
# NOT-ASSERTED: the readout screen over these runs, and the comparators' own verdict text: gates/readout.sh, gates/set_schema.sh, gates/band.sh, gates/json_schema.sh
# NOT-ASSERTED: a framework that is not on this host (pytest, bats, node's runner): R37 declines them, and a consumer adds a third adapter under the same core
#
set -eu
BBX_HOME="$(cd "$(dirname "$0")/.." && pwd)"; export BBX_HOME
PYTHONPATH="$BBX_HOME/lib/py"; export PYTHONPATH
PYTHONDONTWRITEBYTECODE=1; export PYTHONDONTWRITEBYTECODE
unset BBX_CONFIG BBH_CONFIG BBX_MASK_DEFAULT BBX_REPLAYS_DIR CLI_PATH CLI_NONDET CLI_TIMEOUT CLI_KEEP_ENV SUITE_ONLY FAKECLI_SALT SELFGATES_INPUT DOCSET_PATH DOCSET_NONDET DOCSET_VIEW DOCSET_FORMS MASK_RANGES DUMPS POKES SNAP_FRAMES VIDEO_OUT INPUT_OUT TAIL_FRAMES INPUT_INJECT_TEST NO_INPUT_CHECK 2>/dev/null || true
UT="$BBX_HOME/fixture/unittest"; SG="$BBX_HOME/fixture/selfgates"
SUITE="$BBX_HOME/bin/bbx-run-suite"
rc=0
ok()   { printf '  ok    %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1"; rc=1; }
W="$(mktemp -d)"; trap 'rm -rf "$W"' EXIT INT TERM
LOGDIR="$W/last"; : > "$W/runs"
snap() { (cd "$1" && find . -type f -exec cksum {} + | sort); }
snap "$UT" > "$W/ut_before.txt"; snap "$SG" > "$W/sg_before.txt"
# suite_ <consumer-dir> [args...] -> the suite's output in $out, its status in $s, the kept run under $LOGDIR
suite_() { _d="$1"; shift; rm -rf "$LOGDIR"; echo x >> "$W/runs"; if out="$(CLI_PATH="$_d/subject" "$SUITE" --config "$_d/bbx.toml" --log "$LOGDIR" "$@" 2>&1)"; then s=0; else s=$?; fi; }
# keep <what> <dest> — the kept run copied aside; a suite that kept NO run is this gate's own FAIL (G28)
keep() { if [ -d "$LOGDIR" ]; then rm -rf "$2"; cp -R "$LOGDIR" "$2"; else fail "$1: the suite kept NO run at --log (exit $s); its output:"; printf '%s\n' "$out" | sed 's/^/        /'; exit 1; fi; }
row()  { awk -F'\t' -v s="$1" -v k="$2" '$1 == s && $2 == k { print $5 }' "$LOGDIR/results.tsv"; }
rows() { tail -n +2 "$LOGDIR/results.tsv" 2>/dev/null | wc -l | tr -d ' '; }
runv() { grep '^verdict=' "$LOGDIR/run.txt" 2>/dev/null | cut -d= -f2; }
copy() { rm -rf "$W/$2"; cp -R "$1" "$W/$2"; }
has()  { printf '%s\n' "$out" | grep -q -- "$1"; }
nf=0
fired() { printf 'CONTROL FIRED: %s\n' "$1"; nf=$((nf + 1)); }

echo "== 1. the unittest fixture: --check, then the suite GREEN with every printed line frozen =="
if o="$(python3 "$UT/mkunittest.py" --check 2>&1)"; then ok "mkunittest.py --check: the design is chiral, the package is the design's, the tree is what it writes, and the framework reports what the design says"
else fail "mkunittest.py --check: $(printf '%s' "$o" | head -3 | tr '\n' '|')"; fi
cat > "$W/ut_want.txt" <<'WANT'
build fingerprint -> expectation set 'derived'
01_shapes                truth    PASS exact (5 indices, every token the truth's)
NOTE: exit 1
NOTE: band-fields 0
NOTE: emitted-files 0
NOTE: cases 4
02_verdicts              truth    PASS exact (5 indices, every token the truth's)
NOTE: exit 1
NOTE: band-fields 0
NOTE: emitted-files 0
NOTE: cases 4
03_both                  truth    PASS exact (9 indices, every token the truth's)
NOTE: exit 1
NOTE: band-fields 0
NOTE: emitted-files 0
NOTE: cases 8
04_one_case              truth    PASS exact (2 indices, every token the truth's)
NOTE: exit 0
NOTE: band-fields 0
NOTE: emitted-files 0
NOTE: cases 1
SUITE GREEN
WANT
suite_ "$UT"; printf '%s\n' "$out" > "$W/ut_out.txt"; U1="$W/u1"; keep 'the unittest fixture run' "$U1"
if [ "$s" = 0 ] && diff "$W/ut_want.txt" "$W/ut_out.txt" > "$W/ut_diff.txt"; then ok "exit 0 and every printed line is the frozen text (22 lines: 4 pairings, 16 NOTEs, the set line, SUITE GREEN)"
else fail "rc=$s; the printed text differs from the frozen text:"; head -12 "$W/ut_diff.txt" | sed 's/^/        /'; fi
n_v=0; n_pass=0
while IFS= read -r line; do
    case "$line" in "build fingerprint"*|NOTE:*|"SUITE GREEN") continue ;; esac
    v="$(printf '%s' "$line" | sed 's/^[^ ]* *//; s/^[a-z]* *//')"; n_v=$((n_v + 1))
    [ "$(python3 -m bbx.finding "$v")" = pass ] && n_pass=$((n_pass + 1))
done < "$W/ut_out.txt"
[ "$n_v" = 4 ] && [ "$n_pass" = 4 ] || fail "verdict lines $n_v, classified pass $n_pass"
[ "$n_v" = 4 ] && [ "$n_pass" = 4 ] && ok "4 verdict lines, each classified 'pass' by finding.py"
[ "$(rows)" = 4 ] && [ "$(tail -n +2 "$LOGDIR/results.tsv" | cut -f1,2 | tr '\n\t' '  ')" = "01_shapes truth 02_verdicts truth 03_both truth 04_one_case truth " ] \
    && ok "kept: 4 rows keyed (scenario, kind), the scenario order of the tree" || fail "kept rows: $(tail -n +2 "$LOGDIR/results.tsv" | cut -f1,2 | tr '\n' ';')"
[ "$(tail -n +2 "$LOGDIR/results.tsv" | cut -f3 | sort -u)" = exact ] && [ "$(tail -n +2 "$LOGDIR/results.tsv" | cut -f5 | sort -u)" = pass ] \
    && ok "kept: every row class exact, every finding pass" || fail "kept classes/findings: $(tail -n +2 "$LOGDIR/results.tsv" | cut -f3,5 | sort -u | tr '\n' ';')"
grep -q "^01_shapes	cases	4$" "$LOGDIR/notes.tsv" && grep -q "^03_both	cases	8$" "$LOGDIR/notes.tsv" && grep -q "^04_one_case	exit	0$" "$LOGDIR/notes.tsv" \
    && ok "kept: notes.tsv carries the adapters' own NOTE key (cases 4 / 8) and the exit of each run (D43 extended)" || fail "notes.tsv: $(cat "$LOGDIR/notes.tsv" | tr '\n' ';')"
[ "$(runv)" = GREEN ] && grep -q '^loop=kinds$' "$LOGDIR/run.txt" && grep -q '^expset=derived$' "$LOGDIR/run.txt" && grep -q '^driver=.*/drivers/unittest[.]sh$' "$LOGDIR/run.txt" \
    && ok "kept: run.txt loop=kinds, driver drivers/unittest.sh, expset=derived, verdict=GREEN" || fail "run.txt: $(grep -E '^(loop|verdict|driver|expset)=' "$LOGDIR/run.txt" | tr '\n' ' ')"
suite_ "$UT"; U2="$W/u2"; keep 'the second unittest run (BBX-14)' "$U2"
[ "$s" = 0 ] && cmp -s "$U1/results.tsv" "$U2/results.tsv" && ok "twice at one HEAD: results.tsv byte-identical (BBX-14)" || fail "second run rc=$s: $(diff "$U1/results.tsv" "$U2/results.tsv" | head -3 | tr '\n' ';')"
[ "$(find "$UT" -name '__pycache__' | wc -l | tr -d ' ')" = 0 ] && ok "the framework wrote no __pycache__ into the fixture (PYTHONDONTWRITEBYTECODE, D6)" || fail "__pycache__ under $UT: $(find "$UT" -name '__pycache__')"
if o="$(python3 -m bbx.provenance --config "$UT/bbx.toml" 2>&1)"; then
    printf '%s\n' "$o" | grep -q 'derived 8' && ok "the expectation register is complete and every row class derived (8 rows + the registry row)" || fail "register histogram: $(printf '%s' "$o" | grep -i 'derived\|registry' | tr '\n' ';')"
else fail "bbx.provenance over the unittest fixture: $(printf '%s' "$o" | grep FAIL | head -2 | tr '\n' ';')"; fi

echo "== 2. the selfgates fixture: BBX's own runner as the subject, GREEN with every printed line frozen =="
if o="$(python3 "$SG/mkselfgates.py" --check 2>&1)"; then ok "mkselfgates.py --check: the design is chiral, the consumer is the design's, the tree is what it writes, the runner keeps what the contract says, and the identity row is current"
else fail "mkselfgates.py --check: $(printf '%s' "$o" | head -3 | tr '\n' '|')"; fi
cat > "$W/sg_want.txt" <<'WANT'
build fingerprint -> expectation set 'derived'
01_portable              truth    PASS exact (7 indices, every token the truth's)
NOTE: exit 1
NOTE: band-fields 0
NOTE: emitted-files 0
NOTE: gates 6
02_static_skip           truth    PASS exact (2 indices, every token the truth's)
NOTE: exit 0
NOTE: band-fields 0
NOTE: emitted-files 0
NOTE: gates 1
03_static_input          truth    PASS exact (2 indices, every token the truth's)
NOTE: exit 0
NOTE: band-fields 0
NOTE: emitted-files 0
NOTE: gates 1
SUITE GREEN
WANT
suite_ "$SG"; printf '%s\n' "$out" > "$W/sg_out.txt"; G1="$W/g1"; keep 'the selfgates run' "$G1"
if [ "$s" = 0 ] && diff "$W/sg_want.txt" "$W/sg_out.txt" > "$W/sg_diff.txt"; then ok "exit 0 and every printed line is the frozen text (17 lines: 3 pairings, 12 NOTEs, the set line, SUITE GREEN)"
else fail "rc=$s; the printed text differs from the frozen text:"; head -12 "$W/sg_diff.txt" | sed 's/^/        /'; fi
[ "$(rows)" = 3 ] && [ "$(tail -n +2 "$LOGDIR/results.tsv" | cut -f5 | sort -u)" = pass ] && ok "kept: 3 rows, every finding pass" || fail "kept: $(tail -n +2 "$LOGDIR/results.tsv" | cut -f1,2,5 | tr '\n' ';')"
grep -q "^01_portable	gates	6$" "$LOGDIR/notes.tsv" && grep -q "^02_static_skip	gates	1$" "$LOGDIR/notes.tsv" \
    && ok "kept: notes.tsv carries the gate counts (6 rows, then 1 of the static tier)" || fail "notes.tsv: $(cat "$LOGDIR/notes.tsv" | tr '\n' ';')"
grep -q '^driver=.*/drivers/gates[.]sh$' "$LOGDIR/run.txt" && [ "$(runv)" = GREEN ] && ok "kept: run.txt driver drivers/gates.sh, verdict=GREEN" || fail "run.txt: $(grep -E '^(driver|verdict)=' "$LOGDIR/run.txt" | tr '\n' ' ')"
k1="$(BBX_HOME="$BBX_HOME" sh "$SG/idkey.sh" program)"; k2="$(BBX_HOME="$BBX_HOME" sh "$SG/idkey.sh" wholeset)"
case "$k1$k2" in *[!0-9a-f]*) fail "idkey.sh printed something that is not two hex keys: $k1 $k2" ;; *)
    [ "${#k1}" = 40 ] && [ "${#k2}" = 40 ] && [ "$k1" != "$k2" ] && ok "the identity (R38): two 40-hex keys, the whole-set key differing from the program key (it adds gates)" || fail "idkey.sh: program=$k1 wholeset=$k2" ;;
esac
grep -q "^$k2	derived	" "$SG/expected/registry.tsv" && ok "the registry names the identity the harness has NOW (a moved harness is the refreeze R38 rules, R44's cost)" || fail "the registry does not name $k2: $(grep -v '^#' "$SG/expected/registry.tsv" | tr '\n' ';')"
if o="$(BBX_HOME= sh "$SG/idkey.sh" program 2>&1)"; then fail "idkey.sh answered with BBX_HOME unset: $o"
else printf '%s' "$o" | grep -q 'BBX_HOME is unset' && ok "idkey.sh REFUSES without BBX_HOME: the identity is the harness's tree, never the caller's directory" || fail "idkey.sh without BBX_HOME: $o"; fi
if o="$(python3 -m bbx.provenance --config "$SG/bbx.toml" 2>&1)"; then
    printf '%s\n' "$o" | grep -q 'derived 6' && ok "the expectation register is complete and every row class derived (6 rows + the registry row)" || fail "register histogram: $(printf '%s' "$o" | grep -i 'derived\|registry' | tr '\n' ';')"
else fail "bbx.provenance over the selfgates fixture: $(printf '%s' "$o" | grep FAIL | head -2 | tr '\n' ';')"; fi

# refreeze <copy> — the whole-set key of a copied PACKAGE, so a perturbed subject still resolves to its set.
# The self subject needs none of this: its identity is the HARNESS's tree, which a copy does not move (R38).
refreeze() {
    _k="$(python3 -m bbx.fingerprint "$1/subject" --set cases --set-key --config "$1/bbx.toml")"
    python3 - "$1/expected/registry.tsv" "$_k" <<'PY'
import sys, pathlib
p = pathlib.Path(sys.argv[1]); head = [l for l in p.read_text().splitlines() if l.startswith("#")]
p.write_text("\n".join(head + [f"{sys.argv[2]}\tderived\ta control's copy"]) + "\n")
PY
    grep -q "^$_k	derived" "$1/expected/registry.tsv"
}
only() { SUITE_ONLY="$1"; export SUITE_ONLY; shift; suite_ "$@"; unset SUITE_ONLY; }

echo "== 3. MUST-FIRE: two runs that disagree are NONDETERMINISTIC before any class, on both sides =="
copy "$UT" nd_ut
cat > "$W/nd_ut/subject/cases/test_shapes.py" <<'MOD'
"""A KNOWN-BAD copy (a control's, never the tree's): the case NAME carries the clock, so two runs of one
scenario cannot agree and the suite must read NONDETERMINISTIC before any class is consulted."""
import time
import unittest

T = type("T", (unittest.TestCase,), {"test_%d_clock" % time.time_ns(): lambda self: None})
MOD
refreeze "$W/nd_ut" && ok "the perturbation applied: the copy's package has a clock-named case and its identity is refrozen" || fail "the copy's identity could not be refrozen"
only 01_shapes "$W/nd_ut"
if [ "$s" != 0 ] && has "^01_shapes                NONDETERMINISTIC (first divergent frame below)$" && [ "$(row 01_shapes -)" = nondeterministic ] && [ "$(runv)" = RED ]; then
    fired "nondeterministic-before-any-class — unittest: $(printf '%s' "$out" | grep NONDETERMINISTIC | head -1)"
    ok "a clock-named case: NONDETERMINISTIC, kept kind \`-\` finding nondeterministic, RED, exit $s, no kind evaluated"
else fail "the clock-named case did not read NONDETERMINISTIC (rc=$s): $(printf '%s' "$out" | tail -3 | tr '\n' '|')"; fi
copy "$SG" nd_sg
cat > "$W/nd_sg/subject/stubs/gates/g1_holds.sh" <<'STUB'
#!/bin/sh
# A KNOWN-BAD copy (a control's, never the tree's): this stub HOLDS the first time it runs and REDS the
# second, so the two runs of one scenario cannot agree. A stub that merely PRINTED the clock would change
# nothing observable — the mapper reads the `gate` and `verdict` columns only (X32, measured bbx-18).
f="$(dirname "$0")/.ran_once"
if [ -e "$f" ]; then echo "  FAIL  the second run reds by design"; exit 1; fi
: > "$f" || { echo "  FAIL  the marker could not be written"; exit 1; }
echo "  ok    the first run holds by design"
exit 0
STUB
chmod +x "$W/nd_sg/subject/stubs/gates/g1_holds.sh"
grep -q 'reds by design' "$W/nd_sg/subject/stubs/gates/g1_holds.sh" && ok "the perturbation applied: a stub whose VERDICT flips between runs" || fail "the flipping stub was not written"
only 01_portable "$W/nd_sg"
if [ "$s" != 0 ] && has "^01_portable              NONDETERMINISTIC (first divergent frame below)$" && [ "$(row 01_portable -)" = nondeterministic ] && [ "$(runv)" = RED ]; then
    fired "nondeterministic-before-any-class — gates: $(printf '%s' "$out" | grep NONDETERMINISTIC | head -1)"
    ok "a stub whose verdict flips: NONDETERMINISTIC, kept kind \`-\` finding nondeterministic, RED, exit $s"
else fail "the flipping stub did not read NONDETERMINISTIC (rc=$s): $(printf '%s' "$out" | tail -3 | tr '\n' '|')"; fi

echo "== 4. MUST-FIRE: the framework's verdict is an OBSERVATION — a truth that expects otherwise turns RED =="
copy "$UT" obs_ut
sed 's/case:FAIL:/case:ok:/' "$UT/expected/derived/logs/01_shapes.log" > "$W/obs_ut/expected/derived/logs/01_shapes.log"
! cmp -s "$UT/expected/derived/logs/01_shapes.log" "$W/obs_ut/expected/derived/logs/01_shapes.log" && ok "the perturbation applied: the designed FAIL token rewritten as \`case:ok:\` in the copy's truth" || fail "the truth copy is unchanged"
suite_ "$W/obs_ut"
if [ "$s" != 0 ] && has "^01_shapes                truth    FAIL exact: index 2 differs$" && has "^03_both                  truth    PASS exact (9 indices, every token the truth's)$"; then
    fired "framework-verdict-is-an-observation — unittest: $(printf '%s' "$out" | grep 'FAIL exact' | head -1)"
    ok "a truth expecting \`ok\` where the framework said FAIL: that pairing alone FAILs at index 2, the other three PASS"
else fail "the wrong truth did not FAIL at index 2 (rc=$s): $(printf '%s' "$out" | grep -v NOTE | head -5 | tr '\n' '|')"; fi
copy "$SG" obs_sg
sed 's/gate:FAIL:/gate:PASS:/' "$SG/expected/derived/logs/01_portable.log" > "$W/obs_sg/expected/derived/logs/01_portable.log"
! cmp -s "$SG/expected/derived/logs/01_portable.log" "$W/obs_sg/expected/derived/logs/01_portable.log" && ok "the perturbation applied: the red gate's row rewritten as \`gate:PASS:\` in the copy's truth" || fail "the truth copy is unchanged"
suite_ "$W/obs_sg"
if [ "$s" != 0 ] && has "^01_portable              truth    FAIL exact: index 5 differs$" && has "^02_static_skip           truth    PASS exact (2 indices, every token the truth's)$"; then
    fired "framework-verdict-is-an-observation — gates: $(printf '%s' "$out" | grep 'FAIL exact' | head -1)"
    ok "a truth expecting PASS where the runner said FAIL: that pairing alone FAILs at index 5, the other two PASS"
else fail "the wrong truth did not FAIL at index 5 (rc=$s): $(printf '%s' "$out" | grep -v NOTE | head -5 | tr '\n' '|')"; fi

echo "== 5. MUST-FIRE: a run that observed NOTHING is DISCARDED, never a PASS (BBX-7) =="
copy "$UT" none_ut
printf '%s\n%s\n' '"""A KNOWN-BAD copy of a control: a module with no test at all."""' 'import unittest' > "$W/none_ut/subject/cases/test_shapes.py"
rm -f "$W/none.log"
if CLI_PATH="$W/none_ut/subject" "$BBX_HOME/drivers/unittest.sh" cases "$W/none_ut/scenarios/01_shapes.cli" "$W/none.log" > "$W/none_out.txt" 2>&1; then ds=0; else ds=$?; fi
if [ "$ds" = 1 ] && grep -q 'Ran 0 tests`: a green over nothing is DISCARDED' "$W/none_out.txt" && [ ! -f "$W/none.log" ]; then
    fired "nothing-ran — $(head -1 "$W/none_out.txt")"
    ok "the driver on a module with no test: exit 1 DISCARDED, the message names \`Ran 0 tests\`, and NO log written"
else fail "the zero-test run: exit $ds, log present=$([ -f "$W/none.log" ] && echo yes || echo no), $(head -1 "$W/none_out.txt")"; fi
refreeze "$W/none_ut" || fail "the zero-test copy's identity could not be refrozen"
only 01_shapes "$W/none_ut"
if [ "$s" != 0 ] && has "^RUN-FAIL$" && [ "$(row 01_shapes -)" = run-fail ]; then
    ok "and through the suite: RUN-FAIL for that scenario, kind \`-\`, nothing compared"
else fail "the suite over the zero-test package (rc=$s): $(printf '%s' "$out" | tail -3 | tr '\n' '|')"; fi

echo "== 6. MUST-FIRE: the self subject both ways — a deleted stub and a registered orphan =="
copy "$SG" del_sg
rm -f "$W/del_sg/subject/stubs/gates/g1_holds.sh"
[ ! -f "$W/del_sg/subject/stubs/gates/g1_holds.sh" ] && ok "the perturbation applied: one REGISTERED stub deleted from the copy (its row must move to MISSING)" || fail "the stub is still there"
suite_ "$W/del_sg"
if [ "$s" != 0 ] && has "^01_portable              truth    FAIL exact: index 1 differs$"; then
    fired "the-self-subject-both-ways — deleted stub: $(printf '%s' "$out" | grep 'FAIL exact' | head -1)"
    ok "a registered stub deleted: its row reads MISSING where the truth says PASS, and the pairing FAILs at index 1 (BBX-9's dead row)"
else fail "the deleted stub did not FAIL at index 1 (rc=$s): $(printf '%s' "$out" | grep -v NOTE | head -4 | tr '\n' '|')"; fi
copy "$SG" grow_sg
echo g7_orphan >> "$W/grow_sg/subject/stubs/gates/portable.txt"
grep -q '^g7_orphan$' "$W/grow_sg/subject/stubs/gates/portable.txt" && ok "the perturbation applied: the anti-orphan file REGISTERED in the copy (the inventory must grow)" || fail "the orphan is not registered"
suite_ "$W/grow_sg"
if [ "$s" != 0 ] && has "^01_portable              truth    FAIL exact: the run has index 7 the truth does not (8 indices, truth 7)$"; then
    fired "the-self-subject-both-ways — registered orphan: $(printf '%s' "$out" | grep 'FAIL exact' | head -1)"
    ok "the orphan registered: the run carries a seventh row and the exact family names the index the truth does not have (an inventory that GREW, both ways)"
else fail "the registered orphan did not grow the inventory (rc=$s): $(printf '%s' "$out" | grep -v NOTE | head -4 | tr '\n' '|')"; fi

echo "== 7. MUST-FIRE: the identity before any scenario (R38) =="
copy "$SG" id_sg
sed 's/^[0-9a-f]\{40\}/0000000000000000000000000000000000000000/' "$SG/expected/registry.tsv" > "$W/id_sg/expected/registry.tsv"
grep -q '^0000000000000000000000000000000000000000	derived' "$W/id_sg/expected/registry.tsv" && ok "the perturbation applied: the copy's registry names a key the harness does not have" || fail "the registry key was not changed"
suite_ "$W/id_sg"
if [ "$s" != 0 ] && has "^UNREGISTERED build: whole-set " && has "unregistered build fingerprint" && [ "$(rows)" = 0 ]; then
    fired "identity-before-any-scenario — $(printf '%s' "$out" | grep UNREGISTERED | head -1 | cut -c1-96)"
    ok "an identity no registry names: exit $s, the UNREGISTERED line naming both keys, and ZERO scenario rows kept"
else fail "the wrong identity did not refuse (rc=$s, rows $(rows)): $(printf '%s' "$out" | head -3 | tr '\n' '|')"; fi
cp "$SG/expected/registry.tsv" "$W/id_sg/expected/registry.tsv"
suite_ "$W/id_sg"
[ "$s" = 0 ] && [ "$(runv)" = GREEN ] && ok "the row restored: the same copy is GREEN again (the control is not a one-way door, BBX-2)" || fail "the restored copy is not green (rc=$s)"

echo "== 8. MUST-FIRE: a placeholder, a program or a set the grammar does not have is REFUSED =="
copy "$SG" ref_sg
printf '[scenario]\nargs = ["bbx", "run-static", "--config", "{rompath}", "--log", "{log}"]\n' > "$W/ref_sg/scenarios/01_portable.cli"
rm -f "$W/ref.log"
if CLI_PATH="$W/ref_sg/subject" "$BBX_HOME/drivers/gates.sh" stubs "$W/ref_sg/scenarios/01_portable.cli" "$W/ref.log" > "$W/ref_out.txt" 2>&1; then rs=0; else rs=$?; fi
if [ "$rs" = 3 ] && grep -q "^REFUSED: drivers/gates.sh cannot honour scenario placeholder '{rompath}' (the grammar has {config}, {log}, {set} (D58))$" "$W/ref_out.txt" && [ ! -f "$W/ref.log" ]; then
    fired "refusals — $(head -1 "$W/ref_out.txt")"
    ok "a placeholder the grammar lacks: exit 3, the REFUSED line naming it and this driver, no log"
else fail "the unknown placeholder: exit $rs, $(head -1 "$W/ref_out.txt")"; fi
printf '[scenario]\nargs = ["rm", "-rf", "{set}"]\n' > "$W/ref_sg/scenarios/01_portable.cli"
if CLI_PATH="$W/ref_sg/subject" "$BBX_HOME/drivers/gates.sh" stubs "$W/ref_sg/scenarios/01_portable.cli" "$W/ref2.log" > "$W/ref2_out.txt" 2>&1; then rs=0; else rs=$?; fi
if [ "$rs" = 3 ] && grep -q "^REFUSED: drivers/gates.sh cannot honour program 'rm' (it is not an executable file in " "$W/ref2_out.txt" && [ ! -f "$W/ref2.log" ]; then
    ok "a program that is not a file under \$BBX_HOME/bin: exit 3, REFUSED naming it, no log — never looked up on a PATH"
else fail "the unknown program: exit $rs, $(head -1 "$W/ref2_out.txt")"; fi
if CLI_PATH="$W/ref_sg/subject" "$BBX_HOME/drivers/gates.sh" nosuch "$W/ref_sg/scenarios/02_static_skip.cli" "$W/ref3.log" > "$W/ref3_out.txt" 2>&1; then rs=0; else rs=$?; fi
if [ "$rs" = 1 ] && grep -q "^adapters.py: no directory nosuch on CLI_PATH=" "$W/ref3_out.txt"; then
    ok "a set that is no directory on CLI_PATH: exit 1 DISCARDED, naming the set and the path (the adapters' resolver)"
else fail "the unknown set: exit $rs, $(head -1 "$W/ref3_out.txt")"; fi

echo "== 9. the fixtures are read-only to this gate, and --freeze writes nothing where every kind is authored =="
suite_ "$UT" --freeze; [ "$s" = 0 ] && ok "--freeze over the unittest fixture: exit 0" || fail "--freeze rc=$s: $(printf '%s' "$out" | tail -2 | tr '\n' '|')"
suite_ "$SG" --freeze; [ "$s" = 0 ] && ok "--freeze over the selfgates fixture: exit 0" || fail "--freeze rc=$s: $(printf '%s' "$out" | tail -2 | tr '\n' '|')"
snap "$UT" > "$W/ut_after.txt"; snap "$SG" > "$W/sg_after.txt"
cmp -s "$W/ut_before.txt" "$W/ut_after.txt" && cmp -s "$W/sg_before.txt" "$W/sg_after.txt" \
    && ok "every file of both fixtures is byte-identical after $(wc -l < "$W/runs" | tr -d ' ') suite runs, --freeze included (nothing self-froze: every kind is authored)" \
    || fail "a fixture file moved: $(diff "$W/ut_before.txt" "$W/ut_after.txt" | head -3 | tr '\n' ';')$(diff "$W/sg_before.txt" "$W/sg_after.txt" | head -3 | tr '\n' ';')"

echo
if [ "$rc" = 0 ]; then
    echo "PASS: both adapters drive their subjects end to end, the framework's verdict is an observation, a run over nothing is discarded, nondeterminism is red before any class on both sides, the self subject's identity refuses a harness nobody registered, and the fixtures are untouched; $nf control firings, 6 declared"
else
    echo "FAIL: see above"
fi
exit "$rc"
