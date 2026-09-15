#!/bin/sh
# static_runner.sh — the static runner's verdicts, tally, exit status, --strict, MISSING, the anti-orphan report and the static-tier gating mean what they say
# Ground truth for bin/bbx-run-static, run against a SYNTHETIC consumer of stub gates of known
# verdicts through the REAL runner and its registries — never a copy of its logic. Sections
# lifted from bbh selftest/test_run_static.sh (lineage: VampireSaved test_static_runner.sh).
# Portable, ~14 s (14.35 s at bbx-31 with K9's section, which runs the runner twice more).
# Usage: gates/static_runner.sh
# MUST-FIRE: known-bad: skip-and-exit-2 — a gate that prints a SKIP marker and exits 2 must be FAIL in the runner's row and counted in FAIL, never SKIP
# MUST-FIRE: known-bad: strict-all-skip — an all-SKIP run must exit 0 plainly and non-zero under --strict, or --strict does nothing
# MUST-FIRE: known-bad: residue-named — a gate that leaves a bare `mktemp -d` directory behind, run with [residue].note on, must be named on a host-residue NOTE with tmp=1 (the shim put it in the gate's own TMPDIR), and a clean gate on none (K9, R69)
# MUST-FIRE: known-bad: host-escape-counted — a gate that makes a directory by a template path in the host's temporary dir, which the shim leaves alone, must read tmp=0 and host of at least 1, or a form the shim misses reads as zero (R69, BBX-7)
# MUST-FIRE: known-bad: relative-template-untouched — a gate calling mktemp with a bare relative template must get a name in its working directory, never one under its TMPDIR, or the shim changes what a caller asked for
# MUST-FIRE: known-bad: note-off-keeps-lineage-text — the same leaking gate under a config with no [residue] section must print no host-residue line, or bbh's runner text changes under fidelity F13 (D90)
# NOT-ASSERTED: the sweep runner or any gate that needs an instrument: this is the pre-commit chain only
# NOT-ASSERTED: that every mktemp form a gate can write is contained: the shim adds -p only to a call naming no -p, no template and no path, and the host count sees an escape only as a tmp.* directory, only as a NOTE, and beside other processes' directories in the same window
# NOT-ASSERTED: a temporary file a gate writes by an absolute path of its own choosing outside its TMPDIR and the host's temporary dir
# NOT-ASSERTED: runtimes as anything but this host under this load
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

echo "== 9. K9: each gate's own TMPDIR and the mktemp shim; what it leaves is counted, removed and named (R65, R69) =="
HOSTT="$(getconf DARWIN_USER_TEMP_DIR 2>/dev/null || true)"; [ -n "$HOSTT" ] || HOSTT="${TMPDIR:-/tmp}"; HOSTT="${HOSTT%/}"
printf '#!/bin/sh\nd=$(mktemp -d) && echo "made $d" && echo "PASS: left a directory behind"\n' > "$FR/tests/g_leak.sh"
printf '#!/bin/sh\nd=$(mktemp -d "$RESIDUE_HOST/tmp.bbxescape.XXXXXX") && echo "$d" > "$RESIDUE_ESCAPED" && echo "PASS: escaped"\n' > "$FR/tests/g_escape.sh"
printf '#!/bin/sh\nf=$(mktemp tmp_rel.XXXXXX) || exit 1\ncase "$f" in */*) echo "FAIL: the relative template was moved to $f"; exit 1;; esac\n[ -f "$f" ] && rm -f "$f" && echo "PASS: $f in the working directory"\n' > "$FR/tests/g_rel.sh"
mk g_clean 0 "PASS: nothing left"
chmod +x "$FR/tests/g_leak.sh" "$FR/tests/g_escape.sh" "$FR/tests/g_rel.sh"
{ cat "$FR/bbx.toml"; printf '[residue]\nnote = true\n'; } > "$FR/residue_on.toml"
printf 'g_leak\ng_escape\ng_rel\ng_clean\n' > "$FR/tests/ci_portable.txt"; : > "$FR/tests/ci_static.txt"
o11="$(cd "$FR" && RESIDUE_HOST="$HOSTT" RESIDUE_ESCAPED="$T/escaped.txt" "$BBX_HOME/bin/bbx-run-static" --config "$FR/residue_on.toml" --tier portable 2>&1)" && s11=0 || s11=$?
_esc="$(cat "$T/escaped.txt" 2>/dev/null || true)"
case "$_esc" in "$HOSTT"/tmp.bbxescape.*) [ -d "$_esc" ] && rmdir "$_esc" && ok "the escaped directory is removed by its exact path: $_esc" || fail "the escaped directory $_esc was not there to remove" ;; *) fail "g_escape wrote no path under $HOSTT: '$_esc'" ;; esac
if printf '%s\n' "$o11" | grep -qE '^  g_leak +host-residue g_leak tmp=1 host=[0-9]+ ips=[0-9]+$' && ! printf '%s\n' "$o11" | grep -q 'host-residue g_clean'; then
    echo "CONTROL FIRED: residue-named — $(printf '%s\n' "$o11" | grep 'host-residue g_leak' | sed 's/^ *//')"
else
    echo "CONTROL DEAD: residue-named — $(printf '%s\n' "$o11" | grep -E 'host-residue|g_leak' | tr '\n' '|')"; fail "a leaking gate was not named with tmp=1, or a clean gate was"
fi
if printf '%s\n' "$o11" | grep -qE '^  g_escape +host-residue g_escape tmp=0 host=[1-9][0-9]* ips=[0-9]+$'; then
    echo "CONTROL FIRED: host-escape-counted — $(printf '%s\n' "$o11" | grep 'host-residue g_escape' | sed 's/^ *//')"
else
    echo "CONTROL DEAD: host-escape-counted — $(printf '%s\n' "$o11" | grep -E 'host-residue|g_escape' | tr '\n' '|')"; fail "an escape into the host's temporary dir was not counted"
fi
if printf '%s\n' "$o11" | grep -qE '^  g_rel +PASS'; then
    echo "CONTROL FIRED: relative-template-untouched — g_rel's bare relative template stayed in its working directory"
else
    echo "CONTROL DEAD: relative-template-untouched — $(printf '%s\n' "$o11" | grep -A2 -E '^  g_rel' | tr '\n' '|')"; fail "the shim moved a relative template"
fi
printf 'g_leak\ng_clean\n' > "$FR/tests/ci_portable.txt"
o12="$(cd "$FR" && "$BBX_HOME/bin/bbx-run-static" --config "$FR/bbx.toml" --tier portable 2>&1)" && s12=0 || s12=$?
if printf '%s\n' "$o12" | grep -qE '^  g_leak +PASS' && ! printf '%s\n' "$o12" | grep -q 'host-residue'; then
    echo "CONTROL FIRED: note-off-keeps-lineage-text — the leaking gate ran and no host-residue line was printed with [residue].note off"
else
    echo "CONTROL DEAD: note-off-keeps-lineage-text — $(printf '%s\n' "$o12" | grep -E 'host-residue|g_leak' | tr '\n' '|')"; fail "the NOTE printed with [residue].note off"
fi

echo
[ "$rc" = 0 ] && echo "PASS: the runner's verdicts mean what they say." || { echo "FAIL: see above."; exit 1; }
