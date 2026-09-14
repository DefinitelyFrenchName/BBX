#!/usr/bin/env python3
"""gen_skill.py — GENERATE a skill from a constitution's rules section, and the page that anchors each rule to its evidence (S5 step 4; rulings R51, R52).

  bbx skill-gen [--config skill/skills.toml] [--root DIR] [--check] [--prefix PFX]

Two files per `[skill_<PFX>]` table, both GENERATED and never hand-edited (BBX-21):

  SKILL.md (the table's `path`): the frontmatter (`name`, `description`), the `title` and
    the `intro` lines from the table; then one `## <group>` section per bold group heading
    of the constitution's rules section (`constitution`, `section`), in its order, and one
    line per rule: `- [PFX-N]`, the body with its backticked tag removed and its lines
    joined, and each `<cite>-N` id the tag names as a trailing `[<cite>-N]`
    cross-reference (R4: the one lineage prefix the skill may carry).
  the anchor page (the table's `page`, which must be one of its `docs`): the `page_header`
    lines, then the same groups, and one paragraph per rule opening with its anchor
    `**[PFX-N]**`. A rule is RE-ANCHORED by the ledger entries whose explicit lists name
    it, each given by id and heading as `bbx reanchors` reads them (R53: the same reader,
    never a second one), or INHERITED, given with its tag as the constitution writes it
    and the words "a candidate for dropping" (CLAUDE.md §4).

The lifted lock (`bbx check-skills`) then locks the skill to the page, and `bbx
skill-guide` writes GUIDE.md from the page. `--check` writes nothing and byte-compares
both files: FAIL `<file> is STALE` for each that differs, exit 1. Refused with exit 2 and
nothing written: a table key the generator reads is missing; the page is not among the
docs; a rule line the grammar does not read, a rule outside a group, an empty group or a
duplicate id; a tag citation that cannot be resolved one id at a time (a range `..` or a
`/`); this reader and `bbx reanchors` reading different rule ids; any finding of the
ledger reader. The grammar and the keys are docs/defaults.md D68.

One consumer: BBX's own constitution (`skill/skills.toml`), declared in gates/skills.sh
(R50). First written at bbx-27 (2026-09-14), with no ancestor: bbh's H10 writes GUIDE.md
beside a SKILL.md someone wrote, and never writes a SKILL.md (docs/plans/S5.md §4).
"""
import argparse
import re
import sys
from pathlib import Path

from . import checkskills
from . import config as C
from . import reanchors

KEYS = ("name", "description", "title", "intro", "constitution", "section", "ledger", "page", "page_header", "cite")
GROUP = re.compile(r"^\*\*([^*]+)\*\*\s*$")
CONTINUATION = re.compile(r"^[ \t]+\S")


def read_section(text, section, prefix):
    """([(group, [(id, tag, body)])], [error]) from the constitution's rules section: a bold-only
    line opens a group; `- [PFX-N] `[tag]` body` opens a rule, and its indented lines are joined."""
    rule = re.compile(r"^- \[(%s-\d+)\] `(\[[^`]*\])` (\S.*)$" % re.escape(prefix))
    groups, errors, inside, i = [], [], False, 0
    lines = text.split("\n")
    while i < len(lines):
        line = lines[i]
        i += 1
        if line.startswith("## "):
            inside = line == section or line.startswith(section + " ")
            continue
        if not inside:
            continue
        g = GROUP.match(line)
        if g:
            groups.append((g.group(1).strip(), []))
            continue
        if not line.startswith(f"- [{prefix}-"):
            continue
        m = rule.match(line)
        if not m:
            errors.append(f"unread-rule line {i}: not `- [{prefix}-N] `[tag]` body`: {line[:60]}")
            continue
        if not groups:
            errors.append(f"rule-outside-group line {i}: {m.group(1)} comes before any bold group heading")
            continue
        body = [m.group(3).strip()]
        while i < len(lines) and CONTINUATION.match(lines[i]):
            body.append(lines[i].strip())
            i += 1
        groups[-1][1].append((m.group(1), m.group(2), " ".join(body)))
    return groups, errors


def citations(tag, cite, rid, errors):
    """The `<cite>-N` ids a tag names, in its order; a range or a slash cannot be resolved one id at a time."""
    if re.search(r"(?<![A-Za-z])%s-\d+(?:\.\.|/)" % re.escape(cite), tag):
        errors.append(f"unresolvable-citation {rid}: {tag} cites {cite} ids as a range; name each id")
        return []
    return ["%s-%s" % (cite, n) for n in re.findall(r"(?<![A-Za-z])%s-(\d+)(?!\d)" % re.escape(cite), tag)]


def render_skill(t, groups):
    out = ["---", f"name: {t['name']}", f"description: {t['description']}", "---", "", f"# {t['title']}", ""]
    out += list(t["intro"])
    for group, rules in groups:
        out += ["", f"## {group}", ""]
        for rid, _tag, body, cites in rules:
            out.append(f"- [{rid}] {body}" + "".join(f" [{c}]" for c in cites))
    return "\n".join(out) + "\n"


def render_page(t, groups, by_rule, headings, label):
    ledger = t["ledger"]
    out = list(t["page_header"])
    for group, rules in groups:
        out += ["", f"## {group}"]
        for rid, tag, _body, _cites in rules:
            ns = by_rule[rid]
            out.append("")
            if ns:
                word = "entry" if len(ns) == 1 else "entries"
                out.append(f"**[{rid}]** RE-ANCHORED by {len(ns)} {word} of `{ledger}` whose explicit list names it: "
                           + "; ".join(headings[n] for n in ns) + ".")
            else:
                out.append(f"**[{rid}]** INHERITED: no entry of `{ledger}` names it in an explicit list, and the "
                           f"constitution tags it `{tag}` — a candidate for dropping ({t['constitution']} {label}).")
    return "\n".join(out) + "\n"


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--config", help="the consumer's skills table (else $BBX_CONFIG)")
    ap.add_argument("--root", help="a copy of the tree (default: the consumer root)")
    ap.add_argument("--check", action="store_true")
    ap.add_argument("--prefix", action="append", help="default: every skill in [skills].prefixes")
    args = ap.parse_args()
    cfg, root = C.consumer(args.config, args.root)
    root = Path(root)
    try:
        skills, _ = checkskills.load_skills(cfg)
    except KeyError as e:
        print(f"  FAIL  config: {e}")
        sys.exit(2)
    prefixes = args.prefix or list(skills)
    if not prefixes:
        print("  FAIL  config: [skills].prefixes names no skill")
        sys.exit(2)
    stale = 0
    for p in prefixes:
        if p not in skills:
            print(f"  FAIL  config: no [skill_{p}] table for prefix {p}")
            sys.exit(2)
        t = cfg[f"skill_{p}"]
        lacking = [k for k in KEYS if k not in t]
        if lacking:
            print(f"  FAIL  config: [skill_{p}] lacks {', '.join(lacking)} — bbx skill-gen reads them")
            sys.exit(2)
        if t["page"] not in skills[p]["docs"]:
            print(f"  FAIL  config: [skill_{p}].page {t['page']} is not among its docs, so the lock would never read its anchors")
            sys.exit(2)
        try:
            constitution = (root / t["constitution"]).read_text(encoding="utf-8")
            ledger = (root / t["ledger"]).read_text(encoding="utf-8")
        except OSError as e:
            print(f"  FAIL  {p}: unreadable {e}")
            sys.exit(2)
        groups, errors = read_section(constitution, t["section"], p)
        ids = [rid for _, rules in groups for rid, _, _ in rules]
        if not ids:
            errors.append(f"no-rules: {t['constitution']} has no `- [{p}-N]` rule under its `{t['section']}` heading")
        for rid in sorted({r for r in ids if ids.count(r) > 1}):
            errors.append(f"duplicate-rule {rid}")
        other = reanchors.read_rules(constitution, t["section"])
        if ids != other:
            errors.append(f"readers-disagree: this reader reads {len(ids)} rule ids under `{t['section']}` and bbx reanchors reads {len(other)}")
        for group, rules in groups:
            if not rules:
                errors.append(f"empty-group '{group}'")
        full = [(g, [(rid, tag, body, citations(tag, t["cite"], rid, errors)) for rid, tag, body in rules]) for g, rules in groups]
        entries = reanchors.read_entries(ledger, errors)
        by_rule, _lists, _no_list = reanchors.registry(ids, entries, errors, t["constitution"], t["ledger"])
        if errors:
            for e in errors:
                print(f"  FAIL  {p}: {e}")
            print(f"\nbbx skill-gen refused {p}: nothing written")
            sys.exit(2)
        headings = {n: h[3:] for n, h, _ in entries}
        label = "§" + t["section"].lstrip("#").strip().rstrip(".")
        for rel, text in ((skills[p]["path"], render_skill(t, full)),
                          (t["page"], render_page(t, full, by_rule, headings, label))):
            path = root / rel
            if args.check:
                have = path.read_text(encoding="utf-8") if path.is_file() else ""
                if have != text:
                    stale += 1
                    print(f"  FAIL  {rel} is STALE against {t['constitution']} and {t['ledger']} — regenerate with bbx skill-gen")
                else:
                    print(f"  ok    {rel} is current ({len(ids)} rules)")
            else:
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_text(text, encoding="utf-8")
                print(f"wrote {rel} ({len(text.encode())} B)")
    sys.exit(1 if stale else 0)


if __name__ == "__main__":
    main()
