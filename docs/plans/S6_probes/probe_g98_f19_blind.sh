#!/bin/sh
# bbx-31, G98 probe: which of F19's pairs see bbh's gate_header literals taken out of the frame-driven profile? On a
# plain clone of BBX at a commit, gates/fidelity_bbh_s6.sh runs unplanted, then with the LAST `"gate_header": {` of the
# clone's lib/py/bbx/config.py (the frame-driven profile's table; exactly two expected) renamed out of the resolver's
# reach. Each case prints its exit, the F19 tally line, the D85 line where the gate has one, and the pairs that differ.
# Measured once at bbx-31 (F19: 19 pairs, 0 differ unplanted; 8 differ planted), not gated: D85's own control,
# d85-profile-misplaced, is the gated form of the plant.
# Usage: sh probe_g98_f19_blind.sh <bbx-repo> <commit> <bbh-repo> <workdir>
set -u
SRC="$1"; C="$2"; BBH="$3"; W="$4"
rm -rf "$W"; mkdir -p "$W"
{ git clone -q --no-checkout "$SRC" "$W/bbx" && git -C "$W/bbx" checkout -q "$C"; } || { echo "clone failed"; exit 2; }
X="$W/bbx"
run() {  # run <label>
    BBX_BBH_HOME="$BBH" "$X/gates/fidelity_bbh_s6.sh" > "$W/$1.out" 2>&1; e=$?
    echo "case=$1 exit=$e :: $(grep -E '^  F19: ' "$W/$1.out") :: $(grep -E 'D85 (all|[0-9]+ of)' "$W/$1.out" | sed 's/^ *//' | cut -c1-140)"
    grep -F -- '— DIFFERS:' "$W/$1.out" | sed 's/^ *FAIL  /  differs: /'
}
echo "clone head=$(git -C "$X" rev-parse --short HEAD)"
run unplanted
python3 - "$X/lib/py/bbx/config.py" <<'EOF'
import sys
p = sys.argv[1]
t = open(p, encoding="utf-8").read()
old = '"gate_header": {'
if t.count(old) != 2:
    sys.exit("expected the kind-blind and the frame-driven tables, found %d" % t.count(old))
i = t.rindex(old)
open(p, "w", encoding="utf-8").write(t[:i] + '"gate_header_misplaced": {' + t[i + len(old):])
EOF
echo "plant: gate_header tables now $(grep -c '"gate_header": {' "$X/lib/py/bbx/config.py") (2 before)"
run planted
