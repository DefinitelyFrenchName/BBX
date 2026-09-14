#!/bin/sh
# bbx-28, S6 census: re-derive the load-bearing VampireSaved facts at 0cdd9726
# on a plain clone (R18). Read-only over the clone except checkdocshape's run
# (a reader); porcelain printed before and after. Usage: sh rederive_vs.sh <clone> <workdir>
set -u
V="$1"; W="$2"; rm -rf "$W"; mkdir -p "$W"
say() { printf '%s\n' "$*"; }
cd "$V" || exit 9
say "== clone"
say "head=$(git rev-parse --short HEAD) tracked=$(git ls-files | wc -l | tr -d ' ') porcelain_incl_ignored=$(git status --porcelain --ignored | wc -l | tr -d ' ')"
H=docs/project/harness_hardening_history.md
say "== the seven classes ($H)"
/usr/bin/grep -n -E '^[0-9]\. \*\*THE ' "$H" | cut -c1-90
say "count=$(/usr/bin/grep -c -E '^[0-9]\. \*\*THE ' "$H")"
say "== the 19 reds: the sentence and the table"
/usr/bin/grep -n 'NOT ONE red' "$H" | cut -c1-200
/usr/bin/grep -n -B1 'NOT ONE red' "$H" | head -2 | cut -c1-200
/usr/bin/sed -n '84,96p' "$H" > "$W/reds_table.txt"; say "table lines 84-96 kept in $W/reds_table.txt"
say "== doc_shape.tsv"
say "header: $(/usr/bin/grep -m1 -E '^#' docs/doc_shape.tsv | cut -c1-160)"
say "rows=$(/usr/bin/grep -v -c -E '^[[:space:]]*(#|$)' docs/doc_shape.tsv)"
/usr/bin/grep -v -E '^[[:space:]]*(#|$)' docs/doc_shape.tsv | awk -F'\t' '{print $2}' | sort | uniq -c | sort -rn
say "the history file's row: $(/usr/bin/grep -n harness_hardening_history docs/doc_shape.tsv | cut -c1-160)"
say "allow rows=$(/usr/bin/grep -v -c -E '^[[:space:]]*(#|$)' docs/doc_shape_allow.tsv)"
say "== the documents checker"
wc -l tools/checkdocshape.py tests/test_docshape.sh
say "controls in the gate (^control ): $(/usr/bin/grep -c '^control ' tests/test_docshape.sh)"
python3 tools/checkdocshape.py > "$W/docshape.1" 2>&1; e1=$?
python3 tools/checkdocshape.py > "$W/docshape.2" 2>&1; e2=$?
cmp -s "$W/docshape.1" "$W/docshape.2" && same=identical || same=DIFFER
say "checkdocshape exit=$e1,$e2 $same lines=$(wc -l < "$W/docshape.1" | tr -d ' ') last: $(tail -1 "$W/docshape.1" | cut -c1-200)"
say "== must-fire markers over top-level gate scripts"
tot=$(git ls-files 'tests/*.sh' | /usr/bin/grep -v -c '^tests/.*/')
mf=$(git grep -l -i -E 'must.?fire' -- 'tests/*.sh' | /usr/bin/grep -v -c '^tests/.*/')
say "gate_scripts=$tot with_marker=$mf"
say "spellings:"; git grep -o -h -i -E 'must.{0,2}fire' -- tests | sort | uniq -c | sort -rn
say "== gate index"
say "index_rows=$(/usr/bin/grep -c '^| `tests/' docs/project/gate_index.md)"
/usr/bin/grep -n -E 'cur != text|!= text' tools/gen_gate_index.py
say "== harness_scope.md section 7 decisions"
/usr/bin/sed -n '/^## 7\./,/^## 8\./p' docs/project/harness_scope.md | /usr/bin/grep -o -E '^[0-9]+\. \*\*(RULED|DECIDED)' | awk '{print $2}' | sort | uniq -c
say "== clone after"
say "porcelain_incl_ignored=$(git status --porcelain --ignored | wc -l | tr -d ' ')"
