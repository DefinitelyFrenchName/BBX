#!/bin/sh
# cli_suite.sh — the suite drives the command-line fixture end to end and is GREEN twice on it: the kinds loop's SECOND consumer, every EVAL kind of a scenario its own pairing in the printed shape frozen here, the JSON view and the band view reaching their families through the loop's one resolver (the kind's view column), a changed tool refused before any scenario runs, a crash and a refused scenario key read RUN-FAIL apart from a tool's own non-zero exit, nondeterminism red before any class three ways, a view the loop cannot resolve red at the entrance, --freeze writing nothing where every kind is authored, and the band and exit numbers on the screen
# Ground truth for the kinds loop of bin/bbx-run-suite under the command-line profile (docs/plans/S4.md §8.4; §3 "E1" under
# "Under this profile the loop…", "RO1, RO2"; §5's shadow-tool, --nondet, --crash-at, unknown-option and JSON rows; §6; R35;
# D43, D44, D45, D53, D54, D57) and for the view column of the kinds table (D57: `log`, `subject`, `json`, `bands`, `-`,
# resolved by the loop's view_path and nowhere else — BBX-16, R23). The suite runs on the TREE's fixture (read-only: --log
# under TMPDIR; the fixture's files are checksummed before and after) for the positive checks and on COPIES under TMPDIR for
# every control, each perturbation proven applied before its assertion (VampireSaved test_checkdocs_rom.sh's practice).
# Every printed line of the green run is frozen here and classified by finding.py (C4 with no ancestor: the gate is the
# freeze). bbh's precedence loop is not touched by this gate: gates/fidelity_bbh_s2.sh's F12, unchanged and green, is the
# control that nothing moved for bbh. The `band-fields` key is printed TWICE for 04_band — by the comparator (R36) and by
# the log summary (D43): two writers of one key, RULED KEPT (R41, 2026-09-11) and frozen here as an intended screen.
# No instrument. Portable, ~95 s (real 95.3 measured 2026-09-10 on this host: 15 suite runs of 9 scenarios twice each, python start-up dominated).
# Usage: gates/cli_suite.sh
# MUST-FIRE: shadow-tool: identity-before-any-scenario — one byte changed in a copied fakecli.py must make the suite exit 1 as UNREGISTERED with no scenario row kept, and the copy restored must resolve to the registered set and be GREEN again, or a changed tool is compared against the fixture's expectations (S2, BBH-67)
# MUST-FIRE: known-bad: nondeterministic-before-any-class — a scenario copy with `--nondet` in its args must read NONDETERMINISTIC on that scenario with no kind evaluated (kept: kind `-`, finding nondeterministic, RED); a wrapper driver exporting CLI_NONDET=1 must read it on every scenario; the same variable in the caller's environment must leave the suite GREEN (scrubbed, D45), or BBX-14 is prose and the scrub is decoration
# MUST-FIRE: known-bad: crash-vs-refusal — a scenario copy with `--crash-at 3` must print the driver's signal line and RUN-FAIL (kept: run-fail, kind `-`) with nothing compared for it while the other scenarios pass; a scenario copy carrying the key `argz` must print the driver's REFUSED line naming it and RUN-FAIL the same way; and the tree's 05_exit_1 and 06_unknown_option must PASS on `0 exit:1` / `0 exit:2`, or a crash, a refusal and a tool's own non-zero exit are one report (BBX-4, D4, D46)
# MUST-FIRE: known-bad: wrong-truth — 06_unknown_option's truth log copied with `0 exit:0` at index 0 must make its truth pairing alone FAIL naming index 0 (kept: diverged, RED) while every other pairing passes, or the known positive is not one (BBX-5, BBX-2)
# MUST-FIRE: perturbed-copy: schema-before-any-value — a key renamed in a copied .schema (weight -> width, the sorted order kept) must FAIL the schema pairing naming the frozen key as absent from the OBJECT — read from the JSON view the loop handed the family, D54/D57 — and print the suite's own `NOT-EVALUATED (schema failed)` on the scenario's truth pairing (kept: pending, counted as a failure, no NOTE kept for it) while the other scenarios pass, or a wrong shape is read for its values (R34, E2; X21)
# MUST-FIRE: perturbed-copy: band-through-the-loop — a .band copy narrowed to [236, 260] must make the band pairing FAIL naming size, 265 and the band (kept: diverged, RED) while the truth pairing PASSes on the constant token and the summary's `band-fields 1` is still kept, or the band kind's green under the suite has never been seen to fail (BBX-2, D53)
# MUST-FIRE: known-bad: unknown-view — a consumer copy whose kinds table gives `schema` the view `objekt` must make the suite exit 1 at the entrance naming the kind and the view with no scenario row kept, and a copy whose table has the OLD three-field rows must exit 1 on one `bbx expectations:` line naming the row with no kept run, or a view nobody can resolve is a pairing that silently compares nothing (D57, BBX-16)
# NOT-ASSERTED: anything about a real tool: every input is the fixture's (fixture class) or a perturbed copy of it (D45, D46, D50)
# NOT-ASSERTED: bbh's precedence loop and its printed text: gates/fidelity_bbh_s2.sh (F12) and gates/suite.sh; the document-set kind's loop: gates/docset_suite.sh
# NOT-ASSERTED: the verdict text of the families beyond the lines frozen here: gates/band.sh, gates/json_schema.sh, gates/set_schema.sh
# NOT-ASSERTED: the readout screen beyond the lines checked here (the verdict, the register's histogram, the classes, the notes, BBX-14, the driver's blind spots): gates/readout.sh
# NOT-ASSERTED: that the two writers of `band-fields` AGREE: both counts trace to one `bands` list written once by
#   drivers/cli.sh (measured bbx-17), so the duplicate is one number by two routes and nothing here compares them
#   for a driver that would write the log and the band view apart (R41: both writers kept)
#
set -eu
BBX_HOME="$(cd "$(dirname "$0")/.." && pwd)"; export BBX_HOME
PYTHONPATH="$BBX_HOME/lib/py"; export PYTHONPATH
PYTHONDONTWRITEBYTECODE=1; export PYTHONDONTWRITEBYTECODE
unset BBX_CONFIG BBH_CONFIG BBX_MASK_DEFAULT BBX_REPLAYS_DIR CLI_PATH CLI_NONDET CLI_TIMEOUT CLI_KEEP_ENV FAKECLI_SALT DOCSET_PATH DOCSET_NONDET DOCSET_VIEW DOCSET_FORMS SUITE_ONLY MASK_RANGES DUMPS POKES SNAP_FRAMES VIDEO_OUT INPUT_OUT TAIL_FRAMES INPUT_INJECT_TEST NO_INPUT_CHECK 2>/dev/null || true
F="$BBX_HOME/fixture/fakecli"; SUITE="$BBX_HOME/bin/bbx-run-suite"; DRV="$BBX_HOME/drivers/cli.sh"
rc=0
ok()   { printf '  ok    %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1"; rc=1; }
W="$(mktemp -d)"; trap 'rm -rf "$W"' EXIT INT TERM
LOGDIR="$W/last"; : > "$W/runs"
snapshot() { (cd "$F" && find . -type f -exec cksum {} + | sort); }
snapshot > "$W/before.txt"
# suite_ <fixture-dir> [suite args...] -> the suite's output; status in $s; the kept run under $LOGDIR
suite_() { _d="$1"; shift; rm -rf "$LOGDIR"; echo x >> "$W/runs"; if out="$(CLI_PATH="$_d/subject" "$SUITE" --config "$_d/bbx.toml" --log "$LOGDIR" "$@" 2>&1)"; then s=0; else s=$?; fi; }
has()  { printf '%s\n' "$out" | grep -q -- "$1"; }
row()  { awk -F'\t' -v s="$1" -v k="$2" '$1 == s && $2 == k { print $5 }' "$LOGDIR/results.tsv"; }   # the FINDING of one pairing, by field
rows() { tail -n +2 "$LOGDIR/results.tsv" 2>/dev/null | wc -l | tr -d ' '; }
runv() { grep '^verdict=' "$LOGDIR/run.txt" 2>/dev/null | cut -d= -f2; }
copy() { rm -rf "$W/$1"; cp -R "$F" "$W/$1"; }
# keep <what> <dest> — the kept run copied aside. A suite that kept NO run is this gate's OWN FAIL, naming the suite's
# output, never a bare `cp:` line from under `set -e` with no verdict of its own (G28, the bbx-16 learning).
keep() { if [ -d "$LOGDIR" ]; then rm -rf "$2"; cp -R "$LOGDIR" "$2"; else fail "$1: the suite kept NO run at --log (exit $s); its output:"; printf '%s\n' "$out" | sed 's/^/        /'; exit 1; fi; }
edit() { sed -i.bak "$2" "$1"; rm -f "$1.bak"; }   # in place, portable; the caller proves the edit applied

echo "== 1. the tree's fixture: GREEN, every printed line frozen and classified, the kept run keyed (scenario, kind) =="
cat > "$W/want.txt" <<'WANT'
build fingerprint -> expectation set 'fixture'
01_list                  truth    PASS exact (10 indices, every token the truth's)
NOTE: exit 0
NOTE: band-fields 0
NOTE: emitted-files 0
02_unordered             truth    PASS exact (10 indices, every token the truth's)
                         unordered PASS set-inventory (9 rows, the frozen inventory and the run agree both ways)
NOTE: exit 0
NOTE: band-fields 0
NOTE: emitted-files 0
03_show_json             schema   PASS schema (json: 5 keys)
                         truth    PASS exact (6 indices, every token the truth's)
NOTE: exit 0
NOTE: band-fields 0
NOTE: emitted-files 0
04_band                  truth    PASS exact (3 indices, every token the truth's)
                         band     PASS band (1 field(s), every value inside its band)
NOTE: band-fields 1
NOTE: exit 0
NOTE: band-fields 1
NOTE: emitted-files 0
05_exit_1                truth    PASS exact (2 indices, every token the truth's)
NOTE: exit 1
NOTE: band-fields 0
NOTE: emitted-files 0
06_unknown_option        truth    PASS exact (2 indices, every token the truth's)
NOTE: exit 2
NOTE: band-fields 0
NOTE: emitted-files 0
07_emit_file             truth    PASS exact (3 indices, every token the truth's)
NOTE: exit 0
NOTE: band-fields 0
NOTE: emitted-files 1
08_join_stdin            truth    PASS exact (4 indices, every token the truth's)
NOTE: exit 0
NOTE: band-fields 0
NOTE: emitted-files 0
09_env                   truth    PASS exact (11 indices, every token the truth's)
NOTE: exit 0
NOTE: band-fields 0
NOTE: emitted-files 0
SUITE GREEN
WANT
suite_ "$F"; printf '%s\n' "$out" > "$W/out.txt"; R1="$W/r1"; keep 'the tree fixture run' "$R1"
if [ "$s" = 0 ] && diff "$W/want.txt" "$W/out.txt" > "$W/diff.txt"; then ok "exit 0 and every printed line is the frozen text (43 lines: 12 pairings, 28 NOTEs, the set line, SUITE GREEN)"
else fail "rc=$s; the printed text differs from the frozen text:"; head -12 "$W/diff.txt" | sed 's/^/        /'; fi
n_lines=0; n_pass=0
while IFS= read -r line; do
    case "$line" in "build fingerprint"*|NOTE:*|"SUITE GREEN") continue ;; esac
    v="$(printf '%s' "$line" | cut -c26- | sed 's/^[^ ]* *//')"; n_lines=$((n_lines + 1))   # after the 24-wide scenario field, past the kind (`unordered` is 9 wide: never a fixed column)
    [ "$(python3 -m bbx.finding "$v")" = pass ] && n_pass=$((n_pass + 1))
done < "$W/out.txt"
[ "$n_lines" = 12 ] && [ "$n_pass" = 12 ] && ok "12 verdict lines, each classified 'pass' by finding.py" || fail "verdict lines $n_lines, classified pass $n_pass"
[ "$(rows)" = 12 ] && [ "$(tail -n +2 "$LOGDIR/results.tsv" | cut -f1,2 | tr '\n\t' '  ')" = "01_list truth 02_unordered truth 02_unordered unordered 03_show_json schema 03_show_json truth 04_band truth 04_band band 05_exit_1 truth 06_unknown_option truth 07_emit_file truth 08_join_stdin truth 09_env truth " ] \
    && ok "kept: 12 rows keyed (scenario, kind), schema first then the table's order (truth, unordered, band)" || fail "kept rows: $(tail -n +2 "$LOGDIR/results.tsv" | cut -f1,2 | tr '\n' ';')"
[ "$(tail -n +2 "$LOGDIR/results.tsv" | cut -f3 | sort -u | tr '\n' ' ')" = "band exact multiset schema " ] && [ "$(tail -n +2 "$LOGDIR/results.tsv" | cut -f5 | sort -u)" = pass ] && ok "kept: the class column reads the spec's class (band, exact, multiset, schema); every finding pass" || fail "kept classes/findings: $(tail -n +2 "$LOGDIR/results.tsv" | cut -f3,5 | sort -u | tr '\n' ';')"
[ "$(tail -n +2 "$LOGDIR/notes.tsv" | wc -l | tr -d ' ')" = 28 ] && [ "$(grep -c "^04_band	band-fields	1$" "$LOGDIR/notes.tsv")" = 2 ] && grep -q "^07_emit_file	emitted-files	1$" "$LOGDIR/notes.tsv" && grep -q "^05_exit_1	exit	1$" "$LOGDIR/notes.tsv" && grep -q "^06_unknown_option	exit	2$" "$LOGDIR/notes.tsv" \
    && ok "kept: notes.tsv 28 rows (scenario, key, value) — exit / band-fields / emitted-files per scenario (D43, D44); 04_band's band-fields 1 kept TWICE, from the comparator and from the summary (two writers of one key, ruled kept: R41)" || fail "notes.tsv: $(cat "$LOGDIR/notes.tsv" | tr '\n' ';')"
grep -q '^loop=kinds$' "$LOGDIR/run.txt" && [ "$(runv)" = GREEN ] && grep -q '^pass=12$' "$LOGDIR/run.txt" && grep -q '^expset=fixture$' "$LOGDIR/run.txt" && ok "kept: run.txt loop=kinds, expset=fixture, pass=12, verdict=GREEN" || fail "run.txt: $(grep -E '^(loop|verdict|pass|expset)=' "$LOGDIR/run.txt" | tr '\n' ' ')"
v="$(BBX_CONFIG="$F/bbx.toml" python3 -m bbx.expectations kinds | awk -F'\t' '$3 == "EVAL" { printf "%s=%s ", $1, $4 }')"
[ "$v" = "truth=log unordered=log schema=json band=bands " ] && ok "the views the loop handed the families, from the table's fourth column (D57): $v" || fail "views: '$v'"

echo "== 2. twice (BBX-14): a second run at the same HEAD, and the readout's screen over both =="
suite_ "$F"; R2="$W/r2"; keep 'the second run (BBX-14)' "$R2"
[ "$s" = 0 ] && cmp -s "$R1/results.tsv" "$R2/results.tsv" && cmp -s "$R1/notes.tsv" "$R2/notes.tsv" && [ "$(printf '%s\n' "$out")" = "$(cat "$W/out.txt")" ] && ok "the second run: exit 0, results.tsv, notes.tsv and the printed text byte-identical to the first" || fail "second run rc=$s; results differ: $(diff "$R1/results.tsv" "$R2/results.tsv" | head -3 | tr '\n' ';')"
if python3 -m bbx.readout "$R2" --against "$R1" > "$W/screen.txt" 2>&1; then ok "bin/bbx readout <run2> --against <run1>: exit 0 (GREEN and BBX-14 met)"; else fail "readout exit $? on a green pair: $(head -3 "$W/screen.txt" | tr '\n' '|')"; fi
want() { grep -q -- "$2" "$W/screen.txt" && ok "$1" || fail "$1 — missing '$2'"; }
want "the screen counts scenarios and pairings apart" "^VERDICT: GREEN   PASS 12  SKIP 0  FAIL 0  OTHER 0   (scenarios 9, pairings 12; each run 2 times; driver cli.sh)$"
want "the register's histogram: 21 fixture rows (12 files + 9 truth logs), evidence about no real subject" "^  expectations relied upon: fixture 21 (register expected/PROVENANCE.toml; 12 files in the set); fixture 21: evidence about no real subject$"
want "the classes that ran — the spec's class words — none on a real pairing" "^  comparator classes in this run: band, exact, multiset, schema; PASSed on a real pairing: none — every expectation of this set is fixture-class or unregistered$"
want "no coverage number: the command-line kind has none (BBX-18 stated, not faked)" "^  coverage: no scenario reported a coverage number (NOTE: coverage …) — uncovered claims are not counted in this run$"
want "the band inventory on the screen (BBX-13's watch, RO1)" "^  note: 04_band: band-fields 1$"
want "the exit status on the screen, per scenario" "^  note: 06_unknown_option: exit 2$"
want "the emitted files on the screen" "^  note: 07_emit_file: emitted-files 1$"
want "BBX-14 met over pairings" "^  BBX-14 (more than one run): met — 12 pairings, 0 verdict differences against the run started "
want "the driver's blind spots on the screen (RO2)" "^  driver cli.sh: performance, behaviour on inputs outside the scenarios, and anything the tool wrote that the scenario did not declare"
[ "$(grep -c '^  note: 04_band: band-fields 1$' "$W/screen.txt")" = 2 ] && ok "the duplicate is on the screen too: 04_band's band-fields line twice (R41: ruled kept, visible by design)" || fail "band-fields lines on the screen: $(grep -c 'band-fields 1' "$W/screen.txt")"

echo "== 3. --freeze on a copy: every kind authored, nothing written =="
copy fz; (cd "$W/fz" && find . -type f -exec cksum {} + | sort > "$W/fz.before")
suite_ "$W/fz" --freeze; (cd "$W/fz" && find . -type f -exec cksum {} + | sort > "$W/fz.after")
[ "$s" = 0 ] && cmp -s "$W/fz.before" "$W/fz.after" && [ "$(printf '%s\n' "$out" | grep -c 'authored \.[a-z]* expectation — not self-frozen')" = 12 ] && [ "$(tail -n +2 "$LOGDIR/results.tsv" | cut -f5 | sort -u)" = authored ] && [ ! -f "$W/fz/expected/fixture/01_list.sha1" ] \
    && ok "--freeze: exit 0, 12 'authored .<kind> expectation — not self-frozen' lines (kept: authored), no file of the copy changed, no .sha1 written (every expectation is design-derived: nothing self-freezes)" || fail "--freeze: rc=$s authored=$(printf '%s\n' "$out" | grep -c authored) changed=$(diff "$W/fz.before" "$W/fz.after" | grep -c '^[<>]')"

echo "== 4. CONTROL identity-before-any-scenario =="
copy id; edit "$W/id/subject/fakecli.py" 's/Orsolya/Orsolya_/'
if cmp -s "$F/subject/fakecli.py" "$W/id/subject/fakecli.py"; then fail "CONTROL DEAD: identity-before-any-scenario — the perturbation did not apply"
else
    suite_ "$W/id"
    if [ "$s" = 1 ] && has "^UNREGISTERED build: whole-set " && has "^unregistered build fingerprint — see message above$" && [ "$(runv)" = UNREGISTERED ] && [ "$(rows)" = 0 ]; then
        cp "$F/subject/fakecli.py" "$W/id/subject/fakecli.py"; suite_ "$W/id"
        [ "$s" = 0 ] && has "^build fingerprint -> expectation set 'fixture'$" && has "^SUITE GREEN$" && echo "CONTROL FIRED: identity-before-any-scenario — one byte of the tool changed: UNREGISTERED, exit 1, no scenario row; restored: set 'fixture', SUITE GREEN" || fail "CONTROL DEAD: identity-before-any-scenario — restored copy rc=$s $(printf '%s' "$out" | tail -1)"
    else fail "CONTROL DEAD: identity-before-any-scenario — rc=$s verdict=$(runv) rows=$(rows) $(printf '%s' "$out" | head -2 | tr '\n' '|')"; fi
fi

echo "== 5. CONTROL nondeterministic-before-any-class =="
copy nd; edit "$W/nd/scenarios/01_list.cli" 's/^args = \["list"\]$/args = ["list", "--nondet"]/'
c5=0
if ! grep -q -- '--nondet' "$W/nd/scenarios/01_list.cli"; then fail "CONTROL DEAD: nondeterministic-before-any-class — the scenario edit did not apply"; else
    suite_ "$W/nd"
    [ "$s" = 1 ] && has "^01_list                  NONDETERMINISTIC (first divergent frame below)$" && [ "$(row 01_list -)" = nondeterministic ] && [ "$(row 02_unordered truth)" = pass ] && [ "$(rows)" = 12 ] && has "^SUITE RED$" && c5=1 || fail "scenario --nondet: rc=$s $(printf '%s' "$out" | sed -n 2p)"
fi
printf '#!/bin/sh\nCLI_NONDET=1 exec "%s" "$@"\n' "$DRV" > "$W/nondet.sh"; chmod +x "$W/nondet.sh"
suite_ "$F" --driver "$W/nondet.sh"
[ "$s" = 1 ] && has "^01_list                  NONDETERMINISTIC (first divergent frame below)$" && has "^09_env                   NONDETERMINISTIC (first divergent frame below)$" && has "^SUITE RED$" && [ "$(printf '%s\n' "$out" | grep -c ' PASS')" = 0 ] \
    && [ "$(tail -n +2 "$LOGDIR/results.tsv" | cut -f2,5 | sort -u)" = "-	nondeterministic" ] && [ "$(rows)" = 9 ] && [ "$(runv)" = RED ] && c5=$((c5 + 1)) || fail "wrapper driver: rc=$s rows=$(rows) $(printf '%s' "$out" | sed -n 2p)"
CLI_NONDET=1 suite_ "$F"; [ "$s" = 0 ] && has "^SUITE GREEN$" && c5=$((c5 + 1)) || fail "caller's CLI_NONDET=1: rc=$s"
CLI_PATH="$F/subject" CLI_NONDET=1 "$DRV" fakecli "$F/scenarios/01_list.cli" "$W/n1.log" > /dev/null; CLI_PATH="$F/subject" CLI_NONDET=1 "$DRV" fakecli "$F/scenarios/01_list.cli" "$W/n2.log" > /dev/null
cmp -s "$W/n1.log" "$W/n2.log" || c5=$((c5 + 1))
[ "$c5" = 4 ] && echo "CONTROL FIRED: nondeterministic-before-any-class — a scenario copy with --nondet: NONDETERMINISTIC on it, no kind evaluated (kept kind '-', finding nondeterministic), RED; the wrapper driver: on every scenario, 9 rows, no PASS; the caller's CLI_NONDET=1: scrubbed, SUITE GREEN; the driver directly under it: two differing logs" || fail "CONTROL DEAD: nondeterministic-before-any-class — $c5 of 4 directions held"

echo "== 6. CONTROL crash-vs-refusal =="
copy cr; edit "$W/cr/scenarios/01_list.cli" 's/^args = \["list"\]$/args = ["list", "--crash-at", "3"]/'
copy rk; edit "$W/rk/scenarios/01_list.cli" 's/^args = \["list"\]$/argz = ["list"]/'
if ! grep -q -- '--crash-at' "$W/cr/scenarios/01_list.cli" || ! grep -q '^argz = ' "$W/rk/scenarios/01_list.cli"; then fail "CONTROL DEAD: crash-vs-refusal — a scenario edit did not apply"; else
    c6=0
    suite_ "$W/cr"
    [ "$s" = 1 ] && has "^01_list                  cli.py: the tool died by signal 9 (SIGKILL) after 3 points: exit 2, the log .* is the bug report (END-CRASH)$" && has "^RUN-FAIL$" && [ "$(row 01_list -)" = run-fail ] && [ "$(grep -c '^01_list' "$LOGDIR/results.tsv")" = 1 ] && [ "$(grep -c '^01_list' "$LOGDIR/notes.tsv")" = 0 ] && [ "$(row 02_unordered truth)" = pass ] && [ "$(rows)" = 12 ] && has "^SUITE RED$" && c6=1 || fail "--crash-at 3: rc=$s $(printf '%s' "$out" | sed -n '2,3p' | tr '\n' '|')"
    suite_ "$W/rk"
    [ "$s" = 1 ] && has "^01_list                  REFUSED: drivers/cli.sh cannot honour scenario key 'argz' (the keys are args, stdin, stdin_file, cwd, emits, bands, fields (D46; an option the tool does not define is refused, never ignored))$" && has "^RUN-FAIL$" && [ "$(row 01_list -)" = run-fail ] && [ "$(grep -c '^01_list' "$LOGDIR/notes.tsv")" = 0 ] && [ "$(row 09_env truth)" = pass ] && has "^SUITE RED$" && c6=$((c6 + 1)) || fail "argz: rc=$s $(printf '%s' "$out" | sed -n '2,3p' | tr '\n' '|')"
    [ "$(awk -F'\t' '$1 == "05_exit_1" && $2 == "truth" { print $5 }' "$R1/results.tsv")" = pass ] && grep -q "^05_exit_1	exit	1$" "$R1/notes.tsv" && [ "$(awk -F'\t' '$1 == "06_unknown_option" && $2 == "truth" { print $5 }' "$R1/results.tsv")" = pass ] && grep -q "^06_unknown_option	exit	2$" "$R1/notes.tsv" && c6=$((c6 + 1)) || fail "the tool's own non-zero exits did not PASS in the green run"
    [ "$c6" = 3 ] && echo "CONTROL FIRED: crash-vs-refusal — --crash-at 3: the driver's signal line, RUN-FAIL (kept: run-fail, kind '-', one row, no NOTE), the other scenarios pass, RED; scenario key argz: the driver's REFUSED line naming it, RUN-FAIL the same way; 05_exit_1 (exit 1) and 06_unknown_option (exit 2) PASS in the green run with their exit kept — three reports, not one" || fail "CONTROL DEAD: crash-vs-refusal — $c6 of 3 directions held"
fi

echo "== 7. CONTROL wrong-truth =="
copy wt; edit "$W/wt/expected/fixture/logs/06_unknown_option.log" '1s/^0 exit:2$/0 exit:0/'
if [ "$(head -1 "$W/wt/expected/fixture/logs/06_unknown_option.log")" != "0 exit:0" ]; then fail "CONTROL DEAD: wrong-truth — the truth log rewrite did not apply"
else
    suite_ "$W/wt"
    if [ "$s" = 1 ] && has "^06_unknown_option        truth    FAIL exact: index 0 differs$" && [ "$(row 06_unknown_option truth)" = diverged ] && [ "$(tail -n +2 "$LOGDIR/results.tsv" | cut -f5 | sort | uniq -c | tr -s ' ' | tr '\n' ';')" = " 1 diverged; 11 pass;" ] && has "^SUITE RED$"; then
        echo "CONTROL FIRED: wrong-truth — the truth rewritten exit:0 at index 0: the exact pairing alone FAILS naming index 0 (kept: diverged), the other 11 pairings PASS, SUITE RED"
    else fail "CONTROL DEAD: wrong-truth — rc=$s $(printf '%s' "$out" | grep -A1 '^06_unknown' | tr '\n' '|') findings=$(tail -n +2 "$LOGDIR/results.tsv" | cut -f5 | sort | uniq -c | tr '\n' ';')"; fi
fi

echo "== 8. CONTROL schema-before-any-value (the JSON view through the loop) =="
copy sc; edit "$W/sc/expected/fixture/03_show_json.schema" 's/^name = "weight"$/name = "width"/'
if ! grep -q '^name = "width"$' "$W/sc/expected/fixture/03_show_json.schema"; then fail "CONTROL DEAD: schema-before-any-value — the key rename did not apply"
else
    suite_ "$W/sc"
    if [ "$s" = 1 ] && has "^03_show_json             schema   FAIL schema: frozen key 'width' is absent from the object$" && has "^                         truth    NOT-EVALUATED (schema failed)$" \
        && [ "$(row 03_show_json schema)" = diverged ] && [ "$(row 03_show_json truth)" = pending ] && [ "$(grep -c '^03_show_json' "$LOGDIR/notes.tsv")" = 0 ] && [ "$(grep -c '^04_band' "$LOGDIR/notes.tsv")" = 4 ] \
        && grep -q '^pass=10$' "$LOGDIR/run.txt" && grep -q '^fail=2$' "$LOGDIR/run.txt" && [ "$(row 04_band band)" = pass ] && has "^SUITE RED$"; then
        echo "CONTROL FIRED: schema-before-any-value — the schema pairing FAILS naming the frozen key 'width' as absent from the OBJECT (the JSON view, D54, handed by the loop's view column), the truth pairing reads NOT-EVALUATED (schema failed) (kept: pending, fail=2), no NOTE kept for 03_show_json, the other 8 scenarios pass"
    else fail "CONTROL DEAD: schema-before-any-value — rc=$s $(printf '%s' "$out" | grep -A1 '^03_show_json' | tr '\n' '|') notes03=$(grep -c '^03_show_json' "$LOGDIR/notes.tsv")"; fi
fi

echo "== 9. CONTROL band-through-the-loop =="
copy bd; edit "$W/bd/expected/fixture/04_band.band" 's/^max = 270$/max = 260/'
if ! grep -q '^max = 260$' "$W/bd/expected/fixture/04_band.band"; then fail "CONTROL DEAD: band-through-the-loop — the band narrowing did not apply"
else
    suite_ "$W/bd"
    if [ "$s" = 1 ] && has "^                         band     FAIL band size: 265 outside \[236, 260\]$" && [ "$(row 04_band band)" = diverged ] && [ "$(row 04_band truth)" = pass ] && [ "$(grep -c "^04_band	band-fields	1$" "$LOGDIR/notes.tsv")" = 1 ] && grep -q "^04_band	exit	0$" "$LOGDIR/notes.tsv" && has "^SUITE RED$"; then
        echo "CONTROL FIRED: band-through-the-loop — the band narrowed to [236, 260]: the band pairing FAILS naming size, 265 and the band (kept: diverged, RED) through the view the loop handed; the truth pairing PASSes on the constant token; band-fields 1 kept ONCE — the summary's, the comparator's gone with its FAIL"
    else fail "CONTROL DEAD: band-through-the-loop — rc=$s $(printf '%s' "$out" | grep -A1 '^04_band' | tr '\n' '|') notes=$(grep '^04_band' "$LOGDIR/notes.tsv" | tr '\n\t' '|:')"; fi
fi

echo "== 10. CONTROL unknown-view =="
copy uv; printf '\n[expectations]\nkinds = [["skip", "-", "SKIP", "-"], ["sha1", "exact", "N/A", "log"], ["pending", "-", "NOT-EVALUATED", "-"], ["truth", "exact", "EVAL", "log"], ["unordered", "set", "EVAL", "log"], ["schema", "schema", "EVAL", "objekt"], ["band", "tolerant-numeric", "EVAL", "bands"]]\n' >> "$W/uv/bbx.toml"
copy os; printf '\n[expectations]\nkinds = [["skip", "-", "SKIP"], ["truth", "exact", "EVAL"]]\n' >> "$W/os/bbx.toml"
if [ "$(BBX_CONFIG="$W/uv/bbx.toml" python3 -m bbx.expectations view schema)" != objekt ]; then fail "CONTROL DEAD: unknown-view — the consumer's table did not take (view of schema: $(BBX_CONFIG="$W/uv/bbx.toml" python3 -m bbx.expectations view schema))"; else
    c10=0
    suite_ "$W/uv"
    [ "$s" = 1 ] && [ "$(printf '%s\n' "$out" | sed -n 2p)" = "FAIL: kind 'schema' declares view 'objekt', which the kinds loop cannot resolve (log, subject, json, bands or -; D57)" ] && [ "$(rows)" = 0 ] && [ "$(runv)" = RED ] && [ "$(tail -n +2 "$LOGDIR/notes.tsv" | wc -l | tr -d ' ')" = 0 ] && c10=1 || fail "objekt: rc=$s rows=$(rows) $(printf '%s' "$out" | sed -n 2p)"
    suite_ "$W/os"
    [ "$s" = 1 ] && [ "$(printf '%s\n' "$out" | sed -n 1p)" = "bbx expectations: kinds row ['skip', '-', 'SKIP'] has 3 fields, not 4 (extension, family, disposition, view — D57)" ] && [ "$(printf '%s\n' "$out" | sed -n 2p)" = "FAIL: the kinds table could not be read (bbx.expectations kinds)" ] && ! has Traceback && [ ! -f "$LOGDIR/results.tsv" ] && c10=$((c10 + 1)) || fail "old shape: rc=$s $(printf '%s' "$out" | head -2 | tr '\n' '|')"
    [ "$c10" = 2 ] && echo "CONTROL FIRED: unknown-view — view 'objekt' on the schema kind: FAIL at the entrance naming the kind and the view, exit 1, 0 rows, no NOTE, verdict RED; a three-field table: one 'bbx expectations:' line naming the row, the suite's FAIL line, exit 1, no kept run" || fail "CONTROL DEAD: unknown-view — $c10 of 2 directions held"
fi

echo "== 11. READ-ONLY: the tree's fixture after every run =="
snapshot > "$W/after.txt"
cmp -s "$W/before.txt" "$W/after.txt" && ok "every file of fixture/fakecli has the checksum it had before ($(wc -l < "$W/after.txt" | tr -d ' ') files)" || { fail "the tree's fixture was WRITTEN:"; diff "$W/before.txt" "$W/after.txt" | sed 's/^/        /' | head -6; }
echo "NOTE: suite-runs $(wc -l < "$W/runs" | tr -d ' ') (each kept under --log)"

echo
[ "$rc" = 0 ] && echo "PASS: the suite drives the command-line fixture end to end, GREEN twice, the kinds loop's second consumer with every view handed from the table, and every control failed where it must" || { echo "FAIL: see above"; exit 1; }
