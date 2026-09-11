#!/bin/sh
# gates.sh — THE GATES ADAPTER: drivers/README.md's contract over A CONSUMER OF BBX ITSELF — a directory
# holding a bbx.toml and its gates, driven by a harness runner under $BBX_HOME/bin (R14: BBX's own runners
# as a subject, R38's identity), whose kept run's rows are the observation
# (docs/plans/S4.md §3 "D7"; R37, R15). The core is lib/py/bbx/adapters.py over lib/py/bbx/cli.py — the
# SAME sandbox, hermetic environment, recording, timeout and log grammar as drivers/cli.sh, which is why
# the core has three consumers and BBX-25 is met with one to spare. This file is the contract's face.
#
# Usage: CLI_PATH="<dir>[;<dir>]" drivers/gates.sh <set> <scenario.cli> <out.log> [sandbox]
#   env CLI_PATH      the search path: the first directory holding a DIRECTORY named <set> wins (the consumer directory)
#   env CLI_NONDET    1 salts every hashed token with the clock — the kind's NONDETERMINISTIC control on
#                     the driver's side (the suite scrubs the family, D45 hermetic_unset)
#   env CLI_TIMEOUT   seconds the framework may run, default 60 (D51, arbitrary); elapsed: it is killed,
#                     no log is written, exit 1 — the run is DISCARDED
#   env CLI_KEEP_ENV  REFUSED: the subject sees D6's hermetic set plus the scenario's [env] table and
#                     nothing from the caller (D52)
#
# THE FRAMEWORK'S VERDICT IS AN OBSERVATION, NEVER A BBX VERDICT (R37): a failing case or a red gate is a
# token like any other and PASSes against a truth that expects it. What this driver asserts is that the
# framework ran and what it reported — never that the report was good.
#
# REFUSES the frame-driven family (MASK_RANGES, DUMPS, POKES, SNAP_FRAMES, VIDEO_OUT, INPUT_OUT,
# TAIL_FRAMES, INPUT_INJECT_TEST, NO_INPUT_CHECK), the guard family (GUARD_*, CRASH_VECTORS, CODE_RANGES)
# and the document-set family (DOCSET_NONDET, DOCSET_VIEW, DOCSET_FORMS) with exit 3 [BBH-28].
#
# Exit 0 only if the log ends with an END line; 2 the framework DIED BY A SIGNAL (the tokens mapped before
# the death are kept, END-CRASH); 3 REFUSED (a variable, a scenario key, a placeholder or a program the
# grammar does not have); 1 otherwise (no such set on CLI_PATH, the scenario unreadable, the self-test, the
# timeout, a verdict word outside the closed vocabulary, a count that disagrees with the lines seen, a run
# with nothing in it): the run is DISCARDED.
#
# NOT-ASSERTED: the framework's own correctness — identical tokens mean the framework reported the same thing, never that what it reported is true
# NOT-ASSERTED: the DETAIL behind a verdict (a traceback, a gate's printed lines, the detail column of a kept run) and anything the framework timed: a clock in an observation is a nondeterminism the harness would blame on the subject
# NOT-ASSERTED: what the HOST records about a signal death: a framework that dies by a FAULT signal makes the operating system write a crash report OUTSIDE the sandbox (on macOS ~/Library/Logs/DiagnosticReports) which this driver neither creates nor removes (R42, G30)
set -eu
SET="${1:?usage: gates.sh <set> <scenario.cli> <out.log> [sandbox]}"
SCEN="${2:?scenario path required}"
OUT="${3:?output log path required}"
SANDBOX="${4:-}"
BBX_HOME="${BBX_HOME:-$(cd "$(dirname "$0")/.." && pwd)}"; export BBX_HOME
case ":${PYTHONPATH:-}:" in *":$BBX_HOME/lib/py:"*) ;; *) PYTHONPATH="$BBX_HOME/lib/py${PYTHONPATH:+:$PYTHONPATH}"; export PYTHONPATH ;; esac
PYTHONDONTWRITEBYTECODE=1; export PYTHONDONTWRITEBYTECODE

for v in MASK_RANGES DUMPS POKES SNAP_FRAMES VIDEO_OUT INPUT_OUT TAIL_FRAMES INPUT_INJECT_TEST NO_INPUT_CHECK; do
    eval "_x=\${$v:-}"
    [ -z "$_x" ] || { echo "REFUSED: drivers/gates.sh cannot honour $v (the frame-driven family: a framework has no frames and no RAM)"; exit 3; }
done
for v in GUARD_DEBUG GUARD_PROBE GUARD_PROBE_COND GUARD_TRACE GUARD_PC_LOG GUARD_BREAK GUARD_MATCH GUARD_FORCE CRASH_VECTORS CODE_RANGES; do
    eval "_x=\${$v:-}"
    [ -z "$_x" ] || { echo "REFUSED: drivers/gates.sh cannot honour $v (a guarded driver's variable; a framework has no debugger)"; exit 3; }
done
for v in DOCSET_NONDET DOCSET_VIEW DOCSET_FORMS; do
    eval "_x=\${$v:-}"
    [ -z "$_x" ] || { echo "REFUSED: drivers/gates.sh cannot honour $v (the document-set family: a framework has no claim forms)"; exit 3; }
done
[ -z "${CLI_KEEP_ENV:-}" ] || { echo "REFUSED: drivers/gates.sh cannot honour CLI_KEEP_ENV (the subject sees D6's hermetic set plus the scenario's [env] table and nothing from the caller, D52)"; exit 3; }
TIMEOUT="${CLI_TIMEOUT:-60}"
case "$TIMEOUT" in
    ''|*[!0-9]*|0) echo "REFUSED: drivers/gates.sh cannot honour CLI_TIMEOUT='$TIMEOUT' (a positive number of seconds, D51)"; exit 3 ;;
esac

[ -f "$SCEN" ] || { echo "gates.sh: scenario '$SCEN' is not a file"; exit 1; }
SCEN="$(cd "$(dirname "$SCEN")" && pwd)/$(basename "$SCEN")"
OUT_DIR="$(cd "$(dirname "$OUT")" && pwd)"; OUT="$OUT_DIR/$(basename "$OUT")"
FRESH=0
if [ -n "$SANDBOX" ]; then mkdir -p "$SANDBOX"; SANDBOX="$(cd "$SANDBOX" && pwd)"
else SANDBOX="$(mktemp -d)"; FRESH=1; fi
# the set is a DIRECTORY on the search path — resolved by bbx.adapters resolve, the ONE resolver
SETDIR="$(python3 -m bbx.adapters resolve "$SET")" || { echo "$SETDIR"; [ "$FRESH" = 0 ] || rm -rf "$SANDBOX"; exit 1; }

rm -f "$OUT"          # [BBH-27]: "no END line" is never satisfied by a previous run's file

# the self-test first: a reader or a vocabulary that stopped behaving is named before the framework runs
python3 -m bbx.adapters selftest > "$SANDBOX/adapters_selftest.txt" 2>&1 || { cat "$SANDBOX/adapters_selftest.txt"; [ "$FRESH" = 0 ] || rm -rf "$SANDBOX"; exit 1; }

_nd=""; [ "${CLI_NONDET:-}" = "" ] || _nd="--nondet"
python3 -m bbx.adapters gates "$SETDIR" "$SCEN" "$OUT" "$SANDBOX" $_nd --timeout "$TIMEOUT" && _st=0 || _st=$?
[ "$FRESH" = 0 ] || rm -rf "$SANDBOX"
[ "$_st" = 0 ] || exit "$_st"
grep -q "^END " "$OUT" || { echo "gates.sh: the run did not complete (no END line)"; exit 1; }
exit 0
