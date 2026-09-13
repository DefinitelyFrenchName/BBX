#!/bin/sh
# registry_complete.sh — BBX-9's orphan direction has a VERDICT: every gate on disk is in the registry its tier needs, and every sweep row names a gate that exists (R45)
# Ground truth for `bbx tier <config> --complete` (lib/py/bbx/tier.py). The positive is BBX's OWN
# config; the controls are a SYNTHETIC consumer under TMPDIR. Why a gate and not a runner (R45):
# bin/bbx-run-static's printed text and verdict are bbh's, and fidelity F13 runs both runners over a
# synthetic repo that CONTAINS an orphan, so a new failure there would break the lineage obligation;
# the tier listing's registry column cannot say `sweep` either, because F13e diffs that listing.
# Neither runner changes. Measured before the ruling (bbx-22, a clone of 898dbe6): a plain orphan was
# named with exit 0, an INSTRUMENT orphan was reported by nobody, a dead sweep row was listed as real.
# Usage: gates/registry_complete.sh
# MUST-FIRE: known-bad: plain-orphan — an instrument-free gate in neither the portable nor the static registry must FAIL naming it, or an orphan is a report and never a verdict (G34)
# MUST-FIRE: known-bad: instrument-orphan — a gate the tier classifies INSTRUMENT, with no sweep row, must FAIL naming it, or the orphan class step 6 opened stays reported by nobody (G45)
# MUST-FIRE: known-bad: dead-sweep-row — a sweep row naming a gate that is not on disk must FAIL naming it, or a dead row reads like a registration (BBX-9)
# NOT-ASSERTED: that a gate is in the RIGHT registry: an instrument-free gate registered static that could run portable passes here
# NOT-ASSERTED: a dead portable or static row: bin/bbx-run-static already reads it as MISSING and fails, and the fidelity pairs depend on that text
# NOT-ASSERTED: an instrument reached through a path the tier's source regex does not match — that is gates/tier.sh's blind spot, inherited here
#
set -eu
BBX_HOME="$(cd "$(dirname "$0")/.." && pwd)"; export BBX_HOME
PYTHONPATH="$BBX_HOME/lib/py"; export PYTHONPATH
rc=0
ok()   { printf '  ok    %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1"; rc=1; }
T="$(mktemp -d)"; trap 'rm -rf "$T"' EXIT INT TERM

echo "== 1. BBX's own tree: every registry complete both ways =="
if o="$(python3 -m bbx.tier "$BBX_HOME/bbx.toml" --complete 2>&1)"; then ok "bbx tier bbx.toml --complete exits 0 on BBX's own registries"
else fail "BBX's own registries are not complete (exit $?)"; fi
printf '%s\n' "$o" | sed 's/^/        /'

echo "== 2. a synthetic consumer: complete, and a pattern in a COMMENT is not a reach =="
FR="$T/c"; mkdir -p "$FR/tests"
cat > "$FR/bbx.toml" <<'EOF'
[project]
root = "."
gates_dir = "tests"
instrument_word = "instrument"
[registries]
portable = "tests/portable.txt"
static = "tests/static.txt"
sweep = "tests/sweep.tsv"
[tier]
patterns = ['FAKE_INSTRUMENT']
EOF
mk() { printf '#!/bin/sh\n# %s.sh — a stub\n%s\necho "PASS: %s"\n' "$1" "$2" "$1" > "$FR/tests/$1.sh"; chmod +x "$FR/tests/$1.sh"; }
mk g_plain ':'
mk g_static ':'
mk g_inst 'FAKE_INSTRUMENT --run'
mk g_comment '# FAKE_INSTRUMENT is only mentioned here'
printf 'g_plain\ng_comment\n' > "$FR/tests/portable.txt"; printf 'g_static\n' > "$FR/tests/static.txt"
printf '# COLUMNS gate lane scope cadence args note\ng_inst\tprereq\trelease\talways\t-\tthe one instrument gate\n' > "$FR/tests/sweep.tsv"
cmp() { python3 -m bbx.tier "$FR/bbx.toml" --complete > "$T/out" 2>&1 && s=0 || s=$?; }
cmp
if [ "$s" = 0 ] && grep -q "ok: every instrument-free gate is in the portable or static registry" "$T/out" && grep -q "ok: every instrument gate has a sweep row" "$T/out" && grep -q "ok: every sweep row names a gate on disk" "$T/out"; then ok "complete both ways: exit 0, three ok lines (g_comment's pattern sits in a comment and it stays PLAIN)"
else fail "the complete consumer: exit $s; $(tr '\n' '|' < "$T/out")"; fi

echo "== 3. MUST-FIRE controls =="
# CONTROL plain-orphan
mk g_orphan ':'; cmp
if [ "$s" = 1 ] && grep -q "^  FAIL orphan: g_orphan is instrument-free and in neither tests/portable.txt nor tests/static.txt$" "$T/out"; then echo "CONTROL FIRED: plain-orphan — exit 1, g_orphan named"
else echo "CONTROL DEAD: plain-orphan — exit $s; $(tr '\n' '|' < "$T/out")"; fail "an instrument-free orphan was not a failure"; fi
rm "$FR/tests/g_orphan.sh"
# CONTROL instrument-orphan
mk g_inst2 'FAKE_INSTRUMENT --other'; cmp
if [ "$s" = 1 ] && grep -q "^  FAIL orphan: g_inst2 reaches an instrument and has no row in tests/sweep.tsv$" "$T/out"; then echo "CONTROL FIRED: instrument-orphan — exit 1, g_inst2 named"
else echo "CONTROL DEAD: instrument-orphan — exit $s; $(tr '\n' '|' < "$T/out")"; fail "an INSTRUMENT orphan was not a failure"; fi
rm "$FR/tests/g_inst2.sh"
# CONTROL dead-sweep-row
printf 'no_such_gate\tprereq\trelease\talways\t-\ta row naming nothing\n' >> "$FR/tests/sweep.tsv"; cmp
if [ "$s" = 1 ] && grep -q "^  FAIL dead-row: tests/sweep.tsv names no_such_gate, which is not a gate on disk$" "$T/out"; then echo "CONTROL FIRED: dead-sweep-row — exit 1, no_such_gate named"
else echo "CONTROL DEAD: dead-sweep-row — exit $s; $(tr '\n' '|' < "$T/out")"; fail "a dead sweep row was not a failure"; fi

echo
[ "$rc" = 0 ] && echo "PASS: every registry is complete both ways on BBX's own tree, and an orphan of either tier and a dead sweep row each fail" || { echo "FAIL: see above"; exit 1; }
