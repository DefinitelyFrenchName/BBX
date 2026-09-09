#!/bin/sh
# controls.sh — a declared must-fire control that does not fire, or a firing nobody declared, makes the runner NOT GREEN; silence is red under enforcement and invisible without it
# Ground truth for lib/py/bbx/controls.py and the runner's controls block (docs/controls.md,
# ruled R10): the grammar reader, the report line per gate, and the runner's verdict on it —
# against a SYNTHETIC consumer of stub gates. The gap this closes was measured in VampireSaved
# (74 of 311 gates carry the marker as prose, 15+ spellings, no reader; gotcha G5). Portable, ~2 s.
# Usage: gates/controls.sh
# MUST-FIRE: known-bad: dead-control — a gate that declares a control and never prints CONTROL FIRED for it must turn the enforcing runner NOT GREEN with exit 1
#
set -eu
BBX_HOME="$(cd "$(dirname "$0")/.." && pwd)"; export BBX_HOME
PYTHONPATH="$BBX_HOME/lib/py"; export PYTHONPATH
rc=0
ok()   { printf '  ok    %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1"; rc=1; }
T="$(mktemp -d)"; trap 'rm -rf "$T"' EXIT INT TERM
FR="$T/c"; mkdir -p "$FR/tests"
cat > "$FR/bbx.toml" <<'EOF'
[project]
root = "."
[registries]
portable = "tests/ci_portable.txt"
static = "tests/ci_static.txt"
[tier]
patterns = []
[controls]
enforce = true
EOF
RUN="$BBX_HOME/bin/bbx-run-static --config $FR/bbx.toml --tier portable"
mkg() {  # mkg <name> <header-lines...> -- <body-lines...>
    n="$1"; shift; f="$FR/tests/$n.sh"
    { echo "#!/bin/sh"; echo "# $n.sh — a stub"; while [ $# -gt 0 ] && [ "$1" != "--" ]; do echo "$1"; shift; done; echo "#"; shift
      while [ $# -gt 0 ]; do echo "echo '$1'"; shift; done; echo "exit 0"; } > "$f"; chmod +x "$f"
}
mkg g_ok      "# MUST-FIRE: known-bad: wrong-input — the checker must fail on a wrong input" -- "CONTROL FIRED: wrong-input — it failed" "PASS: ok"
mkg g_dead    "# MUST-FIRE: perturbed-copy: flipped-byte — the comparator must fail on one flipped byte" -- "PASS: but the control never ran"
mkg g_undecl  -- "CONTROL FIRED: surprise — nobody declared me" "PASS: fine"
mkg g_none    "# MUST-FIRE: none — this gate lists a registry and asserts no property" -- "PASS: listed"
mkg g_silent  -- "PASS: no declaration at all"
mkg g_deadline "# MUST-FIRE: shadow-tool: stripped-line — the check must fail when the line is stripped" -- "CONTROL DEAD: stripped-line — it passed anyway" "PASS: the real check"
: > "$FR/tests/ci_static.txt"

echo "== 1. the reader =="
d="$(python3 -m bbx.controls declared "$FR/tests/g_ok.sh")"
[ "$d" = "known-bad	wrong-input	the checker must fail on a wrong input" ] && ok "a declaration reads as shape / name / text" || fail "declared: $d"
d="$(python3 -m bbx.controls declared "$FR/tests/g_none.sh")"
[ "$d" = "none	-	this gate lists a registry and asserts no property" ] && ok "'none — reason' reads as the explicit no-control declaration" || fail "none: $d"
[ -z "$(python3 -m bbx.controls declared "$FR/tests/g_silent.sh")" ] && ok "a header with no MUST-FIRE line declares nothing" || fail "silent gate declared something"

echo "== 2. the runner's controls block, one gate at a time =="
one() {  # one <gate> <expected-verdict-word> <expected-exit>
    printf '%s\n' "$1" > "$FR/tests/ci_portable.txt"
    o="$(cd "$FR" && $RUN 2>&1)" && s=0 || s=$?
    line="$(printf '%s\n' "$o" | grep "controls=$1 " || true)"
    if printf '%s' "$line" | grep -q "verdict=$2" && [ "$s" = "$3" ]; then ok "$1 -> $2, runner exit $3"
    else fail "$1: $line (exit $s), expected $2 exit $3"; fi
}
one g_ok OK 0
one g_none OK 0
one g_undecl RED 1
one g_deadline RED 1
one g_silent UNDECLARED 1

echo "== 3. MUST-FIRE: a declared control that never fires =="
printf 'g_dead\n' > "$FR/tests/ci_portable.txt"
o="$(cd "$FR" && $RUN 2>&1)" && s=0 || s=$?
if [ "$s" = 1 ] && printf '%s\n' "$o" | grep -q "controls=g_dead declared=1 fired=0 dead=1 undeclared=0 verdict=RED" && printf '%s\n' "$o" | grep -q "NOT GREEN"; then
    echo "CONTROL FIRED: dead-control — g_dead (declared, never fired) made the runner NOT GREEN, exit 1"
    ok "a dead control refuses the verdict (BBX-6)"
else
    echo "CONTROL DEAD: dead-control — exit $s; $(printf '%s\n' "$o" | grep 'controls=g_dead' || echo 'no controls line')"
    fail "a dead control was not red"
fi

echo "== 4. without enforcement the block is absent and the output is bbh's =="
sed 's/enforce = true/enforce = false/' "$FR/bbx.toml" > "$FR/off.toml"
printf 'g_dead\ng_silent\n' > "$FR/tests/ci_portable.txt"
o="$(cd "$FR" && "$BBX_HOME/bin/bbx-run-static" --config "$FR/off.toml" --tier portable 2>&1)" && s=0 || s=$?
if [ "$s" = 0 ] && ! printf '%s\n' "$o" | grep -q "== controls"; then ok "enforce = false: no controls block, GREEN (fidelity with bbh)"; else fail "enforce = false still reported controls (exit $s)"; fi

echo
[ "$rc" = 0 ] && echo "PASS: declared controls are read, dead ones refuse the verdict, silence is red under enforcement" || { echo "FAIL: see above"; exit 1; }
