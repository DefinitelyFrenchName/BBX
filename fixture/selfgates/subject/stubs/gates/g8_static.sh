#!/bin/sh
# g8_static.sh — a STUB of the STATIC tier: its input is named by the consumer's static_needs_env, so it
# SKIPs while that variable is unset and holds when a scenario's [env] table sets it to a directory inside
# the sandbox. The same gate, two verdicts: that is BBX-1 as an observation rather than a sentence.
[ -n "${SELFGATES_INPUT:-}" ] || { echo "SKIP: SELFGATES_INPUT is unset (asserts nothing)"; exit 0; }
echo "  ok    stub g8_static read its input at $SELFGATES_INPUT"
exit 0
