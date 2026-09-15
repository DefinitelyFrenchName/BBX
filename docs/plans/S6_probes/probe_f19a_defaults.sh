#!/bin/sh
# bbx-30, S6 step 3 probe (R68): does bbh's example gate index reproduce when the kind-blind session pattern is
# neutral? On a plain clone of bbh at a commit (R18, R20), bbh's own `gate-index --check` over its example with bbh's
# defaults, then with `[gate_header].session_regex` replaced in the clone's config.py by an ISO date only and by
# `bbx-N` or an ISO date; the control replaces the runtime pattern by one that cannot match and must read STALE.
# Every case prints its exit and its first lines; the clone is restored and its porcelain printed.
# Usage: sh probe_f19a_defaults.sh <bbh-repo> <commit> <workdir>
set -u
SRC="$1"; C="$2"; W="$3"
rm -rf "$W"; mkdir -p "$W"
{ git clone -q --no-checkout "$SRC" "$W/bbh" && git -C "$W/bbh" checkout -q "$C"; } || { echo "clone failed"; exit 2; }
B="$W/bbh"; CFG="$B/example/bbh.toml"; PY="$B/lib/py/bbh/config.py"
unset BBH_CONFIG PYTHONPATH
cp "$PY" "$W/config.py.orig"
chk() {  # chk <label>
    "$B/bin/bbh" gate-index --config "$CFG" --check > "$W/out" 2>&1; e=$?
    echo "case=$1 exit=$e :: $(head -3 "$W/out" | tr '\n' '|')"
}
patch() {  # patch <key> <raw regex>
    python3 - "$PY" "$1" "$2" <<'EOF'
import re
import sys
p, key, val = sys.argv[1:4]
t = open(p, encoding="utf-8").read()
new, n = re.subn(r'("' + key + r'":\s*)r"[^"]*"', lambda m: m.group(1) + 'r"' + val + '"', t, count=1)
if n != 1:
    sys.exit("no " + key + " line")
open(p, "w", encoding="utf-8").write(new)
EOF
}
echo "clone head=$(git -C "$B" rev-parse --short HEAD)"
chk "bbh-defaults"
patch session_regex '\b(20\d\d-\d\d-\d\d)'; chk "session=iso-date-only"; cp "$W/config.py.orig" "$PY"
patch session_regex '\b(bbx-\d+|20\d\d-\d\d-\d\d)'; chk "session=bbx-or-iso-date"; cp "$W/config.py.orig" "$PY"
patch duration_regex '~\s*(\d+)\s*(fortnights)'; chk "control:duration-never-matches (must be STALE)"; cp "$W/config.py.orig" "$PY"
echo "clone porcelain after restore: $(git -C "$B" status --porcelain | wc -l | tr -d ' ')"
