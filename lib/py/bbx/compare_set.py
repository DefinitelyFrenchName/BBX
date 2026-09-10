#!/usr/bin/env python3
"""compare_set.py — the SET family: a frozen MULTISET of rows against the rows a run produced, both
ways (docs/plans/S3.md §3 "E1", "C1, C2"; rulings R33, R34; abstraction E5, BBX-17).

    python3 -m bbx.compare_set <scenario.claims|.covered> <run.log> <artifact.tsv> <scenario-file>
        one verdict line (a second `NOTE: covered-grew <k>` line when a shrink-only set grew);
        exit 0 PASS, 1 otherwise
    python3 -m bbx.compare_set --freeze <scenario.covered> <run.log> <artifact.tsv> <scenario-file>
        the shrink-only set rewritten from the run (the suite's --freeze, S3 step 4): `frozen set-covered (<n> rows)`;
        an inventory is authored and REFUSED

Two ROW SHAPES, told apart by the fields the frozen rows carry (R34's caveat: named fields, so the shape
is what the file says): the CLAIM row `(document, line, form, status)` of the document-set kind (S3), and
since S4 step 3 the LINE row `(line, sha1)` of the command-line kind's `unordered` expectation (D56): the
multiset of a tool's stdout lines, compared by the sha1 the log carries (D47's `line:<sha1>` points), the
frozen text the name a triage reads; a frozen row whose sha1 is not its line's is hand-editing. Under the
line shape the artifact and the scenario-file arguments are accepted and not read (the log is the whole
observation), and the shrink-only mode is refused (a stream is an inventory). A file that mixes the two
shapes is malformed; a file with no rows is read as the claim shape (S3's behaviour, unchanged).

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
  (the line shape names a frozen row "<line>" and a run row sha1 <hex>: the log holds hashes, never text)
  FAIL set-covered: frozen row <doc>:<line> <form> <status> is not a covered status (BOUND or PARAPHRASE)
  FAIL set: frozen row [<table>] is malformed (<why>)
  FAIL set: <spec> is not a set spec (<why>)
  FAIL set: the run rows cannot be derived (<why>)               (the map does not describe this log,
                                                                 or the artifact / claim set is unreadable)
  FAIL unknown set class '<x>' | mode '<x>'                       (bbh's `FAIL unknown` shape)
"""
import sys
from collections import Counter

from . import cli
from . import docset
from . import toml_subset

MODES = ("inventory", "shrink-only")
LABEL = {"inventory": "set-inventory", "shrink-only": "set-covered"}   # the verdict word is the KIND's, not the mode's
FIELDS = ("document", "line", "form", "status")
LINE_FIELDS = ("line", "sha1")
SHAPES = ("claim", "line")
_NAMES = {}      # the line shape: sha1 -> the frozen text, for the verdict's naming


def _fmt(row):
    if len(row) == 1:                          # the line shape: a row is its sha1
        return f'"{_NAMES[row[0]]}"' if row[0] in _NAMES else f"sha1 {row[0]}"
    d, ln, form, status = row
    return f"{d}:{ln} {form} {status}"


def load_frozen(path):
    """-> (mode, [rows]) or raise ValueError with the verdict line; the row shape is in load_shape."""
    mode, _shape, rows = load_shape(path)
    return mode, rows


def load_shape(path):
    """-> (mode, shape, [rows]) or raise ValueError with the verdict line."""
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
    shape = None
    for name, row in t.items():
        if name == "spec":
            continue
        if not isinstance(row, dict):
            raise ValueError(f"FAIL set: frozen row [{name}] is malformed (needs {', '.join(FIELDS)})")
        this = "line" if set(row) == set(LINE_FIELDS) else "claim" if all(k in row for k in FIELDS) else None
        if this is None:
            raise ValueError(f"FAIL set: frozen row [{name}] is malformed (needs {', '.join(FIELDS)}, or line and sha1)")
        if shape is None:
            shape = this
        elif this != shape:
            raise ValueError(f"FAIL set: frozen row [{name}] is malformed (a {this} row in a file of {shape} rows)")
        if this == "line":
            if not isinstance(row["line"], str) or not isinstance(row["sha1"], str):
                raise ValueError(f"FAIL set: frozen row [{name}] is malformed (line and sha1 are strings)")
            if row["sha1"] != cli.sha1_text(row["line"]):
                raise ValueError(f"FAIL set: frozen row [{name}] is malformed (sha1 is not the line's: hand-editing, BBX-17)")
            _NAMES[row["sha1"]] = row["line"]
            rows.append((row["sha1"],))
            continue
        if not isinstance(row["line"], int) or not all(isinstance(row[k], str) for k in ("document", "form", "status")):
            raise ValueError(f"FAIL set: frozen row [{name}] is malformed (line is an integer, the rest strings)")
        if row["status"] not in docset.STATUSES:
            raise ValueError(f"FAIL set: frozen row [{name}] is malformed (status {row['status']!r} is outside the closed vocabulary)")
        rows.append((row["document"], row["line"], row["form"], row["status"]))
    shape = shape or "claim"
    if shape == "line" and mode != "inventory":
        raise ValueError(f"FAIL set: {path} is not a set spec (the line shape has no {mode} mode: a stream is an inventory)")
    return mode, shape, rows


def line_rows(log_path):
    """The run's rows under the line shape: one (sha1,) per `line:` point of a log in D47's grammar, in log order.
    ValueError on a log that is not one (a crash log, a token outside the vocabulary, no END)."""
    with open(log_path, encoding="utf-8") as fh:
        lines = fh.read().splitlines()
    if not lines or not lines[-1].startswith("END "):
        raise ValueError("the log has no END line last (a crash log is never compared)")
    n = int(lines[-1].split()[1])
    out, last = [], 0
    for l in lines[:-1]:
        f = l.split()
        if len(f) != 2 or not f[0].isdigit():
            raise ValueError(f"not a point line: {l!r}")
        tok = cli.split_token(f[1])          # ValueError names a token outside the vocabulary
        if tok["kind"] == "exit":
            continue
        last = int(f[0])
        if tok["kind"] == "line":
            out.append((tok["sha1"],))
    if last != n:
        raise ValueError(f"END {n} but the last index is {last}")
    return out


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
        mode, shape, frozen = load_shape(spec_path)
    except ValueError as e:
        return [str(e)], 1
    try:
        if shape == "line":
            run = line_rows(log_path)
        else:
            run = [(d, ln, form, status) for _i, d, ln, form, status in docset.run_rows(artifact_path, claims_path, log_path)]
    except (docset.Unreadable, docset.Refused, ValueError, OSError) as e:
        return [f"FAIL set: the run rows cannot be derived ({e})"], 1
    # a run duplicate under the line shape is a stream's multiset, judged by the count below, never by this guard
    dup = _duplicate(frozen, "frozen", mode) or (None if shape == "line" else _duplicate(run, "run", mode))
    if dup:
        return [dup], 1
    if mode == "inventory":
        fc, rc = Counter(frozen), Counter(run)
        lost = [r for r in frozen if r in (fc - rc)]      # the multiset difference: a surplus counts once per surplus copy
        new = [r for r in run if r in (rc - fc)][:sum((rc - fc).values())]
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


def freeze(spec_path, log_path, artifact_path, claims_path):
    """--freeze (S3 step 4): the shrink-only set REWRITTEN from the run — the [spec] table kept, then one
    `[c<i>]` table per covered row of the run in extraction order — the same text the fixture generator
    writes, so a freeze over the fixture reproduces its file byte for byte (gates/docset_suite.sh measures
    it). An inventory (mode `inventory`) is AUTHORED and never self-frozen: refused here. -> (lines, rc)."""
    try:
        mode, _frozen = load_frozen(spec_path)
    except ValueError as e:
        return [str(e)], 1
    if mode != "shrink-only":
        return [f"FAIL set: --freeze is for the shrink-only mode (mode '{mode}' is authored, never self-frozen)"], 1
    try:
        run = [(d, ln, form, status) for _i, d, ln, form, status in docset.run_rows(artifact_path, claims_path, log_path)]
    except (docset.Unreadable, docset.Refused, ValueError, OSError) as e:
        return [f"FAIL set: the run rows cannot be derived ({e})"], 1
    covered = [r for r in run if r[3] in docset.COVERED]
    spec = toml_subset.load(spec_path)["spec"]
    out = ["[spec]"] + [f'{k} = "{v}"' for k, v in spec.items()] + [""]
    for i, (d, ln, form, status) in enumerate(covered, start=1):
        out += [f"[c{i}]", f'document = "{d}"', f"line = {ln}", f'form = "{form}"', f'status = "{status}"', ""]
    with open(spec_path, "w", encoding="utf-8") as fh:
        fh.write("\n".join(out).rstrip("\n") + "\n")
    return [f"frozen set-covered ({len(covered)} rows)"], 0


def main(argv):
    if argv and argv[0] == "--freeze":
        argv = argv[1:]
        if len(argv) != 4:
            print(__doc__.split("\n\n")[1], file=sys.stderr)
            return 2
        lines, rc = freeze(*argv)
        for l in lines:
            print(l)
        return rc
    if len(argv) != 4:
        print(__doc__.split("\n\n")[1], file=sys.stderr)
        return 2
    lines, rc = compare(*argv)
    for l in lines:
        print(l)
    return rc


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
