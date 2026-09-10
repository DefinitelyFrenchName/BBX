#!/bin/sh
# expectation_kinds.sh — every expectation kind is named from the profile's one table, a pending and an unknown kind make the enumeration red, a non-scenario stem is ignored, and a kind whose family the profile lacks is unknown under it
# Ground truth for lib/sh/expectation_kinds.sh and lib/py/bbx/expectations.py (abstraction E1, E2; R23). Cases lifted
# from bbh selftest/test_enumerate_expectations.sh at f675710 (lineage 14z-90, GitHub #17 there: an audit that read
# only *.masked put its blind spot over the one open regression); BBX adds the profile cases. No instrument. Portable, ~1 s (0.7 s measured 2026-09-10).
# Usage: gates/expectation_kinds.sh        (BBX_CONFIG is unset inside except where a case names one)
# MUST-FIRE: known-bad: pending-is-red — a `.pending` must be listed NOT-EVALUATED and make the enumeration non-zero, or an unratified pairing reads green (BBX-3)
# MUST-FIRE: known-bad: unknown-kind — a `.weird` must be listed UNKNOWN-KIND and make it non-zero, or a kind nobody registered is silently ignored
# MUST-FIRE: known-bad: family-absent — a `.masked` under a kind profile with no temporal family (`self`) must be UNKNOWN-KIND, or a profile inherits a family it never declared
# NOT-ASSERTED: the content of any expectation file: only its extension and its stem are read here
# NOT-ASSERTED: the suite's use of the dispositions (S2 step 3)
#
set -eu
BBX_HOME="$(cd "$(dirname "$0")/.." && pwd)"; export BBX_HOME
PYTHONPATH="$BBX_HOME/lib/py"; export PYTHONPATH
unset BBX_CONFIG BBH_CONFIG BBX_REPLAYS_DIR 2>/dev/null || true
. "$BBX_HOME/lib/sh/expectation_kinds.sh"
rc=0
ok()   { printf '  ok    %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1"; rc=1; }
W="$(mktemp -d)"; trap 'rm -rf "$W"' EXIT INT TERM
mkdir -p "$W/root/tests/replays" "$W/root/rpl2" "$W/exp"
for r in a b c d e; do : > "$W/root/tests/replays/$r.rpl"; done
: > "$W/root/rpl2/z.rpl"
echo "exact basis -" > "$W/exp/a.masked"; : > "$W/exp/b.skip"; : > "$W/exp/c.sha1"; : > "$W/exp/notareplay.masked"; echo "basis 42" > "$W/exp/d.diverge"

echo "== 1. the frame-driven profile's five kinds (bbh's) =="
t="$(python3 -m bbx.expectations kinds | tr '\t' ':' | tr '\n' ' ')"
[ "$t" = "skip:-:SKIP:- sha1:exact:N/A:log pending:-:NOT-EVALUATED:- masked:temporal:EVAL:log diverge:temporal:EVAL:log " ] && ok "the table (extension, family, disposition, view — D57): $t" || fail "the table: '$t'"
out="$(enumerate_expectations "$W/exp" "$W/root")" && r=0 || r=$?
[ "$r" = 0 ] && ok "four known kinds, no pending -> exit 0" || fail "exit $r on a clean dir"
[ "$out" = "$(printf 'a|masked|EVAL\nb|skip|SKIP\nc|sha1|N/A\nd|diverge|EVAL')" ] && ok "one line per expectation, kind and disposition named (bbh's lines)" || fail "output: $(printf '%s' "$out" | tr '\n' ';')"
printf '%s' "$out" | grep -q notareplay && fail "a file whose stem is not a scenario was listed" || ok "a non-scenario stem is ignored"
echo "== 2. CONTROL pending-is-red =="
rm "$W/exp/d.diverge"; echo "pending prose" > "$W/exp/d.pending"
if enumerate_expectations "$W/exp" "$W/root" > "$W/o2"; then fail "CONTROL DEAD: pending-is-red — a .pending did not make it non-zero"
elif grep -q "^d|pending|NOT-EVALUATED$" "$W/o2"; then echo "CONTROL FIRED: pending-is-red — $(grep '^d|' "$W/o2"), exit non-zero"
else fail "CONTROL DEAD: pending-is-red — non-zero but not named: $(tr '\n' ';' < "$W/o2")"; fi
echo "== 3. CONTROL unknown-kind =="
rm "$W/exp/d.pending"; : > "$W/exp/e.weird"
if enumerate_expectations "$W/exp" "$W/root" > "$W/o3"; then fail "CONTROL DEAD: unknown-kind — an unknown kind did not make it non-zero"
elif grep -q "^e|weird|UNKNOWN-KIND$" "$W/o3"; then echo "CONTROL FIRED: unknown-kind — $(grep '^e|' "$W/o3"), exit non-zero"
else fail "CONTROL DEAD: unknown-kind — non-zero but not named: $(tr '\n' ';' < "$W/o3")"; fi
rm "$W/exp/e.weird"
echo "== 4. the replays dir: the argument, then the environment =="
echo "exact basis -" > "$W/exp/z.masked"
out="$(enumerate_expectations "$W/exp" "$W/root" rpl2)"; [ "$out" = "z|masked|EVAL" ] && ok "a third argument selects the scenarios dir" || fail "argument dir: '$out'"
out="$(BBX_REPLAYS_DIR=rpl2 enumerate_expectations "$W/exp" "$W/root")"; [ "$out" = "z|masked|EVAL" ] && ok "BBX_REPLAYS_DIR selects it too" || fail "env dir: '$out'"
rm "$W/exp/z.masked"
echo "== 5. CONTROL family-absent: the kinds are the PROFILE's (R23) =="
printf '[project]\nkind = "self"\n' > "$W/self.toml"
t="$(BBX_CONFIG="$W/self.toml" python3 -m bbx.expectations kinds | cut -f1 | tr '\n' ' ')"
[ "$t" = "skip sha1 pending " ] && ok "the self profile carries the three kind-blind kinds only: $t" || fail "self kinds: '$t'"
if BBX_CONFIG="$W/self.toml" enumerate_expectations "$W/exp" "$W/root" > "$W/o5"; then fail "CONTROL DEAD: family-absent — a .masked under kind self was accepted"
elif grep -q "^a|masked|UNKNOWN-KIND$" "$W/o5" && grep -q "^b|skip|SKIP$" "$W/o5" && grep -q "^c|sha1|N/A$" "$W/o5"; then echo "CONTROL FIRED: family-absent — under kind self: $(tr '\n' ' ' < "$W/o5")"
else fail "CONTROL DEAD: family-absent — $(tr '\n' ';' < "$W/o5")"; fi

echo
[ "$rc" = 0 ] && echo "PASS: the expectation kinds are one table per profile, and nothing outside it is silently anything" || { echo "FAIL: see above"; exit 1; }
