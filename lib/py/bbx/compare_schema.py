#!/usr/bin/env python3
"""compare_schema.py — the SCHEMA family: the artifact's SHAPE, checked BEFORE any value is trusted
(docs/plans/S3.md §3 "E1", "C1, C2"; ruling R34; abstraction C4, BBX-16). Two FORMATS, two vocabularies, one
comparator (S4 step 3; R40; D49): `tsv` over the artifact the document-set driver read, `json` over the ONE
object a command-line tool's stdout held — the driver's JSON view `<out>.json` (D54).

    python3 -m bbx.compare_schema <scenario.schema> <artifact>     one verdict line; exit 0 PASS, 1 otherwise
        the artifact is the TSV (format tsv) or the JSON view (format json) the frozen file's [spec].format names

The frozen file is a TOML-subset table (R34's caveat: TSV breaks silently, so the frozen rows carry
named fields): `[spec]` class = "schema", baseset, format = "tsv"; `[col<i>]` name and type, in
order; `[rows]` op (">=" or "=") and n. The artifact is the TSV the run's driver read (resolved by
the caller from the run's DOCSET_PATH — the driver and the comparator resolve it through one
function, bbx.docset.resolve_artifact). The FIRST violation is named — column, type, row — so a
triage opens one thing.

The type vocabulary (D41): int `^-?[0-9]+$`; hex `^[0-9A-Fa-f]+$`; str any cell, empty included;
nonempty any cell but the empty one. A fifth type is a ruling.

THE JSON FORMAT (D49, R40): `[spec]` class = "schema", baseset, format = "json"; `[k<i>]` name and type, the
keys in SORTED order (the order the driver's `field:` points carry, D47), the type one of `int` `number`
`str` `bool` `null` `list` `object`; a list-valued key adds `items_op` (">=" or "=") and `items_n`; a nested
object is one `object` key (its inside is not judged: a consumer's question). A `bool` is never an `int` or
a `number` (json's true is Python's True, which is an int — the vocabulary says what the maintainer means).
The inventory of keys is compared BOTH WAYS before any type: a frozen key the object lacks and an object
key nobody froze each FAIL naming it. A type of the OTHER format's vocabulary (`hex` under json) is
`FAIL unknown schema type`, never read as something else: two vocabularies, ruled apart (R40).

Verdicts (stdout, one line; the tsv text is FROZEN by gates/set_schema.sh, the json text by gates/json_schema.sh):
  PASS schema (tsv: <n> columns, <m> rows)
  FAIL schema: the header has <m> columns (frozen <n>)
  FAIL schema: column <i> is '<got>' (frozen '<want>')
  FAIL schema: row <r> has <m> columns (frozen <n>)             (the maintainer's fifteenth control: a TSV
                                                                 that lost or gained a cell fails on SHAPE)
  FAIL schema: row <r> column '<name>' = '<value>' is not <type>
  FAIL schema: rows <m> (frozen <op> <n>)
  PASS schema (json: <n> keys)
  FAIL schema: frozen key '<name>' is absent from the object
  FAIL schema: key '<name>' is not frozen
  FAIL schema: key '<name>' = <canonical value> is not <type>
  FAIL schema: key '<name>' has <m> items (frozen <op> <n>)
  FAIL schema: the artifact is not one JSON object
  FAIL schema: the artifact has no header line
  FAIL schema: the artifact <path> cannot be read
  FAIL schema: <spec> is not a schema spec (<why>)
  FAIL unknown schema class '<x>' | format '<x>' | type '<x>' | rows op '<x>' | items op '<x>'   (bbh's `FAIL unknown` shape)

Row numbers count data rows from 1 (the header is row 0). A blank line inside the artifact is a row
with one empty column and fails on shape: nothing is skipped silently.
"""
import json
import re
import sys

from . import toml_subset

FORMATS = ("tsv", "json")
JSON_TYPES = ("int", "number", "str", "bool", "null", "list", "object")     # D49 (R40)
TYPES = {
    "int": re.compile(r"^-?[0-9]+$"),
    "hex": re.compile(r"^[0-9A-Fa-f]+$"),
    "str": re.compile(r"^.*$"),
    "nonempty": re.compile(r"^.+$"),
}
OPS = (">=", "=")


def _spec_table(path):
    """-> (the file's tables, the format) or raise ValueError with the verdict line."""
    try:
        t = toml_subset.load(path)
    except (OSError, toml_subset.SubsetError) as e:
        raise ValueError(f"FAIL schema: {path} is not a schema spec ({e})")
    spec = t.get("spec")
    if not isinstance(spec, dict):
        raise ValueError(f"FAIL schema: {path} is not a schema spec (no [spec] table)")
    if spec.get("class") != "schema":
        raise ValueError(f"FAIL unknown schema class '{spec.get('class')}'")
    if spec.get("format") not in FORMATS:
        raise ValueError(f"FAIL unknown schema format '{spec.get('format')}'")
    return t, spec["format"]


def load_spec(path):
    """-> (columns [(name, type)], op, n) for the tsv format, or raise ValueError with the verdict line."""
    t, fmt = _spec_table(path)
    if fmt != "tsv":
        raise ValueError(f"FAIL schema: {path} is not a tsv schema spec (its format is {fmt})")
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


def load_json_spec(path):
    """-> [(name, type, items_op, items_n)] in sorted key order, or raise ValueError with the verdict line (D49)."""
    t, fmt = _spec_table(path)
    if fmt != "json":
        raise ValueError(f"FAIL schema: {path} is not a json schema spec (its format is {fmt})")
    keys = []
    i = 1
    while f"k{i}" in t:
        k = t[f"k{i}"]
        if not isinstance(k, dict) or not isinstance(k.get("name"), str) or not k["name"] or "type" not in k:
            raise ValueError(f"FAIL schema: {path} is not a schema spec ([k{i}] lacks name or type)")
        if k["type"] not in JSON_TYPES:
            raise ValueError(f"FAIL unknown schema type '{k['type']}'")
        extra = set(k) - {"name", "type", "items_op", "items_n"}
        if extra:
            raise ValueError(f"FAIL schema: {path} is not a schema spec ([k{i}] has an unknown key '{sorted(extra)[0]}')")
        op, n = k.get("items_op"), k.get("items_n")
        if k["type"] == "list":
            if op is None or n is None:
                raise ValueError(f"FAIL schema: {path} is not a schema spec ([k{i}] is a list and lacks items_op or items_n)")
            if op not in OPS:
                raise ValueError(f"FAIL unknown schema items op '{op}'")
            if not isinstance(n, int) or isinstance(n, bool) or n < 0:
                raise ValueError(f"FAIL schema: {path} is not a schema spec ([k{i}] items_n is a count)")
        elif op is not None or n is not None:
            raise ValueError(f"FAIL schema: {path} is not a schema spec ([k{i}] carries items_op or items_n but is not a list)")
        if keys and k["name"] <= keys[-1][0]:
            raise ValueError(f"FAIL schema: {path} is not a schema spec ([k{i}] '{k['name']}' is not after '{keys[-1][0]}' in sorted order)")
        keys.append((k["name"], k["type"], op, n))
        i += 1
    if not keys:
        raise ValueError(f"FAIL schema: {path} is not a schema spec (no [k1] table)")
    return keys


def _json_type_ok(typ, v):
    if typ == "bool":
        return isinstance(v, bool)
    if typ == "int":
        return isinstance(v, int) and not isinstance(v, bool)
    if typ == "number":
        return isinstance(v, (int, float)) and not isinstance(v, bool)
    if typ == "str":
        return isinstance(v, str)
    if typ == "null":
        return v is None
    if typ == "list":
        return isinstance(v, list)
    return isinstance(v, dict)          # object


def _canon(v):
    return json.dumps(v, sort_keys=True, separators=(",", ":"), ensure_ascii=False)


def compare_json(spec_path, artifact_path):
    """-> (verdict line, exit status) for the json format: the object's keys both ways, then one type each."""
    try:
        keys = load_json_spec(spec_path)
    except ValueError as e:
        return str(e), 1
    try:
        with open(artifact_path, encoding="utf-8") as fh:
            text = fh.read()
    except (OSError, UnicodeDecodeError):
        return f"FAIL schema: the artifact {artifact_path} cannot be read", 1
    try:
        obj = json.loads(text)
    except ValueError:
        obj = None
    if not isinstance(obj, dict):
        return "FAIL schema: the artifact is not one JSON object", 1
    frozen = [name for name, _t, _op, _n in keys]
    for name in frozen:
        if name not in obj:
            return f"FAIL schema: frozen key '{name}' is absent from the object", 1
    for name in sorted(obj):
        if name not in frozen:
            return f"FAIL schema: key '{name}' is not frozen", 1
    for name, typ, op, n in keys:
        v = obj[name]
        if not _json_type_ok(typ, v):
            return f"FAIL schema: key '{name}' = {_canon(v)} is not {typ}", 1
        if typ == "list":
            m = len(v)
            ok = m >= n if op == ">=" else m == n
            if not ok:
                return f"FAIL schema: key '{name}' has {m} items (frozen {op} {n})", 1
    return f"PASS schema (json: {len(keys)} keys)", 0


def compare(spec_path, artifact_path):
    """-> (verdict line, exit status); the format decides which reader (the tsv path is S3's, unchanged)."""
    try:
        _t, fmt = _spec_table(spec_path)
    except ValueError as e:
        return str(e), 1
    if fmt == "json":
        return compare_json(spec_path, artifact_path)
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
