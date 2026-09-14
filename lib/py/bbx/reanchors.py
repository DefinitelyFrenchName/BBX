#!/usr/bin/env python3
"""reanchors.py — which CLAUDE.md §4 rules the incident ledger re-anchors: the rule ↔ incident registry, derived every run (S5 step 3, K4; ruled R53).

A rule is RE-ANCHORED when at least one ledger entry's EXPLICIT re-anchor list names it,
and INHERITED otherwise: reported as a candidate for dropping (CLAUDE.md §4), never
dropped here (R53). An entry's prose is never read, only its list.

The rules: every `- [BBX-<n>]` line under the rules document's `## 4.` heading, up to the
next `## ` heading. The ledger: one `## G<n> — <title>` heading per entry, numbered from 1
with no gap and no repeat. A list opens at a LEAD, one of the wordings measured over G1–G60
at bbx-26 (docs/plans/S5.md §3.2): `Re-anchors:`, `Re-anchors` without the colon, `Rule
re-anchored in fact:`, `Rules re-anchored in fact:` — case-sensitive, because lower-case
"re-anchors" occurs in prose. A list is read inside its paragraph with the paragraph's lines
joined (a list wraps, G61), from the lead to the end of its sentence, a colon or an em dash,
with every parenthesized explanation, quotation and code span skipped. A lead inside a code
span, a quotation or parentheses is prose, never a list (appendix A's third failure). From
G61 on the one wording is `Rules re-anchored in fact:` (R53); the older ones are read as
they stand. The grammar is registered as D67.

Findings, each printed as `ERROR: <what> <where>`:
  no-rules            the rules document defines no rule under its `## 4.` heading (exit 2)
  no-entries          the ledger holds no `## G<n> — ` heading (exit 2)
  duplicate-rule      a rule id defined twice
  unread-heading      a `## ` heading that is not an entry, or a `G<n>` heading at another level
  entry-sequence      the entry ids are not 1..N in order
  unbalanced          a paragraph holding a lead whose code spans, quotations or parentheses
                      do not close: where its list ends cannot be known, so it is not guessed
  dangling-rule-id    a list names a BBX id the rules do not define
  old-wording         an entry from G61 on whose lead is not `Rules re-anchored in fact:`
  against             (--against) a rule whose entries differ from the table's, both ways

Output, parsed by field name (BBX-12):
    entry G24 no-list
    rule BBX-1 re-anchored G16 G18 G23 G40 G56 G57 G59
    rule BBX-2 inherited
    NOTE: rules re-anchored=23 inherited=7 — candidates for dropping (CLAUDE.md §4): BBX-2 …
    NOTE: ledger entries=69 lists=68 no-list G24
    ledger=docs/gotchas.md entries=69 lists=68 no_list=1 rules=30 re_anchored=23 inherited=7 errors=0
Exit 0 when errors=0, 1 otherwise, 2 when a file is unreadable or defines nothing.

One consumer: BBX's own constitution and ledger, declared in gates/skills.sh (R50).
First written at bbx-27 (2026-09-14); its measured prototype is docs/plans/S5.md appendix A.
"""
import argparse
import os
import re
import sys

PREFIX = "BBX"
ONE_WORDING = "Rules re-anchored in fact:"
RULE_DEF = re.compile(r"^- \[(%s-\d+)\]" % PREFIX)
ENTRY = re.compile(r"^## G(\d+) — ")
H2 = re.compile(r"^## ")
G_HEADING = re.compile(r"^#{1,6}\s*G\d+\b")
LEAD = re.compile(r"Re-anchors:?|Rules? re-anchored in fact:")
RULE_REF = re.compile(r"%s-\d+" % PREFIX)
LIST_END = re.compile(r"\.\s+(?=[A-Z*])|\.\s*$|:\s")


def read_rules(text, section="## 4."):
    ids, inside = [], False
    for line in text.split("\n"):
        if H2.match(line):
            inside = line == section or line.startswith(section + " ")
            continue
        m = RULE_DEF.match(line) if inside else None
        if m:
            ids.append(m.group(1))
    return ids


def read_entries(text, errors):
    """[(n, heading, body)] in ledger order; a heading the entry grammar does not read is an error."""
    entries, cur = [], None
    for i, line in enumerate(text.split("\n"), 1):
        m = ENTRY.match(line)
        if m:
            cur = [int(m.group(1)), line, []]
            entries.append(cur)
            continue
        if H2.match(line) or G_HEADING.match(line):
            errors.append(f"unread-heading line {i}: {line[:80]}")
            cur = None
            continue
        if cur is not None:
            cur[2].append(line)
    return [(n, h, "\n".join(b)) for n, h, b in entries]


def prose_mask(p):
    """(mask, balanced) over a joined paragraph: mask[i] is True where p[i] is inside a code span,
    a quotation or parentheses. A backtick run closes only on a run of the same length (CommonMark)."""
    n, mask = len(p), [False] * len(p)
    dq, curly, depth, i = False, 0, 0, 0
    while i < n:
        ch = p[i]
        if ch == "`":
            j = i
            while j < n and p[j] == "`":
                j += 1
            run, k, close = j - i, j, -1
            while k < n:
                if p[k] != "`":
                    k += 1
                    continue
                e = k
                while e < n and p[e] == "`":
                    e += 1
                if e - k == run:
                    close = k
                    break
                k = e
            if close < 0:
                return mask, False
            for x in range(i, close + run):
                mask[x] = True
            i = close + run
            continue
        quoted = dq or curly > 0
        if ch == '"':
            dq = not dq
            mask[i] = True
        elif ch == "“":
            curly += 1
            mask[i] = True
        elif ch == "”":
            if curly == 0:
                return mask, False
            curly -= 1
            mask[i] = True
        elif ch == "(" and not quoted:
            depth += 1
            mask[i] = True
        elif ch == ")" and not quoted:
            if depth == 0:
                return mask, False
            depth -= 1
            mask[i] = True
        else:
            mask[i] = quoted or depth > 0
        i += 1
    return mask, not (dq or curly or depth)


def read_lists(n, body, errors):
    """The leads of one entry and the refs its lists name: ([lead], [ref])."""
    leads, refs = [], []
    for para in re.split(r"\n\s*\n", body):
        p = para.replace("\n", " ")
        found = list(LEAD.finditer(p))
        if not found:
            continue
        mask, balanced = prose_mask(p)
        if not balanced:
            errors.append(f"unbalanced G{n}: a code span, quotation or parenthesis does not close in the paragraph holding '{found[0].group(0)}'")
            continue
        for m in found:
            if mask[m.start()]:
                continue
            leads.append(m.group(0))
            rest = "".join(ch for ch, q in zip(p[m.end():], mask[m.end():]) if not q)
            seg = LIST_END.split(rest, maxsplit=1)[0].split(" — ")[0]
            refs += [r for r in RULE_REF.findall(seg) if r not in refs]
    return leads, refs


def read_against(path, errors):
    table = {}
    for i, line in enumerate(open(path, encoding="utf-8"), 1):
        f = line.split()
        if not f or f[0].startswith("#"):
            continue
        if f[0] in table:
            errors.append(f"against duplicate-row {f[0]} line {i}")
        table[f[0]] = [] if f[1:] == ["-"] else f[1:]
    return table


def main(argv=None):
    ap = argparse.ArgumentParser(prog="bbx reanchors", description=__doc__.split("\n")[0])
    ap.add_argument("--root", default=".")
    ap.add_argument("--rules", default="CLAUDE.md")
    ap.add_argument("--ledger", default="docs/gotchas.md")
    ap.add_argument("--through", type=int, help="read the entries G1..G<n> only")
    ap.add_argument("--against", help="a table, one line per rule: BBX-<n> then its entries G<n> … or -")
    a = ap.parse_args(argv)
    try:
        rules_text = open(os.path.join(a.root, a.rules), encoding="utf-8").read()
        ledger_text = open(os.path.join(a.root, a.ledger), encoding="utf-8").read()
    except OSError as e:
        print(f"ERROR: unreadable {e}")
        return 2
    errors = []
    rules = read_rules(rules_text)
    if not rules:
        print(f"ERROR: no-rules {a.rules}: no `- [{PREFIX}-<n>]` line under its `## 4.` heading")
        return 2
    for r in sorted({r for r in rules if rules.count(r) > 1}, key=lambda r: int(r.split("-")[1])):
        errors.append(f"duplicate-rule {r}")
    entries = read_entries(ledger_text, errors)
    if a.through is not None:
        entries = [e for e in entries if e[0] <= a.through]
    if not entries:
        print(f"ERROR: no-entries {a.ledger}: no `## G<n> — ` heading")
        return 2
    ids = [n for n, _, _ in entries]
    if ids != list(range(1, len(ids) + 1)):
        errors.append(f"entry-sequence {a.ledger}: the ids read are not G1..G{len(ids)} in order")
    by_rule = {r: [] for r in rules}
    no_list, lists = [], 0
    for n, _, body in entries:
        leads, refs = read_lists(n, body, errors)
        if n >= 61:
            for lead in leads:
                if lead != ONE_WORDING:
                    errors.append(f"old-wording G{n}: '{lead}' — from G61 on a list is written '{ONE_WORDING}' (R53)")
        if leads:
            lists += 1
        else:
            no_list.append(n)
        for r in refs:
            if r in by_rule:
                if n not in by_rule[r]:
                    by_rule[r].append(n)
            else:
                errors.append(f"dangling-rule-id G{n} {r}: the list names a rule {a.rules} does not define")
    if a.against:
        try:
            table = read_against(os.path.join(a.root, a.against) if not os.path.isabs(a.against) else a.against, errors)
        except OSError as e:
            print(f"ERROR: unreadable {e}")
            return 2
        g = lambda ns: ",".join(f"G{x}" for x in ns) or "-"
        for r in rules:
            if r not in table:
                errors.append(f"against {r} table=missing read={g(by_rule[r])}")
            elif table[r] != [f"G{x}" for x in by_rule[r]]:
                errors.append(f"against {r} table={','.join(table[r]) or '-'} read={g(by_rule[r])}")
        for r in table:
            if r not in by_rule:
                errors.append(f"against {r} table={','.join(table[r]) or '-'} read=not-a-rule")
    for e in errors:
        print(f"ERROR: {e}")
    for n in no_list:
        print(f"entry G{n} no-list")
    inherited = [r for r in rules if not by_rule[r]]
    for r in rules:
        print(f"rule {r} " + (("re-anchored " + " ".join(f"G{x}" for x in by_rule[r])) if by_rule[r] else "inherited"))
    re_anchored = len(rules) - len(inherited)
    print(f"NOTE: rules re-anchored={re_anchored} inherited={len(inherited)}"
          + (f" — candidates for dropping (CLAUDE.md §4): {', '.join(inherited)}" if inherited else ""))
    print(f"NOTE: ledger entries={len(entries)} lists={lists} no-list "
          + (", ".join(f"G{n}" for n in no_list) if no_list else "none"))
    through = f" through=G{a.through}" if a.through is not None else ""
    print(f"ledger={a.ledger}{through} entries={len(entries)} lists={lists} no_list={len(no_list)} "
          f"rules={len(rules)} re_anchored={re_anchored} inherited={len(inherited)} errors={len(errors)}")
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main())
