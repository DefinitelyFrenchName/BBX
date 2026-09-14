#!/bin/sh
# skills.sh — the skills lock fires on every perturbation of a synthetic consumer, refuses a wrapped definition, and reads a plain integer under the integers vocabulary; the ledger reader derives which rules the incident ledger re-anchors; BBX's own generated skill is current, locked and guided (S5 steps 2 to 4)
# Ground truth for lib/py/bbx/checkskills.py and gen_skill_guide.py through `bin/bbx check-skills` and `bin/bbx
# skill-guide`, on a host with nothing but sh and python3. §1–§4 lift the shapes of bbh selftest/test_skills.sh at the
# fidelity baseline: a matched consumer passes and its guide generates and checks current; each perturbation fails for
# its stated reason; the lock's own selftest runs by default; a config naming no skill is refused. §5 and §6 are BBX's
# two deltas (R54), each proven both ways: a definition followed by a continuation line fails naming the rule and the
# line, while the next item, a heading or a blank line does not; and `[skill_<PFX>].numbers = "integers"` reads a
# two-digit figure the `lineage` default leaves unasked, found in a log only as a whole integer token, with identifiers,
# section numbers and years not demanded and a value outside the vocabularies refused.
# §7 is the ledger reader, lib/py/bbx/reanchors.py through `bin/bbx reanchors` (R53, D67): a synthetic rules document and
# ledger carry every list shape that G61 and docs/plans/S5.md appendix A name, read against the true table and against
# the table a defective reader would give; each guard is planted once; then BBX's own ledger is read through G60 against
# the §3.2 table quoted from the plan, and whole, its NOTE lines printed for the screen.
# §8 is BBX's own skill (R51, R52, R57; D68, D69): `bin/bbx skill-gen --check`, the lock and the guide over
# skill/skills.toml; then the slice's controls re-run on a copy of the files the skill is generated from, locked to and
# guided by, and each refusal of the generator planted once, with nothing written.
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
# MUST-FIRE: known-bad: wrapped-incident-list — a synthetic list wrapped onto a second line, against the table a reader of the lead's line alone gives, must FAIL naming the rule on the second line (G61)
# MUST-FIRE: known-bad: parenthesized-id — a rule id in a parenthesized explanation and a lead inside parentheses, against the table that credits them, must FAIL naming the rule
# MUST-FIRE: known-bad: quoted-lead — a lead quoted in straight quotes, curly quotes, a code span and a double-backtick span, against the table that credits all four, must FAIL on exactly those four rules
# MUST-FIRE: known-bad: dangling-rule-id — a list naming a rule id defined only outside the rules section must FAIL naming the id
# MUST-FIRE: known-bad: unread-heading — a G<n> heading at the wrong level and a `## ` heading that is not an entry must each FAIL naming its line
# MUST-FIRE: perturbed-copy: entry-sequence — a ledger whose entry ids skip must FAIL
# MUST-FIRE: perturbed-copy: old-wording — an entry from G61 on rewritten with an older lead must FAIL naming the entry (R53)
# MUST-FIRE: perturbed-copy: unbalanced-paragraph — a lead in a paragraph whose parenthesis never closes must FAIL naming the entry, never guess where its list ends
# MUST-FIRE: perturbed-copy: duplicate-rule — a rule id defined twice in the rules section must FAIL naming it
# MUST-FIRE: perturbed-copy: no-rules — a rules document with no `## 4.` section must be refused, never read as zero rules
# MUST-FIRE: known-bad: no-entries — a ledger with no entry heading must be refused, never read as zero entries
# MUST-FIRE: known-bad: wrong-population — the table quoted from docs/plans/S5.md §3.2 (G1–G60) against BBX's whole ledger must FAIL, while through G60 it reproduces (BBX-8)
# MUST-FIRE: perturbed-copy: stale-skill — a rule body edited in a copy of CLAUDE.md, the skill not regenerated, must make skill-gen --check FAIL naming skill/bbx/SKILL.md STALE
# MUST-FIRE: perturbed-copy: stale-rules-page — an entry re-anchoring an inherited rule appended to a copy of the ledger must make skill-gen --check FAIL naming docs/rules.md STALE while the skill stays current
# MUST-FIRE: perturbed-copy: own-unanchored-rule — a rule added to a copy of BBX's generated skill with no anchor must FAIL as ANCHORED NOWHERE
# MUST-FIRE: perturbed-copy: own-orphan-anchor — an anchor added to a copy of docs/rules.md with no rule must FAIL as NOT DEFINED in the skill
# MUST-FIRE: perturbed-copy: own-number-in-no-log — a two-digit integer neither of the skill's logs holds, planted in a copy of a rule, must FAIL as in NO log
# MUST-FIRE: perturbed-copy: own-forbidden-token — a lineage name R57 added to the forbid list, planted in a copy of a rule, must FAIL naming the token
# MUST-FIRE: perturbed-copy: own-foreign-bracket — another lineage skill's bracket citation planted in a copy of a rule must FAIL naming its prefix
# MUST-FIRE: perturbed-copy: own-stale-guide — an anchor paragraph changed in a copy of docs/rules.md, the guide not regenerated, must make skill-guide --check FAIL as STALE
# MUST-FIRE: perturbed-copy: unread-rule — a copy of CLAUDE.md whose rule lost its tag must be refused naming the line, the two readers disagreeing, with nothing written
# MUST-FIRE: perturbed-copy: rule-outside-group — a rule planted before the first group heading must be refused naming its line
# MUST-FIRE: perturbed-copy: empty-group — a group heading with no rule under it must be refused naming the group
# MUST-FIRE: perturbed-copy: gen-duplicate-rule — a rule id defined twice in a copy of CLAUDE.md must be refused by the generator naming it
# MUST-FIRE: perturbed-copy: range-citation — a tag citing a range of bbh ids must be refused naming the rule
# MUST-FIRE: perturbed-copy: page-not-in-docs — a skills table whose page is not among its docs must be refused
# MUST-FIRE: perturbed-copy: lacking-key — a skills table without a key the generator reads must be refused naming the key
# MUST-FIRE: perturbed-copy: ledger-finding-refused — a ledger entry naming a rule the constitution does not define must refuse the generation, with nothing written
# NOT-ASSERTED: that the lift left bbh's messages unchanged: gates/fidelity_bbh_s5.sh diffs them
# NOT-ASSERTED: the guide generator alone over a wrapped definition: it still quotes the first line, and the lock is what refuses the skill (R54)
# NOT-ASSERTED: that a small integer a skill quotes is the one its log means: only its presence as a token somewhere in the declared logs is read, and over docs/gotchas.md and docs/census/*.md 89 of the 90 two-digit integers occur (measured bbx-26)
# NOT-ASSERTED: an integer glued to a letter or written after a hyphen, dot, comma, $ or §: it reads as part of an identifier and is not demanded; and a run of four or more digits inside a commit id is still read by bbh's patterns under either vocabulary (G64)
# NOT-ASSERTED: that an incident truly re-anchors the rules its list names: only an entry's explicit list is read, never its prose, and never whether the incident happened in this tree (R53)
# NOT-ASSERTED: a list written in a wording the reader does not know: that entry reads as having no list and is named on the ledger NOTE line, never failed (D67)
# NOT-ASSERTED: BBX-25 for the ledger reader: its one consumer is BBX's own constitution and ledger (R50)
# NOT-ASSERTED: that a [BBH-N] BBX's skill cites is defined in bbh's skill: gates/fidelity_bbh_s5.sh resolves each against bbh's skill at the fidelity baseline (R56)
# NOT-ASSERTED: that a rule of BBX's skill is true or well chosen: the lock asserts anchoring, liftability, numbers and cross-references, and the page says which ledger entries name a rule, never that they justify it
# NOT-ASSERTED: that the installed skill is this tree's: the symlink under ~/.claude/skills is the maintainer's act (R57), and nothing here reads it
# NOT-ASSERTED: BBX-25 for the skill generator and its anchor page: their one consumer is BBX's own constitution and ledger (R50)
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

echo "== 7. the ledger reader (R53): which rules the incident ledger re-anchors, every list shape both ways =="
mkledger() {  # mkledger <dir> — a rules document and a ledger holding every list shape G61 and appendix A name, G6–G60 stubs, G61 in R53's wording
    mkdir -p "$1"
    cat > "$1/rules.md" <<'EOF'
# Rules

## 3. Before

- [BBX-8] a rule defined before the section, never read as one.

## 4. Rules — a synthetic seed

- [BBX-1] one.
- [BBX-2] two.
- [BBX-3] three.
- [BBX-4] four.
- [BBX-5] five.
- [BBX-6] six.
- [BBX-7] seven.

## 5. After
EOF
    cat > "$1/ledger.md" <<'EOF'
# Ledger

## G1 — plain (paid: 0)
Body. Re-anchors: BBX-1.

## G2 — a list that wraps (paid: 0)
A body whose list wraps. Rules re-anchored in fact: §1,
BBX-2.

## G3 — parentheses (paid: 0)
An aside (Re-anchors: BBX-3) is prose. Rules re-anchored in fact: BBX-1 (unlike BBX-3).

## G4 — quotations (paid: 0)
The entry said "Re-anchors: BBX-4", then “Re-anchors: BBX-5”, then `Rule re-anchored in fact: BBX-6`, then `` Re-anchors: BBX-7 and a ` tick ``. Rules re-anchored in fact: §1.

## G5 — no list (paid: 0)
Nothing here.

EOF
    i=6; while [ "$i" -le 60 ]; do printf '## G%d — a stub (paid: 0)\nNothing here.\n\n' "$i" >> "$1/ledger.md"; i=$((i + 1)); done
    printf '## G61 — in the one wording (paid: 0)\nRules re-anchored in fact: BBX-2.\n' >> "$1/ledger.md"
    printf 'BBX-1 G1 G3\nBBX-2 G2 G61\nBBX-3 -\nBBX-4 -\nBBX-5 -\nBBX-6 -\nBBX-7 -\n' > "$1/true.txt"
}
ra()   { _d="$1"; shift; "$BBX_HOME/bin/bbx" reanchors --root "$_d" --rules rules.md --ledger ledger.md "$@" 2>&1; }
real() { "$BBX_HOME/bin/bbx" reanchors --root "$BBX_HOME" "$@" 2>&1; }
variant() {  # variant <name> — a copy of the synthetic pair to perturb
    rm -rf "$T/l_$1"; cp -R "$T/l" "$T/l_$1"
}
mkledger "$T/l"
passes "the synthetic ledger reads as its lists state: wrapped, parenthesized, quoted, none" ra "$T/l" --against "$T/l/true.txt"
sed 's/^BBX-2 G2 G61$/BBX-2 G61/' "$T/l/true.txt" > "$T/l/wrapped.txt"
control wrapped-incident-list "against BBX-2 table=G61 read=G2,G61" ra "$T/l" --against "$T/l/wrapped.txt"
sed 's/^BBX-3 -$/BBX-3 G3/' "$T/l/true.txt" > "$T/l/paren.txt"
control parenthesized-id "against BBX-3 table=G3 read=-" ra "$T/l" --against "$T/l/paren.txt"
sed 's/^\(BBX-[4-7]\) -$/\1 G4/' "$T/l/true.txt" > "$T/l/quoted.txt"
control quoted-lead " errors=4" ra "$T/l" --against "$T/l/quoted.txt"
[ "$(ra "$T/l" --against "$T/l/quoted.txt" | grep -c '^ERROR: against BBX-[4-7] table=G4 read=-$')" = 4 ] && ok "quoted-lead: each of the four quotings is named, one rule each" || fail "quoted-lead: not every quoting is named on its own rule"
variant dangling; printf '\n## G62 — names a rule outside the section (paid: 0)\nRules re-anchored in fact: BBX-8.\n' >> "$T/l_dangling/ledger.md"
control dangling-rule-id "dangling-rule-id G62 BBX-8" ra "$T/l_dangling"
variant heading; printf '\n### G62 — at the wrong level (paid: 0)\nNothing here.\n\n## Notes\nprose\n' >> "$T/l_heading/ledger.md"
control unread-heading " errors=2" ra "$T/l_heading"
[ "$(ra "$T/l_heading" | grep -c '^ERROR: unread-heading line ')" = 2 ] && ok "unread-heading: both headings are named by line" || fail "unread-heading: not both headings are named"
variant sequence; sed -i.bak 's/^## G5 /## G70 /' "$T/l_sequence/ledger.md"
control entry-sequence "ERROR: entry-sequence" ra "$T/l_sequence"
variant wording; sed -i.bak 's/^Rules re-anchored in fact: BBX-2\.$/Re-anchors: BBX-2./' "$T/l_wording/ledger.md"
control old-wording "old-wording G61: 'Re-anchors:'" ra "$T/l_wording"
variant unbalanced; sed -i.bak 's/^Body\. Re-anchors: BBX-1\.$/Body (never closed. Re-anchors: BBX-1./' "$T/l_unbalanced/ledger.md"
control unbalanced-paragraph "ERROR: unbalanced G1:" ra "$T/l_unbalanced"
variant duplicate; awk '{ print } $0 == "- [BBX-7] seven." { print "- [BBX-1] again." }' "$T/l/rules.md" > "$T/l_duplicate/rules.md"
control duplicate-rule "ERROR: duplicate-rule BBX-1" ra "$T/l_duplicate"
variant norules; sed -i.bak 's/^## 4\. /## Four /' "$T/l_norules/rules.md"
control no-rules "ERROR: no-rules rules.md" ra "$T/l_norules"
variant noentries; printf '# Ledger\n\nprose only\n' > "$T/l_noentries/ledger.md"
control no-entries "ERROR: no-entries ledger.md" ra "$T/l_noentries"

# BBX's own: the plan's §3.2 table quoted from the document (BBX-18), the ledger read, the two compared
awk -F'|' '/^### 3\.2 /{ f = 1; next } /^### /{ f = 0 }
    f && $2 ~ /^ BBX-[0-9]+ $/ {
        id = $2; gsub(/ /, "", id); c = $4; gsub(/ /, "", c)
        e = $3; gsub(/,/, " ", e); n = split(e, a, " "); out = ""
        if (e !~ /G[0-9]/) n = 0
        for (i = 1; i <= n; i++) out = out (i > 1 ? " " : "") a[i]
        if (c + 0 != n) print "COUNT-DISAGREES " id " column=" c " entries=" n
        print id " " (n ? out : "-")
    }' "$BBX_HOME/docs/plans/S5.md" > "$T/table32.txt"
_rows="$(grep -c '^BBX-' "$T/table32.txt" || true)"
if grep -q '^COUNT-DISAGREES' "$T/table32.txt"; then fail "docs/plans/S5.md §3.2 disagrees with its own count column:"; grep '^COUNT-DISAGREES' "$T/table32.txt" | sed 's/^/        /'
elif [ "$_rows" = 30 ]; then ok "quoted docs/plans/S5.md §3.2: 30 rule rows, each count column equal to the entries it lists"
else fail "quoted $_rows rule rows from docs/plans/S5.md §3.2, expected CLAUDE.md §4's 30"; fi
passes "BBX's ledger through G60 reproduces the plan's §3.2 table rule by rule" real --through 60 --against "$T/table32.txt"
real --through 60 --against "$T/table32.txt" | grep -q ' re_anchored=23 inherited=7 errors=0$' && ok "through G60: 23 re-anchored and 7 inherited, as measured at bbx-26 (R53)" || fail "through G60 the reading is not 23 re-anchored and 7 inherited"
control wrong-population "ERROR: against BBX-6 table=" real --against "$T/table32.txt"
if real > "$T/real.out"; then ok "BBX's whole ledger: $(tail -1 "$T/real.out")"; else fail "BBX's whole ledger is refused:"; grep '^ERROR' "$T/real.out" | sed 's/^/        /'; fi
grep '^NOTE: ' "$T/real.out" || fail "the reader printed no NOTE line over BBX's ledger"

echo "== 8. BBX's own skill (S5 step 4): generated from CLAUDE.md §4 and the ledger, locked to docs/rules.md, its guide current =="
BT="$BBX_HOME/skill/skills.toml"
bx() { "$BBX_HOME/bin/bbx" "$@" 2>&1; }
if [ ! -f "$BT" ]; then
    fail "BBX's skills table skill/skills.toml is missing: §8 cannot run, and its controls stay unfired"
else
passes "skill-gen --check: skill/bbx/SKILL.md and docs/rules.md are current" bx skill-gen --config "$BT" --check
passes "check-skills over BBX's own skill" bx check-skills --config "$BT" -v
passes "skill-guide --check over BBX's own guide" bx skill-guide --config "$BT" --check
bx check-skills --config "$BT" -v | grep -q -x -F '  BBX: 30 rules defined in skill/bbx/SKILL.md' && ok "the lock reads the 30 rules of CLAUDE.md §4 in the generated skill" || fail "the lock does not read 30 rules in skill/bbx/SKILL.md"
PYTHONPATH="$BBX_HOME/lib/py" python3 -c 'import sys; from bbx import config as C; f = C.load(sys.argv[1])["skill_BBX"]["forbid"]; sys.exit(1 if not f or any("bbh" in t.lower() for t in f) else 0)' "$BT" && ok "the forbid list is not empty and bars no [BBH- and no bbh token (R4, R57)" || fail "the forbid list is empty or bars what R4 allows"
_ownfiles="$(PYTHONPATH="$BBX_HOME/lib/py" python3 -c 'import sys; from bbx import config as C; t = C.load(sys.argv[1])["skill_BBX"]; fs = ["skill/skills.toml", t["path"], t["path"].rsplit("/", 1)[0] + "/GUIDE.md", t["constitution"], t["ledger"], t["page"]] + list(t["docs"]) + list(t["logs"]); print(" ".join(dict.fromkeys(fs)))' "$BT")"
own() {  # own <name> — a copy of the files BBX's skill is generated from, locked to and guided by
    rm -rf "$T/o_$1"
    for _f in $_ownfiles; do mkdir -p "$(dirname "$T/o_$1/$_f")"; cp "$BBX_HOME/$_f" "$T/o_$1/$_f"; done
}
repl() {  # repl <file> <old> <new> — one literal replacement; <old> must occur exactly once, or the gate stops here
    python3 - "$1" "$2" "$3" <<'EOF'
import sys
p, old, new = sys.argv[1:4]
s = open(p, encoding="utf-8").read()
if s.count(old) != 1:
    sys.exit("repl: %r occurs %d times in %s" % (old, s.count(old), p))
open(p, "w", encoding="utf-8").write(s.replace(old, new))
EOF
}
ogen()   { _d="$T/o_$1"; shift; "$BBX_HOME/bin/bbx" skill-gen --config "$_d/skill/skills.toml" "$@" 2>&1; }
olock()  { _d="$T/o_$1"; shift; "$BBX_HOME/bin/bbx" check-skills --config "$_d/skill/skills.toml" --no-selftest "$@" 2>&1; }
oguide() { _d="$T/o_$1"; shift; "$BBX_HOME/bin/bbx" skill-guide --config "$_d/skill/skills.toml" "$@" 2>&1; }
unwritten() {  # unwritten <name> — a refused generation left the copy's two generated files as the tree has them
    cmp -s "$T/o_$1/skill/bbx/SKILL.md" "$BBX_HOME/skill/bbx/SKILL.md" && cmp -s "$T/o_$1/docs/rules.md" "$BBX_HOME/docs/rules.md"
}
own base
passes "a copy of the files reads as the tree does: the skill and the page current" ogen base --check
passes "a copy of the files reads as the tree does: the lock passes" olock base
passes "a copy of the files reads as the tree does: the guide current" oguide base --check
own sk; repl "$T/o_sk/CLAUDE.md" '- [BBX-3] `[inherited bbh; VS ".pending"]` An unvalidated expectation is a' '- [BBX-3] `[inherited bbh; VS ".pending"]` An always unvalidated expectation is a'
control stale-skill "skill/bbx/SKILL.md is STALE" ogen sk --check
own pg; _next=$(( $(grep -c '^## G[0-9]' "$T/o_pg/docs/gotchas.md") + 1 ))
printf '\n## G%d — a planted incident (paid: 0)\nRules re-anchored in fact: BBX-2.\n' "$_next" >> "$T/o_pg/docs/gotchas.md"
control stale-rules-page "docs/rules.md is STALE" ogen pg --check
ogen pg --check | grep -q -F 'ok    skill/bbx/SKILL.md is current' && ok "stale-rules-page: the skill itself stays current, only the page moved" || fail "stale-rules-page: the skill moved with the page"
own ua; printf -- '- [BBX-99] a planted rule nobody anchored.\n' >> "$T/o_ua/skill/bbx/SKILL.md"
control own-unanchored-rule "ANCHORED NOWHERE: BBX-99" olock ua
own oa; printf -- '\n**[BBX-99]** a planted anchor with no rule.\n' >> "$T/o_oa/docs/rules.md"
control own-orphan-anchor "NOT DEFINED in the skill: BBX-99" olock oa
_absent="$(PYTHONPATH="$BBX_HOME/lib/py" python3 -c 'import sys; from bbx import config as C; from bbx.checkskills import integers; t = C.load(sys.argv[1])["skill_BBX"]; have = set().union(*[integers(open(sys.argv[2] + "/" + p, encoding="utf-8").read()) for p in t["logs"]]); print(next((str(n) for n in range(10, 100) if str(n) not in have), ""))' "$BT" "$BBX_HOME")"
own nl
if [ -n "$_absent" ]; then
    repl "$T/o_nl/skill/bbx/SKILL.md" '- [BBX-3] An unvalidated expectation is a FAILURE' "- [BBX-3] A sweep counted $_absent reds. An unvalidated expectation is a FAILURE"
    control own-number-in-no-log "in NO log: $_absent" olock nl
else
    echo "CONTROL DEAD: own-number-in-no-log — every two-digit integer occurs in the skill's logs, so no figure can be planted"; fail "own-number-in-no-log: the logs hold every two-digit integer, and the integers check cannot fail on one"
fi
own ft; repl "$T/o_ft/skill/bbx/SKILL.md" '- [BBX-3] An unvalidated' '- [BBX-3] On fbneo, an unvalidated'
control own-forbidden-token "names 'fbneo'" olock ft
own fb; repl "$T/o_fb/skill/bbx/SKILL.md" 'is a FAILURE, not a pending note.' 'is a FAILURE, not a pending note [SSP-3].'
control own-foreign-bracket "names '[SSP-'" olock fb
own sg; repl "$T/o_sg/docs/rules.md" '**[BBX-2]** INHERITED: no entry' '**[BBX-2]** INHERITED (planted): no entry'
control own-stale-guide "is STALE" oguide sg --check
own ur; repl "$T/o_ur/CLAUDE.md" '- [BBX-3] `[inherited bbh; VS ".pending"]` ' '- [BBX-3] '
control unread-rule "unread-rule line" ogen ur
ogen ur | grep -q -F 'readers-disagree' && unwritten ur && ok "unread-rule: the two readers disagree on the ids, and nothing was written" || fail "unread-rule: no readers-disagree line, or a generated file was written"
own og; repl "$T/o_og/CLAUDE.md" '
**Verdicts**
' '
- [BBX-98] `[this project]` a planted rule before any group.
**Verdicts**
'
control rule-outside-group "rule-outside-group line" ogen og
own eg; repl "$T/o_eg/CLAUDE.md" '**Controls**' '**A planted empty group**

**Controls**'
control empty-group "empty-group 'A planted empty group'" ogen eg
own dr; repl "$T/o_dr/CLAUDE.md" '- [BBX-4] `' '- [BBX-3] `'
control gen-duplicate-rule "duplicate-rule BBX-3" ogen dr
own rc; repl "$T/o_rc/CLAUDE.md" 'BBH-49]`' 'BBH-49..50]`'
control range-citation "unresolvable-citation BBX-14" ogen rc
own pd; repl "$T/o_pd/skill/skills.toml" 'docs = ["docs/rules.md"]' 'docs = ["DECISIONS.md"]'
control page-not-in-docs "is not among its docs" ogen pd
own lk; repl "$T/o_lk/skill/skills.toml" 'cite = "BBH"
' ''
control lacking-key "lacks cite" ogen lk
own lf; _next=$(( $(grep -c '^## G[0-9]' "$T/o_lf/docs/gotchas.md") + 1 ))
printf '\n## G%d — a planted incident naming a rule nobody defined (paid: 0)\nRules re-anchored in fact: BBX-99.\n' "$_next" >> "$T/o_lf/docs/gotchas.md"
control ledger-finding-refused "dangling-rule-id G$_next BBX-99" ogen lf
unwritten lf && ok "ledger-finding-refused: nothing was written" || fail "ledger-finding-refused: a generated file was written"
fi

echo
[ "$rc" = 0 ] && echo "PASS: the skills lock fires on every perturbation of a synthetic consumer, refuses a wrapped definition both ways, and reads a plain integer under the integers vocabulary; the ledger reader reads every list shape both ways and reproduces the plan's 23 re-anchored and 7 inherited through G60; BBX's own skill is generated current, locked and guided, and every control of the slice fires on a copy of it" || { echo "FAIL: see above"; exit 1; }
