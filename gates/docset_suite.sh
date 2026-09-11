#!/bin/sh
# docset_suite.sh — the suite drives the document-set fixture end to end and is GREEN twice on it: every EVAL kind of a scenario is its own pairing in the printed shape frozen here, the kept run keys its rows (scenario, kind) and carries the coverage numbers the readout puts on the screen, the artifact's shape is judged before any value, --freeze rewrites the shrink-only kind and never a truth log, and a changed document is refused before any claim is read
# Ground truth for the KINDS LOOP of bin/bbx-run-suite (docs/plans/S3.md §8.4; §3 "E1", "O6", "RO1", "RO2"; §5's identity,
# twice, covered-set, wrong-truth and schema rows; R32, R33; D43, D44) and for the suite screen's coverage, note and driver
# lines in lib/py/bbx/readout.py. The suite runs on the TREE's fixture (read-only: --log under TMPDIR; the fixture's files
# are checksummed before and after) for the positive checks and on COPIES under TMPDIR for every control, each perturbation
# proven applied before its assertion (VampireSaved test_checkdocs_rom.sh's practice). Every printed line of the green run
# is frozen here and classified by finding.py (C4 with no ancestor: the gate is the freeze). bbh's precedence loop is not
# touched by this gate: gates/fidelity_bbh_s2.sh's F12, unchanged and green, is the control that nothing moved for bbh.
# No instrument. Portable, ~55 s (real 54.8 measured 2026-09-10: 15 suite runs, python start-up dominated).
# Usage: gates/docset_suite.sh
# MUST-FIRE: known-bad: identity-before-any-claim — one word changed in a copied document must make the suite exit 1 as UNREGISTERED with no scenario row kept, and the copy restored must resolve to the registered set and be GREEN again, or a changed input is compared against the fixture's expectations (S2, BBH-67)
# MUST-FIRE: known-bad: nondeterministic-before-any-class — a wrapper driver that exports DOCSET_NONDET=1 around drivers/docset.sh must read NONDETERMINISTIC on every scenario with no kind evaluated (kept: kind `-`, finding nondeterministic, RED), while the same variable in the caller's environment leaves the suite GREEN (scrubbed, D33) though it moves the log when the driver is called directly, or BBX-14 is prose and the scrub is decoration
# MUST-FIRE: perturbed-copy: covered-shrink-only — a covered row added to a copy that the run does not reach must FAIL naming it (kept: diverged, RED); a row removed must PASS saying the run covers 1 more with `NOTE: covered-grew 1` kept; --freeze must then rewrite that file to the generator's byte for byte, leave the other covered files and every truth log untouched, and the next plain run must be GREEN with no growth NOTE, or the covered set can shrink silently or grow without a trace (R33)
# MUST-FIRE: known-bad: wrong-truth — the fixture's planted wrong claim reads MISMATCH and the suite is GREEN; a copy of its truth log with that index rewritten BOUND must make the exact pairing alone FAIL naming index 3 (kept: diverged, RED) while schema, claims and covered still PASS, or the known positive is not one (BBX-5, BBX-2)
# MUST-FIRE: perturbed-copy: schema-before-any-value — a column renamed in a copied schema must FAIL the schema pairing naming the column and print the suite's own `NOT-EVALUATED (schema failed)` on that scenario's three value kinds (kept: pending, counted as failures, no NOTE kept for it) while the other scenarios pass, or a wrong shape is read for its values (R34, E2)
# MUST-FIRE: perturbed-copy: freeze-keeps-the-truth-log — a marker appended to a copied truth log must survive --freeze while the authored kinds are present (each printed `authored .<kind> expectation — not self-frozen`, the covered kind re-frozen), and the same copy with the scenario's four kinds removed must have that log OVERWRITTEN by the self-freeze (`frozen <sha>`, the marker gone, a .sha1 written), or the guard keeping a self-measured log off a design-derived truth is prose (BBX-3, R11; the bbx-9 HANDOFF hazard)
# NOT-ASSERTED: anything about a real document set: every input is the fixture's (fixture class) or a perturbed copy of it; the forms, guards and lexical classes are the fixture's (D35, D39, D40)
# NOT-ASSERTED: bbh's precedence loop and its printed text: gates/fidelity_bbh_s2.sh (F12) and gates/suite.sh
# NOT-ASSERTED: the readout screen beyond the lines checked here (the verdict, the pairings, the coverage and note lines, BBX-14, the driver's blind spots): gates/readout.sh
# NOT-ASSERTED: a second consumer of the kinds loop (S4's command-line kind): one profile drives it here (BBX-25 unmet, stated)
#
set -eu
BBX_HOME="$(cd "$(dirname "$0")/.." && pwd)"; export BBX_HOME
PYTHONPATH="$BBX_HOME/lib/py"; export PYTHONPATH
PYTHONDONTWRITEBYTECODE=1; export PYTHONDONTWRITEBYTECODE
unset BBX_CONFIG BBH_CONFIG BBX_MASK_DEFAULT BBX_REPLAYS_DIR DOCSET_PATH DOCSET_NONDET DOCSET_VIEW DOCSET_FORMS SUITE_ONLY MASK_RANGES DUMPS POKES SNAP_FRAMES VIDEO_OUT INPUT_OUT TAIL_FRAMES INPUT_INJECT_TEST NO_INPUT_CHECK 2>/dev/null || true
F="$BBX_HOME/fixture/docset"; SUITE="$BBX_HOME/bin/bbx-run-suite"; DRV="$BBX_HOME/drivers/docset.sh"
rc=0
ok()   { printf '  ok    %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1"; rc=1; }
W="$(mktemp -d)"; trap 'rm -rf "$W"' EXIT INT TERM
LOGDIR="$W/last"; : > "$W/runs"
snapshot() { (cd "$F" && find . -type f -exec cksum {} + | sort); }
snapshot > "$W/before.txt"
# suite_ <fixture-dir> [suite args...] -> the suite's output; status in $s; the kept run under $LOGDIR
suite_() { _d="$1"; shift; rm -rf "$LOGDIR"; echo x >> "$W/runs"; if out="$(DOCSET_PATH="$_d/subject" "$SUITE" --config "$_d/bbx.toml" --log "$LOGDIR" "$@" 2>&1)"; then s=0; else s=$?; fi; }
has()  { printf '%s\n' "$out" | grep -q -- "$1"; }
row()  { awk -F'\t' -v s="$1" -v k="$2" '$1 == s && $2 == k { print $5 }' "$LOGDIR/results.tsv"; }   # the FINDING of one pairing, by field
runv() { grep '^verdict=' "$LOGDIR/run.txt" | cut -d= -f2; }
copy() { rm -rf "$W/$1"; cp -R "$F" "$W/$1"; }
# keep <what> <dest> — the kept run copied aside. A suite that kept NO run is this gate's OWN FAIL, naming the suite's
# output, never a bare `cp:` line from under `set -e` with no verdict of its own (G28, the bbx-16 learning).
keep() { if [ -d "$LOGDIR" ]; then rm -rf "$2"; cp -R "$LOGDIR" "$2"; else fail "$1: the suite kept NO run at --log (exit $s); its output:"; printf '%s\n' "$out" | sed 's/^/        /'; exit 1; fi; }

echo "== 1. the tree's fixture: GREEN, every printed line frozen and classified, the kept run keyed (scenario, kind) =="
cat > "$W/want.txt" <<'WANT'
build fingerprint -> expectation set 'fixture'
01_all                   schema   PASS schema (tsv: 4 columns, 12 rows)
                         truth    PASS exact (23 indices, every token the truth's)
                         claims   PASS set-inventory (23 rows, the frozen inventory and the run agree both ways)
                         covered  PASS set-covered (20 frozen rows still covered)
NOTE: coverage 20/23
NOTE: paraphrase 1
NOTE: unbindable 2
NOTE: stale 0
NOTE: mismatch 1
02_weights               schema   PASS schema (tsv: 4 columns, 12 rows)
                         truth    PASS exact (7 indices, every token the truth's)
                         claims   PASS set-inventory (7 rows, the frozen inventory and the run agree both ways)
                         covered  PASS set-covered (6 frozen rows still covered)
NOTE: coverage 6/7
NOTE: paraphrase 0
NOTE: unbindable 0
NOTE: stale 0
NOTE: mismatch 1
03_rows                  schema   PASS schema (tsv: 4 columns, 12 rows)
                         truth    PASS exact (7 indices, every token the truth's)
                         claims   PASS set-inventory (7 rows, the frozen inventory and the run agree both ways)
                         covered  PASS set-covered (7 frozen rows still covered)
NOTE: coverage 7/7
NOTE: paraphrase 0
NOTE: unbindable 0
NOTE: stale 0
NOTE: mismatch 0
SUITE GREEN
WANT
suite_ "$F"; printf '%s\n' "$out" > "$W/out.txt"; R1="$W/r1"; keep 'the tree fixture run' "$R1"
if [ "$s" = 0 ] && diff "$W/want.txt" "$W/out.txt" > "$W/diff.txt"; then ok "exit 0 and every printed line is the frozen text (29 lines: 12 pairings, 15 NOTEs, the set line, SUITE GREEN)"
else fail "rc=$s; the printed text differs from the frozen text:"; head -12 "$W/diff.txt" | sed 's/^/        /'; fi
n_lines=0; n_pass=0
while IFS= read -r line; do
    case "$line" in "build fingerprint"*|NOTE:*|"SUITE GREEN") continue ;; esac
    v="$(printf '%s' "$line" | cut -c34-)"; n_lines=$((n_lines + 1))
    [ "$(python3 -m bbx.finding "$v")" = pass ] && n_pass=$((n_pass + 1))
done < "$W/out.txt"
[ "$n_lines" = 12 ] && [ "$n_pass" = 12 ] && ok "12 verdict lines, each classified 'pass' by finding.py" || fail "verdict lines $n_lines, classified pass $n_pass"
[ "$(tail -n +2 "$LOGDIR/results.tsv" | wc -l | tr -d ' ')" = 12 ] && [ "$(tail -n +2 "$LOGDIR/results.tsv" | cut -f1,2 | tr '\n\t' '  ')" = "01_all schema 01_all truth 01_all claims 01_all covered 02_weights schema 02_weights truth 02_weights claims 02_weights covered 03_rows schema 03_rows truth 03_rows claims 03_rows covered " ] \
    && ok "kept: 12 rows keyed (scenario, kind), schema first then the table's order" || fail "kept rows: $(tail -n +2 "$LOGDIR/results.tsv" | cut -f1,2 | tr '\n' ';')"
[ "$(tail -n +2 "$LOGDIR/results.tsv" | cut -f3 | sort -u | tr '\n' ' ')" = "exact multiset schema " ] && [ "$(tail -n +2 "$LOGDIR/results.tsv" | cut -f5 | sort -u)" = pass ] && ok "kept: the class column reads the spec's class (exact, multiset, schema); every finding pass" || fail "kept classes/findings: $(tail -n +2 "$LOGDIR/results.tsv" | cut -f3,5 | sort -u | tr '\n' ';')"
[ "$(tail -n +2 "$LOGDIR/notes.tsv" | wc -l | tr -d ' ')" = 15 ] && grep -q "^01_all	coverage	20/23$" "$LOGDIR/notes.tsv" && grep -q "^03_rows	mismatch	0$" "$LOGDIR/notes.tsv" && ok "kept: notes.tsv 15 rows (scenario, key, value) — coverage 20/23, 6/7, 7/7 among them (D44)" || fail "notes.tsv: $(cat "$LOGDIR/notes.tsv" | tr '\n' ';')"
grep -q '^loop=kinds$' "$LOGDIR/run.txt" && [ "$(runv)" = GREEN ] && grep -q '^pass=12$' "$LOGDIR/run.txt" && grep -q '^expset=fixture$' "$LOGDIR/run.txt" && ok "kept: run.txt loop=kinds, expset=fixture, pass=12, verdict=GREEN" || fail "run.txt: $(grep -E '^(loop|verdict|pass|expset)=' "$LOGDIR/run.txt" | tr '\n' ' ')"
a1="$(python3 -m bbx.fingerprint "$F/subject" --set records --path --config "$F/bbx.toml")"; a2="$(DOCSET_PATH="$F/subject" BBX_CONFIG="$F/bbx.toml" python3 -m bbx.docset resolve records)"
[ -n "$a1" ] && [ "$a1" = "$a2" ] && ok "the subject file the suite hands the comparators is the file the driver resolves (one artifact: bbx.fingerprint --path = bbx.docset resolve)" || fail "artifact: suite '$a1' driver '$a2'"

echo "== 2. twice (BBX-14): a second run at the same HEAD, and the readout's screen over both =="
suite_ "$F"; R2="$W/r2"; keep 'the second run (BBX-14)' "$R2"
[ "$s" = 0 ] && cmp -s "$R1/results.tsv" "$R2/results.tsv" && cmp -s "$R1/notes.tsv" "$R2/notes.tsv" && ok "the second run: exit 0, results.tsv and notes.tsv byte-identical to the first" || fail "second run rc=$s; results differ: $(diff "$R1/results.tsv" "$R2/results.tsv" | head -3 | tr '\n' ';')"
if python3 -m bbx.readout "$R2" --against "$R1" > "$W/screen.txt" 2>&1; then ok "bin/bbx readout <run2> --against <run1>: exit 0 (GREEN and BBX-14 met)"; else fail "readout exit $? on a green pair: $(head -3 "$W/screen.txt" | tr '\n' '|')"; fi
want() { grep -q -- "$2" "$W/screen.txt" && ok "$1" || fail "$1 — missing '$2'"; }
want "the screen counts scenarios and pairings apart" "^VERDICT: GREEN   PASS 12  SKIP 0  FAIL 0  OTHER 0   (scenarios 3, pairings 12; each run 2 times; driver docset.sh)$"
want "coverage on the screen, per scenario (BBX-18, RO1)" "^  coverage: 01_all: 20/23$"
want "…all three" "^  coverage: 03_rows: 7/7$"
want "the other keys as notes" "^  note: 01_all: unbindable 2$"
want "BBX-14 met over pairings" "^  BBX-14 (more than one run): met — 12 pairings, 0 verdict differences against the run started "
want "the register's histogram: fixture class, evidence about no real subject" "^  expectations relied upon: fixture 15 (register expected/PROVENANCE.toml; 12 files in the set); fixture 15: evidence about no real subject$"
want "the classes that ran, none on a real pairing" "^  comparator classes in this run: exact, multiset, schema; PASSed on a real pairing: none — every expectation of this set is fixture-class or unregistered$"
want "the driver's blind spots on the screen (RO2)" "^  driver docset.sh: the truth of the artifact itself — a document that agrees with a wrong artifact reads BOUND$"

echo "== 3. CONTROL identity-before-any-claim =="
copy id; sed -i.bak 's/weight/mass/' "$W/id/subject/overview.md"; rm "$W/id/subject/overview.md.bak"
if cmp -s "$F/subject/overview.md" "$W/id/subject/overview.md"; then fail "CONTROL DEAD: identity-before-any-claim — the perturbation did not apply"
else
    suite_ "$W/id"
    if [ "$s" = 1 ] && has "^UNREGISTERED build: whole-set " && has "^unregistered build fingerprint — see message above$" && [ "$(runv)" = UNREGISTERED ] && [ "$(wc -l < "$LOGDIR/results.tsv" | tr -d ' ')" = 1 ]; then
        cp "$F/subject/overview.md" "$W/id/subject/overview.md"; suite_ "$W/id"
        [ "$s" = 0 ] && has "^build fingerprint -> expectation set 'fixture'$" && has "^SUITE GREEN$" && echo "CONTROL FIRED: identity-before-any-claim — one word changed: UNREGISTERED, exit 1, no scenario row; restored: set 'fixture', SUITE GREEN" || fail "CONTROL DEAD: identity-before-any-claim — restored copy rc=$s $(printf '%s' "$out" | tail -1)"
    else fail "CONTROL DEAD: identity-before-any-claim — rc=$s verdict=$(runv) rows=$(wc -l < "$LOGDIR/results.tsv") $(printf '%s' "$out" | head -2 | tr '\n' '|')"; fi
fi

echo "== 4. CONTROL nondeterministic-before-any-class =="
printf '#!/bin/sh\nDOCSET_NONDET=1 exec "%s" "$@"\n' "$DRV" > "$W/nondet.sh"; chmod +x "$W/nondet.sh"
suite_ "$F" --driver "$W/nondet.sh"; c4=0
[ "$s" = 1 ] && has "^01_all                   NONDETERMINISTIC (first divergent frame below)$" && has "^03_rows                  NONDETERMINISTIC (first divergent frame below)$" && has "^SUITE RED$" && [ "$(printf '%s\n' "$out" | grep -c ' PASS')" = 0 ] \
    && [ "$(tail -n +2 "$LOGDIR/results.tsv" | cut -f2,5 | sort -u)" = "-	nondeterministic" ] && [ "$(runv)" = RED ] && c4=1
DOCSET_NONDET=1 suite_ "$F"; [ "$s" = 0 ] && has "^SUITE GREEN$" && c4=$((c4 + 1))
DOCSET_PATH="$F/subject" DOCSET_NONDET=1 "$DRV" records "$F/claims/02_weights.claims" "$W/n1.log" > /dev/null; DOCSET_PATH="$F/subject" DOCSET_NONDET=1 "$DRV" records "$F/claims/02_weights.claims" "$W/n2.log" > /dev/null
cmp -s "$W/n1.log" "$W/n2.log" || c4=$((c4 + 1))
[ "$c4" = 3 ] && echo "CONTROL FIRED: nondeterministic-before-any-class — the wrapper driver: NONDETERMINISTIC on every scenario, no kind evaluated, kept kind '-' finding nondeterministic, RED; the caller's DOCSET_NONDET=1: scrubbed, SUITE GREEN; the driver directly under it: two differing logs" || fail "CONTROL DEAD: nondeterministic-before-any-class — $c4 of 3 directions held (wrapper rc=$s)"

echo "== 5. CONTROL covered-shrink-only =="
copy cv; printf '\n[c7]\ndocument = "weights.md"\nline = 5\nform = "of-is"\nstatus = "BOUND"\n' >> "$W/cv/expected/fixture/02_weights.covered"
suite_ "$W/cv"; c5=0
[ "$s" = 1 ] && has "^                         covered  FAIL set-covered: no longer covers weights.md:5 of-is BOUND (1 frozen row(s) lost)$" && [ "$(row 02_weights covered)" = diverged ] && [ "$(row 02_weights truth)" = pass ] && has "^SUITE RED$" && c5=1 || fail "added row: rc=$s $(printf '%s' "$out" | grep 'covered' | tr '\n' '|')"
copy cv; python3 - "$W/cv/expected/fixture/02_weights.covered" <<'EOF'
import sys, re
p = sys.argv[1]; s = open(p).read()
s2 = re.sub(r'\n\[c6\]\ndocument = "weights.md"\nline = 9\nform = "of-is"\nstatus = "BOUND"\n', '\n', s)
assert s2 != s, "the row was not removed"
open(p, "w").write(s2)
EOF
cmp -s "$F/expected/fixture/02_weights.covered" "$W/cv/expected/fixture/02_weights.covered" && fail "CONTROL DEAD: covered-shrink-only — the row removal did not apply"
suite_ "$W/cv"
[ "$s" = 0 ] && has "^                         covered  PASS set-covered (5 frozen rows still covered; the run covers 1 more)$" && has "^NOTE: covered-grew 1$" && grep -q "^02_weights	covered-grew	1$" "$LOGDIR/notes.tsv" && has "^SUITE GREEN$" && c5=$((c5 + 1)) || fail "removed row: rc=$s $(printf '%s' "$out" | grep 'covered' | tr '\n' '|')"
suite_ "$W/cv" --freeze
[ "$s" = 0 ] && has "^                         covered  frozen set-covered (6 rows)$" && has "^                         truth    authored .truth expectation — not self-frozen$" && has "^02_weights               schema   authored .schema expectation — not self-frozen$" && [ "$(row 02_weights covered)" = frozen ] && [ "$(row 02_weights claims)" = authored ] \
    && cmp -s "$W/cv/expected/fixture/02_weights.covered" "$F/expected/fixture/02_weights.covered" && cmp -s "$W/cv/expected/fixture/01_all.covered" "$F/expected/fixture/01_all.covered" && cmp -s "$W/cv/expected/fixture/03_rows.covered" "$F/expected/fixture/03_rows.covered" \
    && cmp -s "$W/cv/expected/fixture/logs/01_all.log" "$F/expected/fixture/logs/01_all.log" && cmp -s "$W/cv/expected/fixture/logs/02_weights.log" "$F/expected/fixture/logs/02_weights.log" && cmp -s "$W/cv/expected/fixture/logs/03_rows.log" "$F/expected/fixture/logs/03_rows.log" && [ ! -f "$W/cv/expected/fixture/02_weights.sha1" ] \
    && c5=$((c5 + 1)) || fail "--freeze: rc=$s $(printf '%s' "$out" | grep '02_weights\|covered' | tr '\n' '|'); covered equals generator's: $(cmp -s "$W/cv/expected/fixture/02_weights.covered" "$F/expected/fixture/02_weights.covered" && echo yes || echo no)"
suite_ "$W/cv"
[ "$s" = 0 ] && has "^SUITE GREEN$" && ! has "covered-grew" && [ "$(grep -c 'covered-grew' "$LOGDIR/notes.tsv")" = 0 ] && c5=$((c5 + 1)) || fail "plain run after the freeze: rc=$s grew-notes=$(grep -c covered-grew "$LOGDIR/notes.tsv")"
[ "$c5" = 4 ] && echo "CONTROL FIRED: covered-shrink-only — a lost row FAILS naming it (diverged, RED); a run covering more PASSes with NOTE: covered-grew 1 kept; --freeze rewrote the file to the generator's byte for byte, the other covered files and the three truth logs untouched, no .sha1 written; the next plain run GREEN with no growth NOTE" || fail "CONTROL DEAD: covered-shrink-only — $c5 of 4 directions held"

echo "== 6. CONTROL wrong-truth =="
grep -q "^02_weights	mismatch	1$" "$R1/notes.tsv" && [ "$(awk -F'\t' '$1 == "02_weights" && $2 == "truth" { print $5 }' "$R1/results.tsv")" = pass ] && ok "the planted wrong claim reads MISMATCH (kept: 02_weights mismatch 1) and the truth expects it: the pairing PASSes" || fail "the planted MISMATCH is not in the green run's notes"
copy wt; sed -i.bak '3s/^3 MISMATCH:/3 BOUND:/' "$W/wt/expected/fixture/logs/02_weights.log"; rm "$W/wt/expected/fixture/logs/02_weights.log.bak"
if cmp -s "$F/expected/fixture/logs/02_weights.log" "$W/wt/expected/fixture/logs/02_weights.log"; then fail "CONTROL DEAD: wrong-truth — the truth log rewrite did not apply"
else
    suite_ "$W/wt"
    if [ "$s" = 1 ] && has "^                         truth    FAIL exact: index 3 differs (truth BOUND, run MISMATCH; quoted same, derived same)$" && [ "$(row 02_weights truth)" = diverged ] && [ "$(row 02_weights schema)" = pass ] && [ "$(row 02_weights claims)" = pass ] && [ "$(row 02_weights covered)" = pass ] && has "^SUITE RED$"; then
        echo "CONTROL FIRED: wrong-truth — the truth rewritten BOUND at index 3: the exact pairing alone FAILS naming index 3 (kept: diverged), schema, claims and covered PASS, SUITE RED"
    else fail "CONTROL DEAD: wrong-truth — rc=$s $(printf '%s' "$out" | grep -A4 '^02_weights' | tr '\n' '|')"; fi
fi

echo "== 7. CONTROL schema-before-any-value =="
copy sc; sed -i.bak 's/^name = "weight"$/name = "mass"/' "$W/sc/expected/fixture/01_all.schema"; rm "$W/sc/expected/fixture/01_all.schema.bak"
if ! grep -q '^name = "mass"$' "$W/sc/expected/fixture/01_all.schema"; then fail "CONTROL DEAD: schema-before-any-value — the column rename did not apply"
else
    suite_ "$W/sc"
    if [ "$s" = 1 ] && has "^01_all                   schema   FAIL schema: column 3 is 'weight' (frozen 'mass')$" && has "^                         truth    NOT-EVALUATED (schema failed)$" && has "^                         claims   NOT-EVALUATED (schema failed)$" && has "^                         covered  NOT-EVALUATED (schema failed)$" \
        && [ "$(row 01_all schema)" = diverged ] && [ "$(row 01_all truth)" = pending ] && [ "$(row 01_all covered)" = pending ] && [ "$(grep -c '^01_all' "$LOGDIR/notes.tsv")" = 0 ] && [ "$(grep -c '^02_weights' "$LOGDIR/notes.tsv")" = 5 ] \
        && grep -q '^pass=8$' "$LOGDIR/run.txt" && grep -q '^fail=4$' "$LOGDIR/run.txt" && [ "$(row 02_weights truth)" = pass ] && has "^SUITE RED$"; then
        echo "CONTROL FIRED: schema-before-any-value — the schema pairing FAILS naming column 3, the three value kinds read NOT-EVALUATED (schema failed) (kept: pending, fail=4), no NOTE kept for 01_all, 02_weights and 03_rows pass"
    else fail "CONTROL DEAD: schema-before-any-value — rc=$s $(printf '%s' "$out" | sed -n '2,5p' | tr '\n' '|') notes01=$(grep -c '^01_all' "$LOGDIR/notes.tsv")"; fi
fi

echo "== 8. CONTROL freeze-keeps-the-truth-log =="
copy fz; echo "MARKER" >> "$W/fz/expected/fixture/logs/03_rows.log"
suite_ "$W/fz" --freeze; c8=0
[ "$s" = 0 ] && has "^03_rows                  schema   authored .schema expectation — not self-frozen$" && has "^                         covered  frozen set-covered (7 rows)$" && [ "$(tail -1 "$W/fz/expected/fixture/logs/03_rows.log")" = MARKER ] && [ ! -f "$W/fz/expected/fixture/03_rows.sha1" ] && c8=1 || fail "freeze with the kinds present: rc=$s marker=$(tail -1 "$W/fz/expected/fixture/logs/03_rows.log") sha1=$([ -f "$W/fz/expected/fixture/03_rows.sha1" ] && echo written || echo none)"
rm "$W/fz/expected/fixture/03_rows.truth" "$W/fz/expected/fixture/03_rows.claims" "$W/fz/expected/fixture/03_rows.covered" "$W/fz/expected/fixture/03_rows.schema"
suite_ "$W/fz" --freeze
[ "$s" = 0 ] && has "^03_rows                  sha1     frozen [0-9a-f]\{40\}$" && [ "$(tail -1 "$W/fz/expected/fixture/logs/03_rows.log")" = "END 7" ] && [ -f "$W/fz/expected/fixture/03_rows.sha1" ] && [ "$(row 03_rows sha1)" = frozen ] && c8=$((c8 + 1)) || fail "freeze with the kinds removed: rc=$s $(printf '%s' "$out" | grep 03_rows) marker=$(tail -1 "$W/fz/expected/fixture/logs/03_rows.log")"
[ "$c8" = 2 ] && echo "CONTROL FIRED: freeze-keeps-the-truth-log — with the authored kinds present --freeze left the marked truth log intact and wrote no .sha1; with the four kinds removed the self-freeze overwrote that log (frozen <sha>, the marker gone) and wrote 03_rows.sha1: the guard is the authored kinds' presence" || fail "CONTROL DEAD: freeze-keeps-the-truth-log — $c8 of 2 directions held"

echo "== 9. the self-frozen kind beside the authored kinds (E4), and NO-EXPECTATION =="
copy sh1; cp "$W/fz/expected/fixture/03_rows.sha1" "$W/sh1/expected/fixture/03_rows.sha1"
suite_ "$W/sh1"
[ "$s" = 0 ] && has "^                         sha1     PASS$" && [ "$(row 03_rows sha1)" = pass ] && [ "$(tail -n +2 "$LOGDIR/results.tsv" | wc -l | tr -d ' ')" = 13 ] && ok "a .sha1 beside the four kinds is a fifth pairing, last: 'sha1     PASS' (kept: pass; 13 rows)" || fail "sha1 beside: rc=$s $(printf '%s' "$out" | grep sha1)"
suite_ "$W/sh1" --freeze
has "^                         sha1     authored kinds present — .sha1 not self-frozen (logs/03_rows.log is theirs)$" && [ "$(row 03_rows sha1)" = authored ] && ok "--freeze with both: the .sha1 is not re-frozen beside authored kinds, and says why" || fail "freeze with both: $(printf '%s' "$out" | grep sha1)"
rm "$W/sh1/expected/fixture/03_rows.sha1" "$W/sh1/expected/fixture/03_rows.truth" "$W/sh1/expected/fixture/03_rows.claims" "$W/sh1/expected/fixture/03_rows.covered" "$W/sh1/expected/fixture/03_rows.schema"
suite_ "$W/sh1"
[ "$s" = 1 ] && has "^03_rows                  NO-EXPECTATION (freeze after review, as a STATE.md decision)$" && [ "$(row 03_rows -)" = no-expectation ] && ok "a scenario with no expectation file of any kind: NO-EXPECTATION, a failure (kept: no-expectation)" || fail "no expectation: rc=$s $(printf '%s' "$out" | grep 03_rows)"

echo "== 10. READ-ONLY: the tree's fixture after every run =="
snapshot > "$W/after.txt"
cmp -s "$W/before.txt" "$W/after.txt" && ok "every file of fixture/docset has the checksum it had before ($(wc -l < "$W/after.txt" | tr -d ' ') files)" || { fail "the tree's fixture was WRITTEN:"; diff "$W/before.txt" "$W/after.txt" | sed 's/^/        /' | head -6; }
echo "NOTE: suite-runs $(wc -l < "$W/runs" | tr -d ' ') (each kept under --log)"

echo
[ "$rc" = 0 ] && echo "PASS: the suite drives the document-set fixture end to end, GREEN twice, every pairing its own verdict and its own kept row, the coverage on the screen, and every control failed where it must" || { echo "FAIL: see above"; exit 1; }
