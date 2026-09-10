#!/bin/sh
# cli_driver.sh — the command-line driver's log equals every truth log of the fixture byte for byte, twice, with two points re-hashed by a second implementation; a crash is apart from a refusal, the scenario grammar is refused where it must be, the sandbox holds what the tool writes, the scrub keeps the caller's shell out and lets the scenario's [env] in, a declared file not produced discards the run, and the timeout kills a tool that sleeps
# Ground truth for drivers/cli.sh and the driver's core in lib/py/bbx/cli.py (docs/plans/S4.md step 2, §3 "D1–D5", "O1",
# "O5", "O6", §5's seven driver rows; R35; D46, D47, D51, D52). The driver runs on the TREE's fixture (read-only) for the
# positive checks and on COPIES under TMPDIR for every control; every perturbation is proven to have applied before its
# assertion (VampireSaved test_checkdocs_rom.sh's practice). The truth log is the GENERATOR's, from the design — so a
# log that equals it is the driver agreeing with the design, never with itself; and two points of it are re-hashed here
# by `shasum` (perl's Digest::SHA, not hashlib): the one writer checked by a second implementation (BBX-15). No comparator
# (step 3): the gate compares with cmp/diff and names the index itself. No instrument. Portable, ~10 s (real 10.26 measured
# 2026-09-10 on this host: ~40 driver runs, python start-up dominated, plus the timeout control's 1 s kill and 1 s sleep).
# Usage: gates/cli_driver.sh
# MUST-FIRE: known-bad: crash-vs-exit — a scenario copy with `--crash-at 3` must make the driver exit 2 with the log ending `END-CRASH 3` and exactly the 3 lines before the death kept, while the tree's `05_exit_1` (the tool's ordinary exit 1) is exit 0 with `0 exit:1` first and equals its truth, or a crash and a refusal are one report (BBX-4, D4)
# MUST-FIRE: known-bad: wrong-truth — `06_unknown_option` (the tool refuses `--colour`, exit 2) must equal its truth and a truth copy with `0 exit:0` at index 0 must differ from the log at line 1 and nowhere else, or the known positive is not one (BBX-5, BBX-2)
# MUST-FIRE: known-bad: unknown-scenario-key — a scenario copy carrying a key the grammar does not have (`argz`) must be REFUSED naming it, exit 3, no log, or a scenario is silently measured with less than it asked (D46; SMS cliguard on the scenario grammar)
# MUST-FIRE: perturbed-copy: sandbox-both-ways — a scenario copy with `--write-home` must leave `$HOME/.fakecli` in the SANDBOX and never in the caller's HOME (proven absent before and after), and the same copy with no sandbox argument must run in a fresh temp dir that is removed, or a tool's home state leaks between runs or onto the host (D52, [BBH-36])
# MUST-FIRE: known-bad: env-scrub — FAKECLI_SALT in the caller's environment must change the tool's output when the tool is called DIRECTLY (the premise, measured first) and not through the driver (the log equals the unsalted truth), while `09_env`'s [env] table must reach it (its truth expects the salted line) with env.txt exactly D6's set plus the table, or the scrub is decoration (O5, D6, D52)
# MUST-FIRE: known-bad: uncaptured-emitted-file — `07_emit_file` on a copy whose args drop `--emit` must exit 1 naming `report.json` as not produced with no log, while the tree's scenario carries the file's hash as a `file` point, or a declared artifact the tool did not write reads as an observation (BBX-7)
# MUST-FIRE: known-bad: timeout — a scenario copy that sleeps 5 s under a wrapper driver exporting CLI_TIMEOUT=1 must exit 1 naming the timeout with no log, and one that sleeps 1 s under CLI_TIMEOUT=10 must exit 0, or a hung tool is a run that never ends or a killed one is read as a finding (D51, [BBH-13])
# NOT-ASSERTED: the verdict text of the exact, set, schema and band comparators over these logs (S4 step 3): the truth is compared here with cmp and diff
# NOT-ASSERTED: the suite over the fixture (identity, the kinds loop, RUN-FAIL on a crash, the band NOTE on the screen): S4 step 4
# NOT-ASSERTED: performance, behaviour on inputs outside the scenarios, and anything the tool wrote that the scenario did not declare
# NOT-ASSERTED: a tool that is a directory, a non-UTF-8 output, an emitted TREE, a fractional band (docs/plans/S4.md §9): a consumer's question, refused or discarded here, never measured
#
set -eu
BBX_HOME="$(cd "$(dirname "$0")/.." && pwd)"; export BBX_HOME
PYTHONPATH="$BBX_HOME/lib/py"; export PYTHONPATH
PYTHONDONTWRITEBYTECODE=1; export PYTHONDONTWRITEBYTECODE
unset BBX_CONFIG BBH_CONFIG CLI_PATH CLI_NONDET CLI_TIMEOUT CLI_KEEP_ENV FAKECLI_SALT DOCSET_NONDET DOCSET_VIEW DOCSET_FORMS MASK_RANGES DUMPS POKES SNAP_FRAMES VIDEO_OUT INPUT_OUT TAIL_FRAMES INPUT_INJECT_TEST NO_INPUT_CHECK 2>/dev/null || true
F="$BBX_HOME/fixture/fakecli"; DRV="$BBX_HOME/drivers/cli.sh"; TRUTH="$F/expected/fixture/logs"; SC="$F/scenarios"; TOOL="$F/subject/fakecli.py"
rc=0
ok()   { printf '  ok    %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1"; rc=1; }
W="$(mktemp -d)"; trap 'rm -rf "$W"' EXIT INT TERM
SB=""
drv() {   # drv <search-path> <scenario> <out> [VAR=value ...] -> the driver's output in $out; status in $s; $SB the sandbox arg
    _p="$1"; _c="$2"; _o="$3"; shift 3
    if [ -n "$SB" ]; then
        if out="$(env CLI_PATH="$_p" "$@" "$DRV" fakecli "$_c" "$_o" "$SB" 2>&1)"; then s=0; else s=$?; fi
    else
        if out="$(env CLI_PATH="$_p" "$@" "$DRV" fakecli "$_c" "$_o" 2>&1)"; then s=0; else s=$?; fi
    fi
}
sha_sh() { printf '%s' "$1" | shasum | cut -c1-40; }          # the second implementation (perl Digest::SHA)
token_at() { awk -v i="$2" '$1 == i { print $2 }' "$1"; }    # the token of one index, by field
copy_scenario() { sed "s/^args = .*/args = [$2]/" "$SC/$1.cli" > "$3"; }

echo "== 1. the core's self-test, standalone =="
o="$(python3 -m bbx.cli selftest 2>&1)" && ok "$o" || fail "self-test: $o"
command -v shasum > /dev/null 2>&1 || { echo "SKIP: shasum is not on this host (the second SHA-1 implementation the gate re-hashes with)"; exit 0; }

echo "== 2. every scenario of the tree's fixture: the driver's log EQUALS the generator's truth, byte for byte, twice =="
for sc in 01_list 02_unordered 03_show_json 04_band 05_exit_1 06_unknown_option 07_emit_file 08_join_stdin 09_env; do
    drv "$F/subject" "$SC/$sc.cli" "$W/$sc.1.log"; [ "$s" = 0 ] || { fail "$sc run 1: exit $s: $out"; continue; }
    drv "$F/subject" "$SC/$sc.cli" "$W/$sc.2.log"; [ "$s" = 0 ] || { fail "$sc run 2: exit $s: $out"; continue; }
    cmp -s "$W/$sc.1.log" "$W/$sc.2.log" && ok "$sc: two runs, byte-identical (BBX-14)" || fail "$sc: the two runs differ"
    if cmp -s "$W/$sc.1.log" "$TRUTH/$sc.log"; then ok "$sc: the log EQUALS the generator's truth ($(head -1 "$W/$sc.1.log"); $(tail -1 "$W/$sc.1.log"))"
    else fail "$sc: the log differs from the truth: $(diff "$TRUTH/$sc.log" "$W/$sc.1.log" | head -2 | tr '\n' ' ')"; fi
    n="$(tail -1 "$W/$sc.1.log" | awk '{print $2}')"; m="$(grep -vc '^END \|^0 exit:' "$W/$sc.1.log" | tr -d ' ')"
    [ "$n" = "$m" ] && ok "$sc: END $n equals the point lines after the exit point ($m)" || fail "$sc: END $n but $m point lines"
done
echo "-- two points re-hashed by a second implementation (BBX-15) --"
line1="$(env -i PATH=/usr/bin:/bin:/usr/sbin:/sbin HOME="$W" python3 "$TOOL" list | head -1)"
[ -n "$line1" ] && [ "$(token_at "$W/01_list.1.log" 1)" = "line:$(sha_sh "$line1")" ] \
    && ok "01_list index 1: shasum('$line1') equals the driver's token (and the truth's)" || fail "01_list index 1: shasum of the tool's first line ('$line1') is not the token $(token_at "$W/01_list.1.log" 1)"
[ "$(token_at "$W/03_show_json.1.log" 2)" = "field:name:$(sha_sh '"Maren"')" ] \
    && ok "03_show_json index 2: shasum of the canonical JSON value '\"Maren\"' equals the driver's field token" || fail "03_show_json index 2: $(token_at "$W/03_show_json.1.log" 2) is not shasum('\"Maren\"')"
echo "-- the band view and the summary --"
[ -f "$W/04_band.1.log.bands" ] && [ "$(cat "$W/04_band.1.log.bands" | tr '\n' ' ')" = "1 size=$(python3 -c 'print(231 + (4 * 29) % 41)') END 1 " ] \
    && ok "04_band: the band view holds the field's value ($(head -1 "$W/04_band.1.log.bands")) and END 1; the log's token is the constant $(token_at "$W/04_band.1.log" 2)" || fail "04_band: the band view: $(cat "$W/04_band.1.log.bands" 2>&1 | tr '\n' ' ')"
[ ! -f "$W/01_list.1.log.bands" ] && ok "01_list: no band view for a scenario with no band field" || fail "01_list has a band view"
for pair in "04_band:NOTE: band-fields 1" "07_emit_file:NOTE: emitted-files 1" "05_exit_1:NOTE: exit 1" "06_unknown_option:NOTE: exit 2" "01_list:NOTE: band-fields 0"; do
    sc="${pair%%:*}"; want="${pair#*:}"
    o="$(python3 -m bbx.cli summary "$W/$sc.1.log" 2>&1)" && printf '%s\n' "$o" | grep -qx "$want" && ok "summary $sc: $want" || fail "summary $sc: wanted '$want', got: $(printf '%s' "$o" | tr '\n' ' ')"
done
echo "-- O5: what the driver fed is recorded in a named sandbox --"
mkdir -p "$W/sb08"; SB="$W/sb08"; drv "$F/subject" "$SC/08_join_stdin.cli" "$W/sb08.log"; SB=""
[ "$s" = 0 ] && [ "$(tail -1 "$W/sb08/argv.txt")" = join ] && [ "$(printf 'juniper\nalder\nrowan\n' | cmp -s - "$W/sb08/stdin.bin" && echo same)" = same ] \
    && ok "08_join_stdin: argv.txt ends with the scenario's args, stdin.bin is the scenario's three lines" || fail "08_join_stdin's records: exit $s, argv tail '$(tail -1 "$W/sb08/argv.txt" 2>&1)'"
[ -f "$W/sb08/cli_selftest.txt" ] && ok "the sandbox holds the self-test's output" || fail "no cli_selftest.txt in the sandbox"
echo "-- CLI_NONDET, the search path, the refusals --"
drv "$F/subject" "$SC/01_list.cli" "$W/nd1.log" CLI_NONDET=1; drv "$F/subject" "$SC/01_list.cli" "$W/nd2.log" CLI_NONDET=1
{ [ "$s" = 0 ] && ! cmp -s "$W/nd1.log" "$W/nd2.log"; } && ok "CLI_NONDET=1: two runs differ (the driver-side nondeterminism knob is live; the suite scrubs it, D45)" || fail "CLI_NONDET=1 did not move the log"
drv "$W/nowhere;$F/subject" "$SC/02_unordered.cli" "$W/sp.log"
[ "$s" = 0 ] && cmp -s "$W/sp.log" "$TRUTH/02_unordered.log" && ok "a two-component CLI_PATH resolves the second component" || fail "two-component CLI_PATH: exit $s: $out"
drv "$W/nowhere" "$SC/02_unordered.cli" "$W/np.log"; [ "$s" = 1 ] && [ ! -f "$W/np.log" ] && ok "no tool on the path: exit 1, no log ($out)" || fail "missing tool: exit $s"
mkdir -p "$W/exe"; printf '#!/bin/sh\necho hello\n' > "$W/exe/fakecli"; chmod +x "$W/exe/fakecli"
drv "$W/exe" "$SC/01_list.cli" "$W/exe.log"
[ "$s" = 0 ] && [ "$(token_at "$W/exe.log" 1)" = "line:$(sha_sh hello)" ] && ok "an executable <set> (an sh script) runs as itself: its one line's token is shasum('hello')" || fail "executable <set>: exit $s, $(cat "$W/exe.log" 2>&1 | tr '\n' ' ')"
printf '[env]\nX = "1"\n' > "$W/noscen.cli"
drv "$F/subject" "$W/noscen.cli" "$W/noscen.log"; [ "$s" = 1 ] && [ ! -f "$W/noscen.log" ] && ok "a scenario with no [scenario] table: exit 1 (DISCARDED): $out" || fail "malformed scenario: exit $s: $out"
for v in MASK_RANGES=043c-043d POKES=50:1000:ff GUARD_DEBUG=1 DOCSET_VIEW=second CLI_KEEP_ENV=1 CLI_TIMEOUT=soon; do
    drv "$F/subject" "$SC/01_list.cli" "$W/ref.log" "$v"
    [ "$s" = 3 ] && [ ! -f "$W/ref.log" ] && printf '%s' "$out" | grep -q "^REFUSED: drivers/cli.sh cannot honour ${v%%=*}" && ok "${v%%=*}: REFUSED, exit 3, no log" || fail "${v%%=*}: exit $s: $out"
done
drv "$F/subject" "$SC/01_list.cli" "$W/em.log" MASK_RANGES=; [ "$s" = 0 ] && ok "an EMPTY MASK_RANGES (what the suite exports for a maskless kind, D26) is not a refusal" || fail "empty MASK_RANGES: exit $s: $out"

echo "== 3. must-fire controls, each on a COPY =="
echo "-- crash-vs-exit --"
copy_scenario 01_list '"list", "--crash-at", "3"' "$W/crash.cli"
if cmp -s "$W/crash.cli" "$SC/01_list.cli"; then fail "CONTROL DEAD: crash-vs-exit — the perturbation did not apply"; else
    drv "$F/subject" "$W/crash.cli" "$W/crash.log"
    if [ "$s" = 2 ] && [ "$(tail -1 "$W/crash.log")" = "END-CRASH 3" ] && [ "$(tail -2 "$W/crash.log" | head -1)" = "CRASH signal:6:SIGABRT" ] \
       && [ "$(grep -c '^[0-9]* line:' "$W/crash.log")" = 3 ] && [ "$(token_at "$W/crash.log" 3)" = "$(token_at "$W/01_list.1.log" 3)" ] \
       && [ "$(head -1 "$W/05_exit_1.1.log")" = "0 exit:1" ] && cmp -s "$W/05_exit_1.1.log" "$TRUTH/05_exit_1.log"; then
        echo "CONTROL FIRED: crash-vs-exit — --crash-at 3: exit 2, the log ends CRASH signal:6:SIGABRT / END-CRASH 3 with the 3 lines before the death kept (line 3 the truth's); 05_exit_1: exit 0, '0 exit:1' first, equal to its truth"
    else fail "CONTROL DEAD: crash-vs-exit — exit $s: $out; log: $(cat "$W/crash.log" 2>&1 | tail -3 | tr '\n' ' ')"; fi; fi
echo "-- wrong-truth --"
sed 's/^0 exit:2$/0 exit:0/' "$TRUTH/06_unknown_option.log" > "$W/truth06.log"
if cmp -s "$W/truth06.log" "$TRUTH/06_unknown_option.log"; then fail "CONTROL DEAD: wrong-truth — the truth copy was not perturbed"; else
    c="$(cmp "$W/06_unknown_option.1.log" "$W/truth06.log" 2>&1 || true)"; d="$(diff "$W/06_unknown_option.1.log" "$W/truth06.log" | grep -c '^[<>]' || true)"
    if cmp -s "$W/06_unknown_option.1.log" "$TRUTH/06_unknown_option.log" && [ "$(head -1 "$W/06_unknown_option.1.log")" = "0 exit:2" ] \
       && printf '%s' "$c" | grep -q 'line 1' && [ "$d" = 2 ]; then
        echo "CONTROL FIRED: wrong-truth — 06_unknown_option is GREEN (the tool's refusal, '0 exit:2' and one err point, is the truth); a truth rewritten '0 exit:0' differs from the log at line 1 and nowhere else"
    else fail "CONTROL DEAD: wrong-truth — cmp: $c; $d differing lines"; fi; fi
echo "-- unknown-scenario-key --"
sed 's/^args = /argz = /' "$SC/01_list.cli" > "$W/argz.cli"
if ! grep -q '^argz = ' "$W/argz.cli"; then fail "CONTROL DEAD: unknown-scenario-key — the perturbation did not apply"; else
    drv "$F/subject" "$W/argz.cli" "$W/argz.log"
    if [ "$s" = 3 ] && [ ! -f "$W/argz.log" ] && printf '%s' "$out" | grep -q "^REFUSED: drivers/cli.sh cannot honour scenario key 'argz'"; then
        echo "CONTROL FIRED: unknown-scenario-key — $(printf '%s' "$out" | head -1 | cut -c1-100); exit 3, no log"
    else fail "CONTROL DEAD: unknown-scenario-key — exit $s: $out"; fi; fi
echo "-- sandbox-both-ways --"
copy_scenario 01_list '"list", "--write-home"' "$W/home.cli"
if cmp -s "$W/home.cli" "$SC/01_list.cli"; then fail "CONTROL DEAD: sandbox-both-ways — the perturbation did not apply"
elif [ -e "$HOME/.fakecli" ]; then fail "CONTROL DEAD: sandbox-both-ways — the caller's HOME already has .fakecli; the control cannot prove the driver did not write it"; else
    mkdir -p "$W/sbh"; SB="$W/sbh"; drv "$F/subject" "$W/home.cli" "$W/home.log"; SB=""; s1="$s"
    mkdir -p "$W/tmp"; drv "$F/subject" "$W/home.cli" "$W/home2.log" TMPDIR="$W/tmp"; s2="$s"
    left="$(find "$W/tmp" -mindepth 1 | wc -l | tr -d ' ')"
    if [ "$s1" = 0 ] && [ "$(cat "$W/sbh/.fakecli")" = visited ] && [ ! -e "$HOME/.fakecli" ] && cmp -s "$W/home.log" "$TRUTH/01_list.log" \
       && [ "$s2" = 0 ] && [ "$left" = 0 ] && cmp -s "$W/home2.log" "$TRUTH/01_list.log"; then
        echo "CONTROL FIRED: sandbox-both-ways — --write-home wrote .fakecli in the SANDBOX (visited) and not in the caller's HOME (absent before and after); with no sandbox argument the fresh temp dir under TMPDIR was removed (0 entries left) and the log is the truth"
    else fail "CONTROL DEAD: sandbox-both-ways — exits $s1/$s2, sandbox .fakecli '$(cat "$W/sbh/.fakecli" 2>&1)', HOME/.fakecli $([ -e "$HOME/.fakecli" ] && echo PRESENT || echo absent), temp entries left $left"; fi; fi
echo "-- env-scrub --"
direct="$(env -i PATH=/usr/bin:/bin:/usr/sbin:/sbin HOME="$W" FAKECLI_SALT=7 python3 "$TOOL" list | tail -1)"
plain="$(env -i PATH=/usr/bin:/bin:/usr/sbin:/sbin HOME="$W" python3 "$TOOL" list | tail -1)"
if [ "$direct" != "salt=7" ] || [ "$plain" = "salt=7" ]; then fail "CONTROL DEAD: env-scrub — the premise failed: the tool called directly under FAKECLI_SALT=7 printed '$direct' (without: '$plain')"; else
    drv "$F/subject" "$SC/01_list.cli" "$W/scrub.log" FAKECLI_SALT=7; s1="$s"
    mkdir -p "$W/sb09"; SB="$W/sb09"; drv "$F/subject" "$SC/09_env.cli" "$W/env9.log" FAKECLI_SALT=7; SB=""; s2="$s"
    sbp="$(cd "$W/sb09" && pwd -P)"
    printf 'FAKECLI_SALT=9\nHOME=%s\nLANG=C.UTF-8\nLC_ALL=C.UTF-8\nPATH=/usr/bin:/bin:/usr/sbin:/sbin\nPYTHONDONTWRITEBYTECODE=1\nTMPDIR=%s\n' "$sbp" "$sbp" > "$W/env9.want"
    if [ "$s1" = 0 ] && cmp -s "$W/scrub.log" "$TRUTH/01_list.log" && [ "$s2" = 0 ] && cmp -s "$W/env9.log" "$TRUTH/09_env.log" \
       && [ "$(token_at "$W/env9.log" 10)" = "line:$(sha_sh 'salt=9')" ] && cmp -s "$W/sb09/env.txt" "$W/env9.want"; then
        echo "CONTROL FIRED: env-scrub — FAKECLI_SALT=7 moves the tool's output when called directly ('$direct') and not through the driver (the log is the unsalted truth); 09_env's [env] table reaches it (index 10 is shasum('salt=9'), the truth's) with env.txt exactly D6's set plus FAKECLI_SALT=9"
    else fail "CONTROL DEAD: env-scrub — exits $s1/$s2; env.txt: $(diff "$W/env9.want" "$W/sb09/env.txt" 2>&1 | tr '\n' ' ')"; fi; fi
echo "-- uncaptured-emitted-file --"
copy_scenario 07_emit_file '"report"' "$W/noemit.cli"
if cmp -s "$W/noemit.cli" "$SC/07_emit_file.cli"; then fail "CONTROL DEAD: uncaptured-emitted-file — the perturbation did not apply"; else
    drv "$F/subject" "$W/noemit.cli" "$W/noemit.log"
    if [ "$s" = 1 ] && [ ! -f "$W/noemit.log" ] && printf '%s' "$out" | grep -q "declared emitted file 'report.json' not produced" \
       && [ "$(token_at "$W/07_emit_file.1.log" 2 | cut -d: -f1-2)" = "file:report.json" ]; then
        echo "CONTROL FIRED: uncaptured-emitted-file — args without --emit: exit 1, 'report.json' named as not produced, no log (DISCARDED); the tree's 07_emit_file carries file:report.json:<sha1> at index 2"
    else fail "CONTROL DEAD: uncaptured-emitted-file — exit $s: $out"; fi; fi
echo "-- timeout --"
printf '#!/bin/sh\nCLI_TIMEOUT="${WRAP_TIMEOUT:-1}"; export CLI_TIMEOUT\nexec "%s" "$@"\n' "$DRV" > "$W/wrap.sh"; chmod +x "$W/wrap.sh"
copy_scenario 01_list '"list", "--sleep", "5"' "$W/sleep5.cli"; copy_scenario 01_list '"list", "--sleep", "1"' "$W/sleep1.cli"
if cmp -s "$W/sleep5.cli" "$SC/01_list.cli" || ! grep -q '"--sleep", "5"' "$W/sleep5.cli"; then fail "CONTROL DEAD: timeout — the perturbation did not apply"; else
    if out="$(env CLI_PATH="$F/subject" WRAP_TIMEOUT=1 "$W/wrap.sh" fakecli "$W/sleep5.cli" "$W/sleep5.log" 2>&1)"; then s1=0; else s1=$?; fi; o1="$out"
    if out="$(env CLI_PATH="$F/subject" WRAP_TIMEOUT=10 "$W/wrap.sh" fakecli "$W/sleep1.cli" "$W/sleep1.log" 2>&1)"; then s2=0; else s2=$?; fi; o2="$out"
    if [ "$s1" = 1 ] && [ ! -f "$W/sleep5.log" ] && printf '%s' "$o1" | grep -q "timeout: the tool ran longer than 1 s" \
       && [ "$s2" = 0 ] && cmp -s "$W/sleep1.log" "$TRUTH/01_list.log"; then
        echo "CONTROL FIRED: timeout — --sleep 5 under CLI_TIMEOUT=1 (a wrapper driver): exit 1 naming the timeout, no log; --sleep 1 under CLI_TIMEOUT=10: exit 0, the log is the truth"
    else fail "CONTROL DEAD: timeout — exits $s1/$s2: $o1 | $o2"; fi; fi

echo
if [ "$rc" = 0 ]; then echo "PASS: the command-line driver's log equals every truth log twice, two points re-hashed by shasum; the crash, the grammar, the sandbox, the scrub, the emitted file and the timeout hold; 7 controls fired"; else echo "FAIL: see above"; fi
exit "$rc"
