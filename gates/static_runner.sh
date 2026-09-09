#!/bin/sh
# static_runner.sh — the static runner's verdicts, tally, exit status, --strict, MISSING, the anti-orphan report and the static-tier gating mean what they say
# Ground truth for bin/bbx-run-static, run against a SYNTHETIC consumer of stub gates of known
# verdicts through the REAL runner and its registries — never a copy of its logic. Sections
# lifted from bbh selftest/test_run_static.sh (lineage: VampireSaved test_static_runner.sh).
# Portable, ~3 s.
# Usage: gates/static_runner.sh
# MUST-FIRE: known-bad: skip-and-exit-2 — a gate that prints a SKIP marker and exits 2 must be FAIL in the runner's row and counted in FAIL, never SKIP
# MUST-FIRE: known-bad: strict-all-skip — an all-SKIP run must exit 0 plainly and non-zero under --strict, or --strict does nothing
#
set -eu
BBX_HOME="$(cd "$(dirname "$0")/.." && pwd)"; export BBX_HOME
rc=0
ok()   { printf '  ok    %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1"; rc=1; }
T="$(mktemp -d)"; trap 'rm -rf "$T"' EXIT INT TERM
FR="$T/fake"; mkdir -p "$FR/tests/lib"
cat > "$FR/bbx.toml" <<'EOF'
[project]
root = "."
instrument_word = "driver"
[registries]
portable = "tests/ci_portable.txt"
static = "tests/ci_static.txt"
static_needs_env = "FAKE_ROOT"
[tier]
patterns = ['FAKE_BIN', 'fakesys\.py']
source_regex = '^\s*\.\s+"?\$(?:REPO|\{REPO\})"?/(tests/lib/[a-z0-9_]+\.sh)'
source_depth = 2
EOF
RUN="$BBX_HOME/bin/bbx-run-static --config $FR/bbx.toml"

mk() {  # mk <name> <exit> <output...>
    n="$1"; st="$2"; shift 2
    { echo "#!/bin/sh"; for l in "$@"; do echo "echo '$l'"; done; echo "exit $st"; } > "$FR/tests/$n.sh"
    chmod +x "$FR/tests/$n.sh"
}
mk g_pass 0 "all good" "PASS: fine"
mk g_fail 1 "something broke" "FAIL: nope"
mk g_skip 0 "SKIP: no build at build/nope"
mk g_skip_indent 0 "  SKIP: indented skip marker"
mk g_prose 0 "checked 3 things, none had to be skipped" "PASS: prose only"
mk g_skip_fail 2 "  SKIPPED: no reference binary" "PARTIAL: the invariant was NOT run"
mk g_shellcrash 0 "tests/g_shellcrash.sh: line 3: FOO: set FOO to a dir OUTSIDE the repo"
mk g_segv_prose 0 "PASS: the summary line" "tests/g_segv_prose.sh: line 64:  2444 Segmentation fault: 11  REPLAY=x"
printf '#!/bin/sh\n. "$REPO/tests/lib/needs_fake.sh"\necho PASS\n' > "$FR/tests/g_needs_fake.sh"; chmod +x "$FR/tests/g_needs_fake.sh"
printf 'FAKE_BIN=x\n' > "$FR/tests/lib/needs_fake.sh"
printf 'g_pass\ng_fail\ng_skip\ng_skip_indent\ng_prose\ng_skip_fail\ng_shellcrash\ng_segv_prose\n' > "$FR/tests/ci_portable.txt"
: > "$FR/tests/ci_static.txt"

out="$(cd "$FR" && $RUN --tier portable 2>&1)" && st=0 || st=$?

echo "== 1. each verdict is classified correctly =="
check() {  # check <name> <expected-verdict>
    if printf '%s' "$out" | grep -qE "^  $1 +$2( |$)"; then ok "$1 -> $2"
    else fail "$1 was not classified $2:"; printf '%s' "$out" | grep -E "^  $1" | sed 's/^/        /'; fi
}
check g_pass PASS
check g_fail FAIL
check g_skip SKIP
check g_skip_indent SKIP
check g_prose PASS
check g_shellcrash FAIL
check g_segv_prose PASS
if printf '%s' "$out" | grep -qE "^  g_skip_fail +FAIL( |$)"; then
    echo "CONTROL FIRED: skip-and-exit-2 — g_skip_fail (SKIPPED marker, exit 2) is FAIL"
    ok "g_skip_fail -> FAIL (a SKIP marker plus a non-zero exit is a failure)"
else
    echo "CONTROL DEAD: skip-and-exit-2 — $(printf '%s' "$out" | grep -E '^  g_skip_fail' || echo 'no row')"
    fail "g_skip_fail was not FAIL"
fi

echo "== 2. the TALLY matches (the number a human reads) =="
printf '%s' "$out" | grep -q "PASS 3 .*SKIP 2 .*FAIL 3" \
    && ok "PASS 3  SKIP 2  FAIL 3 (the SKIP-and-exit-2 gate and the shell crash count FAIL)" \
    || fail "wrong tally: $(printf '%s' "$out" | grep -E '^PASS ' || echo '(none printed)')"

echo "== 3. a FAIL makes the runner exit nonzero =="
[ "$st" != 0 ] && ok "exit $st" || fail "the runner exited 0 with a failing gate"

echo "== 4. MUST-FIRE: an all-SKIP run is not GREEN under --strict =="
printf 'g_skip\ng_skip_indent\n' > "$FR/tests/ci_portable.txt"
o2="$(cd "$FR" && $RUN --tier portable 2>&1)" && s2=0 || s2=$?
o3="$(cd "$FR" && $RUN --tier portable --strict 2>&1)" && s3=0 || s3=$?
if [ "$s2" = 0 ] && printf '%s' "$o2" | grep -qE "SKIP 2" && [ "$s3" != 0 ]; then
    echo "CONTROL FIRED: strict-all-skip — plain run exit 0 with 'SKIP 2', --strict exit $s3"
    ok "without --strict the skips are legitimate and counted; --strict turns them into failure"
else
    echo "CONTROL DEAD: strict-all-skip — plain exit $s2, strict exit $s3"
    fail "--strict does not make SKIP fatal"
fi

echo "== 5. a registered-but-missing gate is MISSING, not silently dropped =="
printf 'g_pass\nno_such_gate\n' > "$FR/tests/ci_portable.txt"
o4="$(cd "$FR" && $RUN --tier portable 2>&1)" && s4=0 || s4=$?
printf '%s' "$o4" | grep -q "MISSING" && [ "$s4" != 0 ] && ok "reported MISSING and exited nonzero" \
    || fail "a registered gate that does not exist was ignored"

echo "== 6. the anti-orphan check =="
printf 'g_pass\n' > "$FR/tests/ci_portable.txt"
mk g_orphan 0 "PASS: nobody registered me"
o5="$(cd "$FR" && $RUN --tier portable 2>&1)"
printf '%s' "$o5" | grep -q "g_orphan" && ok "an unregistered driver-free gate is named" || fail "an unregistered gate was NOT reported"
printf '%s' "$o5" | grep -q "g_needs_fake" && fail "a gate reaching the driver through a sourced lib was nagged about" \
    || ok "a driver gate (reached only through a sourced lib) is left out of the nag list"
rm -f "$FR/tests/g_orphan.sh"

echo "== 7. the static tier is gated by static_needs_env, made absolute =="
printf '#!/bin/sh\ncase "${FAKE_ROOT:-}" in /*) echo "PASS: absolute";; *) echo "FAIL: relative or unset: ${FAKE_ROOT:-}"; exit 1;; esac\n' > "$FR/tests/g_abs.sh"
chmod +x "$FR/tests/g_abs.sh"
printf 'g_pass\n' > "$FR/tests/ci_portable.txt"; printf 'g_abs\n' > "$FR/tests/ci_static.txt"
o7="$(cd "$FR" && env -u FAKE_ROOT $RUN 2>&1)" && s7=0 || s7=$?
printf '%s' "$o7" | grep -q "NOT RUN: FAKE_ROOT is unset" && printf '%s' "$o7" | grep -q "SKIP 1 " \
    && ok "FAKE_ROOT unset: the static tier is NOT RUN and its gates count as SKIP" || fail "static tier gating: $(printf '%s' "$o7" | grep -E 'NOT RUN|^PASS')"
o8="$(cd "$FR" && FAKE_ROOT=. $RUN 2>&1)" && s8=0 || s8=$?
printf '%s' "$o8" | grep -qE "^  g_abs +PASS" && [ "$s8" = 0 ] \
    && ok "FAKE_ROOT set: the static tier runs, the variable reached the gate ABSOLUTE, the run is GREEN" || fail "static tier: $(printf '%s' "$o8" | grep g_abs)"
o9="$(cd "$FR" && FAKE_ROOT=/no/such/dir $RUN 2>&1)" && s9=0 || s9=$?
[ "$s9" = 2 ] && ok "an input dir that does not resolve is refused at the entrance (exit 2)" || fail "unresolvable FAKE_ROOT accepted (exit $s9)"

echo "== 8. --list prints the registries =="
o10="$(cd "$FR" && $RUN --list 2>&1)"
printf '%s' "$o10" | grep -q "portable (1):" && printf '%s' "$o10" | grep -q "static (1):" && ok "--list: portable (1) / static (1)" || fail "--list: $o10"

echo
[ "$rc" = 0 ] && echo "PASS: the runner's verdicts mean what they say." || { echo "FAIL: see above."; exit 1; }
