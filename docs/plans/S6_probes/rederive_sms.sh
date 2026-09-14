#!/bin/sh
# bbx-28, S6 census: re-derive the load-bearing SMS facts at ecc5481 on a plain
# clone (R18). checkdocs reads the clean ROM from outside the tree (read-only).
# The sabotage runs happen in a COPY. Usage: sh rederive_sms.sh <clone> <workdir> <romdir>
set -u
S="$1"; W="$2"; R="$3"; rm -rf "$W"; mkdir -p "$W"
say() { printf '%s\n' "$*"; }
cd "$S" || exit 9
say "== clone"
say "head=$(git rev-parse --short HEAD) tracked=$(git ls-files | wc -l | tr -d ' ') porcelain_incl_ignored=$(git status --porcelain --ignored | wc -l | tr -d ' ')"
say "== checkdocs"
wc -l tools/checkdocs.py
say "@check=$(/usr/bin/grep -c '^@check(' tools/checkdocs.py) @table=$(/usr/bin/grep -c '^@table(' tools/checkdocs.py)"
SMS_ROM_DIR="$R" python3 tools/checkdocs.py > "$W/cd.1" 2>&1; e1=$?
SMS_ROM_DIR="$R" python3 tools/checkdocs.py > "$W/cd.2" 2>&1; e2=$?
cmp -s "$W/cd.1" "$W/cd.2" && same=identical || same=DIFFER
say "checkdocs exit=$e1,$e2 $same first: $(head -1 "$W/cd.1")"
say "== documents: shapes, twins, maps"
say "tracked_md=$(git ls-files '*.md' | wc -l | tr -d ' ') history_twins=$(git ls-files | /usr/bin/grep -c -i -E '_history\.md$')"
say "shape_declarations=$(git grep -i -E '^\**shape:' -- '*.md' | wc -l | tr -d ' ')"
say "positive control, a word known present in the docs ('ROM'): $(git grep -c -I 'ROM' -- '*.md' | wc -l | tr -d ' ') files"
say "== sabotage in a copy: an orphan page and a dead link"
C="$W/copy"; cp -R "$S" "$C"; rm -rf "$C/.git"
printf '# Orphan\n\nNothing links here.\n' > "$C/docs/game/orphan_page.md"
f=$(ls "$C"/docs/game/*.md | head -1); printf '\nSee [nowhere](no_such_page.md) and `tools/no_such_tool.py`.\n' >> "$f"
( cd "$C" && SMS_ROM_DIR="$R" python3 tools/checkdocs.py ) > "$W/cd.sab" 2>&1; es=$?
say "checkdocs on the sabotaged copy exit=$es first: $(head -1 "$W/cd.sab")"
say "positive control, a quoted fragment edited in the same copy:"
python3 - "$C" <<'EOF'
import pathlib, re, sys
root = pathlib.Path(sys.argv[1])
src = (root / "tools/checkdocs.py").read_text()
m = re.search(r"says\(\s*['\"]([^'\"]+\.md)['\"]\s*,\s*['\"]([^'\"]{6,})['\"]", src)
doc, frag = m.group(1), m.group(2)
p = root / "docs" / doc if not doc.startswith("docs/") else root / doc
if not p.exists():
    p = root / "docs/game" / doc
t = p.read_text()
assert frag in t, (doc, frag)
# bbx-28 (G83): the first draft APPENDED "X" after the fragment, which leaves the
# fragment in the document and cannot fail; the edit must break the fragment itself.
mid = len(frag) // 2
p.write_text(t.replace(frag, frag[:mid] + "X" + frag[mid:], 1))
assert frag not in p.read_text(), "the control's edit left the fragment intact"
print("edited", p.relative_to(root), "fragment", repr(frag[:40]))
EOF
( cd "$C" && SMS_ROM_DIR="$R" python3 tools/checkdocs.py ) > "$W/cd.frag" 2>&1; ef=$?
say "checkdocs with an edited fragment exit=$ef first: $(head -1 "$W/cd.frag" | cut -c1-160)"
say "== defaults: a provenance-class vocabulary?"
say "principled|reference-calibrated as words: $(git grep -i -w -E 'principled|reference-calibrated' | wc -l | tr -d ' ') lines"
say "== clone after"
say "porcelain_incl_ignored=$(git status --porcelain --ignored | wc -l | tr -d ' ')"
