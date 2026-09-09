#!/usr/bin/env python3
"""rulings_shape.py — the rulings queue and DECISIONS.md are one registry, complete both ways, and every entry sits under the heading of its state.

Reads docs/rulings.md and DECISIONS.md. The queue's grammar (docs/rulings.md,
header): a `## ` heading opens a state section — `## Open` (and `## Open — …`)
or `## Answered …`; an entry is `### R<n> — <title>`; an entry is ANSWERED
when it carries a line starting `- **Answer` whose value is not `(open)`, or
a line starting `- **Ruling (maintainer` (the form the maintainer's own
additions took); it is OPEN when its answer line is `- **Answer:** (open)`.

Findings, each printed as `ERROR: <what> <where>` (gotcha G14, BBX-20, BBX-9):
  answered-under-open     an answered entry under an Open heading (the shape the maintainer called a dark pattern)
  open-under-answered     an `(open)` entry under an Answered heading
  no-state                an entry under no state heading
  no-answer-line          an entry with neither an answer line nor `(open)`
  duplicate-id            an id defined twice
  no-decisions-row        an answered R<n> with no `| R<n> |` row in DECISIONS.md
  row-without-entry       a `| R<n> |` row in DECISIONS.md with no entry in the queue
  open-line-mismatch      DECISIONS.md's `Open rulings:` line does not list exactly the open ids (`none` when there are none)

Summary line, parsed by field name:
    rulings=docs/rulings.md entries=21 open=0 answered=21 decisions_rows=21 errors=0
Exit 0 when errors=0, 1 otherwise, 2 when a file is unreadable.
First written at bbx-2 (2026-09-09) after G14.
"""
import re
import sys

H2 = re.compile(r"^## (Open|Answered)\b")
H2_ANY = re.compile(r"^## ")
ENTRY = re.compile(r"^### (R\d+)\b")
ANSWER = re.compile(r"^- \*\*Answer")
RULING = re.compile(r"^- \*\*Ruling \(maintainer")
OPEN_VALUE = re.compile(r"^- \*\*Answer:\*\*\s*\(open\)\s*$")
ROW = re.compile(r"^\| (R\d+) \|")
OPEN_LINE = re.compile(r"^Open rulings:")
RID = re.compile(r"\bR\d+\b")


def parse_queue(text):
    """Return list of (rid, state, answered, line_no) and the list of errors found in the queue alone."""
    entries, errors, seen = [], [], set()
    state, cur = None, None
    for n, line in enumerate(text.split("\n"), 1):
        m = H2.match(line)
        if m:
            state = m.group(1)
            cur = None
            continue
        if H2_ANY.match(line):
            state, cur = None, None
            continue
        m = ENTRY.match(line)
        if m:
            rid = m.group(1)
            if rid in seen:
                errors.append(f"ERROR: duplicate-id {rid} line={n}")
            seen.add(rid)
            cur = {"rid": rid, "state": state, "answered": None, "line": n}
            entries.append(cur)
            if state is None:
                errors.append(f"ERROR: no-state {rid} line={n}")
            continue
        if cur is None:
            continue
        if OPEN_VALUE.match(line):
            cur["answered"] = False
        elif ANSWER.match(line) or RULING.match(line):
            cur["answered"] = True
    for e in entries:
        if e["answered"] is None:
            errors.append(f"ERROR: no-answer-line {e['rid']} line={e['line']}")
        elif e["answered"] and e["state"] == "Open":
            errors.append(f"ERROR: answered-under-open {e['rid']} line={e['line']}")
        elif e["answered"] is False and e["state"] == "Answered":
            errors.append(f"ERROR: open-under-answered {e['rid']} line={e['line']}")
    return entries, errors


def parse_decisions(text):
    rows, open_ids, open_line_seen = [], None, False
    for n, line in enumerate(text.split("\n"), 1):
        m = ROW.match(line)
        if m:
            rows.append((m.group(1), n))
        if OPEN_LINE.match(line):
            open_line_seen = True
            open_ids = set(RID.findall(line))
    return rows, open_ids, open_line_seen


def main(argv=None):
    argv = list(sys.argv[1:] if argv is None else argv)
    if len(argv) != 2:
        print("usage: rulings_shape.py <rulings.md> <DECISIONS.md>", file=sys.stderr)
        return 2
    try:
        q = open(argv[0], encoding="utf-8").read()
        d = open(argv[1], encoding="utf-8").read()
    except OSError as e:
        print(f"rulings={argv[0]} error=unreadable detail={e}")
        return 2
    entries, errors = parse_queue(q)
    rows, open_ids, open_line_seen = parse_decisions(d)
    answered = {e["rid"] for e in entries if e["answered"]}
    opened = {e["rid"] for e in entries if e["answered"] is False}
    row_ids = {r for r, _ in rows}
    for rid in sorted(answered - row_ids, key=lambda s: int(s[1:])):
        errors.append(f"ERROR: no-decisions-row {rid}")
    for rid, n in rows:
        if rid not in answered:
            errors.append(f"ERROR: row-without-entry {rid} decisions_line={n}")
    if not open_line_seen:
        errors.append("ERROR: open-line-mismatch DECISIONS.md has no 'Open rulings:' line")
    elif open_ids != opened:
        errors.append(f"ERROR: open-line-mismatch listed={','.join(sorted(open_ids)) or 'none'} actual={','.join(sorted(opened)) or 'none'}")
    for e in errors:
        print(e)
    print(f"rulings={argv[0]} entries={len(entries)} open={len(opened)} answered={len(answered)} "
          f"decisions_rows={len(rows)} errors={len(errors)}")
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main())
