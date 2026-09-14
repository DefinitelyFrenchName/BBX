#!/bin/sh
# bbx-28, S6 census: re-derive what BBX already has for S6, read-only over the
# tree. Run from the BBX root with sh. Usage: sh rederive_bbx.sh <workdir>
set -u
W="$1"; rm -rf "$W"; mkdir -p "$W"
export PYTHONPATH=lib/py PYTHONDONTWRITEBYTECODE=1
say() { printf '%s\n' "$*"; }
say "== tree"
say "head=$(git rev-parse --short HEAD) porcelain=$(git status --porcelain | wc -l | tr -d ' ')"

say "== controls declared by header, per gate on disk (bbx.controls declared)"
: > "$W/declared.tsv"
for g in gates/*.sh; do
  n=$(python3 -m bbx.controls declared "$g" | awk -F'\t' '$1!="none"' | wc -l | tr -d ' ')
  printf '%s\t%s\n' "$(basename "$g" .sh)" "$n" >> "$W/declared.tsv"
done
say "gates_on_disk=$(wc -l < "$W/declared.tsv" | tr -d ' ') declared_on_disk=$(awk -F'\t' '{s+=$2} END{print s}' "$W/declared.tsv")"
reg=$(cat gates/portable.txt gates/static.txt | sed 's/#.*//' | awk 'NF{print $1}' | sed 's/\.sh$//' | sort)
say "registered_gates=$(printf '%s\n' "$reg" | wc -l | tr -d ' ')"
printf '%s\n' "$reg" > "$W/registered.txt"
say "declared_in_registered=$(awk -F'\t' 'NR==FNR{r[$1]=1; next} ($1 in r){s+=$2} END{print s}' "$W/registered.txt" "$W/declared.tsv")"
say "unregistered gates on disk and their declared counts:"; awk -F'\t' 'NR==FNR{r[$1]=1; next} !($1 in r){print "  " $1 " " $2}' "$W/registered.txt" "$W/declared.tsv"
say "shapes over all gates on disk:"; for g in gates/*.sh; do python3 -m bbx.controls declared "$g"; done | awk -F'\t' '$1!="none"{print $1}' | sort | uniq -c

say "== R29 (executable controls): any code that runs a declared control?"
say "self-report|CONTROL LIES|CONTROL= in lib bin gates: $(git grep -n -E 'self-report|CONTROL LIES|CONTROL=' -- lib bin gates | wc -l | tr -d ' ') lines"
say "positive control, 'CONTROL FIRED' in gates: $(git grep -l 'CONTROL FIRED' -- gates | wc -l | tr -d ' ') files"

say "== defaults register"
python3 - <<'EOF'
import re
lines = open("docs/defaults.md").read().splitlines()
rows = [(i + 1, l) for i, l in enumerate(lines) if re.match(r"^\| D\d+ \|", l)]
print("rows=%d first_line=%d last_line=%d" % (len(rows), rows[0][0], rows[-1][0]))
ids = [int(re.match(r"^\| D(\d+) \|", l).group(1)) for _, l in rows]
print("ids_min=%d ids_max=%d distinct=%d gaps=%s" % (min(ids), max(ids), len(set(ids)), sorted(set(range(1, max(ids) + 1)) - set(ids))))
inv = sum(1 for a, b in zip(ids, ids[1:]) if b < a)
print("order: descents=%d (a row whose id is lower than the row above)" % inv)
headers = [i + 1 for i, l in enumerate(lines) if re.match(r"^\| *id *\|", l)]
print("table header lines=%s" % headers)
breaks = [i + 1 for i in range(rows[0][0], rows[-1][0] - 1) if not lines[i].startswith("|")]
print("non-table lines between the first and last row: %s" % breaks)
cls = {}
bad_cells = []
for n, l in rows:
    cells = re.split(r"(?<!\\)\|", l)[1:-1]
    if len(cells) != 6:
        bad_cells.append((l.split("|")[1].strip(), len(cells)))
        continue
    c = cells[4].strip()
    cls[c] = cls.get(c, 0) + 1
print("rows_with_cell_count_not_6=%s" % bad_cells)
three = {"principled", "reference-calibrated", "arbitrary"}
print("class column histogram (rows with 6 cells):")
for c, k in sorted(cls.items(), key=lambda x: -x[1]):
    print("  %3d  %s%s" % (k, c[:90], "" if c in three else "   <- not one of BBX-24's three words alone"))
print("single_word_class=%d of %d six-cell rows" % (sum(k for c, k in cls.items() if c in three), sum(cls.values())))
EOF

say "== documents: shapes, twins, reachability from HANDOFF"
n=0; t=0; : > "$W/noshape.txt"; : > "$W/shapes.txt"
for f in $(git ls-files '*.md'); do
  t=$((t+1))
  if head -10 "$f" | /usr/bin/grep -q -i -E '^\**shape'; then n=$((n+1)); head -10 "$f" | /usr/bin/grep -m1 -i -E '^\**shape' | cut -c1-120 | sed "s|^|$f: |" >> "$W/shapes.txt"; else echo "$f" >> "$W/noshape.txt"; fi
done
say "tracked_md=$t shape_at_line_start_in_first_10=$n"
say "without:"; sed 's/^/  /' "$W/noshape.txt"
say "history files: $(git ls-files | /usr/bin/grep -i -E 'history' | tr '\n' ' ')"
m=0; : > "$W/unnamed.txt"
for f in $(git ls-files '*.md'); do [ "$f" = HANDOFF.md ] && continue; /usr/bin/grep -q -F "$f" HANDOFF.md || { m=$((m+1)); echo "$f" >> "$W/unnamed.txt"; }; done
say "md_not_named_by_full_path_in_HANDOFF=$m of $((t-1))"; sed 's/^/  /' "$W/unnamed.txt"

say "== gate headers: line 2 form and NOT-ASSERTED lines"
k=0; for g in gates/*.sh; do b=$(basename "$g"); sed -n 2p "$g" | /usr/bin/grep -q -F "# $b — " && k=$((k+1)); done
say "line2_form_ok=$k of $(ls gates/*.sh | wc -l | tr -d ' ')"
say "NOT-ASSERTED lines: gates=$(git grep -h '^# NOT-ASSERTED: ' -- 'gates/*.sh' | wc -l | tr -d ' ') drivers=$(git grep -h '^# NOT-ASSERTED: ' -- 'drivers/*.sh' | wc -l | tr -d ' ')"

say "== the ledger: entries naming S6"
say "entries=$(/usr/bin/grep -c '^## G[0-9]' docs/gotchas.md)"
awk '/^## G[0-9]+ /{id=$2} /S6/{print id}' docs/gotchas.md | sort -u | sort -t G -k1.2 -n | tr '\n' ' '; echo

say "== tree after"
say "porcelain=$(git status --porcelain | wc -l | tr -d ' ')"
