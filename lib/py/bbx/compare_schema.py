#!/usr/bin/env python3
"""compare_schema.py — the SCHEMA family: the artifact's SHAPE, checked BEFORE any value is trusted
(docs/plans/S3.md §3 "E1", "C1, C2"; ruling R34; abstraction C4, BBX-16).

    python3 -m bbx.compare_schema <scenario.schema> <artifact.tsv>     one verdict line; exit 0 PASS, 1 otherwise

The frozen file is a TOML-subset table (R34's caveat: TSV breaks silently, so the frozen rows carry
named fields): `[spec]` class = "schema", baseset, format = "tsv"; `[col<i>]` name and type, in
order; `[rows]` op (">=" or "=") and n. The artifact is the TSV the run's driver read (resolved by
the caller from the run's DOCSET_PATH — the driver and the comparator resolve it through one
function, bbx.docset.resolve_artifact). The FIRST violation is named — column, type, row — so a
triage opens one thing.

The type vocabulary (D41): int `^-?[0-9]+$`; hex `^[0-9A-Fa-f]+$`; str any cell, empty included;
nonempty any cell but the empty one. A fifth type is a ruling.

Verdicts (stdout, one line; the text is FROZEN by gates/set_schema.sh):
  PASS schema (tsv: <n> columns, <m> rows)
  FAIL schema: the header has <m> columns (frozen <n>)
  FAIL schema: column <i> is '<got>' (frozen '<want>')
  FAIL schema: row <r> has <m> columns (frozen <n>)             (the maintainer's fifteenth control: a TSV
                                                                 that lost or gained a cell fails on SHAPE)
  FAIL schema: row <r> column '<name>' = '<value>' is not <type>
  FAIL schema: rows <m> (frozen <op> <n>)
  FAIL schema: the artifact has no header line
  FAIL schema: the artifact <path> cannot be read
  FAIL schema: <spec> is not a schema spec (<why>)
  FAIL unknown schema class '<x>' | format '<x>' | type '<x>' | rows op '<x>'   (bbh's `FAIL unknown` shape)

Row numbers count data rows from 1 (the header is row 0). A blank line inside the artifact is a row
with one empty column and fails on shape: nothing is skipped silently.
"""
import re
import sys

from . import toml_subset

TYPES = {
    "int": re.compile(r"^-?[0-9]+$"),
    "hex": re.compile(r"^[0-9A-Fa-f]+$"),
    "str": re.compile(r"^.*$"),
    "nonempty": re.compile(r"^.+$"),
}
OPS = (">=", "=")


def load_spec(path):
    """-> (columns [(name, type)], op, n) or raise ValueError with the verdict line."""
    try:
        t = toml_subset.load(path)
    except (OSError, toml_subset.SubsetError) as e:
        raise ValueError(f"FAIL schema: {path} is not a schema spec ({e})")
    spec = t.get("spec")
    if not isinstance(spec, dict):
        raise ValueError(f"FAIL schema: {path} is not a schema spec (no [spec] table)")
    if spec.get("class") != "schema":
        raise ValueError(f"FAIL unknown schema class '{spec.get('class')}'")
    if spec.get("format") != "tsv":
        raise ValueError(f"FAIL unknown schema format '{spec.get('format')}'")
    cols = []
    i = 1
    while f"col{i}" in t:
        c = t[f"col{i}"]
        if not isinstance(c, dict) or not isinstance(c.get("name"), str) or "type" not in c:
            raise ValueError(f"FAIL schema: {path} is not a schema spec ([col{i}] lacks name or type)")
        if c["type"] not in TYPES:
            raise ValueError(f"FAIL unknown schema type '{c['type']}'")
        cols.append((c["name"], c["type"]))
        i += 1
    if not cols:
        raise ValueError(f"FAIL schema: {path} is not a schema spec (no [col1] table)")
    rows = t.get("rows")
    if not isinstance(rows, dict) or not isinstance(rows.get("n"), int) or "op" not in rows:
        raise ValueError(f"FAIL schema: {path} is not a schema spec ([rows] lacks op or n)")
    if rows["op"] not in OPS:
        raise ValueError(f"FAIL unknown schema rows op '{rows['op']}'")
    return cols, rows["op"], rows["n"]


def compare(spec_path, artifact_path):
    """-> (verdict line, exit status)."""
    try:
        cols, op, n = load_spec(spec_path)
    except ValueError as e:
        return str(e), 1
    try:
        with open(artifact_path, encoding="utf-8") as fh:
            lines = fh.read().splitlines()
    except (OSError, UnicodeDecodeError):
        return f"FAIL schema: the artifact {artifact_path} cannot be read", 1
    if not lines:
        return "FAIL schema: the artifact has no header line", 1
    header = lines[0].split("\t")
    if len(header) != len(cols):
        return f"FAIL schema: the header has {len(header)} columns (frozen {len(cols)})", 1
    for i, (got, (want, _t)) in enumerate(zip(header, cols), start=1):
        if got != want:
            return f"FAIL schema: column {i} is '{got}' (frozen '{want}')", 1
    for r, line in enumerate(lines[1:], start=1):
        cells = line.split("\t")
        if len(cells) != len(cols):
            return f"FAIL schema: row {r} has {len(cells)} columns (frozen {len(cols)})", 1
        for cell, (name, typ) in zip(cells, cols):
            if not TYPES[typ].match(cell):
                return f"FAIL schema: row {r} column '{name}' = '{cell}' is not {typ}", 1
    m = len(lines) - 1
    ok = m >= n if op == ">=" else m == n
    if not ok:
        return f"FAIL schema: rows {m} (frozen {op} {n})", 1
    return f"PASS schema (tsv: {len(cols)} columns, {m} rows)", 0


def main(argv):
    if len(argv) != 2:
        print(__doc__.split("\n\n")[1], file=sys.stderr)
        return 2
    line, rc = compare(argv[0], argv[1])
    print(line)
    return rc


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
