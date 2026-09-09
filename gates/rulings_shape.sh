#!/bin/sh
# rulings_shape.sh — every ruling sits under the heading of its state, and the queue and DECISIONS.md agree both ways
# docs/rulings.md is a document BBX reads (R14): an entry under `## Open` must be `(open)`, an
# entry under `## Answered …` must carry its answer, every answered R<n> has a `| R<n> |` row in
# DECISIONS.md and every row has an entry, and DECISIONS.md's `Open rulings:` line lists exactly
# the open ids. Born of gotcha G14 (three answered rulings left under an Open heading with their
# answers written in — "the kind of dark pattern that leads to silent issues"). Portable, ~1 s.
# Usage: gates/rulings_shape.sh
# MUST-FIRE: known-bad: answered-under-open — a shadow queue with an answered entry moved under the Open heading must FAIL on that id
# MUST-FIRE: known-bad: open-under-answered — a shadow queue whose one entry is `(open)` under an Answered heading must FAIL on that id
# MUST-FIRE: known-bad: no-decisions-row — a shadow DECISIONS.md with one R row deleted must FAIL naming that id
# MUST-FIRE: known-bad: row-without-entry — a shadow DECISIONS.md with a row for an R that no entry defines must FAIL naming it
# NOT-ASSERTED: the prose of a ruling: only its heading, its answer line and its DECISIONS row are read
#
set -eu
BBX_HOME="$(cd "$(dirname "$0")/.." && pwd)"; export BBX_HOME
TOOL="$BBX_HOME/lib/py/bbx/rulings_shape.py"
Q="$BBX_HOME/docs/rulings.md"; D="$BBX_HOME/DECISIONS.md"
rc=0
ok()   { printf '  ok    %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1"; rc=1; }
T="$(mktemp -d)"; trap 'rm -rf "$T"' EXIT INT TERM

echo "== the real files =="
if python3 "$TOOL" "$Q" "$D" > "$T/real.out" 2>&1; then
    ok "$(tail -1 "$T/real.out")"
else
    fail "$(tail -1 "$T/real.out")"; grep '^ERROR' "$T/real.out" | sed 's/^/        /' | head -12
fi

# the id the shadows move around: the last ANSWERED entry — the last R row of DECISIONS.md, which
# the real check has just held equal to the queue's answered set. (The first version took the
# queue's last entry, which was answered only until the first open ruling was raised: both
# controls went dead the hour R21 was filed, and the battery said so — BBX-2, both directions.)
last="$(grep -oE '^\| R[0-9]+ \|' "$D" | tail -1 | tr -d '| ')"
[ -n "$last" ] || { echo "FAIL: no answered ruling row in $D to build the shadows from"; exit 1; }
grep -q "^### $last " "$Q" || { echo "FAIL: DECISIONS row $last has no entry in $Q (the real check above should have said so)"; exit 1; }

echo "== MUST-FIRE controls =="
# 1. answered-under-open: retitle the heading above the last entry to `## Open`
python3 - "$Q" "$T/q1.md" "$last" <<'PY'
import re, sys
q, dst, rid = sys.argv[1], sys.argv[2], sys.argv[3]
L = open(q, encoding="utf-8").read().split("\n")
i = next(k for k, l in enumerate(L) if l.startswith("### " + rid + " "))
h = max(k for k in range(i) if L[k].startswith("## "))
L[h] = "## Open — shadow"
open(dst, "w", encoding="utf-8").write("\n".join(L))
PY
if python3 "$TOOL" "$T/q1.md" "$D" > "$T/c1.out" 2>&1; then
    fail "CONTROL DEAD: answered-under-open — $last under an Open heading passed"
elif grep -q "^ERROR: answered-under-open $last " "$T/c1.out"; then
    echo "CONTROL FIRED: answered-under-open — $(grep "^ERROR: answered-under-open $last " "$T/c1.out")"
else
    fail "CONTROL DEAD: answered-under-open — failed, but not on $last: $(grep '^ERROR' "$T/c1.out" | head -2 | tr '\n' ' ')"
fi
# 2. open-under-answered: a one-entry queue, `(open)` under an Answered heading; DECISIONS shadow with no rows, open line none
printf '## Answered — shadow\n\n### R999 — shadow\n- **Answer:** (open)\n' > "$T/q2.md"
printf 'Open rulings: none.\n' > "$T/d2.md"
if python3 "$TOOL" "$T/q2.md" "$T/d2.md" > "$T/c2.out" 2>&1; then
    fail "CONTROL DEAD: open-under-answered — an (open) entry under Answered passed"
elif grep -q '^ERROR: open-under-answered R999 ' "$T/c2.out"; then
    echo "CONTROL FIRED: open-under-answered — $(grep '^ERROR: open-under-answered R999 ' "$T/c2.out")"
else
    fail "CONTROL DEAD: open-under-answered — failed, but not on R999: $(grep '^ERROR' "$T/c2.out" | head -2 | tr '\n' ' ')"
fi
# 3. no-decisions-row: DECISIONS without the last entry's row
grep -v "^| $last |" "$D" > "$T/d3.md"
if python3 "$TOOL" "$Q" "$T/d3.md" > "$T/c3.out" 2>&1; then
    fail "CONTROL DEAD: no-decisions-row — $last with no DECISIONS row passed"
elif grep -q "^ERROR: no-decisions-row $last\$" "$T/c3.out"; then
    echo "CONTROL FIRED: no-decisions-row — $(grep "^ERROR: no-decisions-row $last" "$T/c3.out")"
else
    fail "CONTROL DEAD: no-decisions-row — failed, but not naming $last: $(grep '^ERROR' "$T/c3.out" | head -2 | tr '\n' ' ')"
fi
# 4. row-without-entry: DECISIONS with a row for R999
{ cat "$D"; printf '| R999 | shadow | shadow | 2026-09-09 |\n'; } > "$T/d4.md"
if python3 "$TOOL" "$Q" "$T/d4.md" > "$T/c4.out" 2>&1; then
    fail "CONTROL DEAD: row-without-entry — a DECISIONS row for R999 passed"
elif grep -q '^ERROR: row-without-entry R999 ' "$T/c4.out"; then
    echo "CONTROL FIRED: row-without-entry — $(grep '^ERROR: row-without-entry R999 ' "$T/c4.out")"
else
    fail "CONTROL DEAD: row-without-entry — failed, but not naming R999: $(grep '^ERROR' "$T/c4.out" | head -2 | tr '\n' ' ')"
fi

echo
[ "$rc" = 0 ] && echo "PASS: $(tail -1 "$T/real.out"); 4 controls fired" || { echo "FAIL: see above"; exit 1; }
