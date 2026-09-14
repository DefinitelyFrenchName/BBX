#!/bin/sh
# skills.sh — the skills lock fires on every perturbation of a synthetic consumer, refuses a wrapped definition, and reads a plain integer under the integers vocabulary (S5 step 2)
# Ground truth for lib/py/bbx/checkskills.py and gen_skill_guide.py through `bin/bbx check-skills` and `bin/bbx
# skill-guide`, on a host with nothing but sh and python3. §1–§4 lift the shapes of bbh selftest/test_skills.sh at the
# fidelity baseline: a matched consumer passes and its guide generates and checks current; each perturbation fails for
# its stated reason; the lock's own selftest runs by default; a config naming no skill is refused. §5 and §6 are BBX's
# two deltas (R54), each proven both ways: a definition followed by a continuation line fails naming the rule and the
# line, while the next item, a heading or a blank line does not; and `[skill_<PFX>].numbers = "integers"` reads a
# two-digit figure the `lineage` default leaves unasked, found in a log only as a whole integer token, with identifiers,
# section numbers and years not demanded and a value outside the vocabularies refused.
# Usage: gates/skills.sh     (portable)
# MUST-FIRE: perturbed-copy: unanchored-rule — a rule added to a copy of the skill with no anchor must FAIL naming it ANCHORED NOWHERE
# MUST-FIRE: perturbed-copy: stripped-anchor — an anchor removed from a copy of the doc must FAIL its rule as ANCHORED NOWHERE
# MUST-FIRE: perturbed-copy: orphan-anchor — an anchor added to a copy of the doc with no rule must FAIL as NOT DEFINED in the skill
# MUST-FIRE: perturbed-copy: forbidden-token — a forbidden token in a copy of the skill's body must FAIL naming the token
# MUST-FIRE: perturbed-copy: lineage-number-in-no-log — a hex figure no log carries, under the default vocabulary, must FAIL as in NO log
# MUST-FIRE: perturbed-copy: dangling-cross-reference — a cross-reference to a rule the other configured skill never defines must FAIL naming it
# MUST-FIRE: perturbed-copy: foreign-prefix-barred — a cross-reference to a prefix outside the table, barred by a bracket forbid token, must FAIL naming the token
# MUST-FIRE: perturbed-copy: anchor-in-history-twin — an anchor moved into a history twin must FAIL naming the twin
# MUST-FIRE: perturbed-copy: anchor-outside-sections — an anchor in the rolling part of a sectioned doc must FAIL as OUTSIDE the standing sections
# MUST-FIRE: perturbed-copy: stale-guide — a rule reworded after its guide was generated must make skill-guide --check FAIL as STALE
# MUST-FIRE: known-bad: no-skill-config — a config naming no skill must be refused, never passed
# MUST-FIRE: perturbed-copy: wrapped-definition — a definition continued on an indented line must FAIL naming the rule and the line (R54)
# MUST-FIRE: perturbed-copy: lazy-continuation — a definition continued on an unindented line must FAIL naming the rule and the line (R54)
# MUST-FIRE: perturbed-copy: number-in-no-log — under numbers = "integers", a two-digit figure no log carries must FAIL as in NO log (R54)
# MUST-FIRE: known-bad: integer-substring — under numbers = "integers", a figure a log holds only inside longer digit runs must still FAIL as in NO log
# MUST-FIRE: known-bad: unknown-vocabulary — a numbers value outside the vocabularies must be refused, naming the key
# NOT-ASSERTED: anything about a real skill: every input here is a synthetic consumer (fixture class); bbh's and VampireSaved's skills are read by gates/fidelity_bbh_s5.sh (F18)
# NOT-ASSERTED: that the lift left bbh's messages unchanged: gates/fidelity_bbh_s5.sh diffs them
# NOT-ASSERTED: the guide generator alone over a wrapped definition: it still quotes the first line, and the lock is what refuses the skill (R54)
# NOT-ASSERTED: that a small integer a skill quotes is the one its log means: only its presence as a token somewhere in the declared logs is read, and over docs/gotchas.md and docs/census/*.md 89 of the 90 two-digit integers occur (measured bbx-26)
# NOT-ASSERTED: an integer glued to a letter or written after a hyphen, dot, comma, $ or §: it reads as part of an identifier and is not demanded; and a run of four or more digits inside a commit id is still read by bbh's patterns under either vocabulary (G64)
#
set -eu
BBX_HOME="$(cd "$(dirname "$0")/.." && pwd)"; export BBX_HOME
PYTHONDONTWRITEBYTECODE=1; export PYTHONDONTWRITEBYTECODE
unset BBX_CONFIG PYTHONPATH 2>/dev/null || true
rc=0
ok()   { printf '  ok    %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1"; rc=1; }
T="$(mktemp -d)"; trap 'rm -rf "$T"' EXIT INT TERM

# a synthetic consumer: two skills, a doc, a rolling doc, a history twin, an archive (bbh selftest/test_skills.sh's shape)
mk() {  # mk <dir>
    mkdir -p "$1/skills/aa" "$1/skills/bb" "$1/docs"
    cat > "$1/bbx.toml" <<'EOF'
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
run()   { _d="$1"; shift; (cd "$_d" && "$BBX_HOME/bin/bbx" check-skills --config bbx.toml "$@" 2>&1); }
guide() { _d="$1"; shift; (cd "$_d" && "$BBX_HOME/bin/bbx" skill-guide --config bbx.toml "$@" 2>&1); }
setkey() {  # setkey <dir> <line> — one line added to [skill_AA], directly under its path
    awk -v add="$2" '{ print } $0 == "path = \"skills/aa/SKILL.md\"" { print add }' "$1/bbx.toml" > "$1/bbx.toml.new" && mv "$1/bbx.toml.new" "$1/bbx.toml"
}
control() {  # control <name> <expected substring> <command...> — the command must FAIL, printing the substring
    _n="$1"; _e="$2"; shift 2
    if _o="$("$@")"; then echo "CONTROL DEAD: $_n — the perturbed input PASSED"; fail "$_n: the check is not checking"; printf '%s\n' "$_o" | sed 's/^/        /'
    elif printf '%s\n' "$_o" | grep -q -F -- "$_e"; then echo "CONTROL FIRED: $_n — $_e"; ok "$_n: fails for its stated reason"
    else echo "CONTROL DEAD: $_n — it failed for another reason"; fail "$_n: wrong reason:"; printf '%s\n' "$_o" | sed 's/^/        /'; fi
}
passes() {  # passes <label> <command...> — the command must PASS
    _l="$1"; shift
    if _o="$("$@")"; then ok "$_l: $(printf '%s\n' "$_o" | tail -1 | cut -c1-70)"; else fail "$_l — refused:"; printf '%s\n' "$_o" | sed 's/^/        /'; fi
}

echo "== 1. a matched synthetic consumer PASSES, and its guide generates and checks current =="
mk "$T/base"
passes "check-skills -v over the matched consumer" run "$T/base" -v
run "$T/base" -v | grep -q -x -F '  AA: 2 rules defined in skills/aa/SKILL.md' && ok "-v lists each skill's rule count in [skills].prefixes order" || fail "-v does not list AA's two rules"
guide "$T/base" > /dev/null && [ -s "$T/base/skills/aa/GUIDE.md" ] && ok "skill-guide wrote skills/aa/GUIDE.md" || fail "skill-guide did not write the guide"
grep -q -x -F '# The first skill — the guide' "$T/base/skills/aa/GUIDE.md" && grep -q -F 'Origin: a synthetic project' "$T/base/skills/aa/GUIDE.md" && ok "the guide's header carries the title and the configured origin" || fail "the guide's header is wrong"
grep -q -x -F '> The first paragraph. The rule one paragraph, with its incident.' "$T/base/skills/aa/GUIDE.md" && ok "the incident is the anchored paragraph with its marker stripped" || fail "the incident block is wrong"
grep -q -F '**[AA-1]** rule one quotes 0x600000' "$T/base/skills/aa/GUIDE.md" && ok "the rule is quoted verbatim under its id" || fail "the rule line is not in the guide"
passes "skill-guide --check on the fresh guide" guide "$T/base" --check

echo "== 2. MUST-FIRE: each perturbation of the consumer fails for its stated reason =="
mk "$T/a"; printf -- '- [AA-9] a rule nobody anchored\n' >> "$T/a/skills/aa/SKILL.md"
control unanchored-rule "ANCHORED NOWHERE: AA-9" run "$T/a" --no-selftest
mk "$T/b"; sed -i.bak 's/\*\*\[AA-1\]\*\* //' "$T/b/docs/ref.md"
control stripped-anchor "ANCHORED NOWHERE: AA-1" run "$T/b" --no-selftest
mk "$T/c"; printf -- '\n**[AA-7]** an orphan anchor\n' >> "$T/c/docs/ref.md"
control orphan-anchor "NOT DEFINED in the skill: AA-7" run "$T/c" --no-selftest
mk "$T/d"; printf -- '\nA note that names vsav by name.\n' >> "$T/d/skills/aa/SKILL.md"
control forbidden-token "level-1 skill names 'vsav'" run "$T/d" --no-selftest
mk "$T/e"; printf -- '\nThe magic figure is 0xDEADBEEF1.\n' >> "$T/e/skills/aa/SKILL.md"
control lineage-number-in-no-log "in NO log: 0xDEADBEEF1" run "$T/e" --no-selftest
mk "$T/f"; printf -- '- [AA-3] cites [BB-8], which BB never defined.\n' >> "$T/f/skills/aa/SKILL.md"; printf -- '\n**[AA-3]** anchor three.\n' >> "$T/f/docs/ref.md"
control dangling-cross-reference "cross-reference [BB-8]" run "$T/f" --no-selftest
mk "$T/g"; printf -- '- [AA-3] cites [ZZ-1], a skill outside the table.\n' >> "$T/g/skills/aa/SKILL.md"; printf -- '\n**[AA-3]** anchor three.\n' >> "$T/g/docs/ref.md"
control foreign-prefix-barred "level-1 skill names '[ZZ-'" run "$T/g" --no-selftest
mk "$T/h"; printf -- '\n**[AA-2]** moved into the twin\n' >> "$T/h/docs/ref_history.md"; sed -i.bak 's/\*\*\[AA-2\]\*\* //' "$T/h/docs/rolling.md"
control anchor-in-history-twin "anchored in HISTORY file docs/ref_history.md" run "$T/h" --no-selftest
mk "$T/i"; printf -- '\n**[AA-5]** an anchor in the rolling part\n' >> "$T/i/docs/rolling.md"; printf -- '- [AA-5] a rule anchored where the file rolls\n' >> "$T/i/skills/aa/SKILL.md"
control anchor-outside-sections "AA-5 anchored in docs/rolling.md OUTSIDE" run "$T/i" --no-selftest
mk "$T/j"; guide "$T/j" > /dev/null; sed -i.bak 's/rule two, anchored/rule two, REWORDED, anchored/' "$T/j/skills/aa/SKILL.md"
control stale-guide "is STALE" guide "$T/j" --check
mkdir -p "$T/none"; printf '[project]\nroot = "."\n' > "$T/none/bbx.toml"
control no-skill-config "names no skill" run "$T/none"

echo "== 3. the lock's own selftest runs by default, and passes =="
passes "check-skills without --no-selftest" run "$T/base"

echo "== 5. a definition is ONE line (R54), both ways =="
mk "$T/w0"; printf -- '## 2. A heading straight after the last definition\n\nA note after a blank line.\n' >> "$T/w0/skills/aa/SKILL.md"
passes "a definition followed by the next item, a heading or a blank line is not continued" run "$T/w0" --no-selftest
mk "$T/w1"; printf -- '  continued on an indented second line.\n' >> "$T/w1/skills/aa/SKILL.md"
control wrapped-definition "rule AA-2 wraps onto line 11 of skills/aa/SKILL.md" run "$T/w1" --no-selftest
mk "$T/w2"; printf -- 'continued with no indentation at all.\n' >> "$T/w2/skills/aa/SKILL.md"
control lazy-continuation "rule AA-2 wraps onto line 11 of skills/aa/SKILL.md" run "$T/w2" --no-selftest

echo "== 6. the number vocabulary per skill (R54), both ways =="
mk "$T/n0"; printf -- '\nThe mature sweep found 19 reds.\n' >> "$T/n0/skills/aa/SKILL.md"
passes "the lineage vocabulary (the default) leaves a two-digit figure unasked" run "$T/n0" --no-selftest
mk "$T/n1"; printf -- '\nThe mature sweep found 19 reds.\n' >> "$T/n1/skills/aa/SKILL.md"; setkey "$T/n1" 'numbers = "integers"'
control number-in-no-log "in NO log: 19" run "$T/n1" --no-selftest
mk "$T/n2"; printf -- '\nThe mature sweep found 19 reds.\n' >> "$T/n2/skills/aa/SKILL.md"; setkey "$T/n2" 'numbers = "integers"'; printf -- '\nThe sweep found 19 reds, says the log.\n' >> "$T/n2/docs/ref.md"
passes "under integers, a figure the log holds as a token is found" run "$T/n2" --no-selftest
mk "$T/n3"; printf -- '\nThe mature sweep found 19 reds.\n' >> "$T/n3/skills/aa/SKILL.md"; setkey "$T/n3" 'numbers = "integers"'; printf -- '\nIn 2019 the counter read 1195.\n' >> "$T/n3/docs/ref.md"
control integer-substring "in NO log: 19" run "$T/n3" --no-selftest
mk "$T/n4"; printf -- '\nSee BBX-10, G61 and R4, commit 581eced, and section 3.2 of the doc, in 2026.\n' >> "$T/n4/skills/aa/SKILL.md"; setkey "$T/n4" 'numbers = "integers"'
passes "under integers, identifiers, a commit id, a section number and a year are not demanded" run "$T/n4" --no-selftest
mk "$T/n5"; setkey "$T/n5" 'numbers = "words"'
control unknown-vocabulary "[skill_AA].numbers is 'words'" run "$T/n5"

echo
[ "$rc" = 0 ] && echo "PASS: the skills lock fires on every perturbation of a synthetic consumer, refuses a wrapped definition both ways, and reads a plain integer under the integers vocabulary" || { echo "FAIL: see above"; exit 1; }
