#!/bin/sh
# close_sweeps.sh — the close ritual's sweeps run as a check: no retracted claim stated as current, no deferral in prose, no default cited without a register row, no header entry that runs past its one line
# HANDOFF.md step 8 was hand-run at every close until bbx-2; a sweep that is remembered is a
# sweep that is skipped (VampireSaved VSP-13 paid for it). lib/py/bbx/close_sweeps.py walks the
# tree: every row of docs/retractions.tsv (BBX-22) may appear only in the ledgers the row allows;
# TODO/TBD/FIXME appear nowhere but the lines that define the sweep; every `D<n>` citation
# resolves to a docs/defaults.md row (BBX-24); every must-fire and blind-spot entry of a *.sh
# header is one line, because every reader reads one line (G53, bbx-24). Step 9 (the lineage
# untouched) is by construction since R18/R20 and proved by the fidelity gate; it is not repeated
# here. Portable, ~7 s (measured 2026-09-13, bbx-24: 6 s in the opening battery before the header
# sweep, 7 s alone after it; the ~1 s quoted here until then was stale).
# Usage: gates/close_sweeps.sh
# MUST-FIRE: known-bad: retraction-restated — a copy of the tree with a retracted wording planted in STATE.md must FAIL naming that file and line
# MUST-FIRE: known-bad: deferral-planted — a copy with a TODO planted in a document must FAIL naming it
# MUST-FIRE: known-bad: default-unregistered — a copy citing a D row that has no register row must FAIL naming the id
# MUST-FIRE: known-bad: entry-continued — a copy of the tree with a gate's MUST-FIRE entry run on by a plain comment line and a driver's NOT-ASSERTED entry run on by an indented one must FAIL naming both files and lines, or a blind spot the readout prints cut passes the close (G53)
# NOT-ASSERTED: that every corrected claim has a register row: the register is written by hand at the correction (a claim nobody registered is not swept)
# NOT-ASSERTED: step 9 of the close (the lineage untouched): that is the recount's clone and the fidelity gate's proof, not this gate
# NOT-ASSERTED: a blind spot or a control written as free prose without its key: only a keyed entry is read, so the header sweep sees an entry that runs on and never a sentence that should have been one
#
set -eu
BBX_HOME="$(cd "$(dirname "$0")/.." && pwd)"; export BBX_HOME
PYTHONPATH="$BBX_HOME/lib/py"; export PYTHONPATH
rc=0
ok()   { printf '  ok    %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1"; rc=1; }
T="$(mktemp -d)"; trap 'rm -rf "$T"' EXIT INT TERM

echo "== the real tree =="
if python3 -m bbx.close_sweeps "$BBX_HOME" > "$T/real.out" 2>&1; then ok "$(tail -1 "$T/real.out")"
else fail "$(tail -1 "$T/real.out")"; grep '^ERROR' "$T/real.out" | sed 's/^/        /' | head -12; fi
# a header sweep that read no entry proves nothing about continued ones (BBX-7): the count must be there and above zero
grep -Eq ' header_entries=[1-9][0-9]* continued=0 ' "$T/real.out" && ok "the header sweep read $(tail -1 "$T/real.out" | sed 's/.* header_entries=\([0-9]*\) .*/\1/') entries and none runs on" || fail "the header sweep read no entry, or one runs on: $(tail -1 "$T/real.out")"

# a copy of the tree to plant defects in: tracked AND untracked-not-ignored files (`-co --exclude-standard`),
# the same universe the real sweep walks — a new register or gate not yet committed must still be there
mk_copy() {  # mk_copy <dir>
    mkdir -p "$1"
    (cd "$BBX_HOME" && git ls-files -co --exclude-standard -z | tr '\0' '\n' | grep -E '\.(md|sh|py|toml|txt|tsv)$' | while IFS= read -r f; do
        mkdir -p "$1/$(dirname "$f")"; cp "$f" "$1/$f"; done)
}
echo "== MUST-FIRE controls =="
mk_copy "$T/c1"; printf '\nThe constitution cites MFI-52 for BBX-5.\n' >> "$T/c1/STATE.md"
if python3 -m bbx.close_sweeps "$T/c1" > "$T/o1" 2>&1; then fail "CONTROL DEAD: retraction-restated — a planted MFI-52 in STATE.md passed"
elif grep -q '^ERROR: retraction X1 (retracted 2026-09-09) still stated in STATE.md:' "$T/o1"; then echo "CONTROL FIRED: retraction-restated — $(grep '^ERROR: retraction X1' "$T/o1")"
else fail "CONTROL DEAD: retraction-restated — failed, but not on STATE.md: $(grep '^ERROR' "$T/o1" | head -2 | tr '\n' ' ')"; fi
mk_copy "$T/c2"; printf '\nTODO: write the rest later.\n' >> "$T/c2/docs/abstraction.md"
if python3 -m bbx.close_sweeps "$T/c2" > "$T/o2" 2>&1; then fail "CONTROL DEAD: deferral-planted — a planted TODO passed"
elif grep -q '^ERROR: deferral TODO in docs/abstraction.md:' "$T/o2"; then echo "CONTROL FIRED: deferral-planted — $(grep '^ERROR: deferral' "$T/o2")"
else fail "CONTROL DEAD: deferral-planted — $(grep '^ERROR' "$T/o2" | head -2 | tr '\n' ' ')"; fi
mk_copy "$T/c3"; printf '\nThe timeout is registered (D999).\n' >> "$T/c3/docs/abstraction.md"
if python3 -m bbx.close_sweeps "$T/c3" > "$T/o3" 2>&1; then fail "CONTROL DEAD: default-unregistered — a citation of D999 passed"
elif grep -q '^ERROR: defaults cited-not-registered D999 in docs/abstraction.md:' "$T/o3"; then echo "CONTROL FIRED: default-unregistered — $(grep '^ERROR: defaults cited' "$T/o3")"
else fail "CONTROL DEAD: default-unregistered — $(grep '^ERROR' "$T/o3" | head -2 | tr '\n' ' ')"; fi
# entry-continued: both shapes a continuation takes (a plain `# ` line, an indented `#   ` line), in both entry kinds, in a gate and a driver
mk_copy "$T/c4"
nm="$(grep -n '^# MUST-FIRE: ' "$T/c4/gates/readout.sh" | head -1 | cut -d: -f1)"
nn="$(grep -n '^# NOT-ASSERTED: ' "$T/c4/drivers/docset.sh" | head -1 | cut -d: -f1)"
awk -v n="$nm" '{print} NR==n{print "# which the screen must also say"}' "$T/c4/gates/readout.sh" > "$T/c4/planted" && mv "$T/c4/planted" "$T/c4/gates/readout.sh"
awk -v n="$nn" '{print} NR==n{print "#   and the rest of that sentence"}' "$T/c4/drivers/docset.sh" > "$T/c4/planted" && mv "$T/c4/planted" "$T/c4/drivers/docset.sh"
# the count must rise by EXACTLY the two planted from what the real tree reads: a real continued entry fails the
# real-tree check above by name, and never makes this control read DEAD for a reason it did not plant (bbx-20's hazard)
c0="$(tail -1 "$T/real.out" | sed -n 's/.* continued=\([0-9]*\) .*/\1/p')"; c0="${c0:-0}"
if python3 -m bbx.close_sweeps "$T/c4" > "$T/o4" 2>&1; then fail "CONTROL DEAD: entry-continued — two entries run on by a plain and an indented line passed"
elif grep -q "^ERROR: header continued-entry MUST-FIRE in gates/readout.sh:$nm runs on 1 line(s)" "$T/o4" && grep -q "^ERROR: header continued-entry NOT-ASSERTED in drivers/docset.sh:$nn runs on 1 line(s)" "$T/o4" && grep -q " continued=$((c0 + 2)) " "$T/o4"; then echo "CONTROL FIRED: entry-continued — gates/readout.sh:$nm (MUST-FIRE, run on by a plain line) and drivers/docset.sh:$nn (NOT-ASSERTED, run on by an indented line) named, continued rose $c0 -> $((c0 + 2))"
else fail "CONTROL DEAD: entry-continued — $(grep -E '^ERROR|^close_sweeps=' "$T/o4" | head -3 | tr '\n' ' ')"; fi

echo
[ "$rc" = 0 ] && echo "PASS: $(tail -1 "$T/real.out"); 4 controls fired" || { echo "FAIL: see above"; exit 1; }
