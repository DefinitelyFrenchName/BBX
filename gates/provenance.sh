#!/bin/sh
# provenance.sh — the expectation register is complete both ways, every row names one class of the eight and no file twice, a testimony row is named as not evidence, and a register the subset refuses is a FAIL, never a pass
# Ground truth for lib/py/bbx/provenance.py (abstraction E3; R11, R24). The lineage's two controls (VampireSaved
# test_expectation_provenance.sh, bbh test_provenance.sh at f675710: a deleted row is an unprovenanced file; a row
# naming a missing file is dead) plus BBX's: a class outside the eight, a file named twice, a missing field, a
# duplicate table (the subset's refusal), excluded basenames and dotfiles out of scope, --register overriding,
# the histogram by class. Synthetic tree, no instrument. Portable, ~1 s.
# Usage: gates/provenance.sh
# MUST-FIRE: known-bad: file-without-row — a file in the tree with no row must FAIL naming it, or an expectation nobody vouched for reads as vouched for
# MUST-FIRE: known-bad: row-without-file — a row naming a file that is gone must FAIL naming it, or the register is read as exhaustive while it is stale
# MUST-FIRE: known-bad: class-outside-eight — a class that is not one of R11's eight must be REFUSED naming the row, or riders become classes again (the VampireSaved 6-to-13 drift)
# MUST-FIRE: known-bad: file-named-twice — a second row for one file must be REFUSED, or a hand-edited register carries two answers
# NOT-ASSERTED: that a row's class is TRUE of its file: the register is written by hand at the freeze; only completeness and the vocabulary are checked
# NOT-ASSERTED: bbh's example register (markdown, a consumer list of classes): it is bbh's and F19 (S6) reads it under R11
#
set -eu
BBX_HOME="$(cd "$(dirname "$0")/.." && pwd)"; export BBX_HOME
PYTHONPATH="$BBX_HOME/lib/py"; export PYTHONPATH
unset BBX_CONFIG 2>/dev/null || true
rc=0
ok()   { printf '  ok    %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1"; rc=1; }
T="$(mktemp -d)"; trap 'rm -rf "$T"' EXIT INT TERM
R="$T/r"; mkdir -p "$R/expected/a-set/logs" "$R/expected/base"
printf '[project]\nroot = "."\nkind = "self"\n[suite]\nexpected_dir = "expected"\n' > "$R/bbx.toml"
: > "$R/expected/registry.tsv"; echo "exact base -" > "$R/expected/a-set/x.masked"; : > "$R/expected/a-set/y.sha1"; : > "$R/expected/a-set/logs/y.log"
: > "$R/expected/base/MASK"; : > "$R/expected/README.md"; : > "$R/expected/.hidden"; : > "$R/expected/a-set/mask"
reg() {  # reg <rows...>  each row: file|class[|extra toml lines]
    : > "$R/expected/PROVENANCE.toml"; i=0
    for r in "$@"; do i=$((i + 1)); f="${r%%|*}"; rest="${r#*|}"; c="${rest%%|*}"; x=""; case "$rest" in *\|*) x="${rest#*|}" ;; esac
        printf '[e%s]\nfile = "%s"\ndescribes = "d"\nclass = "%s"\nrefreeze = "r"\n%s\n' "$i" "$f" "$c" "$x" >> "$R/expected/PROVENANCE.toml"; done
}
PV="python3 -m bbx.provenance --config $R/bbx.toml"
reg 'registry.tsv|registry' 'a-set/x.masked|derived' 'a-set/y.sha1|self' 'a-set/logs/y.log|self'

echo "== 1. the clean case: four files (README, MASK, mask, the dotfile out of scope), four rows =="
o="$($PV)" && ok "exit 0" || fail "exit non-zero on a complete register: $(printf '%s' "$o" | tr '\n' ' ')"
printf '%s\n' "$o" | grep -q '^  ok: 4 expectation files, 4 rows, complete both ways$' && ok "four files across the tree, README / MASK / mask / dotfile excluded, the lineage's ok line" || fail "$(printf '%s\n' "$o" | sed -n 2p)"
printf '%s\n' "$o" | grep -q '^  ok: every row complete, every class one of the eight, no file named twice$' && ok "every row inside the vocabulary" || fail "row line"
printf '%s\n' "$o" | grep -q '^  self 2, derived 1, registry 1$' && ok "the classes counted in rank order" || fail "histogram line: $(printf '%s\n' "$o" | tail -1)"
h="$($PV --histogram a-set | tr '\n' ' ')"; [ "$h" = "class=self count=2 class=derived count=1 " ] && ok "--histogram a-set: $h" || fail "histogram: '$h'"
h="$($PV --histogram nosuch | tr '\n' ' ')"; [ "$h" = "class=none count=0 " ] && ok "--histogram of a set with no rows: none" || fail "empty histogram: '$h'"

echo "== 2. CONTROL file-without-row =="
reg 'registry.tsv|registry' 'a-set/x.masked|derived' 'a-set/logs/y.log|self'
if o="$($PV 2>&1)"; then fail "CONTROL DEAD: file-without-row — a deleted row was NOT caught"
elif printf '%s\n' "$o" | grep -q '^  FAIL: 1 expectation file(s) with NO provenance row:$' && printf '%s\n' "$o" | grep -q '^      a-set/y.sha1$' && printf '%s\n' "$o" | grep -q '^      Add a row to expected/PROVENANCE.toml saying what the$'; then echo "CONTROL FIRED: file-without-row — a-set/y.sha1 named, the advice names the register"
else fail "CONTROL DEAD: file-without-row — $(printf '%s' "$o" | head -3 | tr '\n' ' ')"; fi
echo "== 3. CONTROL row-without-file =="
reg 'registry.tsv|registry' 'a-set/x.masked|derived' 'a-set/y.sha1|self' 'a-set/logs/y.log|self' 'a-set/gone.sha1|self'
if o="$($PV 2>&1)"; then fail "CONTROL DEAD: row-without-file — a dead row was NOT caught"
elif printf '%s\n' "$o" | grep -q '^  FAIL: 1 provenance row(s) naming a file that is gone:$' && printf '%s\n' "$o" | grep -q '^      a-set/gone.sha1$'; then echo "CONTROL FIRED: row-without-file — a-set/gone.sha1 named"
else fail "CONTROL DEAD: row-without-file — $(printf '%s' "$o" | head -4 | tr '\n' ' ')"; fi
echo "== 4. CONTROL class-outside-eight =="
reg 'registry.tsv|registry' 'a-set/x.masked|authored' 'a-set/y.sha1|self' 'a-set/logs/y.log|self'
if o="$($PV 2>&1)"; then fail "CONTROL DEAD: class-outside-eight — 'authored' passed"
elif printf '%s\n' "$o" | grep -q "^      \[e2\] a-set/x.masked: class 'authored' is not one of the eight (R11): reference, corroborator, self, derived, hash-lock, registry, fixture, testimony$"; then echo "CONTROL FIRED: class-outside-eight — 'authored' refused, the eight printed"
else fail "CONTROL DEAD: class-outside-eight — $(printf '%s' "$o" | grep -A2 'refused' | tr '\n' ' ')"; fi
reg 'registry.tsv|registry' 'a-set/x.masked|self-frozen' 'a-set/y.sha1|self' 'a-set/logs/y.log|self'
$PV > /dev/null 2>&1 && fail "a rider inside the class ('self-frozen') passed as a substring of nothing" || ok "a class with a rider ('self-frozen') is refused: riders go in notes (R11)"
echo "== 5. CONTROL file-named-twice; a missing field; a duplicate table =="
reg 'registry.tsv|registry' 'a-set/x.masked|derived' 'a-set/y.sha1|self' 'a-set/logs/y.log|self' 'a-set/y.sha1|derived'
if o="$($PV 2>&1)"; then fail "CONTROL DEAD: file-named-twice — a second row for one file passed"
elif printf '%s\n' "$o" | grep -q '^      \[e5\] names a-set/y.sha1 a second time (first in \[e3\])'; then echo "CONTROL FIRED: file-named-twice — the second row refused, the first named"
else fail "CONTROL DEAD: file-named-twice — $(printf '%s' "$o" | grep -A2 refused | tr '\n' ' ')"; fi
reg 'registry.tsv|registry' 'a-set/x.masked|derived' 'a-set/y.sha1|self' 'a-set/logs/y.log|self'
awk '/^refreeze = "r"$/ { n++; if (n == 2) next } { print }' "$R/expected/PROVENANCE.toml" > "$T/nofield.toml" && mv "$T/nofield.toml" "$R/expected/PROVENANCE.toml"   # drop the SECOND refreeze line only
grep -c '^refreeze' "$R/expected/PROVENANCE.toml" | grep -qx 3 || fail "the missing-field fixture was not built ($(grep -c '^refreeze' "$R/expected/PROVENANCE.toml") refreeze lines)"
o="$($PV 2>&1)" && fail "a row with no refreeze field passed" || { printf '%s\n' "$o" | grep -q '^      \[e2\] lacks refreeze$' && ok "a missing field is refused BY NAME" || fail "missing field: $(printf '%s' "$o" | grep -A2 refused | tr '\n' ' ')"; }
reg 'registry.tsv|registry' 'a-set/x.masked|derived' 'a-set/y.sha1|self' 'a-set/logs/y.log|self'
printf '[e1]\nfile = "registry.tsv"\ndescribes = "d"\nclass = "registry"\nrefreeze = "r"\n' >> "$R/expected/PROVENANCE.toml"
o="$($PV 2>&1)" && s=0 || s=$?; [ "$s" = 2 ] && printf '%s\n' "$o" | grep -q 'declared twice' && ok "a table declared twice is refused by the subset parser (exit 2, the parser's line)" || fail "duplicate table: rc=$s '$o'"
echo "== 6. testimony is not evidence; a missing register; --register =="
reg 'registry.tsv|registry' 'a-set/x.masked|testimony' 'a-set/y.sha1|fixture' 'a-set/logs/y.log|self'
o="$($PV)" && printf '%s\n' "$o" | grep -q '^  NOTE: testimony rows=1 — a filed count never reads green (BBX-3); these files are not evidence$' && printf '%s\n' "$o" | grep -q '^  NOTE: fixture rows=1 — synthesized with known truth; evidence about no real subject$' && ok "testimony and fixture rows are complete (exit 0) and NAMED as not evidence" || fail "testimony/fixture: $(printf '%s' "$o" | tail -3 | tr '\n' ' ')"
cp "$R/expected/PROVENANCE.toml" "$T/alt.toml"; rm "$R/expected/PROVENANCE.toml"
o="$($PV 2>&1)" && fail "a missing register passed" || { [ "$o" = "FAIL: expected/PROVENANCE.toml is missing" ] && ok "a missing register is the lineage's one-line FAIL" || fail "missing: '$o'"; }
$PV --register "$T/alt.toml" > /dev/null 2>&1 && ok "--register names another register" || fail "--register did not override"

echo
[ "$rc" = 0 ] && echo "PASS: every frozen expectation says where its numbers came from, in one closed vocabulary, in a register that cannot be ambiguous" || { echo "FAIL: see above"; exit 1; }
