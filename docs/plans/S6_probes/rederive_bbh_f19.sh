#!/bin/sh
# bbx-28, S6 census: re-derive the load-bearing F19 facts about bbh at 10a82d2
# on a plain clone (R18, R20). Every line printed is a measurement; run with sh.
# Usage: sh rederive_bbh_f19.sh <clone> <workdir>
set -u
S="$1"; W="$2"
rm -rf "$W"; mkdir -p "$W"
say() { printf '%s\n' "$*"; }

say "== clone"
say "head=$(git -C "$S" rev-parse --short HEAD) porcelain_incl_ignored=$(git -C "$S" status --porcelain --ignored | wc -l | tr -d ' ')"

say "== module sizes (wc -l)"
( cd "$S/lib/py/bbh" && wc -l provenance.py header_defaults.py gate_header.py ref_rot.py gen_gate_index.py demand_after_trap.py )

say "== unchanged baseline -> tip (empty stat means unchanged)"
git -C "$S" diff --stat 10a82d2 e7d6767 -- lib/py/bbh/provenance.py lib/py/bbh/header_defaults.py lib/py/bbh/gate_header.py lib/py/bbh/ref_rot.py lib/py/bbh/gen_gate_index.py lib/py/bbh/demand_after_trap.py bin/bbh
say "stat_lines=$(git -C "$S" diff --stat 10a82d2 e7d6767 -- lib/py/bbh/provenance.py lib/py/bbh/header_defaults.py lib/py/bbh/gate_header.py lib/py/bbh/ref_rot.py lib/py/bbh/gen_gate_index.py lib/py/bbh/demand_after_trap.py bin/bbh | wc -l | tr -d ' ')"
say "positive control, the example's rendered index baseline -> tip: $(git -C "$S" diff --stat 10a82d2 e7d6767 -- example/docs/gate_index.md | wc -l | tr -d ' ') stat lines"

say "== which bbh sub-commands the example's hygiene gate runs"
# (bbx-28: a first pattern here, 'bbh[" ]+[a-z-]+', matched nothing — the gate loops over bare names)
/usr/bin/grep -n -E 'for c in' "$S/example/tests/g_hygiene.sh"
say "positive control, the gate file's line count: $(wc -l < "$S/example/tests/g_hygiene.sh" | tr -d ' ')"

say "== the five on the example, twice each"
cd "$S/example" || exit 9
run2() { name="$1"; shift
  "$@" > "$W/$name.1" 2>&1; e1=$?
  "$@" > "$W/$name.2" 2>&1; e2=$?
  if cmp -s "$W/$name.1" "$W/$name.2"; then same=identical; else same=DIFFER; fi
  say "$name exit=$e1,$e2 $same bytes=$(wc -c < "$W/$name.1" | tr -d ' ') first: $(head -1 "$W/$name.1")"
}
run2 provenance       ../bin/bbh provenance --config bbh.toml
run2 header-defaults  ../bin/bbh header-defaults --config bbh.toml
run2 ref-rot          ../bin/bbh ref-rot --config bbh.toml
run2 gate-index       ../bin/bbh gate-index --config bbh.toml --check
run2 demand-after-trap ../bin/bbh demand-after-trap tests

say "== BBX-8: each pointed at the wrong thing (an empty root / a missing dir)"
E="$W/empty"; mkdir -p "$E"
for t in provenance header-defaults ref-rot; do
  ../bin/bbh "$t" --config bbh.toml --root "$E" > "$W/wrong.$t" 2>&1; say "$t --root <empty> exit=$? first: $(head -1 "$W/wrong.$t")"
done
../bin/bbh gate-index --config bbh.toml --root "$E" --check > "$W/wrong.gate-index" 2>&1; say "gate-index --root <empty> --check exit=$? first: $(head -1 "$W/wrong.gate-index")"
../bin/bbh demand-after-trap "$W/no-such-dir" > "$W/wrong.dat" 2>&1; say "demand-after-trap <missing dir> exit=$? bytes=$(wc -c < "$W/wrong.dat" | tr -d ' ')"

say "== gate-index --check: text or bytes? (a CRLF copy of the committed index)"
C="$W/copy"; cp -R "$S/example" "$C"
python3 -c 'import sys; p=sys.argv[1]; b=open(p,"rb").read(); open(p,"wb").write(b.replace(b"\r\n",b"\n").replace(b"\n",b"\r\n"))' "$C/docs/gate_index.md"
cmp -s "$S/example/docs/gate_index.md" "$C/docs/gate_index.md"; say "cmp committed vs CRLF copy: status=$? (1 = the bytes differ)"
( cd "$C" && "$S/bin/bbh" gate-index --config bbh.toml --check ) > "$W/crlf.out" 2>&1; say "gate-index --check on the CRLF copy exit=$? first: $(head -1 "$W/crlf.out")"
printf 'trailing\n' >> "$C/docs/gate_index.md"
( cd "$C" && "$S/bin/bbh" gate-index --config bbh.toml --check ) > "$W/append.out" 2>&1; say "positive control, one appended line: exit=$? first: $(head -1 "$W/append.out")"
say "the comparison lines:"; /usr/bin/grep -n -E 'read_text|!= *rendered|== *rendered' "$S/lib/py/bbh/gen_gate_index.py"

say "== clone after"
say "porcelain_incl_ignored=$(git -C "$S" status --porcelain --ignored | wc -l | tr -d ' ')"
