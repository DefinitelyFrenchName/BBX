#!/bin/sh
# cli.sh — THE COMMAND-LINE DRIVER: drivers/README.md's contract over a TOOL — an executable, or a
# python3 script, found on a search path — so the suite, the comparators and the gates run end to end
# over a subject that is executable but not frame-driven (docs/plans/S4.md §3 "D1–D5", "O5", "O6";
# R35; D46, D51, D52). The core is lib/py/bbx/cli.py; this file is the contract's face.
#
# Usage: CLI_PATH="<dir>[;<dir>]" drivers/cli.sh <set> <scenario.cli> <out.log> [sandbox]
#   env CLI_PATH      the search path: per directory an executable `<set>` wins over `<set>.py`, and the
#                     first directory that has either wins (resolved by bbx.cli resolve, the one resolver);
#                     a `<set>.py` runs under the harness's own python3, never one the pinned PATH finds
#   env CLI_NONDET    1 salts every hashed token with the clock — the kind's NONDETERMINISTIC control on
#                     the driver's side (bbh's FAKE_NONDET analogue; the suite scrubs it, D45 hermetic_unset)
#   env CLI_TIMEOUT   seconds the tool may run, default 60 (D51, arbitrary); elapsed: the tool is killed,
#                     no log is written, exit 1 — the run is DISCARDED
#   env CLI_KEEP_ENV  REFUSED: in S4 the subject sees exactly D6's hermetic set plus the scenario's [env]
#                     table and nothing from the caller (D52); a knob that would let the caller's shell
#                     reach the tool is refused, never ignored, so a consumer's need is loud (D3)
#
# The sandbox is the tool's WORKING DIRECTORY (the scenario's `cwd` under it), its HOME and its TMPDIR —
# a fresh `mktemp -d` when omitted, removed after the run [BBH-36]; a NAMED sandbox is deliberate carry-over
# and keeps what the driver fed the tool: argv.txt, stdin.bin, env.txt (O5), and cli_selftest.txt.
#
# REFUSES the frame-driven family (MASK_RANGES, DUMPS, POKES, SNAP_FRAMES, VIDEO_OUT, INPUT_OUT,
# TAIL_FRAMES, INPUT_INJECT_TEST, NO_INPUT_CHECK), the guard family (GUARD_*, CRASH_VECTORS, CODE_RANGES)
# and the document-set family (DOCSET_NONDET, DOCSET_VIEW, DOCSET_FORMS) with exit 3: a tool has no frames,
# no RAM, no debugger and no claim forms, and a caller that set one is measuring something this run would
# silently not measure [BBH-28]. A scenario key the grammar does not have is refused the same way (D46).
#
# What the run does, in order: the core's SELF-TEST (exit 1 naming what broke — before the tool is run);
# the out file, `<out>.bands` and `<out>.json` removed [BBH-27]; the tool run under the scrub in the sandbox;
# the log written in D47's grammar — `0 exit:<n>` first (A TOOL'S NON-ZERO EXIT IS AN OBSERVATION, never a
# driver failure), then stdout as lines or, under `fields = "json"`, as the object's keys in sorted order (a
# band field's token the constant `band`, its value in `<out>.bands`; the object's canonical text in
# `<out>.json`, the schema family's artifact — D54), stderr, the declared emitted files, `END <n>`.
#
# Exit 0 only if the log ends with an END line; 2 the tool DIED BY A SIGNAL — the guard: `END-CRASH <n>`
# written, the points before the death kept, the log is the bug report (the fixture's `--crash-at`);
# 3 REFUSED (a variable, a scenario key or table, a value the grammar does not have — the REFUSED line
# names it); 1 otherwise (no tool on the path, the scenario or its stdin_file unreadable, a declared
# emitted file not produced, a non-UTF-8 output, the timeout, the self-test): the run is DISCARDED.
#
# NOT-ASSERTED: performance, behaviour on inputs outside the scenarios, and anything the tool wrote that the scenario did not declare — a file not in `emits`, a socket, the clock, the terminal — are not observed
# NOT-ASSERTED: what the HOST records about a signal death: a subject that dies by a FAULT signal (SIGABRT, SIGSEGV,
#   SIGILL, SIGBUS, SIGTRAP, SIGFPE, SIGSYS) makes the operating system write a crash report OUTSIDE the sandbox
#   (on macOS ~/Library/Logs/DiagnosticReports) which this driver neither creates nor removes — the sandbox's
#   removal does not reach it, and the fixture's own control dies by SIGKILL for exactly that reason (R42, G30)
# NOT-ASSERTED: that a tool which reads its environment declares every variable it reads: only the [env] table reaches it, and a variable it silently needed is a run under D6's set, not a refusal
set -eu
SET="${1:?usage: cli.sh <set> <scenario.cli> <out.log> [sandbox]}"
SCEN="${2:?scenario path required}"
OUT="${3:?output log path required}"
SANDBOX="${4:-}"
BBX_HOME="${BBX_HOME:-$(cd "$(dirname "$0")/.." && pwd)}"
case ":${PYTHONPATH:-}:" in *":$BBX_HOME/lib/py:"*) ;; *) PYTHONPATH="$BBX_HOME/lib/py${PYTHONPATH:+:$PYTHONPATH}"; export PYTHONPATH ;; esac
PYTHONDONTWRITEBYTECODE=1; export PYTHONDONTWRITEBYTECODE

for v in MASK_RANGES DUMPS POKES SNAP_FRAMES VIDEO_OUT INPUT_OUT TAIL_FRAMES INPUT_INJECT_TEST NO_INPUT_CHECK; do
    eval "_x=\${$v:-}"
    [ -z "$_x" ] || { echo "REFUSED: drivers/cli.sh cannot honour $v (the frame-driven family: a tool has no frames and no RAM)"; exit 3; }
done
for v in GUARD_DEBUG GUARD_PROBE GUARD_PROBE_COND GUARD_TRACE GUARD_PC_LOG GUARD_BREAK GUARD_MATCH GUARD_FORCE CRASH_VECTORS CODE_RANGES; do
    eval "_x=\${$v:-}"
    [ -z "$_x" ] || { echo "REFUSED: drivers/cli.sh cannot honour $v (a guarded driver's variable; a tool has no debugger — its guard is the signal that kills it)"; exit 3; }
done
for v in DOCSET_NONDET DOCSET_VIEW DOCSET_FORMS; do
    eval "_x=\${$v:-}"
    [ -z "$_x" ] || { echo "REFUSED: drivers/cli.sh cannot honour $v (the document-set family: a tool has no claim forms and no artifact view)"; exit 3; }
done
[ -z "${CLI_KEEP_ENV:-}" ] || { echo "REFUSED: drivers/cli.sh cannot honour CLI_KEEP_ENV (the subject sees D6's hermetic set plus the scenario's [env] table and nothing from the caller, D52)"; exit 3; }
TIMEOUT="${CLI_TIMEOUT:-60}"
case "$TIMEOUT" in
    ''|*[!0-9]*|0) echo "REFUSED: drivers/cli.sh cannot honour CLI_TIMEOUT='$TIMEOUT' (a positive number of seconds, D51)"; exit 3 ;;
esac

[ -f "$SCEN" ] || { echo "cli.sh: scenario '$SCEN' is not a file"; exit 1; }
SCEN="$(cd "$(dirname "$SCEN")" && pwd)/$(basename "$SCEN")"
OUT_DIR="$(cd "$(dirname "$OUT")" && pwd)"; OUT="$OUT_DIR/$(basename "$OUT")"
FRESH=0
if [ -n "$SANDBOX" ]; then mkdir -p "$SANDBOX"; SANDBOX="$(cd "$SANDBOX" && pwd)"
else SANDBOX="$(mktemp -d)"; FRESH=1; fi
# the search path, component by component, ABSOLUTE (bbh's drivers learned it on a relative one) —
# resolved by bbx.cli resolve, the ONE resolver
TOOL="$(python3 -m bbx.cli resolve "$SET")" || { echo "$TOOL"; [ "$FRESH" = 0 ] || rm -rf "$SANDBOX"; exit 1; }

# Clear the artifact BEFORE the run: "no END line" must never be satisfied by a previous run's file [BBH-27]
rm -f "$OUT" "$OUT.bands" "$OUT.json"

# the self-test first: a vocabulary or a scenario reader that stopped behaving is named before the tool runs
python3 -m bbx.cli selftest > "$SANDBOX/cli_selftest.txt" 2>&1 || { cat "$SANDBOX/cli_selftest.txt"; [ "$FRESH" = 0 ] || rm -rf "$SANDBOX"; exit 1; }

_nd=""; [ "${CLI_NONDET:-}" = "" ] || _nd="--nondet"
python3 -m bbx.cli run "$TOOL" "$SCEN" "$OUT" "$SANDBOX" $_nd --timeout "$TIMEOUT" && _st=0 || _st=$?
[ "$FRESH" = 0 ] || rm -rf "$SANDBOX"
[ "$_st" = 0 ] || exit "$_st"
grep -q "^END " "$OUT" || { echo "cli.sh: the run did not complete (no END line)"; exit 1; }
exit 0
