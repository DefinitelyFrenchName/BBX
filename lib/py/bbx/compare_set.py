#!/usr/bin/env python3
"""compare_set.py — the SET family: a frozen MULTISET of rows against the rows a run produced, both
ways (docs/plans/S3.md §3 "E1", "C1, C2"; rulings R33, R34; abstraction E5, BBX-17).

    python3 -m bbx.compare_set <scenario.claims|.covered> <run.log> <artifact.tsv> <scenario-file>
        one verdict line (a second `NOTE: covered-grew <k>` line when a shrink-only set grew);
        exit 0 PASS, 1 otherwise

Two consumers inside one family (BBX-25): the `claims` kind (mode `inventory`: the frozen rows and
the run's rows are the same multiset, a difference in EITHER direction fails naming the row and the
direction) and the `covered` kind (mode `shrink-only`, R33: every frozen row must still be covered
by the run — a lost row FAILS naming it; a run that covers MORE passes with a NOTE and re-freezes
under the suite's --freeze; a frozen row whose status is not a covered status is hand-editing). A
row is `(document, line, form, status)` — named TOML fields in the frozen file (R34's caveat), and
the run's rows are the log's statuses joined by index with the claim map (bbx.docset.run_rows: the
map is proven to describe THIS log through the quoted-hash half of every token, D38). A DUPLICATE
row on either side fails naming it: the binder never produces one, so a duplicate is a hand edit
(BBX-17).

Verdicts (stdout; the text is FROZEN by gates/set_schema.sh — C4 with no ancestor):
  PASS set-inventory (<n> rows, the frozen inventory and the run agree both ways)
  FAIL set-inventory: <a> frozen row(s) not in the run (first <doc>:<line> <form> <status>); <b> run row(s) not frozen (first …)
      — only the non-empty directions are printed
  PASS set-covered (<n> frozen rows still covered)
  PASS set-covered (<n> frozen rows still covered; the run covers <k> more)   + `NOTE: covered-grew <k>`
  FAIL set-covered: no longer covers <doc>:<line> <form> <status> (<k> frozen row(s) lost)
  FAIL set-inventory|set-covered: frozen row <doc>:<line> <form> <status> appears <k> times (a duplicate is hand-editing, BBX-17)
  FAIL set-inventory|set-covered: run row <doc>:<line> <form> <status> appears <k> times (the binder produced a duplicate)
  FAIL set-covered: frozen row <doc>:<line> <form> <status> is not a covered status (BOUND or PARAPHRASE)
  FAIL set: frozen row [<table>] is malformed (<why>)
  FAIL set: <spec> is not a set spec (<why>)
  FAIL set: the run rows cannot be derived (<why>)               (the map does not describe this log,
                                                                 or the artifact / claim set is unreadable)
  FAIL unknown set class '<x>' | mode '<x>'                       (bbh's `FAIL unknown` shape)
"""
import sys
from collections import Counter

from . import docset
from . import toml_subset

MODES = ("inventory", "shrink-only")
LABEL = {"inventory": "set-inventory", "shrink-only": "set-covered"}   # the verdict word is the KIND's, not the mode's
FIELDS = ("document", "line", "form", "status")


def _fmt(row):
    d, ln, form, status = row
    return f"{d}:{ln} {form} {status}"


def load_frozen(path):
    """-> (mode, [rows]) or raise ValueError with the verdict line."""
    try:
        t = toml_subset.load(path)
    except (OSError, toml_subset.SubsetError) as e:
        raise ValueError(f"FAIL set: {path} is not a set spec ({e})")
    spec = t.get("spec")
    if not isinstance(spec, dict):
        raise ValueError(f"FAIL set: {path} is not a set spec (no [spec] table)")
    if spec.get("class") != "multiset":
        raise ValueError(f"FAIL unknown set class '{spec.get('class')}'")
    mode = spec.get("mode")
    if mode not in MODES:
        raise ValueError(f"FAIL unknown set mode '{mode}'")
    rows = []
    for name, row in t.items():
        if name == "spec":
            continue
        if not isinstance(row, dict) or any(k not in row for k in FIELDS):
            raise ValueError(f"FAIL set: frozen row [{name}] is malformed (needs {', '.join(FIELDS)})")
        if not isinstance(row["line"], int) or not all(isinstance(row[k], str) for k in ("document", "form", "status")):
            raise ValueError(f"FAIL set: frozen row [{name}] is malformed (line is an integer, the rest strings)")
        if row["status"] not in docset.STATUSES:
            raise ValueError(f"FAIL set: frozen row [{name}] is malformed (status {row['status']!r} is outside the closed vocabulary)")
        rows.append((row["document"], row["line"], row["form"], row["status"]))
    return mode, rows


def _duplicate(rows, side, mode):
    c = Counter(rows)
    for row in rows:                       # the first duplicate in file / extraction order
        if c[row] > 1:
            why = "a duplicate is hand-editing, BBX-17" if side == "frozen" else "the binder produced a duplicate"
            return f"FAIL {LABEL[mode]}: {side} row {_fmt(row)} appears {c[row]} times ({why})"
    return None


def compare(spec_path, log_path, artifact_path, claims_path):
    """-> (verdict lines, exit status)."""
    try:
        mode, frozen = load_frozen(spec_path)
    except ValueError as e:
        return [str(e)], 1
    try:
        run = [(d, ln, form, status) for _i, d, ln, form, status in docset.run_rows(artifact_path, claims_path, log_path)]
    except (docset.Unreadable, docset.Refused, ValueError, OSError) as e:
        return [f"FAIL set: the run rows cannot be derived ({e})"], 1
    dup = _duplicate(frozen, "frozen", mode) or _duplicate(run, "run", mode)
    if dup:
        return [dup], 1
    if mode == "inventory":
        fc, rc = Counter(frozen), Counter(run)
        lost = [r for r in frozen if fc[r] > rc[r]]
        new = [r for r in run if rc[r] > fc[r]]
        if lost or new:
            parts = []
            if lost:
                parts.append(f"{len(lost)} frozen row(s) not in the run (first {_fmt(lost[0])})")
            if new:
                parts.append(f"{len(new)} run row(s) not frozen (first {_fmt(new[0])})")
            return ["FAIL set-inventory: " + "; ".join(parts)], 1
        return [f"PASS set-inventory ({len(frozen)} rows, the frozen inventory and the run agree both ways)"], 0
    # shrink-only
    for row in frozen:
        if row[3] not in docset.COVERED:
            return [f"FAIL set-covered: frozen row {_fmt(row)} is not a covered status ({' or '.join(docset.COVERED)})"], 1
    covered = [r for r in run if r[3] in docset.COVERED]
    cc = Counter(covered)
    lost = [r for r in frozen if cc[r] < 1]
    if lost:
        return [f"FAIL set-covered: no longer covers {_fmt(lost[0])} ({len(lost)} frozen row(s) lost)"], 1
    grew = len(covered) - len(frozen)
    if grew > 0:
        return [f"PASS set-covered ({len(frozen)} frozen rows still covered; the run covers {grew} more)",
                f"NOTE: covered-grew {grew}"], 0
    return [f"PASS set-covered ({len(frozen)} frozen rows still covered)"], 0


def main(argv):
    if len(argv) != 4:
        print(__doc__.split("\n\n")[1], file=sys.stderr)
        return 2
    lines, rc = compare(*argv)
    for l in lines:
        print(l)
    return rc


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
