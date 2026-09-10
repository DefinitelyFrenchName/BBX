#!/bin/sh
# set_schema.sh — the document-set kind's three comparator families hold both ways on the fixture: exact BY INDEX with short apart from diverged, set both ways (inventory) and shrink-only (covered), schema before any value; every verdict line is frozen here, every line is classified by finding.py, and the one dispatcher reaches each family from its kind
# Ground truth for lib/py/bbx/compare_exact.py, compare_set.py, compare_schema.py and the exact/set/schema branches of
# lib/sh/compare.sh (docs/plans/S3.md §3 "C1, C2", "C3", "E1", §5's set / schema / verdict-text rows; R23, R33, R34;
# D41, D42). The driver runs once per scenario on the TREE's fixture (read-only); every comparator then runs on the
# tree's expectation set and on COPIES under TMPDIR, every perturbation proven applied before its assertion. No
# instrument. Portable, ~4 s.
# Usage: gates/set_schema.sh        (BBX_CONFIG is the fixture's inside: the document-set profile is in force)
# MUST-FIRE: perturbed-copy: inventory-both-ways — a row removed from a copy of the frozen inventory and a row added to it must each FAIL naming the row and its direction, or the inventory is compared one way (BBX-17)
# MUST-FIRE: perturbed-copy: covered-shrink-only — a frozen covered row the run no longer reaches must FAIL naming it, a duplicated frozen row must FAIL as hand-editing, and a run that covers MORE than frozen must PASS with `NOTE: covered-grew`, or the covered set can shrink silently (R33)
# MUST-FIRE: perturbed-copy: schema-before-values — a column renamed, a cell dropped from one row and a non-numeral in an int column, each in a copied artifact, must FAIL on SHAPE naming the column or the row, and a value perturbed must PASS schema and FAIL exact at its index, or a wrong artifact is read for its values (R34, BBX-16)
# MUST-FIRE: perturbed-copy: short-apart-from-diverged — a run log truncated must read FAIL-SHORT (finding `short`) and a run log with one token changed FAIL exact at its index (finding `diverged`), or the two findings are one (BBX-4)
# MUST-FIRE: shadow-tool: verdict-text — a shadow copy of compare_set.py with one verdict string changed must make this gate's frozen-text check FAIL, or the text frozen here is not frozen (C4 with no ancestor: the gate is the freeze)
# NOT-ASSERTED: the suite's loop over the kinds, the kept-run rows (scenario, kind), NOT-EVALUATED on a schema FAIL and --freeze for the shrink-only kind: gates/docset_suite.sh
# NOT-ASSERTED: anything about a real document set: every input is the fixture's (fixture class) or a perturbed copy of it
# NOT-ASSERTED: the schema family on a second format or a second consumer (S4's JSON): tsv is its one format and the fixture's artifact its one consumer (BBX-25 unmet, stated)
#
set -eu
BBX_HOME="$(cd "$(dirname "$0")/.." && pwd)"; export BBX_HOME
PYTHONPATH="$BBX_HOME/lib/py"; export PYTHONPATH
PYTHONDONTWRITEBYTECODE=1; export PYTHONDONTWRITEBYTECODE
unset BBX_CONFIG BBH_CONFIG BBX_MASK_DEFAULT DOCSET_PATH DOCSET_NONDET DOCSET_VIEW DOCSET_FORMS MASK_RANGES DUMPS POKES SNAP_FRAMES VIDEO_OUT INPUT_OUT TAIL_FRAMES INPUT_INJECT_TEST NO_INPUT_CHECK 2>/dev/null || true
F="$BBX_HOME/fixture/docset"; E="$F/expected/fixture"; CL="$F/claims"; ART="$F/subject/records.tsv"; DRV="$BBX_HOME/drivers/docset.sh"
BBX_CONFIG="$F/bbx.toml"; export BBX_CONFIG
. "$BBX_HOME/lib/sh/compare.sh"
rc=0
ok()   { printf '  ok    %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1"; rc=1; }
W="$(mktemp -d)"; trap 'rm -rf "$W"' EXIT INT TERM
: > "$W/lines.txt"
# try <want-rc> <want-first-line> <want-finding> -- <command...>   sets got / gotf; true when all three match
try() {
    _w="$1"; _t="$2"; _f="$3"; shift 4
    if "$@" > "$W/out" 2>&1; then _rc=0; else _rc=$?; fi
    got="$(head -1 "$W/out")"; printf '%s\n' "$got" >> "$W/lines.txt"; gotf="$(python3 -m bbx.finding "$got")"
    [ "$_rc" = "$_w" ] && [ "$got" = "$_t" ] && [ "$gotf" = "$_f" ]
}
expect() { _l="$1"; shift; if try "$@"; then ok "$_l — $got"; else fail "$_l: rc=$_rc finding=$gotf got '$got' want '$2' ($3)"; fi; }
drv() { env DOCSET_PATH="$1" "$DRV" records "$2" "$3" > "$W/drv.txt" 2>&1 || { fail "driver on $2: $(cat "$W/drv.txt")"; return 1; }; }
droptable() { awk -v t="[$2]" '$0 == t {skip=1; next} skip && /^\[/ {skip=0} !skip' "$1"; }   # a TOML-subset table removed, by name

echo "== 1. the driver on the tree's fixture, once per scenario =="
for sc in 01_all 02_weights 03_rows; do drv "$F/subject" "$CL/$sc.claims" "$W/$sc.log" && ok "$sc: $(tail -1 "$W/$sc.log")"; done
L="$W/01_all.log"

echo "== 2. every kind of every scenario PASSes through the one dispatcher, the family from the kind (R23) =="
expect "01_all truth"   0 "PASS exact (23 indices, every token the truth's)" pass -- compare_check "$E" 01_all truth - "" "$L"
expect "01_all claims"  0 "PASS set-inventory (23 rows, the frozen inventory and the run agree both ways)" pass -- compare_check "$E" 01_all claims - "" "$L" "$CL/01_all.claims" "$ART"
expect "01_all covered" 0 "PASS set-covered (20 frozen rows still covered)" pass -- compare_check "$E" 01_all covered - "" "$L" "$CL/01_all.claims" "$ART"
expect "01_all schema"  0 "PASS schema (tsv: 4 columns, 12 rows)" pass -- compare_check "$E" 01_all schema - "" "$L" "$CL/01_all.claims" "$ART"
expect "02_weights truth"   0 "PASS exact (7 indices, every token the truth's)" pass -- compare_check "$E" 02_weights truth - "" "$W/02_weights.log"
expect "02_weights claims"  0 "PASS set-inventory (7 rows, the frozen inventory and the run agree both ways)" pass -- compare_check "$E" 02_weights claims - "" "$W/02_weights.log" "$CL/02_weights.claims" "$ART"
expect "02_weights covered" 0 "PASS set-covered (6 frozen rows still covered)" pass -- compare_check "$E" 02_weights covered - "" "$W/02_weights.log" "$CL/02_weights.claims" "$ART"
expect "02_weights schema"  0 "PASS schema (tsv: 4 columns, 12 rows)" pass -- compare_check "$E" 02_weights schema - "" "$W/02_weights.log" "$CL/02_weights.claims" "$ART"
expect "03_rows truth"   0 "PASS exact (7 indices, every token the truth's)" pass -- compare_check "$E" 03_rows truth - "" "$W/03_rows.log"
expect "03_rows claims"  0 "PASS set-inventory (7 rows, the frozen inventory and the run agree both ways)" pass -- compare_check "$E" 03_rows claims - "" "$W/03_rows.log" "$CL/03_rows.claims" "$ART"
expect "03_rows covered" 0 "PASS set-covered (7 frozen rows still covered)" pass -- compare_check "$E" 03_rows covered - "" "$W/03_rows.log" "$CL/03_rows.claims" "$ART"
expect "03_rows schema"  0 "PASS schema (tsv: 4 columns, 12 rows)" pass -- compare_check "$E" 03_rows schema - "" "$W/03_rows.log" "$CL/03_rows.claims" "$ART"
for k in truth claims covered schema; do f="$(python3 -m bbx.expectations family "$k")"; printf '%s ' "$k=$f"; done > "$W/fam"; [ "$(cat "$W/fam")" = "truth=exact claims=set covered=set schema=schema " ] && ok "the families from the profile's table: $(cat "$W/fam")" || fail "families: $(cat "$W/fam")"
"$BBX_HOME/bin/bbx" compare exact "$E/logs/02_weights.log" "$W/02_weights.log" > "$W/o" && [ "$(cat "$W/o")" = "PASS exact (7 indices, every token the truth's)" ] && ok "bin/bbx compare exact reaches the tool" || fail "bin/bbx compare exact: $(cat "$W/o")"
"$BBX_HOME/bin/bbx" compare schema "$E/03_rows.schema" "$ART" > "$W/o" && ok "bin/bbx compare schema reaches the tool" || fail "bin/bbx compare schema: $(cat "$W/o")"

echo "== 3. what is refused: a kind outside the profile, a spec outside its family, a truth log that is gone, a map that is not this log's =="
expect "a .masked under the document-set profile" 1 "FAIL kind 'masked' has no comparator family in the kind profile in force (R23: a kind is registered in the profile's table or not at all)" diverged -- compare_check "$E" 01_all masked "exact fixture -" "" "$L"
o="$(env -u BBX_CONFIG sh -c '. "$BBX_HOME/lib/sh/compare.sh"; compare_check "$1" 01_all truth - "" "$2"' _ "$E" "$L" 2>&1)" && fail "a .truth under the frame-driven profile compared" || { [ "$o" = "FAIL kind 'truth' has no comparator family in the kind profile in force (R23: a kind is registered in the profile's table or not at all)" ] && ok "a .truth under the frame-driven profile (BBX_CONFIG unset) has no family" || fail "truth under frame-driven: '$o'"; }
cp -R "$F/expected" "$W/x"; X="$W/x/fixture"
sed 's/^class = "exact"$/class = "sortof"/' "$E/01_all.truth" > "$X/01_all.truth"; grep -q sortof "$X/01_all.truth" || fail "the truth spec was not perturbed"
expect "a truth spec whose class is not exact" 1 "FAIL unknown exact class 'sortof'" unknown-class -- compare_check "$X" 01_all truth - "" "$L"
sed 's/^mode = "inventory"$/mode = "sortof"/' "$E/01_all.claims" > "$X/01_all.claims"
expect "a set spec whose mode is unknown" 1 "FAIL unknown set mode 'sortof'" unknown-class -- compare_check "$X" 01_all claims - "" "$L" "$CL/01_all.claims" "$ART"
sed 's/^class = "multiset"$/class = "sortof"/' "$E/01_all.covered" > "$X/01_all.covered"
expect "a set spec whose class is unknown" 1 "FAIL unknown set class 'sortof'" unknown-class -- compare_check "$X" 01_all covered - "" "$L" "$CL/01_all.claims" "$ART"
sed 's/^type = "int"$/type = "float"/' "$E/01_all.schema" > "$X/01_all.schema"
expect "a schema spec with a type outside the vocabulary" 1 "FAIL unknown schema type 'float'" unknown-class -- compare_check "$X" 01_all schema - "" "$L" "$CL/01_all.claims" "$ART"
sed 's/^op = ">="$/op = "~"/' "$E/01_all.schema" > "$X/01_all.schema"
expect "a schema spec with a rows op outside the vocabulary" 1 "FAIL unknown schema rows op '~'" unknown-class -- compare_check "$X" 01_all schema - "" "$L" "$CL/01_all.claims" "$ART"
cp "$E/01_all.truth" "$X/01_all.truth"; rm "$X/logs/01_all.log"
expect "a truth log that is gone" 1 "NO-BASE-LOG $X/logs/01_all.log" no-base-log -- compare_check "$X" 01_all truth - "" "$L"
expect "the 02_weights log against 01_all's claim map" 1 "FAIL set: the run rows cannot be derived (the claim map does not describe this log at index 1 (the quoted hash differs))" diverged -- compare_check "$E" 01_all claims - "" "$W/02_weights.log" "$CL/01_all.claims" "$ART"
expect "the set family without its two trailing arguments" 1 "FAIL set: the set family needs the scenario file and the artifact (compare_check's two trailing arguments)" diverged -- compare_check "$E" 01_all claims - "" "$L"
expect "an expectation file that is not there" 1 "FAIL schema: $E/09_none.schema is not a schema spec (no such file)" diverged -- compare_check "$E" 09_none schema - "" "$L" "$CL/01_all.claims" "$ART"
printf 'END 0\n' > "$X/logs/01_all.log"
expect "a truth with no indices" 1 "FAIL exact: the truth has no indices — nothing compared" diverged -- compare_check "$X" 01_all truth - "" "$L"

echo "== 4. must-fire controls, each on a COPY =="
echo "-- inventory-both-ways --"
cp -R "$F/expected" "$W/i"; I="$W/i/fixture"
droptable "$E/01_all.claims" c5 > "$I/01_all.claims"
if grep -q '^\[c5\]' "$I/01_all.claims" || [ "$(grep -c '^\[c' "$I/01_all.claims")" != 22 ]; then fail "CONTROL DEAD: inventory-both-ways — the row was not removed"; else
    a=0; try 1 "FAIL set-inventory: 1 run row(s) not frozen (first overview.md:7 has BOUND)" diverged -- compare_check "$I" 01_all claims - "" "$L" "$CL/01_all.claims" "$ART" && a=1
    cp "$E/01_all.claims" "$I/01_all.claims"; printf '\n[c24]\ndocument = "ranks.md"\nline = 99\nform = "row"\nstatus = "BOUND"\n' >> "$I/01_all.claims"
    b=0; try 1 "FAIL set-inventory: 1 frozen row(s) not in the run (first ranks.md:99 row BOUND)" diverged -- compare_check "$I" 01_all claims - "" "$L" "$CL/01_all.claims" "$ART" && b=1
    droptable "$I/01_all.claims" c5 > "$I/both.claims"; mv "$I/both.claims" "$I/01_all.claims"
    c=0; try 1 "FAIL set-inventory: 1 frozen row(s) not in the run (first ranks.md:99 row BOUND); 1 run row(s) not frozen (first overview.md:7 has BOUND)" diverged -- compare_check "$I" 01_all claims - "" "$L" "$CL/01_all.claims" "$ART" && c=1
    if [ "$a$b$c" = 111 ]; then echo "CONTROL FIRED: inventory-both-ways — a frozen row removed names the run's row (overview.md:7), a frozen row added names it (ranks.md:99), both at once name both directions"
    else fail "CONTROL DEAD: inventory-both-ways — removed=$a added=$b both=$c (last: '$got')"; fi; fi
echo "-- covered-shrink-only --"
cp -R "$F/subject" "$W/c4"; sed 's/^Corvin	19E4	37	11$/Corvin	19E4	36	11/' "$F/subject/records.tsv" > "$W/c4/records.tsv"
if cmp -s "$W/c4/records.tsv" "$ART"; then fail "CONTROL DEAD: covered-shrink-only — the artifact copy was not perturbed"; else
    drv "$W/c4" "$CL/01_all.claims" "$W/c4.log"
    a=0; try 1 "FAIL set-covered: no longer covers overview.md:5 paraphrase PARAPHRASE (1 frozen row(s) lost)" diverged -- compare_check "$E" 01_all covered - "" "$W/c4.log" "$CL/01_all.claims" "$W/c4/records.tsv" && a=1
    cp -R "$F/expected" "$W/v"; V="$W/v/fixture"
    printf '\n[c21]\ndocument = "overview.md"\nline = 3\nform = "has"\nstatus = "BOUND"\n' >> "$V/01_all.covered"
    b=0; try 1 "FAIL set-covered: frozen row overview.md:3 has BOUND appears 2 times (a duplicate is hand-editing, BBX-17)" diverged -- compare_check "$V" 01_all covered - "" "$L" "$CL/01_all.claims" "$ART" && b=1
    droptable "$E/01_all.covered" c20 > "$V/01_all.covered"; [ "$(grep -c '^\[c' "$V/01_all.covered")" = 19 ] || fail "the growth copy has $(grep -c '^\[c' "$V/01_all.covered") rows, not 19"
    c=0; try 0 "PASS set-covered (19 frozen rows still covered; the run covers 1 more)" pass -- compare_check "$V" 01_all covered - "" "$L" "$CL/01_all.claims" "$ART" && [ "$(sed -n 2p "$W/out")" = "NOTE: covered-grew 1" ] && c=1
    sed 's/^status = "BOUND"$/status = "MISMATCH"/' "$E/02_weights.covered" > "$V/02_weights.covered"
    d=0; try 1 "FAIL set-covered: frozen row weights.md:3 of-is MISMATCH is not a covered status (BOUND or PARAPHRASE)" diverged -- compare_check "$V" 02_weights covered - "" "$W/02_weights.log" "$CL/02_weights.claims" "$ART" && d=1
    if [ "$a$b$c$d" = 1111 ]; then echo "CONTROL FIRED: covered-shrink-only — the paraphrase's literal perturbed (37 -> 36) loses overview.md:5 and FAILs naming it; a duplicated frozen row FAILs as hand-editing; 19 frozen of 20 covered PASSes with NOTE: covered-grew 1; a frozen row with status MISMATCH is refused"
    else fail "CONTROL DEAD: covered-shrink-only — lost=$a duplicate=$b grew=$c status=$d (last: '$got')"; fi; fi
echo "-- schema-before-values --"
mkdir -p "$W/s"; sed '1s/	weight	/	mass	/' "$ART" > "$W/s/rename.tsv"; awk -F'\t' -v OFS='\t' 'NR == 3 { NF = 3 } { print }' "$ART" > "$W/s/dropcell.tsv"; awk -F'\t' -v OFS='\t' 'NR == 2 { $3 = "x" } { print }' "$ART" > "$W/s/notint.tsv"
if cmp -s "$W/s/rename.tsv" "$ART" || cmp -s "$W/s/dropcell.tsv" "$ART" || cmp -s "$W/s/notint.tsv" "$ART"; then fail "CONTROL DEAD: schema-before-values — a perturbation did not apply"; else
    a=0; try 1 "FAIL schema: column 3 is 'mass' (frozen 'weight')" diverged -- compare_check "$E" 01_all schema - "" "$L" "$CL/01_all.claims" "$W/s/rename.tsv" && a=1
    b=0; try 1 "FAIL schema: row 2 has 3 columns (frozen 4)" diverged -- compare_check "$E" 01_all schema - "" "$L" "$CL/01_all.claims" "$W/s/dropcell.tsv" && b=1
    c=0; try 1 "FAIL schema: row 1 column 'weight' = 'x' is not int" diverged -- compare_check "$E" 01_all schema - "" "$L" "$CL/01_all.claims" "$W/s/notint.tsv" && c=1
    sed 's/^op = ">="$/op = "="/; s/^n = 12$/n = 11/' "$E/01_all.schema" > "$X/01_all.schema"
    d=0; try 1 "FAIL schema: rows 12 (frozen = 11)" diverged -- compare_check "$X" 01_all schema - "" "$L" "$CL/01_all.claims" "$ART" && d=1
    cp -R "$F/subject" "$W/c5"; sed 's/^Dorin	7B06	57	1$/Dorin	7B06	56	1/' "$ART" > "$W/c5/records.tsv"; cmp -s "$W/c5/records.tsv" "$ART" && fail "the value perturbation did not apply"
    drv "$W/c5" "$CL/01_all.claims" "$W/c5.log"
    e=0; try 0 "PASS schema (tsv: 4 columns, 12 rows)" pass -- compare_check "$E" 01_all schema - "" "$W/c5.log" "$CL/01_all.claims" "$W/c5/records.tsv" && e=1
    f=0; try 1 "FAIL exact: index 4 differs (truth BOUND, run MISMATCH; quoted same, derived differs)" diverged -- compare_check "$E" 01_all truth - "" "$W/c5.log" && f=1
    if [ "$a$b$c$d$e$f" = 111111 ]; then echo "CONTROL FIRED: schema-before-values — a renamed column, a dropped cell (row 2) and a non-numeral (row 1, weight) each FAIL on shape naming it; rows 12 against a frozen '= 11' FAILs; a value perturbed (Dorin 57 -> 56) PASSes schema and FAILs exact at index 4 with the derived half named"
    else fail "CONTROL DEAD: schema-before-values — rename=$a dropcell=$b notint=$c rows=$d value-schema=$e value-exact=$f (last: '$got')"; fi; fi
echo "-- short-apart-from-diverged --"
head -20 "$L" > "$W/short.log"; echo "END 20" >> "$W/short.log"
sed 's/^5 BOUND:/5 STALE:/' "$L" > "$W/div.log"
if cmp -s "$W/short.log" "$L" || cmp -s "$W/div.log" "$L"; then fail "CONTROL DEAD: short-apart-from-diverged — a perturbation did not apply"; else
    a=0; try 1 "FAIL-SHORT exact: the run ends at index 20, the truth at 23 (the observation ended before the comparison finished)" short -- compare_check "$E" 01_all truth - "" "$W/short.log" && a=1
    b=0; try 1 "FAIL exact: index 5 differs (truth BOUND, run STALE; quoted same, derived same)" diverged -- compare_check "$E" 01_all truth - "" "$W/div.log" && b=1
    grep -v '^5 ' "$L" | sed 's/^END 23$/END 22/' > "$W/gap.log"
    c=0; try 1 "FAIL exact: index 5 is absent from the run (a gap, not an early end)" diverged -- compare_check "$E" 01_all truth - "" "$W/gap.log" && c=1
    grep -v '^5 ' "$L" > "$W/end.log"
    d=0; try 1 "FAIL exact: the run END 23 does not equal its 22 indices" diverged -- compare_check "$E" 01_all truth - "" "$W/end.log" && d=1
    { grep -v '^END' "$L"; echo "24 BOUND:0:0"; echo "END 24"; } > "$W/long.log"
    e=0; try 1 "FAIL exact: the run has index 24 the truth does not (24 indices, truth 23)" diverged -- compare_check "$E" 01_all truth - "" "$W/long.log" && e=1
    { grep -v '^END' "$L"; grep '^5 ' "$L"; echo "END 24"; } > "$W/dup.log"
    f=0; try 1 "FAIL exact: index 5 appears twice in the run" diverged -- compare_check "$E" 01_all truth - "" "$W/dup.log" && f=1
    cp -R "$F/subject" "$W/c1"; sed 's/^Dorin has weight 57\.$/Dorin has mass 57./' "$F/subject/overview.md" > "$W/c1/overview.md"
    drv "$W/c1" "$CL/01_all.claims" "$W/c1.log"
    g=0; try 1 "FAIL exact: index 4 differs (truth BOUND, run STALE; quoted differs, derived differs)" diverged -- compare_check "$E" 01_all truth - "" "$W/c1.log" && g=1
    if [ "$a$b$c$d$e$f$g" = 1111111 ]; then echo "CONTROL FIRED: short-apart-from-diverged — a log cut at index 20 reads FAIL-SHORT (finding short); one token changed reads FAIL exact at index 5 (diverged); a gap, an END that disagrees, an index the truth lacks and a duplicated index each FAIL naming the index; an edited document names the quoted half"
    else fail "CONTROL DEAD: short-apart-from-diverged — short=$a diverged=$b gap=$c end=$d long=$e dup=$f quoted=$g (last: '$got')"; fi; fi
echo "-- verdict-text --"
SH="$W/shadow"; mkdir -p "$SH/lib/py" "$SH/lib/sh"; cp -R "$BBX_HOME/lib/py/bbx" "$SH/lib/py/bbx"; cp "$BBX_HOME/lib/sh/compare.sh" "$SH/lib/sh/compare.sh"
sed -i.bak 's/PASS set-inventory (/PASS set-inventory [/' "$SH/lib/py/bbx/compare_set.py"
if ! grep -q 'PASS set-inventory \[' "$SH/lib/py/bbx/compare_set.py"; then fail "CONTROL DEAD: verdict-text — the shadow was not perturbed (sed matched nothing)"; else
    o="$(env BBX_HOME="$SH" PYTHONPATH="$SH/lib/py" sh -c '. "$BBX_HOME/lib/sh/compare.sh"; compare_check "$@"' _ "$E" 01_all claims - "" "$L" "$CL/01_all.claims" "$ART" 2>&1)" && s=0 || s=$?
    if [ "$s" = 0 ] && [ "$o" != "PASS set-inventory (23 rows, the frozen inventory and the run agree both ways)" ] && [ "$o" = "PASS set-inventory [23 rows, the frozen inventory and the run agree both ways)" ]; then
        echo "CONTROL FIRED: verdict-text — the shadow's changed string is exactly what the frozen-text check refuses: '$o' is not the frozen line"
    else fail "CONTROL DEAD: verdict-text — exit $s: '$o'"; fi; fi

echo "== 5. every verdict line this gate saw is classified (finding.py never reads unclassified) =="
sort -u "$W/lines.txt" > "$W/uniq.txt"; n=0; bad=0
while IFS= read -r line; do n=$((n + 1)); [ "$(python3 -m bbx.finding "$line")" = unclassified ] && { bad=1; fail "unclassified: $line"; }; done < "$W/uniq.txt"
[ "$bad" = 0 ] && ok "$n distinct verdict lines, every one classified" || true
echo "NOTE: verdict-lines-frozen $n"

echo
if [ "$rc" = 0 ]; then echo "PASS: the exact, set and schema families hold both ways on the fixture, their verdict text is frozen and classified, and the dispatcher reaches each from its kind; 5 controls fired"; else echo "FAIL: see above"; fi
exit "$rc"
