#!/bin/sh
# gate_index.sh — docs/gates.md is the current generated index of BBX's gates, and the lifted generator fails where it must: a stale index, a CRLF copy, a gate with no family, a dead or doubled family row, and columns only where the config names them
# Ruled R63 and R68 (S6 step 3, K7). `bbx gate-index` (lib/py/bbx/gen_gate_index.py, lifted from bbh at 10a82d2;
# D84, D85, D86) renders one row per gate from its own header, the family register gates/families.toml and the
# registries. The positive is BBX's own committed index. The controls run on a synthetic consumer under TMPDIR
# whose index is written and read clean before any control (G53); each control changes one thing in a copy of it
# and requires its own finding and nothing else. F19a diffs the generator's text against bbh's.
# Usage: gates/gate_index.sh        Portable, ~1 s (1 s on its first run, bbx-30).
# MUST-FIRE: perturbed-copy: stale-index — a gate's line 2 changed after the index was written must make --check read STALE with the changed row in its diff, exit 1
# MUST-FIRE: perturbed-copy: crlf-index — the written index rewritten with CRLF line endings must make --check read STALE, exit 1, where bbh's text comparison reads it current (R63's bytes delta)
# MUST-FIRE: perturbed-copy: family-toml-row-missing — a gate whose table is taken out of a TOML family register must read PROBLEM NO FAMILY ROW naming it and no other problem, exit 1 (R68)
# MUST-FIRE: perturbed-copy: family-toml-dead-row — a TOML table naming a gate that is not on disk must read PROBLEM DEAD ROW naming it and no other problem, exit 1 (R68)
# MUST-FIRE: perturbed-copy: family-toml-duplicate — a gate named by a second TOML table must read PROBLEM DUPLICATE ROW naming it and no other problem, exit 1 (BBX-17)
# MUST-FIRE: known-bad: columns-by-config — a config naming controls and blind spots must render both columns with each synthetic header's own counts, and the same consumer naming none must render bbh's five columns only (R68)
# NOT-ASSERTED: that a gate's family is the right one: the register is written by hand, and only its completeness both ways is read
# NOT-ASSERTED: that a header's first paragraph says anything true: the index quotes it, cut near 240 characters
# NOT-ASSERTED: the generator's text against bbh's over the same inputs: gates/fidelity_bbh_s6.sh diffs it (F19a)
# NOT-ASSERTED: that the TOML family register or the two further columns are generic: each has one consumer, BBX's own gates (R50)
#
set -eu
BBX_HOME="$(cd "$(dirname "$0")/.." && pwd)"; export BBX_HOME
PYTHONPATH="$BBX_HOME/lib/py"; export PYTHONPATH
unset BBX_CONFIG 2>/dev/null || true
rc=0
ok()   { printf '  ok    %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1"; rc=1; }
T="$(mktemp -d)"; trap 'rm -rf "$T"' EXIT INT TERM
gi() { python3 -m bbx.gen_gate_index "$@" > "$T/out" 2>&1 && s=0 || s=$?; }
problems() { grep -c '^PROBLEM ' "$T/out" || true; }

echo "== 1. BBX's own index is current =="
gi --config "$BBX_HOME/bbx.toml" --check
if [ "$s" = 0 ] && grep -q '^ok    docs/gates.md is current (' "$T/out"; then ok "bbx gate-index --check exits 0: $(sed 's/^ok *//' "$T/out")"
else fail "docs/gates.md: exit $s; $(tr '\n' '|' < "$T/out" | cut -c1-600)"; fi
_rows="$(grep -c '^| `gates/' "$BBX_HOME/docs/gates.md" || true)"
_disk="$(ls "$BBX_HOME"/gates/*.sh | wc -l | tr -d ' ')"
echo "NOTE: gate-index rows=$_rows gates-on-disk=$_disk"
if [ "$_rows" = "$_disk" ]; then ok "one row per gate on disk ($_disk)"; else fail "the index has $_rows rows for $_disk gates on disk"; fi

echo "== 2. a synthetic consumer with a TOML family register, written and read clean =="
C="$T/c"; mkdir -p "$C/tests" "$C/docs"
cat > "$C/bbx.toml" <<'EOF'
[project]
root = "."
kind = "self"
gates_dir = "tests"
instrument_word = "instrument"
[registries]
portable = "tests/portable.txt"
static = "tests/static.txt"
static_needs_env = "INPUTS"
[gate_header]
index_out = "docs/gates.md"
families_tsv = "tests/families.toml"
families = [["alpha", "the first family"], ["beta", "the second family"]]
index_preamble = ["# Index", ""]
EOF
printf '#!/bin/sh\n# g_one.sh — the first synthetic gate locks one law (bbx-1).\n# MUST-FIRE: known-bad: one-a — a\n# MUST-FIRE: known-bad: one-b — b\n# MUST-FIRE: perturbed-copy: one-c — c\n# NOT-ASSERTED: x\n# NOT-ASSERTED: y\n# NOT-ASSERTED: z\n#\necho PASS\n' > "$C/tests/g_one.sh"
printf '#!/bin/sh\n# g_two.sh — the second synthetic gate asserts nothing (bbx-2).\n# MUST-FIRE: none — it is a stub\n#\necho PASS\n' > "$C/tests/g_two.sh"
printf 'g_one\n' > "$C/tests/portable.txt"; printf 'g_two\n' > "$C/tests/static.txt"
printf '[f1]\ngate = "tests/g_one.sh"\nfamily = "alpha"\n\n[f2]\ngate = "tests/g_two.sh"\nfamily = "beta"\n' > "$C/tests/families.toml"
gi --config "$C/bbx.toml"; _w="$s $(cat "$T/out")"
gi --config "$C/bbx.toml" --check
if [ "$s" = 0 ] && [ "$(problems)" = 0 ] && grep -q '^ok    docs/gates.md is current (2 scripts, every one with a family)$' "$T/out"; then ok "written ($_w) and read clean: $(cat "$T/out")"
else fail "the synthetic consumer is not clean, so no control below can be read: exit $s; $(tr '\n' '|' < "$T/out")"; fi
copy() { rm -rf "$T/x"; cp -R "$C" "$T/x"; }
cp -R "$C" "$T/tsv"; printf 'tests/g_one.sh\talpha\ntests/g_two.sh\tbeta\n' > "$T/tsv/tests/families.tsv"
sed 's#tests/families.toml#tests/families.tsv#' "$C/bbx.toml" > "$T/tsv/bbx.toml"
gi --config "$T/tsv/bbx.toml" --check
if [ "$s" = 0 ] && grep -q '^ok    docs/gates.md is current (2 scripts' "$T/out"; then ok "the same families as a TSV file read the same index: the TSV reader is bbh's, unchanged"
else fail "a TSV family file: exit $s; $(tr '\n' '|' < "$T/out")"; fi

echo "== 3. MUST-FIRE controls =="
[ "$rc" = 0 ] || { echo "  FAIL  section 3 not run: section 1 or 2 is not clean"; echo "FAIL: see above"; exit 1; }
# CONTROL stale-index
copy; sed -i.bak '2s/locks one law/locks another law/' "$T/x/tests/g_one.sh"; rm -f "$T/x/tests/g_one.sh.bak"
grep -q 'locks another law' "$T/x/tests/g_one.sh" || fail "the stale-index plant did not change the header"
gi --config "$T/x/bbx.toml" --check
if [ "$s" = 1 ] && grep -q '^STALE docs/gates.md differs from a regeneration:$' "$T/out" && grep -q '^  +| `tests/g_one.sh` .*locks another law' "$T/out"; then echo "CONTROL FIRED: stale-index — exit 1, STALE, the changed row in the diff"
else echo "CONTROL DEAD: stale-index — exit $s; $(tr '\n' '|' < "$T/out")"; fail "a stale index read current"; fi
# CONTROL crlf-index
copy; python3 -c 'import sys; p = sys.argv[1]; d = open(p, "rb").read(); open(p, "wb").write(d.replace(b"\n", b"\r\n"))' "$T/x/docs/gates.md"
if cmp -s "$T/x/docs/gates.md" "$C/docs/gates.md"; then fail "the crlf-index plant did not change the bytes"; fi
gi --config "$T/x/bbx.toml" --check
if [ "$s" = 1 ] && grep -q '^STALE docs/gates.md differs from a regeneration:$' "$T/out" && grep -q '^  (no line differs and the bytes do: ' "$T/out"; then echo "CONTROL FIRED: crlf-index — exit 1, STALE, no line differs and the bytes do"
else echo "CONTROL DEAD: crlf-index — exit $s; $(tr '\n' '|' < "$T/out")"; fail "a CRLF copy of the index read current"; fi
# CONTROL family-toml-row-missing
copy; printf '[f1]\ngate = "tests/g_one.sh"\nfamily = "alpha"\n' > "$T/x/tests/families.toml"
gi --config "$T/x/bbx.toml" --check
if [ "$s" = 1 ] && [ "$(problems)" = 1 ] && grep -q '^PROBLEM NO FAMILY ROW in tests/families.toml: tests/g_two.sh$' "$T/out"; then echo "CONTROL FIRED: family-toml-row-missing — exit 1, $(grep '^PROBLEM ' "$T/out")"
else echo "CONTROL DEAD: family-toml-row-missing — exit $s; $(tr '\n' '|' < "$T/out")"; fail "a gate with no table read as having a family"; fi
# CONTROL family-toml-dead-row
copy; printf '\n[f3]\ngate = "tests/g_gone.sh"\nfamily = "alpha"\n' >> "$T/x/tests/families.toml"
gi --config "$T/x/bbx.toml" --check
if [ "$s" = 1 ] && [ "$(problems)" = 1 ] && grep -q '^PROBLEM DEAD ROW in tests/families.toml: tests/g_gone.sh (script gone)$' "$T/out"; then echo "CONTROL FIRED: family-toml-dead-row — exit 1, $(grep '^PROBLEM ' "$T/out")"
else echo "CONTROL DEAD: family-toml-dead-row — exit $s; $(tr '\n' '|' < "$T/out")"; fail "a table for a gone gate was not a problem"; fi
# CONTROL family-toml-duplicate
copy; printf '\n[f4]\ngate = "tests/g_one.sh"\nfamily = "beta"\n' >> "$T/x/tests/families.toml"
gi --config "$T/x/bbx.toml" --check
if [ "$s" = 1 ] && [ "$(problems)" = 1 ] && grep -q '^PROBLEM DUPLICATE ROW in tests/families.toml: tests/g_one.sh$' "$T/out"; then echo "CONTROL FIRED: family-toml-duplicate — exit 1, $(grep '^PROBLEM ' "$T/out")"
else echo "CONTROL DEAD: family-toml-duplicate — exit $s; $(tr '\n' '|' < "$T/out")"; fail "a gate named twice was not a problem"; fi
# CONTROL columns-by-config
gi --config "$C/bbx.toml" --stdout; cp "$T/out" "$T/five.md"
copy; printf 'columns = ["controls", "blind spots"]\n' >> "$T/x/bbx.toml"
gi --config "$T/x/bbx.toml" --stdout
if [ "$s" = 0 ] \
   && grep -q -F "| gate | kind | tier | needs | locks (the script's own header) | since | controls | blind spots |" "$T/out" \
   && grep -q '^| `tests/g_one.sh` | .* | 2 known-bad, 1 perturbed-copy | 3 |$' "$T/out" \
   && grep -q '^| `tests/g_two.sh` | .* | none | 0 |$' "$T/out" \
   && grep -q -F "| gate | kind | tier | needs | locks (the script's own header) | since |" "$T/five.md" \
   && ! grep -q 'blind spots' "$T/five.md"; then
    echo "CONTROL FIRED: columns-by-config — both columns rendered with the headers' own counts (2 known-bad, 1 perturbed-copy, 3; none, 0), and bbh's five columns only without them"
else echo "CONTROL DEAD: columns-by-config — exit $s; $(grep -E '^\| (gate|`tests)' "$T/out" | tr '\n' '|')"; fail "the columns did not follow the config"; fi
copy; printf 'columns = ["controls", "owner"]\n' >> "$T/x/bbx.toml"
gi --config "$T/x/bbx.toml" --stdout
if [ "$s" = 1 ] && grep -q "^PROBLEM UNKNOWN COLUMN 'owner' in \[gate_header\].columns" "$T/out"; then ok "a column the tool does not know is a PROBLEM, exit 1"
else fail "an unknown column: exit $s; $(grep '^PROBLEM' "$T/out" | tr '\n' '|')"; fi

echo
[ "$rc" = 0 ] && echo "PASS: docs/gates.md is current, and the lifted index generator fails on a stale index, a CRLF copy, a missing, dead or doubled family row, and renders its further columns only where the config names them" || { echo "FAIL: see above"; exit 1; }
