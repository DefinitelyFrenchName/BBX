#!/usr/bin/env python3
"""compare_band.py — the TOLERANT-NUMERIC family: a band field's VALUE against the inclusive [min, max]
MEASURED on a named reference and frozen with its provenance (docs/plans/S4.md §3 "E1" band row, "C1, C2",
§5's ruling-less-class row; rulings R36 and R25's shape; D48, D53, D55; BBX-13, BBX-16).

    python3 -m bbx.compare_band <scenario.band> <run.log.bands>
        one verdict line, then `NOTE: band-fields <n>` after a PASS; exit 0 PASS, 1 otherwise
    python3 -m bbx.compare_band --freeze <scenario.band> <proposed.band>
        the frozen file REPLACED by the proposed bands when no band widens, or when every band that widens
        has its field named in the PROPOSED file's [spec].rulings (R36: a band is loosened only with a
        measured mechanism named and a ruling); otherwise REFUSED, exit 3, the file unchanged. Narrowing is
        free. A field in one file and not the other is REFUSED too: the band inventory is BBX-13's watch and
        never moves through a freeze. The class and the baseset are the frozen file's, never the proposed's.

THE VIEW. The band value lives in the driver's band view `<out>.bands` (D53): `<i> <name>=<canonical JSON
value>` per band field the object carries, sorted, `END <k>` — and nowhere else (BBX-16: the log holds the
constant `field:<name>:band`, so the exact family never fails on a legitimate move). The frozen file is
D48's: `[spec]` class = "band", baseset, measured (how, in words — a band with no measurement is a knob),
the optional `rulings` inline table `<field> = "R<n>"`; `[b<i>]` field, min, max — inclusive INTEGERS in
the field's own unit (the subset refuses floats; a fractional band is a consumer's question). The
inventory is compared BOTH WAYS before any value: a frozen field the view lacks and a view field nobody
froze each FAIL naming it — a band nobody froze is a tolerance nobody ratified (BBX-13).

TWO WRITERS OF `band-fields`. This NOTE and the log summary's (`bbx.cli summary`, D43) both print the key, so a band
scenario's screen carries the number twice; RULED KEPT as printed (R41, 2026-09-11 — the contributor recommended
retiring this one, the maintainer declined). They cannot disagree under drivers/cli.sh, which writes the log's band
tokens and the band view from one list in one run; nothing compares them for a driver that would write them apart.
This line is printed after a PASS only — a band FAIL leaves the summary's as the only count.

Verdicts (stdout; the text is FROZEN by gates/band.sh — C4 with no ancestor):
  PASS band (<n> field(s), every value inside its band)          + `NOTE: band-fields <n>`
  FAIL band <field>: <v> outside [<min>, <max>]
  FAIL band <field>: <v> is not an integer (the band is [<min>, <max>])
  FAIL band: frozen field '<name>' is not in the band view
  FAIL band: view field '<name>' is not frozen (a band nobody froze, BBX-13)
  FAIL band: the band view <path> cannot be read (<why>)
  FAIL band: the band view <path> is malformed (<why>)
  FAIL band: <spec> is not a band spec (<why>)
  FAIL unknown tolerant-numeric class '<x>'                        (bbh's `FAIL unknown` shape)
--freeze (stdout; not a pairing's verdict — never classified by finding.py):
  frozen band (<n> field(s); <k> narrowed, <w> widened under <ids>)                       exit 0
  REFUSED: band <field> widens [<a>, <b>] -> [<c>, <d>] with no rulings entry for it (R36)  exit 3
  REFUSED: band inventory moves (<why>)                                                     exit 3
  FAIL band: … / FAIL unknown tolerant-numeric class …  (either file)                       exit 1
"""
import json
import re
import sys

from . import toml_subset

CLASS = "band"
FIELD_RE = re.compile(r"^[^\s:]+$")


class Spec:
    def __init__(self, baseset, measured, rulings, bands):
        self.baseset = baseset
        self.measured = measured
        self.rulings = rulings          # {field: ruling id}
        self.bands = bands              # [(field, min, max)] in file order


def _malformed(path, why):
    return ValueError(f"FAIL band: {path} is not a band spec ({why})")


def load_spec(path):
    """-> Spec, or raise ValueError carrying the verdict line."""
    try:
        t = toml_subset.load(path)
    except (OSError, toml_subset.SubsetError) as e:
        raise _malformed(path, e)
    spec = t.get("spec")
    if not isinstance(spec, dict):
        raise _malformed(path, "no [spec] table")
    if spec.get("class") != CLASS:
        raise ValueError(f"FAIL unknown tolerant-numeric class '{spec.get('class')}'")
    if not isinstance(spec.get("baseset"), str) or not spec["baseset"]:
        raise _malformed(path, "[spec] lacks baseset")
    if not isinstance(spec.get("measured"), str) or not spec["measured"]:
        raise _malformed(path, "[spec] lacks measured: a band with no measurement is a knob (R36)")
    rulings = spec.get("rulings", {})
    if not isinstance(rulings, dict) or not all(isinstance(k, str) and isinstance(v, str) and v for k, v in rulings.items()):
        raise _malformed(path, "[spec].rulings is an inline table <field> = \"R<n>\"")
    for k in spec:
        if k not in ("class", "baseset", "measured", "rulings"):
            raise _malformed(path, f"[spec] has an unknown key '{k}'")
    bands, seen = [], set()
    i = 1
    while f"b{i}" in t:
        b = t[f"b{i}"]
        if not isinstance(b, dict) or set(b) != {"field", "min", "max"}:
            raise _malformed(path, f"[b{i}] is field, min, max and nothing else")
        f = b["field"]
        if not isinstance(f, str) or not FIELD_RE.match(f):
            raise _malformed(path, f"[b{i}] field is a name with no space and no colon")
        if not isinstance(b["min"], int) or not isinstance(b["max"], int) or isinstance(b["min"], bool) or isinstance(b["max"], bool):
            raise _malformed(path, f"[b{i}] min and max are integers (a fractional band is a consumer's question, D48)")
        if b["min"] > b["max"]:
            raise _malformed(path, f"[b{i}] min {b['min']} is above max {b['max']}")
        if f in seen:
            raise _malformed(path, f"[b{i}] field '{f}' is frozen twice (a duplicate is hand-editing, BBX-17)")
        seen.add(f)
        bands.append((f, b["min"], b["max"]))
        i += 1
    if not bands:
        raise _malformed(path, "no [b1] table")
    for k in t:
        if k != "spec" and not (k.startswith("b") and k[1:].isdigit() and 1 <= int(k[1:]) < i):
            raise _malformed(path, f"[{k}] is not a band table ([b1], [b2], … in order)")
    for f in rulings:
        if f not in seen:
            raise _malformed(path, f"[spec].rulings names '{f}', which no [b<i>] table freezes")
    return Spec(spec["baseset"], spec["measured"], dict(rulings), bands)


def load_view(path):
    """-> [(name, value)] in the view's order, or raise ValueError carrying the verdict line (D53's grammar)."""
    try:
        with open(path, encoding="utf-8") as fh:
            lines = fh.read().splitlines()
    except OSError as e:
        raise ValueError(f"FAIL band: the band view {path} cannot be read ({e.strerror}: no band field was observed — the scenario declares no bands, or stdout was not one JSON object)")
    except UnicodeDecodeError as e:
        raise ValueError(f"FAIL band: the band view {path} cannot be read ({e.reason})")
    def bad(why):
        return ValueError(f"FAIL band: the band view {path} is malformed ({why})")
    if not lines or not lines[-1].startswith("END "):
        raise bad("no END line last")
    try:
        k = int(lines[-1].split(" ", 1)[1])
    except ValueError:
        raise bad("END is not followed by a count")
    rows, names = [], set()
    for n, line in enumerate(lines[:-1], start=1):
        parts = line.split(" ", 1)
        if len(parts) != 2 or parts[0] != str(n) or "=" not in parts[1]:
            raise bad(f"line {n} is not `{n} <name>=<value>`")
        name, text = parts[1].split("=", 1)
        if not FIELD_RE.match(name):
            raise bad(f"line {n}: '{name}' is not a field name")
        if name in names:
            raise bad(f"field '{name}' appears twice")
        try:
            value = json.loads(text)
        except ValueError:
            raise bad(f"line {n}: the value of '{name}' is not canonical JSON")
        names.add(name)
        rows.append((name, value))
    if k != len(rows):
        raise bad(f"END {k} but {len(rows)} rows")
    return rows


def compare(spec_path, view_path):
    """-> (verdict lines, exit status)."""
    try:
        spec = load_spec(spec_path)
        view = load_view(view_path)
    except ValueError as e:
        return [str(e)], 1
    frozen = {f: (lo, hi) for f, lo, hi in spec.bands}
    seen = dict(view)
    for f in frozen:
        if f not in seen:
            return [f"FAIL band: frozen field '{f}' is not in the band view"], 1
    for name, _v in view:
        if name not in frozen:
            return [f"FAIL band: view field '{name}' is not frozen (a band nobody froze, BBX-13)"], 1
    for f, lo, hi in spec.bands:
        v = seen[f]
        if isinstance(v, bool) or not isinstance(v, int):
            return [f"FAIL band {f}: {json.dumps(v, sort_keys=True, separators=(',', ':'), ensure_ascii=False)} is not an integer (the band is [{lo}, {hi}])"], 1
        if v < lo or v > hi:
            return [f"FAIL band {f}: {v} outside [{lo}, {hi}]"], 1
    n = len(spec.bands)
    return [f"PASS band ({n} field(s), every value inside its band)", f"NOTE: band-fields {n}"], 0


def _toml_str(s):
    if '"' in s or "\\" in s or "\n" in s:
        raise ValueError("a band spec string holds no quote, no backslash and no newline")
    return f'"{s}"'


def render(baseset, measured, rulings, bands):
    """The frozen file's text — the same text fixture/fakecli/mkfakecli.py writes, so a freeze of an unchanged
    band reproduces the generator's file byte for byte (gates/band.sh measures it)."""
    out = ["[spec]", f'class = "{CLASS}"', f"baseset = {_toml_str(baseset)}", f"measured = {_toml_str(measured)}"]
    if rulings:
        out.append("rulings = { " + ", ".join(f"{k} = {_toml_str(rulings[k])}" for k in sorted(rulings)) + " }")
    for i, (f, lo, hi) in enumerate(bands, start=1):
        out += ["", f"[b{i}]", f'field = "{f}"', f"min = {lo}", f"max = {hi}"]
    return "\n".join(out) + "\n"


def freeze(spec_path, proposed_path):
    """-> (lines, exit status): 0 written, 3 REFUSED (the file unchanged), 1 either file unreadable."""
    try:
        cur = load_spec(spec_path)
        new = load_spec(proposed_path)
    except ValueError as e:
        return [str(e)], 1
    cur_f = [f for f, _lo, _hi in cur.bands]
    new_f = [f for f, _lo, _hi in new.bands]
    if set(cur_f) != set(new_f):
        gone = [f for f in cur_f if f not in new_f]
        added = [f for f in new_f if f not in cur_f]
        why = "; ".join(p for p in (gone and f"frozen but not proposed: {', '.join(gone)}",
                                    added and f"proposed but not frozen: {', '.join(added)}") if p)
        return [f"REFUSED: band inventory moves ({why}) — the inventory is BBX-13's watch and never moves through a freeze"], 3
    cur_b = {f: (lo, hi) for f, lo, hi in cur.bands}
    narrowed, widened = 0, []
    for f, lo, hi in new.bands:
        clo, chi = cur_b[f]
        if lo < clo or hi > chi:
            rid = new.rulings.get(f)
            if not rid:
                return [f"REFUSED: band {f} widens [{clo}, {chi}] -> [{lo}, {hi}] with no rulings entry for it (R36: a band is loosened only with a measured mechanism named and a ruling)"], 3
            widened.append((f, rid))
        elif (lo, hi) != (clo, chi):
            narrowed += 1
    try:
        text = render(cur.baseset, new.measured, new.rulings, new.bands)
    except ValueError as e:
        return [f"FAIL band: {proposed_path} is not a band spec ({e})"], 1
    with open(spec_path, "w", encoding="utf-8") as fh:
        fh.write(text)
    under = " under " + ", ".join(sorted({rid for _f, rid in widened})) if widened else ""
    return [f"frozen band ({len(new.bands)} field(s); {narrowed} narrowed, {len(widened)} widened{under})"], 0


def main(argv):
    if argv and argv[0] == "--freeze":
        if len(argv) != 3:
            print(__doc__.split("\n\n")[1], file=sys.stderr)
            return 2
        lines, rc = freeze(argv[1], argv[2])
    elif len(argv) == 2:
        lines, rc = compare(argv[0], argv[1])
    else:
        print(__doc__.split("\n\n")[1], file=sys.stderr)
        return 2
    for l in lines:
        print(l)
    return rc


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
