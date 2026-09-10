#!/bin/sh
# docset.sh — THE DOCUMENT-SET DRIVER: drivers/README.md's contract over a document set — an
# artifact (a TSV) and the documents beside it — so the suite, the comparators and the gates run
# end to end over a subject that has no executable at all (docs/plans/S3.md §3 "D1–D5"; R31, R33).
#
# Usage: DOCSET_PATH="<dir>[;<dir>]" drivers/docset.sh <set> <scenario.claims> <out.log> [sandbox]
#   env DOCSET_PATH    the search path holding <set>.tsv (the first directory that has it wins);
#                      the claim set's documents are read from THAT directory — the artifact and
#                      the documents are one set, and the suite's identity is the hash over all of
#                      them (D33)
#   env DOCSET_NONDET  1 mixes the clock into every token — the kind's NONDETERMINISTIC control
#                      (bbh's FAKE_NONDET analogue; the suite scrubs it, D33 hermetic_unset)
#   env DOCSET_VIEW    REFUSED: one artifact per set in S3, so there is no second artifact view to
#                      select (D3: a variable a driver cannot honour is refused, never ignored)
#   env DOCSET_FORMS   REFUSED: no form override exists; the claim set declares the forms
#
# REFUSES the frame-driven family (MASK_RANGES, DUMPS, POKES, SNAP_FRAMES, VIDEO_OUT, INPUT_OUT,
# TAIL_FRAMES, INPUT_INJECT_TEST, NO_INPUT_CHECK) and the guard family (GUARD_*, CRASH_VECTORS,
# CODE_RANGES) with exit 3: a document set has no frames, no RAM and no debugger, and a caller that
# set one of these is measuring something this run would silently not measure [BBH-28].
#
# What the run does, in order: the extractor's SELF-TEST on synthetic lines (exit 1 naming the form
# if an extractor stopped matching — before any document is read); then lib/py/bbx/docset.py binds
# every claim of the claim set and writes the log: `<index> <status>:<sha1-quoted>:<sha1-derived>`
# per claim, `END <n>` last (D37).
#
# Exit 0 only if the log ends with an END line; 3 REFUSED (a form no extractor implements, a view,
# an unlisted absence or number — the REFUSED line names it); 1 otherwise (the artifact, a document
# or the claim set cannot be read, or the self-test failed): the run is DISCARDED. No exit 2: the
# kind has no guard.
#
# NOT-ASSERTED: prose, reasoning and causal claims in the documents — only sentences in a declared form, and the listed paraphrases and unbindables, are claims
# NOT-ASSERTED: the truth of the artifact itself — a document that agrees with a wrong artifact reads BOUND
set -eu
SET="${1:?usage: docset.sh <set> <scenario.claims> <out.log> [sandbox]}"
CLAIMS="${2:?claim-set path required}"
OUT="${3:?output log path required}"
SANDBOX="${4:-}"
BBX_HOME="${BBX_HOME:-$(cd "$(dirname "$0")/.." && pwd)}"
case ":${PYTHONPATH:-}:" in *":$BBX_HOME/lib/py:"*) ;; *) PYTHONPATH="$BBX_HOME/lib/py${PYTHONPATH:+:$PYTHONPATH}"; export PYTHONPATH ;; esac
PYTHONDONTWRITEBYTECODE=1; export PYTHONDONTWRITEBYTECODE

for v in MASK_RANGES DUMPS POKES SNAP_FRAMES VIDEO_OUT INPUT_OUT TAIL_FRAMES INPUT_INJECT_TEST NO_INPUT_CHECK; do
    eval "_x=\${$v:-}"
    [ -z "$_x" ] || { echo "REFUSED: drivers/docset.sh cannot honour $v (the frame-driven family: a document set has no frames and no RAM)"; exit 3; }
done
for v in GUARD_DEBUG GUARD_PROBE GUARD_PROBE_COND GUARD_TRACE GUARD_PC_LOG GUARD_BREAK GUARD_MATCH CRASH_VECTORS CODE_RANGES; do
    eval "_x=\${$v:-}"
    [ -z "$_x" ] || { echo "REFUSED: drivers/docset.sh cannot honour $v (a guarded driver's variable; a document set has no debugger)"; exit 3; }
done
[ -z "${DOCSET_VIEW:-}" ] || { echo "REFUSED: drivers/docset.sh cannot honour DOCSET_VIEW (one artifact per set in S3: there is no second artifact view to select)"; exit 3; }
[ -z "${DOCSET_FORMS:-}" ] || { echo "REFUSED: drivers/docset.sh cannot honour DOCSET_FORMS (no form override exists: the claim set declares the forms)"; exit 3; }

[ -f "$CLAIMS" ] || { echo "docset.sh: claim set '$CLAIMS' is not a file"; exit 1; }
CLAIMS="$(cd "$(dirname "$CLAIMS")" && pwd)/$(basename "$CLAIMS")"
OUT_DIR="$(cd "$(dirname "$OUT")" && pwd)"; OUT="$OUT_DIR/$(basename "$OUT")"
if [ -n "$SANDBOX" ]; then mkdir -p "$SANDBOX"; SANDBOX="$(cd "$SANDBOX" && pwd)"; fi
[ -n "${DOCSET_PATH:-}" ] || { echo "docset.sh: set DOCSET_PATH to the directory holding $SET.tsv"; exit 1; }
# the search path, component by component, ABSOLUTE (bbh's drivers learned it on a relative one)
ARTIFACT=""; _rest="$DOCSET_PATH;"
while [ -n "$_rest" ]; do
    _d="${_rest%%;*}"; _rest="${_rest#*;}"
    [ -n "$_d" ] || continue
    case "$_d" in /*) ;; *) _d="$(CDPATH= cd "$_d" 2>/dev/null && pwd)" || { echo "docset.sh: search-path component '$_d' does not resolve from $(pwd)"; exit 1; } ;; esac
    [ -f "$_d/$SET.tsv" ] && { ARTIFACT="$_d/$SET.tsv"; break; }
done
[ -n "$ARTIFACT" ] || { echo "docset.sh: no $SET.tsv on DOCSET_PATH=$DOCSET_PATH"; exit 1; }

# Clear the artifact BEFORE the run: "no END line" must never be satisfied by a previous run's file [BBH-27]
rm -f "$OUT"

# the self-test first: an extractor that stopped matching is named before any document is read
python3 -m bbx.docset selftest > "${SANDBOX:-$OUT_DIR}/docset_selftest.txt" 2>&1 || { cat "${SANDBOX:-$OUT_DIR}/docset_selftest.txt"; exit 1; }
[ -n "$SANDBOX" ] || rm -f "$OUT_DIR/docset_selftest.txt"

_nd=""; [ "${DOCSET_NONDET:-}" = "" ] || _nd="--nondet"
python3 -m bbx.docset run "$ARTIFACT" "$CLAIMS" "$OUT" $_nd && _st=0 || _st=$?
[ "$_st" = 0 ] || exit "$_st"
grep -q "^END " "$OUT" || { echo "docset.sh: the run did not complete (no END line)"; exit 1; }
exit 0
