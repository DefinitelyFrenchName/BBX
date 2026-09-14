#!/bin/sh
# fidelity_bbh_s5.sh — BBX's lifted skills lock and guide generator reproduce bbh's verdict text byte for byte over the same skills (F18)
# THE FIDELITY OBLIGATION for slice S5 (CLAUDE.md §7.2; docs/fidelity.md F18; ruling R56): `bin/bbx check-skills` and
# `bin/bbx skill-guide` (lib/py/bbx/checkskills.py, gen_skill_guide.py, lifted from bbh at the baseline) and bbh's own
# `bin/bbh` run over the SAME inputs, every printed line and the exit diffed. F18a bbh's own skill on the clone
# (`--config skill/skills.toml` with `-v`, `--no-selftest`, `--check`, `--prefix`, an unknown prefix, and the bare
# forms that read no config and exit 2), and the guide REGENERATED on two copies of the clone with the written bytes
# compared; F18b the synthetic consumer of bbh's selftest/test_skills.sh (two skills, a rolling doc, a history twin,
# an archive) and each of its perturbations, the stale guide and the empty config; F18c the lock's own synthetic
# selftest, run by default; F18d VampireSaved's eight skills at the commit its census records
# (docs/census/vampiresaved.md, read by bbx.recount's one parser) through a private copy of bbh's
# example/consumers/bbh.vampire.toml whose root is that clone (bbh's rule on a config that lives outside its tree).
# ONE normalisation: the generator's stale line names the command to run, `bbx skill-guide` on BBX's side, read as
# `bbh skill-guide` before the diff. Beside the pairs, every `[BBH-N]` BBX's own generated skill (skill/bbx/SKILL.md)
# cites is resolved against bbh's skill on the same clone at the baseline (R4, R56; S5 step 4).
# Usage: BBX_BBH_HOME=~/Developer/blackbox-harness gates/fidelity_bbh_s5.sh     (static tier)
# SKIP: BBX_BBH_HOME unset or not a bbh tree (exit 0; asserts nothing).
# READ-ONLY (R18, R20): bbh on a PLAIN LOCAL CLONE of the baseline (lib/sh/baseline.sh, docs/defaults.md D20) and
# VampireSaved on a plain clone of its census commit, both under TMPDIR, each required clean of tracked, untracked AND
# ignored entries after the run; PYTHONDONTWRITEBYTECODE=1 for the whole gate, as in fidelity_bbh_s2.sh.
# MUST-FIRE: shadow-tool: verdict-text-f18 — a shadow BBX home whose lifted lock prints one verdict string changed must make an F18a pair differ, or the diff cannot fail
# MUST-FIRE: perturbed-copy: unresolved-bbh-citation — a copy of BBX's skill with a planted [BBH-999] must FAIL naming it, or the citation check cannot fail
# NOT-ASSERTED: a skill whose rule definitions wrap onto a second line, or a number outside bbh's six patterns: no F18 input carries either, and gates/skills.sh is where BBX's two deltas for them are asserted (R54)
# NOT-ASSERTED: that a [BBH-N] BBX's skill cites says what the BBX rule says: only that bbh's skill at the fidelity baseline defines the id is read (R56)
# NOT-ASSERTED: the --help text of the two lifted tools, which names bbx and $BBX_CONFIG by design; no pair asks for help
# NOT-ASSERTED: VampireSaved's eight skills on a host whose census-recorded VampireSaved path holds no copy of the recorded commit: F18d is then not run, and a NOTE says so
# NOT-ASSERTED: that any skill says anything true, or that bbh's H10 is correct: identical output on both sides is fidelity, not truth
#
set -eu
BBX_HOME="$(cd "$(dirname "$0")/.." && pwd)"; export BBX_HOME
PYTHONDONTWRITEBYTECODE=1; export PYTHONDONTWRITEBYTECODE
unset BBX_CONFIG BBH_CONFIG PYTHONPATH 2>/dev/null || true
B_SRC="${BBX_BBH_HOME:-}"
[ -n "$B_SRC" ] && [ -x "$B_SRC/bin/bbh-run-static" ] || { echo "SKIP: BBX_BBH_HOME is not a bbh tree (${B_SRC:-unset}); fidelity needs it"; exit 0; }
B_SRC="$(cd "$B_SRC" && pwd)"
. "$BBX_HOME/lib/sh/baseline.sh"          # THE ONE DEFINITION (R43); docs/defaults.md D20
BASELINE="$(bbx_baseline)"
rc=0
ok()   { printf '  ok    %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1"; rc=1; }
T="$(mktemp -d)"; trap 'rm -rf "$T"' EXIT INT TERM
_tip="$(git -C "$B_SRC" rev-parse --short HEAD)"; _porc="$(git -C "$B_SRC" status --porcelain | wc -l | tr -d ' ')"
git -C "$B_SRC" cat-file -e "$BASELINE^{commit}" 2>/dev/null || { echo "FAIL: baseline $BASELINE is not a commit of $B_SRC (BBX_BBH_BASELINE)"; exit 1; }
B="$T/bbh"
{ git clone -q --no-checkout "$B_SRC" "$B" && git -C "$B" checkout -q "$BASELINE"; } || { echo "SETUP-FAIL: could not clone $B_SRC at $BASELINE under $T"; exit 1; }
_ahead="$(git -C "$B_SRC" rev-list --count "$BASELINE..HEAD" 2>/dev/null || echo '?')"
echo "bbh: $B_SRC tip=$_tip porcelain=$_porc — measured on a plain clone at $BASELINE (R8, R20), ahead=$_ahead"
[ "$_ahead" = 0 ] || echo "NOTE: bbh-drift baseline=$BASELINE tip=$_tip ahead=$_ahead"

pairs=0; bad=0
BH="$BBX_HOME"      # the BBX home whose bin/bbx is measured; the control points it at a shadow and back
judge() {  # judge <label> — diff the two captured sides
    pairs=$((pairs + 1))
    if diff "$T/a.txt" "$T/b.txt" > "$T/d.txt"; then ok "$1 — identical ($(tail -2 "$T/a.txt" | tr '\n' ' ' | cut -c1-72))"
    else bad=$((bad + 1)); fail "$1 — DIFFERS:"; head -12 "$T/d.txt" | sed 's/^/        /'; fi
}
pair() {  # pair <label> <dir> <args...> — bbh's and BBX's command in the same directory (neither writes): output + exit diffed
    _l="$1"; _d="$2"; shift 2
    (set +e; cd "$_d" && "$B/bin/bbh" "$@" 2>&1; echo "exit=$?") > "$T/a.txt"
    (set +e; cd "$_d" && "$BH/bin/bbx" "$@" 2>&1; echo "exit=$?") | sed 's/bbx skill-guide/bbh skill-guide/g' > "$T/b.txt"
    judge "$_l"
}
pair2() {  # pair2 <label> <dir-bbh> <dir-bbx> <args...> — each side in its own copy (the command may write): output + exit diffed
    _l="$1"; _da="$2"; _db="$3"; shift 3
    (set +e; cd "$_da" && "$B/bin/bbh" "$@" 2>&1; echo "exit=$?") > "$T/a.txt"
    (set +e; cd "$_db" && "$BH/bin/bbx" "$@" 2>&1; echo "exit=$?") | sed 's/bbx skill-guide/bbh skill-guide/g' > "$T/b.txt"
    judge "$_l"
}
samebytes() {  # samebytes <label> <file-a> <file-b>
    if cmp -s "$2" "$3"; then ok "$1 — byte-identical ($(wc -c < "$2" | tr -d ' ') B)"; else bad=$((bad + 1)); fail "$1 — the written files differ"; fi
}

echo "== F18a. bbh's own skill, on the clone at $BASELINE =="
pair "F18a check-skills --config skill/skills.toml -v" "$B" check-skills --config skill/skills.toml -v
pair "F18a check-skills --config skill/skills.toml --no-selftest" "$B" check-skills --config skill/skills.toml --no-selftest
pair "F18a skill-guide --config skill/skills.toml --check" "$B" skill-guide --config skill/skills.toml --check
pair "F18a skill-guide --check --prefix BBH" "$B" skill-guide --config skill/skills.toml --check --prefix BBH
pair "F18a skill-guide --check --prefix NOPE (no such table)" "$B" skill-guide --config skill/skills.toml --check --prefix NOPE
pair "F18a check-skills -v with no config (refused)" "$B" check-skills -v
pair "F18a skill-guide --check with no config (refused)" "$B" skill-guide --check
for s in a b; do mkdir -p "$T/w$s"; git -C "$B" archive HEAD | tar -x -f - -C "$T/w$s"; rm "$T/w$s/skill/blackbox-harness/GUIDE.md"; done
pair2 "F18a skill-guide regenerates the guide (each side on its own copy)" "$T/wa" "$T/wb" skill-guide --config skill/skills.toml
samebytes "F18a the two regenerated guides" "$T/wa/skill/blackbox-harness/GUIDE.md" "$T/wb/skill/blackbox-harness/GUIDE.md"

echo "== F18b. the synthetic consumer of bbh's selftest/test_skills.sh, and its perturbations =="
# mk: transcribed from bbh selftest/test_skills.sh at the baseline (the input only; both sides read the same tree)
mk() {  # mk <dir>
    mkdir -p "$1/skills/aa" "$1/skills/bb" "$1/docs"
    cat > "$1/bbh.toml" <<'EOF'
[project]
root = "."
[skills]
prefixes = ["AA", "BB"]
history_exempt = ["docs/archive_history.md"]
guided = ["AA"]
guide_origin = "a synthetic project"
[skill_AA]
path = "skills/aa/SKILL.md"
docs = ["docs/ref.md", "docs/rolling.md"]
logs = ["docs/ref.md", "docs/ref_history.md", "docs/archive_history.md"]
forbid = ["vsav", "[ZZ-"]
sections = [["docs/rolling.md", "## Standing"]]
[skill_BB]
path = "skills/bb/SKILL.md"
docs = ["docs/ref.md"]
logs = ["docs/ref.md"]
forbid = []
EOF
    printf -- '---\nname: aa\ndescription: the first\n---\n# The first skill\n\n## 1. Rules\n\n- [AA-1] rule one quotes 0x600000 and cites [BB-1].\n- [AA-2] rule two, anchored in the rolling file.\n' > "$1/skills/aa/SKILL.md"
    printf -- '---\nname: bb\ndescription: the second\n---\n# The second skill\n\n## 1. Rules\n\n- [BB-1] rule one of the second.\n' > "$1/skills/bb/SKILL.md"
    printf -- '# Ref\n\n## Things\n\nThe first paragraph. **[AA-1]** The rule one paragraph, with its incident.\n\nAnother. **[BB-1]** The second skill'"'"'s rule.\n' > "$1/docs/ref.md"
    printf -- '# Rolling\n\n## Standing\n\n**[AA-2]** The standing paragraph.\n\n## Sessions\n\nsession notes that roll over\n' > "$1/docs/rolling.md"
    printf -- '# Ref history\n\n2026-01-01 measured 0x600000.\n' > "$1/docs/ref_history.md"
    printf -- '# Archive\n\nold sessions, no anchors\n' > "$1/docs/archive_history.md"
}
S="$T/syn"
mk "$S/base"
pair "F18b the matched consumer, -v" "$S/base" check-skills --config bbh.toml -v
mk "$S/a"; printf -- '- [AA-9] a rule nobody anchored\n' >> "$S/a/skills/aa/SKILL.md"
pair "F18b an unanchored rule" "$S/a" check-skills --config bbh.toml --no-selftest
mk "$S/b"; sed -i.bak 's/\*\*\[AA-1\]\*\* //' "$S/b/docs/ref.md"
pair "F18b a stripped anchor" "$S/b" check-skills --config bbh.toml --no-selftest
mk "$S/c"; printf -- '\n**[AA-7]** an orphan anchor\n' >> "$S/c/docs/ref.md"
pair "F18b an orphan anchor" "$S/c" check-skills --config bbh.toml --no-selftest
mk "$S/d"; printf -- '\nA note that names vsav by name.\n' >> "$S/d/skills/aa/SKILL.md"
pair "F18b a forbidden token" "$S/d" check-skills --config bbh.toml --no-selftest
mk "$S/e"; printf -- '\nThe magic figure is 0xDEADBEEF1.\n' >> "$S/e/skills/aa/SKILL.md"
pair "F18b a number in no log" "$S/e" check-skills --config bbh.toml --no-selftest
mk "$S/f"; printf -- '- [AA-3] cites [BB-8], which BB never defined.\n' >> "$S/f/skills/aa/SKILL.md"; printf -- '\n**[AA-3]** anchor three.\n' >> "$S/f/docs/ref.md"
pair "F18b a dangling cross-reference" "$S/f" check-skills --config bbh.toml --no-selftest
mk "$S/g"; printf -- '- [AA-3] cites [ZZ-1], a skill outside the table.\n' >> "$S/g/skills/aa/SKILL.md"; printf -- '\n**[AA-3]** anchor three.\n' >> "$S/g/docs/ref.md"
pair "F18b a foreign prefix barred by a forbid token" "$S/g" check-skills --config bbh.toml --no-selftest
mk "$S/h"; printf -- '\n**[AA-2]** moved into the twin\n' >> "$S/h/docs/ref_history.md"; sed -i.bak 's/\*\*\[AA-2\]\*\* //' "$S/h/docs/rolling.md"
pair "F18b an anchor in a history twin" "$S/h" check-skills --config bbh.toml --no-selftest
mk "$S/i"; printf -- '\n**[AA-5]** an anchor in the rolling part\n' >> "$S/i/docs/rolling.md"; printf -- '- [AA-5] a rule anchored where the file rolls\n' >> "$S/i/skills/aa/SKILL.md"
pair "F18b an anchor outside the named sections" "$S/i" check-skills --config bbh.toml --no-selftest
mk "$S/ja"; mk "$S/jb"
pair2 "F18b skill-guide writes the guide (each side on its own copy)" "$S/ja" "$S/jb" skill-guide --config bbh.toml
samebytes "F18b the two written guides" "$S/ja/skills/aa/GUIDE.md" "$S/jb/skills/aa/GUIDE.md"
pair2 "F18b skill-guide --check on the fresh guide" "$S/ja" "$S/jb" skill-guide --config bbh.toml --check
for s in ja jb; do sed -i.bak 's/rule two, anchored/rule two, REWORDED, anchored/' "$S/$s/skills/aa/SKILL.md"; done
pair2 "F18b a stale guide after the rule was reworded" "$S/ja" "$S/jb" skill-guide --config bbh.toml --check
mkdir -p "$S/none"; printf '[project]\nroot = "."\n' > "$S/none/bbh.toml"
pair "F18b a config with no skill (refused)" "$S/none" check-skills --config bbh.toml

echo "== F18c. the lock's own synthetic selftest, run by default =="
pair "F18c check-skills with its selftest, over the matched consumer" "$S/base" check-skills --config bbh.toml
pair "F18c check-skills with its selftest, over a perturbed consumer" "$S/a" check-skills --config bbh.toml

echo "== F18d. VampireSaved's eight skills at the commit its census records =="
_vs="$(PYTHONPATH="$BBX_HOME/lib/py" python3 -c 'import sys; from bbx.recount import parse_census; h, r, _ = parse_census(sys.argv[1]); print(h, r)' "$BBX_HOME/docs/census/vampiresaved.md" 2>/dev/null)" || _vs=""
VS_HEAD="${_vs%% *}"; VS_SRC="${_vs#* }"
if [ -z "$_vs" ] || [ ! -d "$VS_SRC/.git" ] || ! git -C "$VS_SRC" cat-file -e "$VS_HEAD^{commit}" 2>/dev/null; then
    echo "NOTE: f18d not-run reason=no-vampiresaved-tree-holding-${VS_HEAD:-unknown}"
else
    V="$T/vs"
    { git clone -q --no-checkout "$VS_SRC" "$V" && git -C "$V" checkout -q "$VS_HEAD"; } || { echo "SETUP-FAIL: could not clone $VS_SRC at $VS_HEAD under $T"; exit 1; }
    python3 - "$B/example/consumers/bbh.vampire.toml" "$T/vampire.toml" "$V" <<'EOF'
import re, sys
src, dst, root = sys.argv[1:4]
text = open(src, encoding="utf-8").read()
new, n = re.subn(r'(?m)^root = .*$', lambda m: 'root = "' + root + '"', text, count=1)
if n != 1:
    sys.exit("SETUP-FAIL: no root line in " + src)
open(dst, "w", encoding="utf-8").write(new)
EOF
    pair "F18d check-skills -v over the eight skills" "$V" check-skills --config "$T/vampire.toml" -v
    pair "F18d skill-guide --check over the guided skills" "$V" skill-guide --config "$T/vampire.toml" --check
    _vd="$(git -C "$V" status --porcelain --ignored)"
    if [ -z "$_vd" ]; then ok "the VampireSaved clone is clean after the run: 0 tracked, untracked or ignored entries"
    else fail "the VampireSaved clone was WRITTEN by this gate:"; printf '%s\n' "$_vd" | sed 's/^/        /' | head -12; fi
    echo "NOTE: f18d vampiresaved=$VS_HEAD"
fi
echo "  F18: $pairs pairs, $bad differ"

echo "== MUST-FIRE: a verdict-text change is visible to F18 =="
SB="$T/shadow"; mkdir -p "$SB/bin" "$SB/lib"; cp "$BBX_HOME/bin/bbx" "$SB/bin/bbx"; cp -R "$BBX_HOME/lib/py" "$SB/lib/py"
sed -i.bak 's/"ALL PASS (/"ALL PASS. (/' "$SB/lib/py/bbx/checkskills.py"
if cmp -s "$SB/lib/py/bbx/checkskills.py" "$BBX_HOME/lib/py/bbx/checkskills.py"; then echo "CONTROL DEAD: verdict-text-f18 — the shadow copy was not perturbed (sed matched nothing)"; fail "control could not be built"
else
    # the shadow pair is MEANT to fail: its counters and rc are restored to what they were, never reset to zero,
    # so a failure recorded before this section (a written clone, a differing pair) still decides the verdict
    _pb=$pairs; _bb=$bad; _rb=$rc
    BH="$SB"
    pair "shadow: F18a check-skills -v" "$B" check-skills --config skill/skills.toml -v > "$T/shadow.out" 2>&1 || true
    BH="$BBX_HOME"
    if [ "$bad" -gt "$_bb" ]; then echo "CONTROL FIRED: verdict-text-f18 — one changed verdict string in the lifted lock, the pair differs: $(grep '^[<>]' "$T/d.txt" | tr '\n' ' ' | cut -c1-80)"; bad=$_bb; rc=$_rb; ok "the F18 diff can fail"
    else echo "CONTROL DEAD: verdict-text-f18 — a changed verdict string produced an empty diff"; fail "the diff cannot fail"; fi
    pairs=$_pb
fi

echo "== [BBH-N]: every bbh rule BBX's own skill cites is defined in bbh's skill at $BASELINE (R4, R56) =="
cite_check() {  # cite_check <a BBX SKILL.md> — one verdict line; exit 1 when a citation does not resolve
    PYTHONPATH="$BBX_HOME/lib/py" python3 - "$1" "$B/skill/blackbox-harness/SKILL.md" <<'EOF'
import re, sys
from bbx.checkskills import skill_defs
skill = open(sys.argv[1], encoding="utf-8").read()
defined = set(skill_defs(open(sys.argv[2], encoding="utf-8").read()))
cited = re.findall(r"(?<!\*)\[(BBH-\d+)\](?!\*)", skill.split("\n---\n", 1)[-1])
if not defined:
    sys.exit("FAIL bbh-citations: bbh's skill at the baseline defines no rule, so the extractor read nothing")
if not cited:
    sys.exit("FAIL bbh-citations: BBX's skill cites no [BBH-N], so the check would pass on nothing")
missing = sorted({c for c in cited if c not in defined}, key=lambda c: int(c.split("-")[1]))
if missing:
    sys.exit(f"FAIL bbh-citations: {', '.join('[' + m + ']' for m in missing)} not defined in bbh's skill ({len(defined)} rules)")
print(f"bbh-citations cited={len(cited)} distinct={len(set(cited))} defined_in_bbh={len(defined)} unresolved=0")
EOF
}
if [ -f "$BBX_HOME/skill/bbx/SKILL.md" ]; then
    if _c="$(cite_check "$BBX_HOME/skill/bbx/SKILL.md" 2>&1)"; then ok "$_c"; else fail "$_c"; fi
    cp "$BBX_HOME/skill/bbx/SKILL.md" "$T/cite_skill.md"
    printf -- '- [BBX-999] a planted rule citing a bbh rule no skill defines. [BBH-999]\n' >> "$T/cite_skill.md"
    if _c="$(cite_check "$T/cite_skill.md" 2>&1)"; then echo "CONTROL DEAD: unresolved-bbh-citation — a planted [BBH-999] resolved"; fail "the citation check cannot fail"
    elif printf '%s\n' "$_c" | grep -q -F '[BBH-999] not defined'; then echo "CONTROL FIRED: unresolved-bbh-citation — $_c"; ok "an unresolved citation fails"
    else echo "CONTROL DEAD: unresolved-bbh-citation — it failed for another reason: $_c"; fail "the citation check failed for another reason"; fi
else
    fail "BBX's own skill skill/bbx/SKILL.md is missing, so no citation was resolved"
fi

echo "== READ-ONLY: the bbh clone after the run (R18, R20) =="
_dirt="$(git -C "$B" status --porcelain --ignored)"
if [ -z "$_dirt" ]; then ok "the clone is clean after the run: 0 tracked, untracked or ignored entries"
else fail "the clone was WRITTEN by this gate:"; printf '%s\n' "$_dirt" | sed 's/^/        /' | head -12; fi
echo "NOTE: bbh-source tip=$_tip porcelain=$_porc untouched-by-construction=clone"

echo
[ "$rc" = 0 ] && [ "$bad" = 0 ] && echo "PASS: BBX's lifted skills lock and guide generator reproduce bbh's verdict text over $pairs pairings (F18)" || { echo "FAIL: see above"; exit 1; }
