#!/bin/sh
# json_schema.sh — the schema family's second format and the set family's second row shape hold both ways on the command-line fixture: a JSON object's shape is judged before any value (a key renamed by a shadow tool FAILs schema naming the frozen key, its value moved PASSes schema and FAILs exact at the key's index), a type of the other format's vocabulary is refused, the unordered listing's inventory is compared both ways with a duplicate named as hand-editing, and the ordered listing against a reversed truth FAILs at index 1 where the set family cannot see the order; every verdict line is frozen here and classified by finding.py
# Ground truth for the json format of lib/py/bbx/compare_schema.py, the line row shape of compare_set.py and the END rule
# of compare_exact.py over a command-line log (docs/plans/S4.md §3 "E1" schema and unordered rows, "C3", §5's JSON and
# unordered rows; R40; D47, D49, D54, D56; X20). The driver runs on the TREE's fixture (read-only) and on SHADOW copies of
# the tool under TMPDIR; every perturbation is proven applied before its assertion. The schema family's artifact is the
# driver's JSON view `<log>.json` (D54), passed here by the gate. No instrument. Portable, ~4 s.
# Usage: gates/json_schema.sh        (BBX_CONFIG is the fixture's inside: the command-line profile is in force)
# MUST-FIRE: shadow-tool: schema-before-values — a shadow fakecli.py whose object key `weight` is renamed must FAIL schema naming the frozen key as absent (and FAIL exact at index 2, where the renamed key sorts), one whose `weight` VALUE moves must PASS schema and FAIL exact at index 5, one that adds a key must FAIL schema naming the key as not frozen, and one whose `rank` is a string must FAIL schema naming the type, or the shape is read for its values or the values for their shape (R40, BBX-16)
# MUST-FIRE: perturbed-copy: two-vocabularies — a .schema copy with type `hex` (the TSV vocabulary's, D41) and one with `float` must each read FAIL unknown schema type under format json, and the document-set fixture's TSV schema with type `list` (JSON's) the same under format tsv, or the two formats share a vocabulary they were ruled apart (R40, D49)
# MUST-FIRE: perturbed-copy: unordered-both-ways — a frozen line removed, a line added and a line duplicated in a copy of the unordered inventory must each FAIL naming the row and the direction, a frozen row whose sha1 is not its line's must FAIL as hand-editing, and a run log copy with its last line dropped or a line repeated must FAIL naming the direction, or the inventory is compared one way (BBX-17)
# MUST-FIRE: perturbed-copy: reversed-truth — 01_list's log against a truth copy whose line points are in the reverse order must FAIL exact at index 1, and the same log against the unordered inventory must PASS (the set family cannot see order: the truth kind is where an order error is caught), or an order error hides behind a listing (BBX-15, D50)
# MUST-FIRE: shadow-tool: verdict-text — a shadow copy of compare_schema.py with one verdict string changed must make this gate's frozen-text check FAIL, or the text frozen here is not frozen (C4 with no ancestor: the gate is the freeze)
# NOT-ASSERTED: the suite over the fixture — `NOT-EVALUATED (schema failed)` on the truth row of a scenario whose schema FAILed, and how the suite hands the JSON view to the schema family in place of the subject file: S4 step 4
# NOT-ASSERTED: the TSV format's verdicts beyond its vocabulary: gates/set_schema.sh freezes them; nothing here reads a TSV artifact
# NOT-ASSERTED: anything about a real tool: every input is the fixture's (fixture class) or a perturbed copy of it; a tool whose unordered output repeats a line cannot be frozen (a duplicate frozen row is hand-editing, BBX-17) — a consumer's question; the inside of a nested object is not judged (D49)
#
set -eu
BBX_HOME="$(cd "$(dirname "$0")/.." && pwd)"; export BBX_HOME
PYTHONPATH="$BBX_HOME/lib/py"; export PYTHONPATH
PYTHONDONTWRITEBYTECODE=1; export PYTHONDONTWRITEBYTECODE
unset BBX_CONFIG BBH_CONFIG BBX_MASK_DEFAULT CLI_PATH CLI_NONDET CLI_TIMEOUT CLI_KEEP_ENV FAKECLI_SALT DOCSET_PATH DOCSET_NONDET DOCSET_VIEW DOCSET_FORMS MASK_RANGES DUMPS POKES SNAP_FRAMES VIDEO_OUT INPUT_OUT TAIL_FRAMES INPUT_INJECT_TEST NO_INPUT_CHECK 2>/dev/null || true
F="$BBX_HOME/fixture/fakecli"; E="$F/expected/fixture"; SC="$F/scenarios"; DRV="$BBX_HOME/drivers/cli.sh"; TOOL="$F/subject/fakecli.py"
DS="$BBX_HOME/fixture/docset/expected/fixture/01_all.schema"
BBX_CONFIG="$F/bbx.toml"; export BBX_CONFIG
. "$BBX_HOME/lib/sh/compare.sh"
rc=0
ok()   { printf '  ok    %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1"; rc=1; }
W="$(mktemp -d)"; trap 'rm -rf "$W"' EXIT INT TERM
: > "$W/lines.txt"
try() {
    _w="$1"; _t="$2"; _f="$3"; shift 4
    if "$@" > "$W/out" 2>&1; then _rc=0; else _rc=$?; fi
    got="$(head -1 "$W/out")"; printf '%s\n' "$got" >> "$W/lines.txt"; gotf="$(python3 -m bbx.finding "$got")"
    [ "$_rc" = "$_w" ] && [ "$got" = "$_t" ] && [ "$gotf" = "$_f" ]
}
expect() { _l="$1"; shift; if try "$@"; then ok "$_l — $got"; else fail "$_l: rc=$_rc finding=$gotf got '$got' want '$2' ($3)"; fi; }
drv() { env CLI_PATH="$1" "$DRV" fakecli "$2" "$3" > "$W/drv.txt" 2>&1 || { fail "driver on $2: $(cat "$W/drv.txt")"; return 1; }; }
shadow_tool() { mkdir -p "$W/$1"; sed "$2" "$TOOL" > "$W/$1/fakecli.py"; ! cmp -s "$W/$1/fakecli.py" "$TOOL"; }   # a shadow copy of the tool, true when the edit applied
droptable() { awk -v t="[$2]" '$0 == t {skip=1; next} skip && /^\[/ {skip=0} !skip' "$1"; }
# the set family's two trailing arguments (accepted and not read under the line shape, D56): the scenario file and the subject file
U="$SC/02_unordered.cli"; A="$TOOL"

echo "== 1. the driver on the tree's fixture: the three scenarios these families read =="
for sc in 01_list 02_unordered 03_show_json; do drv "$F/subject" "$SC/$sc.cli" "$W/$sc.log" && ok "$sc: $(tail -1 "$W/$sc.log")"; done
J="$W/03_show_json.log.json"; [ -f "$J" ] && [ "$(head -c 1 "$J")" = "{" ] && ok "03_show_json wrote its JSON view beside the log (D54): $(cat "$J")" || fail "no JSON view for 03_show_json"
[ ! -f "$W/01_list.log.json" ] && ok "01_list wrote no JSON view (stdout was lines)" || fail "01_list has a JSON view"

echo "== 2. every kind of the three scenarios PASSes through the one dispatcher, the family from the kind (R23) =="
expect "03_show_json schema (json)" 0 "PASS schema (json: 5 keys)" pass -- compare_check "$E" 03_show_json schema - "" "$W/03_show_json.log" "$SC/03_show_json.cli" "$J"
expect "03_show_json truth" 0 "PASS exact (6 indices, every token the truth's)" pass -- compare_check "$E" 03_show_json truth - "" "$W/03_show_json.log"
expect "02_unordered unordered (the line shape)" 0 "PASS set-inventory (9 rows, the frozen inventory and the run agree both ways)" pass -- compare_check "$E" 02_unordered unordered - "" "$W/02_unordered.log" "$U" "$A"
expect "02_unordered truth" 0 "PASS exact (10 indices, every token the truth's)" pass -- compare_check "$E" 02_unordered truth - "" "$W/02_unordered.log"
expect "01_list truth (the exit point is index 0 and END counts the points after it — X20)" 0 "PASS exact (10 indices, every token the truth's)" pass -- compare_check "$E" 01_list truth - "" "$W/01_list.log"
for k in truth unordered schema; do f="$(python3 -m bbx.expectations family "$k")"; printf '%s ' "$k=$f"; done > "$W/fam"; [ "$(cat "$W/fam")" = "truth=exact unordered=set schema=schema " ] && ok "the families from the profile's table: $(cat "$W/fam")" || fail "families: $(cat "$W/fam")"
"$BBX_HOME/bin/bbx" compare schema "$E/03_show_json.schema" "$J" > "$W/o" && [ "$(cat "$W/o")" = "PASS schema (json: 5 keys)" ] && ok "bin/bbx compare schema reaches the json format" || fail "bin/bbx compare schema: $(cat "$W/o")"
"$BBX_HOME/bin/bbx" compare set "$E/02_unordered.unordered" "$W/02_unordered.log" "$A" "$U" > "$W/o" && ok "bin/bbx compare set reaches the line shape" || fail "bin/bbx compare set: $(cat "$W/o")"

echo "== 3. what is refused: a format or a spec outside the grammar, an artifact that is not one object, a shape that is mixed, a mode a stream has not =="
cp -R "$F/expected" "$W/x"; X="$W/x/fixture"
sed 's/^format = "json"$/format = "yaml"/' "$E/03_show_json.schema" > "$X/03_show_json.schema"
expect "a schema format outside the two" 1 "FAIL unknown schema format 'yaml'" unknown-class -- compare_check "$X" 03_show_json schema - "" "$W/03_show_json.log" "$SC/03_show_json.cli" "$J"
sed 's/^items_op = ">="$/items_op = "~"/' "$E/03_show_json.schema" > "$X/03_show_json.schema"
expect "an items op outside the vocabulary" 1 "FAIL unknown schema items op '~'" unknown-class -- compare_check "$X" 03_show_json schema - "" "$W/03_show_json.log" "$SC/03_show_json.cli" "$J"
sed 's/^items_n = 1$/items_n = 3/' "$E/03_show_json.schema" > "$X/03_show_json.schema"
expect "a list shorter than frozen" 1 "FAIL schema: key 'tags' has 2 items (frozen >= 3)" diverged -- compare_check "$X" 03_show_json schema - "" "$W/03_show_json.log" "$SC/03_show_json.cli" "$J"
sed 's/^name = "id"$/name = "@@"/; s/^name = "name"$/name = "id"/; s/^name = "@@"$/name = "name"/' "$E/03_show_json.schema" > "$X/03_show_json.schema"   # k1 and k2 swapped (through a placeholder: two plain substitutions cancel)
expect "keys not in sorted order" 1 "FAIL schema: $X/03_show_json.schema is not a schema spec ([k2] 'id' is not after 'name' in sorted order)" diverged -- compare_check "$X" 03_show_json schema - "" "$W/03_show_json.log" "$SC/03_show_json.cli" "$J"
grep -v '^items_' "$E/03_show_json.schema" > "$X/03_show_json.schema"
expect "a list with no items claim" 1 "FAIL schema: $X/03_show_json.schema is not a schema spec ([k4] is a list and lacks items_op or items_n)" diverged -- compare_check "$X" 03_show_json schema - "" "$W/03_show_json.log" "$SC/03_show_json.cli" "$J"
sed 's/^type = "list"$/type = "str"/' "$E/03_show_json.schema" > "$X/03_show_json.schema"
expect "items on a key that is not a list" 1 "FAIL schema: $X/03_show_json.schema is not a schema spec ([k4] carries items_op or items_n but is not a list)" diverged -- compare_check "$X" 03_show_json schema - "" "$W/03_show_json.log" "$SC/03_show_json.cli" "$J"
expect "the subject file handed as the artifact (what the suite passes today: S4 step 4's open point)" 1 "FAIL schema: the artifact is not one JSON object" diverged -- compare_check "$E" 03_show_json schema - "" "$W/03_show_json.log" "$SC/03_show_json.cli" "$A"
expect "an artifact that is not there" 1 "FAIL schema: the artifact $W/nowhere.json cannot be read" diverged -- compare_check "$E" 03_show_json schema - "" "$W/03_show_json.log" "$SC/03_show_json.cli" "$W/nowhere.json"
sed 's/^mode = "inventory"$/mode = "shrink-only"/' "$E/02_unordered.unordered" > "$X/02_unordered.unordered"
expect "a line-shaped set in the shrink-only mode" 1 "FAIL set: $X/02_unordered.unordered is not a set spec (the line shape has no shrink-only mode: a stream is an inventory)" diverged -- compare_check "$X" 02_unordered unordered - "" "$W/02_unordered.log" "$U" "$A"
{ cat "$E/02_unordered.unordered"; printf '\n[c1]\ndocument = "x.md"\nline = 1\nform = "has"\nstatus = "BOUND"\n'; } > "$X/02_unordered.unordered"
expect "a claim row in a file of line rows" 1 "FAIL set: frozen row [c1] is malformed (a claim row in a file of line rows)" diverged -- compare_check "$X" 02_unordered unordered - "" "$W/02_unordered.log" "$U" "$A"
expect "a run log that is not one (a truth spec handed as the log)" 1 "FAIL set: the run rows cannot be derived (the log has no END line last (a crash log is never compared))" diverged -- compare_check "$E" 02_unordered unordered - "" "$E/02_unordered.truth" "$U" "$A"

echo "== 4. must-fire controls, each on a COPY =="
echo "-- schema-before-values --"
if ! shadow_tool ren 's/"weight": r\[2\]/"mass": r[2]/' || ! shadow_tool val 's/"weight": r\[2\]/"weight": r[2] + 1/' \
   || ! shadow_tool add 's/"tags": list(r\[4\])}/"tags": list(r[4]), "zzz": 1}/' || ! shadow_tool typ 's/"rank": r\[3\]/"rank": str(r[3])/'; then fail "CONTROL DEAD: schema-before-values — a shadow edit did not apply"; else
    for s in ren val add typ; do drv "$W/$s" "$SC/03_show_json.cli" "$W/$s.log" || true; done
    a=0; try 1 "FAIL schema: frozen key 'weight' is absent from the object" diverged -- compare_check "$E" 03_show_json schema - "" "$W/ren.log" "$SC/03_show_json.cli" "$W/ren.log.json" && a=1
    b=0; try 1 "FAIL exact: index 2 differs" diverged -- compare_check "$E" 03_show_json truth - "" "$W/ren.log" && b=1
    c=0; try 0 "PASS schema (json: 5 keys)" pass -- compare_check "$E" 03_show_json schema - "" "$W/val.log" "$SC/03_show_json.cli" "$W/val.log.json" && c=1
    d=0; try 1 "FAIL exact: index 5 differs" diverged -- compare_check "$E" 03_show_json truth - "" "$W/val.log" && d=1
    e=0; try 1 "FAIL schema: key 'zzz' is not frozen" diverged -- compare_check "$E" 03_show_json schema - "" "$W/add.log" "$SC/03_show_json.cli" "$W/add.log.json" && e=1
    f=0; try 1 "FAIL schema: key 'rank' = \"6\" is not int" diverged -- compare_check "$E" 03_show_json schema - "" "$W/typ.log" "$SC/03_show_json.cli" "$W/typ.log.json" && f=1
    if [ "$a$b$c$d$e$f" = 111111 ]; then echo "CONTROL FIRED: schema-before-values — weight renamed: schema FAILs naming the frozen key absent and exact FAILs at index 2 (mass sorts second); weight + 1: schema PASSes and exact FAILs at index 5; a key added: schema names it as not frozen; rank as a string: schema names the type"
    else fail "CONTROL DEAD: schema-before-values — rename=$a rename-exact=$b value-schema=$c value-exact=$d added=$e type=$f (last: '$got')"; fi; fi
echo "-- two-vocabularies --"
sed 's/^type = "int"$/type = "hex"/' "$E/03_show_json.schema" > "$W/hex.schema"; sed 's/^type = "int"$/type = "float"/' "$E/03_show_json.schema" > "$W/float.schema"
sed 's/^type = "hex"$/type = "list"/' "$DS" > "$W/tsvlist.schema"
if ! grep -q '"hex"' "$W/hex.schema" || ! grep -q '"float"' "$W/float.schema" || ! grep -q '"list"' "$W/tsvlist.schema" || ! grep -q '^format = "tsv"$' "$W/tsvlist.schema"; then fail "CONTROL DEAD: two-vocabularies — a perturbation did not apply"; else
    a=0; try 1 "FAIL unknown schema type 'hex'" unknown-class -- python3 -m bbx.compare_schema "$W/hex.schema" "$J" && a=1
    b=0; try 1 "FAIL unknown schema type 'float'" unknown-class -- python3 -m bbx.compare_schema "$W/float.schema" "$J" && b=1
    c=0; try 1 "FAIL unknown schema type 'list'" unknown-class -- python3 -m bbx.compare_schema "$W/tsvlist.schema" "$BBX_HOME/fixture/docset/subject/records.tsv" && c=1
    if [ "$a$b$c" = 111 ]; then echo "CONTROL FIRED: two-vocabularies — hex (the TSV vocabulary's) and float are unknown types under json; list (JSON's) is an unknown type under tsv: two formats, two vocabularies, one comparator (R40)"
    else fail "CONTROL DEAD: two-vocabularies — hex=$a float=$b tsv-list=$c (last: '$got')"; fi; fi
echo "-- unordered-both-ways --"
cp -R "$F/expected" "$W/i"; I="$W/i/fixture"; L2="$W/02_unordered.log"
droptable "$E/02_unordered.unordered" l5 > "$I/02_unordered.unordered"
if grep -q '^\[l5\]' "$I/02_unordered.unordered" || [ "$(grep -c '^\[l' "$I/02_unordered.unordered")" != 8 ]; then fail "CONTROL DEAD: unordered-both-ways — the row was not removed"; else
    a=0; try 1 "FAIL set-inventory: 1 run row(s) not frozen (first sha1 b447285ad32e4dd9ecce0707941a93aec477a57d)" diverged -- compare_check "$I" 02_unordered unordered - "" "$L2" "$U" "$A" && a=1
    { cat "$E/02_unordered.unordered"; printf '\n[l10]\nline = "10 Zorak 0000 1"\nsha1 = "%s"\n' "$(python3 -c 'import hashlib; print(hashlib.sha1(b"10 Zorak 0000 1").hexdigest())')"; } > "$I/02_unordered.unordered"
    b=0; try 1 'FAIL set-inventory: 1 frozen row(s) not in the run (first "10 Zorak 0000 1")' diverged -- compare_check "$I" 02_unordered unordered - "" "$L2" "$U" "$A" && b=1
    { cat "$E/02_unordered.unordered"; printf '\n[l10]\nline = "1 Rosalind 3F60 48"\nsha1 = "b447285ad32e4dd9ecce0707941a93aec477a57d"\n'; } > "$I/02_unordered.unordered"
    c=0; try 1 'FAIL set-inventory: frozen row "1 Rosalind 3F60 48" appears 2 times (a duplicate is hand-editing, BBX-17)' diverged -- compare_check "$I" 02_unordered unordered - "" "$L2" "$U" "$A" && c=1
    sed 's/^line = "6 Maren 4D2B 83"$/line = "6 Maren 4D2B 84"/' "$E/02_unordered.unordered" > "$I/02_unordered.unordered"; grep -q '4D2B 84' "$I/02_unordered.unordered" || fail "the hand edit did not apply"
    d=0; try 1 "FAIL set: frozen row [l1] is malformed (sha1 is not the line's: hand-editing, BBX-17)" diverged -- compare_check "$I" 02_unordered unordered - "" "$L2" "$U" "$A" && d=1
    { grep -v '^END' "$L2" | grep -v '^9 '; echo "END 8"; } > "$W/u8.log"
    e=0; try 1 'FAIL set-inventory: 1 frozen row(s) not in the run (first "5 Vesna 5A7D 82")' diverged -- compare_check "$E" 02_unordered unordered - "" "$W/u8.log" "$U" "$A" && e=1
    { grep -v '^END' "$L2"; echo "10 $(awk '$1 == 4 {print $2}' "$L2")"; echo "END 10"; } > "$W/u10.log"
    f=0; try 1 'FAIL set-inventory: 1 run row(s) not frozen (first "4 Quillon 9A35 17")' diverged -- compare_check "$E" 02_unordered unordered - "" "$W/u10.log" "$U" "$A" && f=1
    if [ "$a$b$c$d$e$f" = 111111 ]; then echo "CONTROL FIRED: unordered-both-ways — a frozen row removed names the run's row by its sha1 (the log holds hashes); a frozen row added names it by its text; a duplicated frozen row is hand-editing; a frozen row whose sha1 is not its line's is hand-editing; a run with its last line dropped names the lost frozen row (Vesna); a run with a line repeated names the one surplus row (Quillon)"
    else fail "CONTROL DEAD: unordered-both-ways — removed=$a added=$b duplicate=$c hand-sha1=$d run-lost=$e run-dup=$f (last: '$got')"; fi; fi
echo "-- reversed-truth --"
cp -R "$F/expected" "$W/v"; V="$W/v/fixture"; T="$E/logs/01_list.log"
{ head -1 "$T"; grep '^[1-9] ' "$T" | awk '{t[NR] = $2} END {for (i = NR; i >= 1; i--) print (NR - i + 1) " " t[i]}'; tail -1 "$T"; } > "$V/logs/01_list.log"
if cmp -s "$V/logs/01_list.log" "$T" || [ "$(awk '$1 == 1 {print $2}' "$V/logs/01_list.log")" != "$(awk '$1 == 9 {print $2}' "$T")" ]; then fail "CONTROL DEAD: reversed-truth — the truth copy was not reversed"; else
    a=0; try 1 "FAIL exact: index 1 differs" diverged -- compare_check "$V" 01_list truth - "" "$W/01_list.log" && a=1
    b=0; try 0 "PASS set-inventory (9 rows, the frozen inventory and the run agree both ways)" pass -- compare_check "$E" 02_unordered unordered - "" "$W/01_list.log" "$U" "$A" && b=1
    c=0; try 1 "FAIL exact: index 1 differs" diverged -- compare_check "$E" 02_unordered truth - "" "$W/01_list.log" && c=1
    if [ "$a$b$c" = 111 ]; then echo "CONTROL FIRED: reversed-truth — the ordered listing against its truth reversed FAILs exact at index 1; the same log PASSes the unordered inventory (the set family cannot see order) and FAILs the unordered scenario's truth at index 1 (the rank order is neither the name order nor its reverse, D50: the two listings differ in order alone, and only the exact family sees it)"
    else fail "CONTROL DEAD: reversed-truth — reversed=$a inventory=$b other-truth=$c (last: '$got')"; fi; fi
echo "-- verdict-text --"
SH="$W/shadow"; mkdir -p "$SH/lib/py" "$SH/lib/sh"; cp -R "$BBX_HOME/lib/py/bbx" "$SH/lib/py/bbx"; cp "$BBX_HOME/lib/sh/compare.sh" "$SH/lib/sh/compare.sh"
sed -i.bak 's/PASS schema (json: /PASS schema [json: /' "$SH/lib/py/bbx/compare_schema.py"
if ! grep -q 'PASS schema \[json: ' "$SH/lib/py/bbx/compare_schema.py"; then fail "CONTROL DEAD: verdict-text — the shadow was not perturbed (sed matched nothing)"; else
    o="$(env BBX_HOME="$SH" PYTHONPATH="$SH/lib/py" sh -c '. "$BBX_HOME/lib/sh/compare.sh"; compare_check "$@"' _ "$E" 03_show_json schema - "" "$W/03_show_json.log" "$SC/03_show_json.cli" "$J" 2>&1)" && s=0 || s=$?
    if [ "$s" = 0 ] && [ "$o" != "PASS schema (json: 5 keys)" ] && [ "$o" = "PASS schema [json: 5 keys)" ]; then
        echo "CONTROL FIRED: verdict-text — the shadow's changed string is exactly what the frozen-text check refuses: '$o' is not the frozen line"
    else fail "CONTROL DEAD: verdict-text — exit $s: '$o'"; fi; fi

echo "== 5. every verdict line this gate saw is classified (finding.py never reads unclassified) =="
sort -u "$W/lines.txt" > "$W/uniq.txt"; n=0; bad=0
while IFS= read -r line; do n=$((n + 1)); [ "$(python3 -m bbx.finding "$line")" = unclassified ] && { bad=1; fail "unclassified: $line"; }; done < "$W/uniq.txt"
[ "$bad" = 0 ] && ok "$n distinct verdict lines, every one classified" || true
echo "NOTE: verdict-lines-frozen $n"

echo
if [ "$rc" = 0 ]; then echo "PASS: the json schema format and the line-shaped inventory hold both ways on the fixture, the exact family reads a command-line log by index, the verdict text is frozen and classified, and the dispatcher reaches each family from its kind; 5 controls fired"; else echo "FAIL: see above"; fi
exit "$rc"
