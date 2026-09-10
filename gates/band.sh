#!/bin/sh
# band.sh — the tolerant-numeric family holds both ways on the command-line fixture: a band field's value inside its measured band PASSes with the inventory as a NOTE, a value outside FAILs naming the field, the value and the band, the band inventory is compared both ways before any value, --freeze refuses to widen a band with no ruling id and leaves the file unchanged while a narrowing and a ruled widening are written; every verdict line is frozen here and classified by finding.py, and the one dispatcher reaches the family from its kind
# Ground truth for lib/py/bbx/compare_band.py and the tolerant-numeric branch of lib/sh/compare.sh (docs/plans/S4.md §3 "E1"
# band row, "C1, C2", §5's ruling-less-class row; R36; D48, D53, D55). The driver runs on the TREE's fixture (read-only)
# for the band view; every perturbation is a COPY under TMPDIR, proven applied before its assertion. The band value the
# view holds (size(4) of the design) is re-derived here from the design's function, never read off the view it judges.
# No instrument. Portable, ~3 s.
# Usage: gates/band.sh        (BBX_CONFIG is the fixture's inside: the command-line profile is in force)
# MUST-FIRE: known-bad: ruling-less-class — a .band copy WIDER than the frozen one, re-frozen with --freeze and no rulings entry for the field, must be REFUSED with exit 3 and the file unchanged (cmp), while the same copy with `rulings = { size = "R36" }` and a NARROWER copy with no ruling must each be written and a copy that adds a field refused, or a band can be loosened without a ruling (R36, BBX-13)
# MUST-FIRE: perturbed-copy: outside-the-band — a band view copy one below the min and one above the max must each FAIL naming the field, the value and the band, while the min and the max themselves PASS, or the band is open on a side or closed on the wrong one
# MUST-FIRE: perturbed-copy: inventory-both-ways — a band view copy carrying a field not frozen and a .band copy freezing a field the view lacks must each FAIL naming the field before any value is judged, or a band nobody froze is judged as if it were (BBX-13)
# MUST-FIRE: shadow-tool: verdict-text — a shadow copy of compare_band.py with one verdict string changed must make this gate's frozen-text check FAIL, or the text frozen here is not frozen (C4 with no ancestor: the gate is the freeze)
# NOT-ASSERTED: the suite's loop over the band kind, `NOTE: band-fields` on the readout's screen and --freeze under the suite: S4 step 4
# NOT-ASSERTED: that a rulings entry names a ruling that exists, or that the ruling names a mechanism: any non-empty id is accepted here (the thresholds gate's rule, R25; docs/plans/S4.md §9)
# NOT-ASSERTED: anything about a real tool: every input is the fixture's (fixture class) or a perturbed copy of it; a fractional band or a band field that is not an integer by design is a consumer's question (D48)
#
set -eu
BBX_HOME="$(cd "$(dirname "$0")/.." && pwd)"; export BBX_HOME
PYTHONPATH="$BBX_HOME/lib/py"; export PYTHONPATH
PYTHONDONTWRITEBYTECODE=1; export PYTHONDONTWRITEBYTECODE
unset BBX_CONFIG BBH_CONFIG BBX_MASK_DEFAULT CLI_PATH CLI_NONDET CLI_TIMEOUT CLI_KEEP_ENV FAKECLI_SALT DOCSET_PATH DOCSET_NONDET DOCSET_VIEW DOCSET_FORMS MASK_RANGES DUMPS POKES SNAP_FRAMES VIDEO_OUT INPUT_OUT TAIL_FRAMES INPUT_INJECT_TEST NO_INPUT_CHECK 2>/dev/null || true
F="$BBX_HOME/fixture/fakecli"; E="$F/expected/fixture"; SC="$F/scenarios"; DRV="$BBX_HOME/drivers/cli.sh"
BBX_CONFIG="$F/bbx.toml"; export BBX_CONFIG
. "$BBX_HOME/lib/sh/compare.sh"
rc=0
ok()   { printf '  ok    %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1"; rc=1; }
W="$(mktemp -d)"; trap 'rm -rf "$W"' EXIT INT TERM
: > "$W/lines.txt"; : > "$W/tool.txt"
# try <want-rc> <want-first-line> <want-finding> -- <command...>   sets got / gotf; true when all three match
try() {
    _w="$1"; _t="$2"; _f="$3"; shift 4
    if "$@" > "$W/out" 2>&1; then _rc=0; else _rc=$?; fi
    got="$(head -1 "$W/out")"; printf '%s\n' "$got" >> "$W/lines.txt"; gotf="$(python3 -m bbx.finding "$got")"
    [ "$_rc" = "$_w" ] && [ "$got" = "$_t" ] && [ "$gotf" = "$_f" ]
}
expect() { _l="$1"; shift; if try "$@"; then ok "$_l — $got"; else fail "$_l: rc=$_rc finding=$gotf got '$got' want '$2' ($3)"; fi; }
# tool <want-rc> <want-first-line> -- <command...>   the freeze's lines: frozen text, not a pairing's verdict — never classified
tool() { _w="$1"; _t="$2"; shift 3; if "$@" > "$W/out" 2>&1; then _rc=0; else _rc=$?; fi; got="$(head -1 "$W/out")"; printf '%s\n' "$got" >> "$W/tool.txt"; [ "$_rc" = "$_w" ] && [ "$got" = "$_t" ]; }
drv() { env CLI_PATH="$1" "$DRV" fakecli "$2" "$3" > "$W/drv.txt" 2>&1 || { fail "driver on $2: $(cat "$W/drv.txt")"; return 1; }; }
view() { cp "$L" "$2.log"; printf '1 size=%s\nEND 1\n' "$1" > "$2.log.bands"; }   # a log copy whose band view holds one value (D53)
freeze() { python3 -m bbx.compare_band --freeze "$@"; }

echo "== 1. the driver on the tree's fixture: 04_band, once =="
drv "$F/subject" "$SC/04_band.cli" "$W/04_band.log" && ok "04_band: $(tail -1 "$W/04_band.log"); the view: $(head -1 "$W/04_band.log.bands")"
L="$W/04_band.log"; V="$L.bands"
want="$(python3 -c 'print(231 + (4 * 29) % 41)')"    # size(4) of the design (mkfakecli.py BAND_BASE, BAND_MUL, BAND_MOD), re-derived
[ "$(head -1 "$V")" = "1 size=$want" ] && [ "$(tail -1 "$V")" = "END 1" ] && ok "the view holds the design's size(4) = $want and END 1" || fail "the view: $(cat "$V" | tr '\n' ' ') (design $want)"
[ "$(awk '$1 == 2 {print $2}' "$L")" = "field:size:band" ] && ok "index 2 of the log is the constant field:size:band — the value lives in the view only (BBX-16)" || fail "index 2: $(awk '$1 == 2 {print $2}' "$L")"

echo "== 2. the pairing PASSes through the one dispatcher, the family from the kind (R23), with the NOTE =="
expect "04_band band" 0 "PASS band (1 field(s), every value inside its band)" pass -- compare_check "$E" 04_band band - "" "$L"
[ "$(sed -n 2p "$W/out")" = "NOTE: band-fields 1" ] && ok "NOTE: band-fields 1 follows the PASS (BBX-13's inventory watch, for the screen)" || fail "the NOTE line: '$(sed -n 2p "$W/out")'"
expect "04_band truth (the band token is the constant, so the exact family never moves with the value)" 0 "PASS exact (3 indices, every token the truth's)" pass -- compare_check "$E" 04_band truth - "" "$L"
f="$(python3 -m bbx.expectations family band)"; [ "$f" = tolerant-numeric ] && ok "the family from the profile's table: band=$f" || fail "band's family: $f"
"$BBX_HOME/bin/bbx" compare band "$E/04_band.band" "$V" > "$W/o" && [ "$(head -1 "$W/o")" = "PASS band (1 field(s), every value inside its band)" ] && ok "bin/bbx compare band reaches the tool" || fail "bin/bbx compare band: $(cat "$W/o")"
view "$want" "$W/same"; expect "the same value through a view copy" 0 "PASS band (1 field(s), every value inside its band)" pass -- compare_check "$E" 04_band band - "" "$W/same.log"

echo "== 3. what is refused: a class outside the family, a spec that is not a band, a view that is not there or not the grammar =="
cp -R "$F/expected" "$W/x"; X="$W/x/fixture"
sed 's/^class = "band"$/class = "sortof"/' "$E/04_band.band" > "$X/04_band.band"; grep -q sortof "$X/04_band.band" || fail "the class perturbation did not apply"
expect "a band spec whose class is not band" 1 "FAIL unknown tolerant-numeric class 'sortof'" unknown-class -- compare_check "$X" 04_band band - "" "$L"
o="$(env -u BBX_CONFIG sh -c '. "$BBX_HOME/lib/sh/compare.sh"; compare_check "$1" 04_band band - "" "$2"' _ "$E" "$L" 2>&1)" && fail "a .band under the frame-driven profile compared" || { [ "$o" = "FAIL kind 'band' has no comparator family in the kind profile in force (R23: a kind is registered in the profile's table or not at all)" ] && ok "a .band under the frame-driven profile (BBX_CONFIG unset) has no family" || fail "band under frame-driven: '$o'"; }
expect "an expectation file that is not there" 1 "FAIL band: $X/09_none.band is not a band spec (no such file)" diverged -- compare_check "$X" 09_none band - "" "$L"
drv "$F/subject" "$SC/01_list.cli" "$W/01_list.log"; [ ! -f "$W/01_list.log.bands" ] || fail "01_list has a band view"
expect "a log with no band view (01_list declares no bands)" 1 "FAIL band: the band view $W/01_list.log.bands cannot be read (No such file or directory: no band field was observed — the scenario declares no bands, or stdout was not one JSON object)" diverged -- compare_check "$E" 04_band band - "" "$W/01_list.log"
grep -v '^measured' "$E/04_band.band" > "$X/04_band.band"
expect "a band with no measured statement" 1 "FAIL band: $X/04_band.band is not a band spec ([spec] lacks measured: a band with no measurement is a knob (R36))" diverged -- compare_check "$X" 04_band band - "" "$L"
sed 's/^min = 236$/min = 271/' "$E/04_band.band" > "$X/04_band.band"
expect "a band whose min is above its max" 1 "FAIL band: $X/04_band.band is not a band spec ([b1] min 271 is above max 270)" diverged -- compare_check "$X" 04_band band - "" "$L"
sed 's/^max = 270$/max = 270.5/' "$E/04_band.band" > "$X/04_band.band"
expect "a fractional band (the subset refuses the float, D48)" 1 "FAIL band: $X/04_band.band is not a band spec (line 9: unsupported value syntax: '270.5')" diverged -- compare_check "$X" 04_band band - "" "$L"
sed 's/^measured = \(.*\)$/measured = \1\nrulings = { seed = "R36" }/' "$E/04_band.band" > "$X/04_band.band"
expect "a rulings entry for a field no table freezes" 1 "FAIL band: $X/04_band.band is not a band spec ([spec].rulings names 'seed', which no [b<i>] table freezes)" diverged -- compare_check "$X" 04_band band - "" "$L"
view '265.5' "$W/v1"; expect "a view value that is not an integer" 1 "FAIL band size: 265.5 is not an integer (the band is [236, 270])" diverged -- compare_check "$E" 04_band band - "" "$W/v1.log"
view '"265"' "$W/v2"; expect "a view value that is a string" 1 'FAIL band size: "265" is not an integer (the band is [236, 270])' diverged -- compare_check "$E" 04_band band - "" "$W/v2.log"
cp "$L" "$W/v3.log"; printf '1 size=265\nEND 2\n' > "$W/v3.log.bands"
expect "a view whose END disagrees" 1 "FAIL band: the band view $W/v3.log.bands is malformed (END 2 but 1 rows)" diverged -- compare_check "$E" 04_band band - "" "$W/v3.log"
cp "$L" "$W/v4.log"; printf '1 size=265\n' > "$W/v4.log.bands"
expect "a view with no END" 1 "FAIL band: the band view $W/v4.log.bands is malformed (no END line last)" diverged -- compare_check "$E" 04_band band - "" "$W/v4.log"
cp "$L" "$W/v5.log"; printf '1 size=265\n1 size=265\nEND 2\n' > "$W/v5.log.bands"
expect "a view whose indices do not run 1..k" 1 "FAIL band: the band view $W/v5.log.bands is malformed (line 2 is not \`2 <name>=<value>\`)" diverged -- compare_check "$E" 04_band band - "" "$W/v5.log"

echo "== 4. must-fire controls, each on a COPY =="
echo "-- outside-the-band --"
lo="$(sed -n 's/^min = //p' "$E/04_band.band")"; hi="$(sed -n 's/^max = //p' "$E/04_band.band")"
if [ "$lo" != 236 ] || [ "$hi" != 270 ]; then fail "CONTROL DEAD: outside-the-band — the frozen band is [$lo, $hi], not the design's [236, 270]"; else
    view "$((lo - 1))" "$W/below"; a=0; try 1 "FAIL band size: 235 outside [236, 270]" diverged -- compare_check "$E" 04_band band - "" "$W/below.log" && a=1
    view "$((hi + 1))" "$W/above"; b=0; try 1 "FAIL band size: 271 outside [236, 270]" diverged -- compare_check "$E" 04_band band - "" "$W/above.log" && b=1
    view "$lo" "$W/atlo"; c=0; try 0 "PASS band (1 field(s), every value inside its band)" pass -- compare_check "$E" 04_band band - "" "$W/atlo.log" && c=1
    view "$hi" "$W/athi"; d=0; try 0 "PASS band (1 field(s), every value inside its band)" pass -- compare_check "$E" 04_band band - "" "$W/athi.log" && d=1
    if [ "$a$b$c$d" = 1111 ]; then echo "CONTROL FIRED: outside-the-band — 235 and 271 each FAIL naming size, the value and [236, 270]; 236 and 270 themselves PASS (inclusive both sides)"
    else fail "CONTROL DEAD: outside-the-band — below=$a above=$b at-min=$c at-max=$d (last: '$got')"; fi; fi
echo "-- inventory-both-ways --"
cp "$L" "$W/vi.log"; printf '1 seed=4\n2 size=%s\nEND 2\n' "$want" > "$W/vi.log.bands"
cp -R "$F/expected" "$W/i"; I="$W/i/fixture"; printf '\n[b2]\nfield = "seed"\nmin = 1\nmax = 9\n' >> "$I/04_band.band"
if ! grep -q '^1 seed=4$' "$W/vi.log.bands" || ! grep -q '^\[b2\]$' "$I/04_band.band"; then fail "CONTROL DEAD: inventory-both-ways — a perturbation did not apply"; else
    a=0; try 1 "FAIL band: view field 'seed' is not frozen (a band nobody froze, BBX-13)" diverged -- compare_check "$E" 04_band band - "" "$W/vi.log" && a=1
    b=0; try 1 "FAIL band: frozen field 'seed' is not in the band view" diverged -- compare_check "$I" 04_band band - "" "$L" && b=1
    c=0; try 0 "PASS band (2 field(s), every value inside its band)" pass -- compare_check "$I" 04_band band - "" "$W/vi.log" && [ "$(sed -n 2p "$W/out")" = "NOTE: band-fields 2" ] && c=1
    if [ "$a$b$c" = 111 ]; then echo "CONTROL FIRED: inventory-both-ways — a view field nobody froze (seed) FAILs naming it; a frozen field the view lacks (seed) FAILs naming it; the two together PASS with NOTE: band-fields 2 (the inventory grew, and the screen says so)"
    else fail "CONTROL DEAD: inventory-both-ways — view-not-frozen=$a frozen-not-in-view=$b both=$c (last: '$got')"; fi; fi
echo "-- ruling-less-class --"
R="$W/r"; mkdir -p "$R"; cp "$E/04_band.band" "$R/04_band.band"                          # the slot the freeze writes: a copy, never the tree
sed 's/^max = 270$/max = 275/' "$E/04_band.band" > "$W/wider.band"
sed 's/^max = 270$/max = 275/; s/^measured = \(.*\)$/measured = \1\nrulings = { size = "R36" }/' "$E/04_band.band" > "$W/ruled.band"
sed 's/^min = 236$/min = 240/' "$E/04_band.band" > "$W/narrower.band"
{ cat "$E/04_band.band"; printf '\n[b2]\nfield = "seed"\nmin = 1\nmax = 9\n'; } > "$W/plus.band"
if cmp -s "$W/wider.band" "$E/04_band.band" || ! grep -q '^rulings = { size = "R36" }$' "$W/ruled.band" || ! grep -q '^min = 240$' "$W/narrower.band"; then fail "CONTROL DEAD: ruling-less-class — a perturbation did not apply"; else
    view 273 "$W/v273"; view 238 "$W/v238"
    a=0; try 1 "FAIL band size: 273 outside [236, 270]" diverged -- compare_check "$R" 04_band band - "" "$W/v273.log" && a=1
    b=0; tool 3 "REFUSED: band size widens [236, 270] -> [236, 275] with no rulings entry for it (R36: a band is loosened only with a measured mechanism named and a ruling)" -- freeze "$R/04_band.band" "$W/wider.band" && cmp -s "$R/04_band.band" "$E/04_band.band" && b=1
    c=0; tool 0 "frozen band (1 field(s); 0 narrowed, 1 widened under R36)" -- freeze "$R/04_band.band" "$W/ruled.band" && grep -q '^max = 275$' "$R/04_band.band" && grep -q '^rulings = { size = "R36" }$' "$R/04_band.band" && c=1
    d=0; try 0 "PASS band (1 field(s), every value inside its band)" pass -- compare_check "$R" 04_band band - "" "$W/v273.log" && d=1
    e=0; tool 0 "frozen band (1 field(s); 1 narrowed, 0 widened)" -- freeze "$R/04_band.band" "$W/narrower.band" && grep -q '^min = 240$' "$R/04_band.band" && grep -q '^max = 270$' "$R/04_band.band" && ! grep -q rulings "$R/04_band.band" && e=1
    f=0; try 1 "FAIL band size: 238 outside [240, 270]" diverged -- compare_check "$R" 04_band band - "" "$W/v238.log" && f=1
    cp "$R/04_band.band" "$W/before_plus.band"
    g=0; tool 3 "REFUSED: band inventory moves (proposed but not frozen: seed) — the inventory is BBX-13's watch and never moves through a freeze" -- freeze "$R/04_band.band" "$W/plus.band" && cmp -s "$R/04_band.band" "$W/before_plus.band" && g=1
    cp "$E/04_band.band" "$R/04_band.band"
    h=0; tool 0 "frozen band (1 field(s); 0 narrowed, 0 widened)" -- freeze "$R/04_band.band" "$E/04_band.band" && cmp -s "$R/04_band.band" "$E/04_band.band" && h=1
    if [ "$a$b$c$d$e$f$g$h" = 11111111 ]; then echo "CONTROL FIRED: ruling-less-class — 273 FAILs against [236, 270]; a copy widened to 275 with no rulings entry is REFUSED, exit 3, the file unchanged (cmp); with rulings = { size = \"R36\" } it is written (max 275, the entry kept) and 273 now PASSes; a narrower copy [240, 270] is written with no ruling and 238 now FAILs against it; a copy adding a field is REFUSED unchanged; the generator's own file re-frozen over itself is byte-identical"
    else fail "CONTROL DEAD: ruling-less-class — before=$a refused=$b ruled=$c after=$d narrowed=$e narrow-fails=$f inventory=$g identity=$h (last: '$got')"; fi; fi
echo "-- verdict-text --"
SH="$W/shadow"; mkdir -p "$SH/lib/py" "$SH/lib/sh"; cp -R "$BBX_HOME/lib/py/bbx" "$SH/lib/py/bbx"; cp "$BBX_HOME/lib/sh/compare.sh" "$SH/lib/sh/compare.sh"
sed -i.bak 's/PASS band (/PASS band [/' "$SH/lib/py/bbx/compare_band.py"
if ! grep -q 'PASS band \[' "$SH/lib/py/bbx/compare_band.py"; then fail "CONTROL DEAD: verdict-text — the shadow was not perturbed (sed matched nothing)"; else
    o="$(env BBX_HOME="$SH" PYTHONPATH="$SH/lib/py" sh -c '. "$BBX_HOME/lib/sh/compare.sh"; compare_check "$@"' _ "$E" 04_band band - "" "$L" 2>&1 | head -1)" && s=0 || s=$?
    if [ "$s" = 0 ] && [ "$o" != "PASS band (1 field(s), every value inside its band)" ] && [ "$o" = "PASS band [1 field(s), every value inside its band)" ]; then
        echo "CONTROL FIRED: verdict-text — the shadow's changed string is exactly what the frozen-text check refuses: '$o' is not the frozen line"
    else fail "CONTROL DEAD: verdict-text — exit $s: '$o'"; fi; fi

echo "== 5. every verdict line this gate saw is classified (finding.py never reads unclassified); the freeze's lines are frozen, not classified =="
sort -u "$W/lines.txt" > "$W/uniq.txt"; n=0; bad=0
while IFS= read -r line; do n=$((n + 1)); [ "$(python3 -m bbx.finding "$line")" = unclassified ] && { bad=1; fail "unclassified: $line"; }; done < "$W/uniq.txt"
[ "$bad" = 0 ] && ok "$n distinct verdict lines, every one classified" || true
m="$(sort -u "$W/tool.txt" | wc -l | tr -d ' ')"; ok "$m distinct --freeze lines frozen above (a tool's answer, never a pairing's verdict)"
echo "NOTE: verdict-lines-frozen $n"

echo
if [ "$rc" = 0 ]; then echo "PASS: the tolerant-numeric family holds both ways on the fixture, its inventory both ways, --freeze refuses to widen without a ruling and writes a narrowing, the verdict text is frozen and classified, and the dispatcher reaches the family from its kind; 4 controls fired"; else echo "FAIL: see above"; fi
exit "$rc"
