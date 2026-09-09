#!/bin/sh
# tier.sh — the tier classifier sees an instrument reached directly or through sourced libs to the configured depth, and no further
# Ground truth for lib/py/bbx/tier.py. Cases lifted from bbh selftest/test_tier.sh, each paid
# for in the lineage: a gate that reaches the instrument ONLY through a sourced lib (two gates
# were reported static and one ran 208 s inside a chain advertised as emulator-free); a
# mention in a COMMENT is not a reach; runner prefixes and manual suffixes are excluded. Plus
# BBX's generalization: an empty pattern list means nothing reaches an instrument. Portable, ~1 s.
# Usage: gates/tier.sh
# MUST-FIRE: known-bad: depth-3-chain — a chain three libs deep must be PLAIN at source_depth 2 and INSTRUMENT at source_depth 3, or the depth is not what decides
#
set -eu
BBX_HOME="$(cd "$(dirname "$0")/.." && pwd)"; export BBX_HOME
PYTHONPATH="$BBX_HOME/lib/py"; export PYTHONPATH
rc=0
ok()   { printf '  ok    %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1"; rc=1; }
T="$(mktemp -d)"; trap 'rm -rf "$T"' EXIT INT TERM
mkdir -p "$T/p/tests/lib"
cat > "$T/p/bbx.toml" <<'EOF'
[project]
root = "."
[tier]
patterns = ['run_instrument\.sh', 'INSTR_BIN']
source_regex = '^\s*\.\s+"?\$(?:REPO|\{REPO\})"?/(tests/lib/[a-z0-9_]+\.sh)'
source_depth = 2
[registries]
portable = "tests/ci_portable.txt"
static = "tests/ci_static.txt"
EOF
g() { printf '#!/bin/sh\n%s\n' "$2" > "$T/p/tests/$1.sh"; chmod +x "$T/p/tests/$1.sh"; }
g direct   'INSTR_BIN=x tools/run_instrument.sh set'
g comment  '# this gate never calls run_instrument.sh, it only mentions it
echo PASS'
g via_lib  '. "$REPO/tests/lib/l1.sh"'
g via_two  '. "$REPO/tests/lib/l2a.sh"'
g via_three '. "$REPO/tests/lib/l3a.sh"'
g plain    'echo PASS'
g run_all  'echo I am a runner'
g long_soak 'echo I am manual'
printf '. "$REPO/tests/lib/deep.sh"\n' > "$T/p/tests/lib/l1.sh"; printf 'INSTR_BIN=x\n' > "$T/p/tests/lib/deep.sh"
printf '. "$REPO/tests/lib/l2b.sh"\n' > "$T/p/tests/lib/l2a.sh"; printf 'INSTR_BIN=x\n' > "$T/p/tests/lib/l2b.sh"
printf '. "$REPO/tests/lib/l3b.sh"\n' > "$T/p/tests/lib/l3a.sh"; printf '. "$REPO/tests/lib/l3c.sh"\n' > "$T/p/tests/lib/l3b.sh"; printf 'INSTR_BIN=x\n' > "$T/p/tests/lib/l3c.sh"
printf 'plain\n' > "$T/p/tests/ci_portable.txt"; : > "$T/p/tests/ci_static.txt"

echo "== 1. --list classifies each gate =="
lst="$(python3 -m bbx.tier "$T/p/bbx.toml" --list)"
want() { printf '%s\n' "$lst" | grep -q "^$1	$2	$3\$" && ok "$1 -> $2 ($3)" || fail "$1: $(printf '%s\n' "$lst" | grep "^$1	" || echo missing) expected $2 $3"; }
want direct    INSTRUMENT -
want comment   PLAIN -
want via_lib   INSTRUMENT -
want via_two   INSTRUMENT -
want via_three PLAIN -
want plain     PLAIN portable
want run_all   PLAIN -

echo "== 2. --unregistered names the right gates =="
un="$(python3 -m bbx.tier "$T/p/bbx.toml" --unregistered)"
printf '%s\n' "$un" | grep -q "      comment" && ok "the comment-only gate is unregistered (it is instrument-free)" || fail "comment-only gate not reported"
printf '%s\n' "$un" | grep -q "      via_three" && ok "the depth-3 chain is reported (depth 2 does not reach it)" || fail "depth-3 chain not reported"
printf '%s\n' "$un" | grep -q "      via_lib\|      via_two\|      direct" && fail "an instrument gate was reported" || ok "no instrument gate is reported"
printf '%s\n' "$un" | grep -q "      run_all\|      long_soak" && fail "a runner or manual gate was reported" || ok "runner prefix and manual suffix are excluded"
printf '%s\n' "$un" | grep -q "      plain" && fail "a registered gate was reported" || ok "a registered gate is not reported"
printf '%s\n' "$un" | grep -q "^  2 emulator-free gate(s) in NEITHER registry:" && ok "the report's count line is the lineage's text (a kindless config is frame-driven: 'emulator')" || fail "report text: $(printf '%s\n' "$un" | head -1)"

echo "== 3. MUST-FIRE: depth 3 reaches the third lib, depth 2 does not =="
sed 's/source_depth = 2/source_depth = 3/' "$T/p/bbx.toml" > "$T/p/bbx3.toml"
d2="$(printf '%s\n' "$lst" | grep '^via_three' | cut -f2)"
d3="$(python3 -m bbx.tier "$T/p/bbx3.toml" --list | grep '^via_three' | cut -f2)"
if [ "$d2" = PLAIN ] && [ "$d3" = INSTRUMENT ]; then
    echo "CONTROL FIRED: depth-3-chain — via_three is PLAIN at depth 2 and INSTRUMENT at depth 3"
    ok "source_depth decides the reach"
else
    echo "CONTROL DEAD: depth-3-chain — depth 2 read $d2, depth 3 read $d3"
    fail "source_depth is not what decides"
fi

echo "== 4. the clean case, and the empty-patterns generalization =="
printf 'plain\ncomment\nvia_three\n' > "$T/p/tests/ci_portable.txt"
python3 -m bbx.tier "$T/p/bbx.toml" --unregistered | grep -q "ok: every emulator-free gate is registered" && ok "all registered -> the ok line" || fail "clean case not reported ok"
sed "s/^patterns = .*/patterns = []/" "$T/p/bbx.toml" > "$T/p/empty.toml"
e="$(python3 -m bbx.tier "$T/p/empty.toml" --list | grep -c INSTRUMENT || true)"
[ "$e" = 0 ] && ok "an empty pattern list classifies nothing as INSTRUMENT (bbh's alternation of zero patterns would match everything)" || fail "empty patterns matched $e gates as INSTRUMENT"

echo
[ "$rc" = 0 ] && echo "PASS: the tier classifier sees what the runners need it to see" || { echo "FAIL: see above"; exit 1; }
