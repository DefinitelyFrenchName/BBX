#!/bin/sh
# classify.sh — the verdict classifier's verdicts mean what they say, in both directions
# Ground truth for lib/sh/classify.sh through bin/bbx-classify: every verdict case both
# runners depend on, each with a case that must NOT produce it (BBX-2: verdict logic is
# validated both ways). Cases lifted from bbh selftest/test_classify.sh, whose lineage is
# VampireSaved's test_static_runner.sh §1 and test_emulator_runner.sh §12: the SKIP-in-prose
# case, the SKIP-and-exit-2 case, the exit-0-after-a-shell-error case and its benign
# segfault look-alike were each paid for. Portable, ~1 s.
# Usage: gates/classify.sh
# MUST-FIRE: known-bad: config-reaches-classifier — a consumer [classify] with another skip marker must change the verdict of a `SKIP:` log from SKIP to PASS, and its own marker must read SKIP
# NOT-ASSERTED: that a verdict word printed by a gate outside the runner is read at all: the classifier reads exit status first, then the log; a PASS printed after a non-zero exit is FAIL by design
#
set -eu
BBX_HOME="$(cd "$(dirname "$0")/.." && pwd)"; export BBX_HOME
rc=0
ok()   { printf '  ok    %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1"; rc=1; }
W="$(mktemp -d)"; trap 'rm -rf "$W"' EXIT INT TERM

case_() {  # case_ <label> <exit> <expected-verdict> <log lines...>
    _l="$1"; _st="$2"; _exp="$3"; shift 3
    : > "$W/log"; for line in "$@"; do printf '%s\n' "$line" >> "$W/log"; done
    _got="$("$BBX_HOME/bin/bbx-classify" "$_st" "$W/log" | cut -f1)"
    [ "$_got" = "$_exp" ] && ok "$_l -> $_exp" || fail "$_l: got $_got, expected $_exp"
}
echo "== 1. the verdict cases, both directions =="
case_ "exit 0, PASS line"                 0 PASS "all good" "PASS: fine"
case_ "exit 1, FAIL line"                 1 FAIL "something broke" "FAIL: nope"
case_ "exit 0, SKIP marker"               0 SKIP "SKIP: no build at build/nope"
case_ "exit 0, indented SKIP marker"      0 SKIP "  SKIP: indented"
case_ "exit 0, SKIP only in prose"        0 PASS "checked 3 things, none had to be skipped" "PASS: prose only"
case_ "SKIP marker AND exit 2"            2 FAIL "  SKIPPED: no reference binary" "PARTIAL: the invariant was NOT run"
case_ "exit 124 (timeout)"              124 TIMEOUT "partial output"
case_ "exit 137 (timeout -k)"           137 TIMEOUT ""
case_ "exit 1 is FAIL, not TIMEOUT"       1 FAIL "killed? no: a plain failure"
case_ "exit 0 after a shell error"        0 FAIL "gates/g.sh: line 3: FOO: set FOO to a dir OUTSIDE the repo"
case_ "exit 0, benign teardown segfault"  0 PASS "PASS: the summary line" "gates/g.sh: line 64:  2444 Segmentation fault: 11  REPLAY=x"
case_ "exit 0, empty log"                 0 PASS
case_ "SETUP-FAIL marker, exit 1 (R13: a sub-outcome of FAIL, never a fifth word)" 1 FAIL "SETUP-FAIL: the fixture did not stage"

echo "== 2. the detail line =="
printf 'SKIP: reason one\nSKIP: reason two\n' > "$W/log"
d="$("$BBX_HOME/bin/bbx-classify" 0 "$W/log" | cut -f2)"
[ "$d" = "SKIP: reason one" ] && ok "SKIP detail is the FIRST marker line" || fail "SKIP detail '$d'"
printf 'x\nFAIL: the real reason\n' > "$W/log"
d="$("$BBX_HOME/bin/bbx-classify" 1 "$W/log" | cut -f2)"
[ "$d" = "exit 1: FAIL: the real reason" ] && ok "FAIL detail carries the exit and the last FAIL line" || fail "FAIL detail '$d'"
printf 'SKIP: %s\n' "$(printf 'x%.0s' $(seq 1 120))" > "$W/log"
d="$("$BBX_HOME/bin/bbx-classify" 0 "$W/log" --width 20 | cut -f2)"
[ "${#d}" = 20 ] && ok "--width cuts the detail (20 chars)" || fail "--width ignored: ${#d} chars"

echo "== 3. MUST-FIRE: the config reaches the classifier =="
mkdir -p "$W/c/tests"
printf '[classify]\nskip_regex = "^SKIPPED"\ntimeout_exits = [99]\n' > "$W/c/bbx.toml"
printf 'SKIP: the default marker\n' > "$W/log"
v1="$("$BBX_HOME/bin/bbx-classify" 0 "$W/log" --config "$W/c/bbx.toml" | cut -f1)"
printf 'SKIPPED: theirs\n' > "$W/log"
v2="$("$BBX_HOME/bin/bbx-classify" 0 "$W/log" --config "$W/c/bbx.toml" | cut -f1)"
v3="$("$BBX_HOME/bin/bbx-classify" 99 "$W/log" --config "$W/c/bbx.toml" | cut -f1)"
v4="$("$BBX_HOME/bin/bbx-classify" 124 "$W/log" --config "$W/c/bbx.toml" | cut -f1)"
if [ "$v1" = PASS ] && [ "$v2" = SKIP ] && [ "$v3" = TIMEOUT ] && [ "$v4" = FAIL ]; then
    echo "CONTROL FIRED: config-reaches-classifier — 'SKIP:' read PASS under a consumer skip_regex, 'SKIPPED:' read SKIP, exit 99 read TIMEOUT, exit 124 read FAIL"
    ok "a consumer [classify] replaces every default it names, and only those"
else
    echo "CONTROL DEAD: config-reaches-classifier — got $v1 $v2 $v3 $v4, expected PASS SKIP TIMEOUT FAIL"
    fail "the config did not reach the classifier"
fi

echo
[ "$rc" = 0 ] && echo "PASS: the classifier's verdicts mean what they say, in both directions" || { echo "FAIL: see above"; exit 1; }
