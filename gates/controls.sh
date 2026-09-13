#!/bin/sh
# controls.sh — a declared must-fire control that does not fire, or a firing nobody declared, makes the runner NOT GREEN; silence is red under enforcement and invisible without it; a correct SKIP sets its declarations aside and nothing else (R48); a reader that does not report every gate is red (G48)
# Ground truth for lib/py/bbx/controls.py and the runner's controls block (docs/controls.md,
# ruled R10; the header's extent ruled R30): the grammar reader, the report line per gate, and the runner's verdict on it —
# against a SYNTHETIC consumer of stub gates. The gap this closes was measured in VampireSaved
# (74 of 311 gates carry the marker as prose, 15+ spellings, no reader; gotcha G5). Portable, ~14 s measured 2026-09-13 (15 runner runs).
# Usage: gates/controls.sh
# MUST-FIRE: known-bad: body-is-not-header — a MUST-FIRE line after the first code line must declare nothing, or the header is the whole file and a comment anywhere declares a control
# MUST-FIRE: known-bad: dead-control — a gate that declares a control and never prints CONTROL FIRED for it must turn the enforcing runner NOT GREEN with exit 1
# MUST-FIRE: known-bad: skip-cannot-hide-dead — a gate the classifier calls SKIP that prints CONTROL DEAD must stay RED and the runner NOT GREEN, or a skip becomes a place to hide a dead control (R48, BBX-6)
# MUST-FIRE: known-bad: failed-skip-not-exempt — a gate that prints a SKIP marker and exits 2 is a FAIL (BBX-1), so its declared control that never fired must stay dead and the runner NOT GREEN, or the exemption reads the marker instead of the verdict (R48)
# MUST-FIRE: known-bad: strict-admits-no-exemption — a gate that SKIPS correctly, its declared control set aside, must still make the runner NOT GREEN with exit 1 under --strict, for the --strict reason and not the controls one (R48: --strict admits no exception)
# MUST-FIRE: shadow-tool: reader-crash-is-red — a copy of the controls reader with one line stripped, so that it crashes before reporting, must make the runner NOT GREEN naming the unreported count, or a dead instrument reads as "red: 0" (G48)
# NOT-ASSERTED: that a control is RIGHT — only that a declared control fired and an undeclared one is red (docs/controls.md)
# NOT-ASSERTED: that a SKIP is JUSTIFIED — a skip for a bad reason sets its controls aside exactly like a good one; the screen names it and --strict refuses it, and nothing here judges the reason (R48)
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

echo "== 1b. the header is the leading comment block (R30): a bare # does not end it, the first code line does =="
printf '#!/bin/sh\n# g_late.sh — declares after a bare separator\n#\n# MUST-FIRE: known-bad: late-decl — declared after the bare line\nset -eu\necho "CONTROL FIRED: late-decl — fine"\necho "PASS: ok"\n' > "$FR/tests/g_late.sh"; chmod +x "$FR/tests/g_late.sh"
[ "$(python3 -m bbx.controls declared "$FR/tests/g_late.sh")" = "known-bad	late-decl	declared after the bare line" ] && ok "a declaration after a bare # line is read (bbh: 264 of 315 gates have one within five lines)" || fail "late declaration: $(python3 -m bbx.controls declared "$FR/tests/g_late.sh")"
# CONTROL body-is-not-header
printf '#!/bin/sh\n# g_body.sh — a declaration in the BODY is not a declaration\nset -eu\n# MUST-FIRE: known-bad: in-body — this line is code territory\necho "CONTROL FIRED: in-body — but nobody declared me"\necho "PASS: ok"\n' > "$FR/tests/g_body.sh"; chmod +x "$FR/tests/g_body.sh"
if [ -z "$(python3 -m bbx.controls declared "$FR/tests/g_body.sh")" ]; then echo "CONTROL FIRED: body-is-not-header — a MUST-FIRE line after the first code line declares nothing (its firing will read as undeclared)"
else fail "CONTROL DEAD: body-is-not-header — a body line was read as a declaration: $(python3 -m bbx.controls declared "$FR/tests/g_body.sh")"; fi
rm "$FR/tests/g_late.sh" "$FR/tests/g_body.sh"

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

echo "== 5. R48: a gate the classifier calls SKIP has its declared controls set aside, never dead — and nothing else is set aside =="
SK="SKIP: the input is absent on this host"
mkg g_skip       "# MUST-FIRE: known-bad: needs-input — the check must fail on a wrong input" -- "$SK"
mkg g_skipsilent -- "$SK"
mkg g_skipundecl -- "CONTROL FIRED: surprise — nobody declared me" "$SK"
mkg g_skipdead   "# MUST-FIRE: known-bad: needs-input — the check must fail on a wrong input" -- "CONTROL DEAD: needs-input — it passed anyway" "$SK"
printf '#!/bin/sh\n# g_skipfail.sh — prints a skip marker, then exits 2\n# MUST-FIRE: known-bad: needs-input — the check must fail on a wrong input\n#\necho "%s"\nexit 2\n' "$SK" > "$FR/tests/g_skipfail.sh"; chmod +x "$FR/tests/g_skipfail.sh"
printf 'g_skip\n' > "$FR/tests/ci_portable.txt"
o="$(cd "$FR" && $RUN 2>&1)" && s=0 || s=$?
if [ "$s" = 0 ] && printf '%s\n' "$o" | grep -qx "  controls=g_skip declared=1 fired=0 dead=0 undeclared=0 verdict=SKIPPED" && printf '%s\n' "$o" | grep -q "^GREEN"; then ok "a correct skip with a declared control: verdict=SKIPPED, dead=0, the run GREEN with exit 0 (G47's case)"
else fail "a correct skip: exit $s; $(printf '%s\n' "$o" | grep -E 'controls=g_skip|GREEN' | tr '\n' '|')"; fi
printf '%s\n' "$o" | grep -qx "  controls fired 0 / declared 0; gates with no declaration: 0; red: 0; skipped: 1, whose 1 declared control(s) assert nothing" && ok "the sum sets the skipped declaration aside and the screen says how many" || fail "the sum line: $(printf '%s\n' "$o" | grep 'controls fired')"
printf 'g_ok\ng_skip\n' > "$FR/tests/ci_portable.txt"
o="$(cd "$FR" && $RUN 2>&1)" && s=0 || s=$?
[ "$s" = 0 ] && printf '%s\n' "$o" | grep -qx "  controls fired 1 / declared 1; gates with no declaration: 0; red: 0; skipped: 1, whose 1 declared control(s) assert nothing" && ok "beside a gate that fired, only the skipped gate's declaration leaves the denominator" || fail "mixed run: exit $s; $(printf '%s\n' "$o" | grep 'controls fired')"
one g_skipsilent UNDECLARED 1
one g_skipundecl RED 1
# CONTROL skip-cannot-hide-dead
printf 'g_skipdead\n' > "$FR/tests/ci_portable.txt"
o="$(cd "$FR" && $RUN 2>&1)" && s=0 || s=$?
if [ "$s" = 1 ] && printf '%s\n' "$o" | grep -Eq '^PASS 0 +SKIP 1 +FAIL 0 ' && printf '%s\n' "$o" | grep -qx "  controls=g_skipdead declared=1 fired=0 dead=1 undeclared=0 verdict=RED" && printf '%s\n' "$o" | grep -q "^NOT GREEN"; then
    echo "CONTROL FIRED: skip-cannot-hide-dead — g_skipdead was classified SKIP and printed CONTROL DEAD: RED, runner exit 1"
else
    echo "CONTROL DEAD: skip-cannot-hide-dead — exit $s; $(printf '%s\n' "$o" | grep -E '^PASS|controls=g_skipdead' | tr '\n' '|')"
    fail "a skip hid a dead control"
fi
# CONTROL failed-skip-not-exempt
printf 'g_skipfail\n' > "$FR/tests/ci_portable.txt"
o="$(cd "$FR" && $RUN 2>&1)" && s=0 || s=$?
if [ "$s" = 1 ] && printf '%s\n' "$o" | grep -Eq '^PASS 0 +SKIP 0 +FAIL 1 ' && printf '%s\n' "$o" | grep -qx "  controls=g_skipfail declared=1 fired=0 dead=1 undeclared=0 verdict=RED"; then
    echo "CONTROL FIRED: failed-skip-not-exempt — a SKIP marker with exit 2 is FAIL in the tally and its unfired control stays dead: RED, runner exit 1"
else
    echo "CONTROL DEAD: failed-skip-not-exempt — exit $s; $(printf '%s\n' "$o" | grep -E '^PASS|controls=g_skipfail' | tr '\n' '|')"
    fail "a skip marker with a non-zero exit was exempted"
fi
# CONTROL strict-admits-no-exemption
printf 'g_skip\n' > "$FR/tests/ci_portable.txt"
o="$(cd "$FR" && $RUN --strict 2>&1)" && s=0 || s=$?
if [ "$s" = 1 ] && printf '%s\n' "$o" | grep -qx "  controls=g_skip declared=1 fired=0 dead=0 undeclared=0 verdict=SKIPPED" && printf '%s\n' "$o" | grep -q "^--strict: SKIP counts as failure" && ! printf '%s\n' "$o" | grep -q "^controls: " && printf '%s\n' "$o" | grep -q "^NOT GREEN"; then
    echo "CONTROL FIRED: strict-admits-no-exemption — the same correct skip under --strict: controls SKIPPED, not red, and the run NOT GREEN for --strict alone, exit 1"
else
    echo "CONTROL DEAD: strict-admits-no-exemption — exit $s; $(printf '%s\n' "$o" | grep -E 'controls=g_skip|^--strict|^controls: |GREEN' | tr '\n' '|')"
    fail "--strict did not refuse a skip whose controls were set aside, or refused it for another reason"
fi

echo "== 6. G48: the controls verdict rests on the reader's OUTPUT, one line per gate that ran — never on its exit, which is 1 for RED and 1 for a crash =="
# CONTROL reader-crash-is-red: a shadow harness whose siblings are symlinks, the reader a copy with one line stripped
SH="$T/shadow"; mkdir -p "$SH/lib/py/bbx"
ln -s "$BBX_HOME/bin" "$SH/bin"; ln -s "$BBX_HOME/lib/sh" "$SH/lib/sh"
for f in "$BBX_HOME"/lib/py/bbx/*; do case "$f" in */__pycache__|*/controls.py) ;; *) ln -s "$f" "$SH/lib/py/bbx/" ;; esac; done
STRIP='    ctrls, none = declared(gate_path)'
n_strip="$(grep -cxF "$STRIP" "$BBX_HOME/lib/py/bbx/controls.py" || true)"
grep -vxF "$STRIP" "$BBX_HOME/lib/py/bbx/controls.py" > "$SH/lib/py/bbx/controls.py" || true
printf 'g_ok\n' > "$FR/tests/ci_portable.txt"
o="$(cd "$FR" && PYTHONDONTWRITEBYTECODE=1 "$SH/bin/bbx-run-static" --config "$FR/bbx.toml" --tier portable 2>&1)" && s=0 || s=$?
if [ "$n_strip" = 1 ] && [ "$s" = 1 ] && printf '%s\n' "$o" | grep -q "NameError" && printf '%s\n' "$o" | grep -q "^controls: the reader reported 0 of 1 gate(s) that ran" && printf '%s\n' "$o" | grep -q "^NOT GREEN"; then
    echo "CONTROL FIRED: reader-crash-is-red — the stripped reader crashed (NameError) before reporting g_ok, whose own control fired: NOT GREEN, exit 1"
else
    echo "CONTROL DEAD: reader-crash-is-red — stripped lines $n_strip, exit $s; $(printf '%s\n' "$o" | grep -E 'Error|^controls|GREEN' | tr '\n' '|')"
    fail "a crashed controls reader did not refuse the verdict"
fi

echo
[ "$rc" = 0 ] && echo "PASS: declared controls are read, dead ones refuse the verdict, silence is red under enforcement, a correct SKIP sets its declarations aside and nothing else (R48), --strict admits no exception, and an unfinished reader is red (G48)" || { echo "FAIL: see above"; exit 1; }
