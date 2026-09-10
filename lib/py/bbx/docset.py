#!/usr/bin/env python3
"""docset.py — the document-set kind's EXTRACTOR: quote a claim from a document, derive the fact it
states from the artifact, bind the two, and write the point-indexed log the harness already reads
(docs/plans/S3.md §3 "D1–D5", "O1", "the claim set"; rulings R31, R33; defaults D35, D37, D38–D40).

    python3 -m bbx.docset selftest                                    the extractors on synthetic lines
    python3 -m bbx.docset run <artifact.tsv> <scenario.claims> <out.log> [--nondet]
    python3 -m bbx.docset map <artifact.tsv> <scenario.claims>        index -> (document, line, form, status, quoted, derived)
    python3 -m bbx.docset summary <log>                               NOTE: coverage / paraphrase / unbindable
    python3 -m bbx.docset rows <artifact.tsv> <scenario.claims> <log>  the run's rows: index, document, line, form, status
                                                                      (the log's statuses joined by index with the map,
                                                                      the map proven to describe THIS log — S3 step 3)
    python3 -m bbx.docset resolve <set>                               the artifact `<set>.tsv` on DOCSET_PATH (`;`-separated,
                                                                      each component made absolute; the first that has it
                                                                      wins) — the ONE resolver the driver and the schema
                                                                      comparator share; exit 1 naming the path if none

THE TWO STRINGS ARE DEFINED HERE AND NOWHERE ELSE. The QUOTED string is the document's line, verbatim
(the `text` view); the DERIVED string is what the artifact says about the thing the line names (the
`artifact` view): `<name>.<field>=<value>`, or `<name>.<field>=<absent>` when the artifact has no such
record or column, or `unbindable:<reason>` for a claim the claim set lists as unbindable (D38). The
fixture generator (fixture/docset/mkdocset.py) imports `quoted_text`, `derived_text`,
`derived_unbindable` and `token` from here to write the expected truth from its DESIGN, so the truth
and the driver's log agree by construction and disagree only when the BINDING disagrees with the
design — which is the test.

THE OBSERVATION (O1, R31): one line per claim, `<index> <status>:<sha1-of-quoted>:<sha1-of-derived>`,
then `END <n>`. The index is the claim's position in the extraction order — document order in the
claim set, then line — and the claim set is the map from index to (document, line, form). The
token is one space-free field, compared as a token by every comparator (never interpreted) and
split by `split_token()` here, in one place, by field name (BBX-12). `n` counts every claim seen,
UNBINDABLE ones included: the denominator is in the log (R33).

THE STATUS VOCABULARY is CLOSED (R33, D37):
    BOUND       the line matched a declared form and the value it states equals the artifact's
    MISMATCH    the line matched a declared form (or is a listed paraphrase) and the value differs
    PARAPHRASE  listed in the claim set as a paraphrase of a literal fact; the LITERAL equals the
                artifact's value — never counted as BOUND, never allowed to degrade into a skip
    UNBINDABLE  listed in the claim set with a reason (absence | no-source | no-form); counted in the
                denominator, never bound
    STALE       the line names a record or a column the artifact does not have, or a listed line no
                longer exists — the quoted sentence is no longer in the document the artifact describes
    a status nobody named here cannot be printed.

WHAT IS REFUSED (exit 3 from the driver, the REFUSED line printed here): a form the claim set declares
that no extractor implements (C6: never bound by a looser regex); a view other than `artifact`; a line
that states an absence, or carries a number, matches no declared form and is not listed — an absence
nobody listed is not silently dropped (BBX-7; the guards are D40). A document or artifact that cannot
be read is exit 1 (the run is DISCARDED).

THE SELF-TEST (SMS `claim_selftests`, docs/plans/S3.md §5 "the extractor that stopped matching"): every
run, before any document is read, each form is exercised on synthetic lines against a synthetic
artifact — the true sentence is found and BOUND, the falsified one (the value's MIRROR, BBX-15: a
reader that mirrors digits would call it BOUND) is found and MISMATCH, the loose sentence is not
found. A form whose extractor no longer matches is named, and the driver exits 1 before any document
is read. A gate proves the self-test fires on a shadow copy with one regex broken.

Lineage: SMS-FrenchName-edition `tools/checkdocs.py` (quote from the document, derive from the ROM,
compare; UNENCODABLE printed, never dropped), VampireSaved `checkdocs_rom.py` (PARAPHRASE checked
against the literal fact; the covered set frozen). Nothing here is lifted; the printed lines are BBX's.
"""
import hashlib
import os
import re
import sys
import time
from pathlib import Path

from . import logfmt
from . import toml_subset

STATUSES = ("BOUND", "PARAPHRASE", "UNBINDABLE", "STALE", "MISMATCH")
COVERED = ("BOUND", "PARAPHRASE")
REASONS = ("absence", "no-source", "no-form")
VIEWS = ("artifact",)

# D35 (the fixture's three sentence forms) with D39's lexical classes: a name and a field are one
# space-free, bar-free token; a value is a decimal or hexadecimal numeral (so a markdown table's
# header row `| name | field | value |` is not a claim, and a bare word is never a value)
_NAME = r"(?P<name>[^\s|]+)"
_FIELD = r"(?P<field>[^\s|]+)"
_VALUE = r"(?P<value>[0-9A-Fa-f]+)"
FORMS = {
    "has":   re.compile(rf"^{_NAME} has {_FIELD} {_VALUE}\.$"),
    "of-is": re.compile(rf"^The {_FIELD} of {_NAME} is {_VALUE}\.$"),
    "row":   re.compile(rf"^\| {_NAME} \| {_FIELD} \| {_VALUE} \|$"),
}

# D40 — the unlisted-claim guards (BBX-7): a line that matches no declared form and is not listed,
# but states an absence or carries a number, is REFUSED — not silently a non-claim
ABSENCE_GUARD = re.compile(r"^(Nothing|None|No [^\s|]+) (lists|records|gives|states|has|carries|mentions)\b")
NUMBER_GUARD = re.compile(r"[0-9]")

# the driver's own variables, the family the suite scrubs (D33 hermetic_unset)
DRIVER_FAMILY = ("DOCSET_FORMS", "DOCSET_NONDET", "DOCSET_VIEW")


class Refused(Exception):
    """what the driver cannot honour: printed as `REFUSED: drivers/docset.sh cannot honour <what> (<why>)`, exit 3."""
    def __init__(self, what, why):
        super().__init__(f"REFUSED: drivers/docset.sh cannot honour {what} ({why})")


class Unreadable(Exception):
    """the artifact, a document or the claim set cannot be read: exit 1, the run DISCARDED."""


# ── the two strings, the token, the one splitter (D38) ─────────────────────────
def quoted_text(line):
    """The QUOTED string: the document's line, verbatim, without its newline."""
    return line.rstrip("\r\n")


def derived_text(name, field, value):
    """The DERIVED string for a record's field: `<name>.<field>=<value>`; value None = absent."""
    return f"{name}.{field}={'<absent>' if value is None else value}"


def derived_unbindable(reason):
    """The DERIVED string of a listed unbindable claim: `unbindable:<reason>`."""
    return f"unbindable:{reason}"


def sha1(text):
    return hashlib.sha1(text.encode("utf-8")).hexdigest()


def token(status, quoted, derived):
    if status not in STATUSES:
        raise ValueError(f"status {status!r} is not in the closed vocabulary {STATUSES}")
    return f"{status}:{sha1(quoted)}:{sha1(derived)}"


def split_token(tok):
    """`<status>:<sha1-of-quoted>:<sha1-of-derived>` -> dict by field name; the ONE splitter (O3, BBX-12)."""
    parts = tok.split(":")
    if len(parts) != 3 or parts[0] not in STATUSES:
        raise ValueError(f"not a document-set token: {tok!r}")
    return {"status": parts[0], "quoted": parts[1], "derived": parts[2]}


# ── the views ─────────────────────────────────────────────────────────────────
def read_artifact(path):
    """The `artifact` view: a TSV whose FIRST column keys the records (D39) -> (columns, {key: {column: value}})."""
    try:
        text = Path(path).read_text(encoding="utf-8")
    except OSError as e:
        raise Unreadable(f"artifact {path} cannot be read: {e.strerror}")
    lines = [l for l in text.splitlines() if l.strip()]
    if not lines:
        raise Unreadable(f"artifact {path} is empty (no header line)")
    columns = lines[0].split("\t")
    records = {}
    for l in lines[1:]:
        cells = l.split("\t")
        records[cells[0]] = dict(zip(columns, cells))
    return columns, records


def read_document(path):
    """The `text` view: the document's lines, in order, 1-based by position."""
    try:
        return Path(path).read_text(encoding="utf-8").splitlines()
    except OSError as e:
        raise Unreadable(f"document {path} cannot be read: {e.strerror}")


# ── the claim set (D35's grammar) ─────────────────────────────────────────────
class ClaimSet:
    def __init__(self, documents, forms, view, listed):
        self.documents = documents      # in order: the extraction order's first key
        self.forms = forms              # in the declared order: the first matching form wins
        self.view = view
        self.listed = listed            # (document, line) -> ("paraphrase", name, field, literal) | ("unbindable", reason)


def load_claims(path):
    try:
        t = toml_subset.load(path)
    except (OSError, toml_subset.SubsetError) as e:
        raise Unreadable(f"claim set {path} cannot be read: {e}")
    c = t.get("claims")
    if not isinstance(c, dict):
        raise Unreadable(f"claim set {path}: no [claims] table")
    documents = c.get("documents"); forms = c.get("forms"); view = c.get("view", "artifact")
    if not isinstance(documents, list) or not documents or not all(isinstance(d, str) for d in documents):
        raise Unreadable(f"claim set {path}: [claims].documents must be a non-empty list of names")
    if not isinstance(forms, list) or not forms or not all(isinstance(f, str) for f in forms):
        raise Unreadable(f"claim set {path}: [claims].forms must be a non-empty list of names")
    for f in forms:
        if f not in FORMS:
            raise Refused(f"form '{f}'", f"no extractor implements it; the forms are {', '.join(FORMS)} — a claim in another form is listed UNBINDABLE with reason no-form, never bound by a looser regex")
    if view not in VIEWS:
        raise Refused(f"view '{view}'", f"the derived side is read from the artifact only; the views are {', '.join(VIEWS)}")
    listed = {}
    for name, row in t.items():
        if name == "claims":
            continue
        if not isinstance(row, dict) or "kind" not in row:
            raise Unreadable(f"claim set {path}: [{name}] is not a paraphrase or unbindable row (no `kind`)")
        doc, line = row.get("document"), row.get("line")
        if doc not in documents or not isinstance(line, int) or line < 1:
            raise Unreadable(f"claim set {path}: [{name}] must name a document of this claim set and a line >= 1")
        if (doc, line) in listed:
            raise Unreadable(f"claim set {path}: {doc}:{line} is listed twice ([{name}])")
        if row["kind"] == "paraphrase":
            for k in ("name", "field", "literal"):
                if k not in row:
                    raise Unreadable(f"claim set {path}: [{name}] paraphrase row lacks `{k}`")
            listed[(doc, line)] = ("paraphrase", str(row["name"]), str(row["field"]), str(row["literal"]))
        elif row["kind"] == "unbindable":
            reason = row.get("reason")
            if reason not in REASONS:
                raise Refused(f"[{name}].reason '{reason}'", f"the reasons are {', '.join(REASONS)}")
            listed[(doc, line)] = ("unbindable", reason)
        else:
            raise Unreadable(f"claim set {path}: [{name}].kind {row['kind']!r} is neither paraphrase nor unbindable")
    return ClaimSet(documents, forms, view, listed)


# ── binding ───────────────────────────────────────────────────────────────────
def _lookup(records, name, field):
    rec = records.get(name)
    if rec is None or field not in rec:
        return None
    return rec[field]


def bind_lines(docname, lines, claims, records):
    """Bind one document's lines -> [(line, form, status, quoted, derived)] in line order."""
    out = []
    for ln, raw in enumerate(lines, start=1):
        quoted = quoted_text(raw)
        listed = claims.listed.get((docname, ln))
        if listed is not None:
            if listed[0] == "unbindable":
                out.append((ln, "unbindable", "UNBINDABLE", quoted, derived_unbindable(listed[1])))
            else:
                _, name, field, literal = listed
                got = _lookup(records, name, field)
                derived = derived_text(name, field, got)
                status = "STALE" if got is None else ("PARAPHRASE" if got == literal else "MISMATCH")
                out.append((ln, "paraphrase", status, quoted, derived))
            continue
        matched = False
        for form in claims.forms:
            m = FORMS[form].match(quoted)
            if not m:
                continue
            name, field, value = m.group("name"), m.group("field"), m.group("value")
            got = _lookup(records, name, field)
            derived = derived_text(name, field, got)
            status = "STALE" if got is None else ("BOUND" if got == value else "MISMATCH")
            out.append((ln, form, status, quoted, derived))
            matched = True
            break
        if matched:
            continue
        if ABSENCE_GUARD.search(quoted):
            raise Refused(f"{docname}:{ln}", f"an unlisted absence: {quoted!r} — list it under [u<n>] with a reason, or it is silently dropped (BBX-7)")
        if NUMBER_GUARD.search(quoted):
            raise Refused(f"{docname}:{ln}", f"an unlisted number in no declared form: {quoted!r} — list it under [u<n>] (reason no-form or no-source) or [p<n>], or it is silently dropped (BBX-7)")
    # a listed line the document no longer has: STALE, never silently dropped
    for (d, ln), listed in sorted(claims.listed.items(), key=lambda kv: kv[0][1]):
        if d == docname and ln > len(lines):
            derived = derived_unbindable(listed[1]) if listed[0] == "unbindable" else derived_text(listed[1], listed[2], None)
            out.append((ln, listed[0], "STALE", "", derived))
    out.sort(key=lambda r: r[0])
    return out


def bind(artifact, claims):
    """The whole scenario -> [(index, document, line, form, status, quoted, derived)] in extraction order (R31)."""
    _columns, records = read_artifact(artifact)
    docdir = Path(artifact).parent
    rows = []
    for d in claims.documents:
        for ln, form, status, quoted, derived in bind_lines(d, read_document(docdir / d), claims, records):
            rows.append((len(rows) + 1, d, ln, form, status, quoted, derived))
    return rows


def write_log(rows, out, nondet=False):
    salt = f"|{time.time_ns()}" if nondet else ""
    with open(out, "w", encoding="utf-8") as fh:
        for index, _d, _ln, _form, status, quoted, derived in rows:
            fh.write(f"{index} {token(status, quoted, derived + salt)}\n")
        fh.write(f"END {len(rows)}\n")


def run_rows(artifact, claimsfile, log):
    """The run's rows for the set family: [(index, document, line, form, status)] — the STATUS from the
    log's token (the observation), the (document, line, form) from the map (the scenario, R31), joined by
    index. The map is proven to describe THIS log: every index of the log must be in the map and the
    quoted half of every token must equal the sha1 of the map's quoted string (D38; DOCSET_NONDET salts
    the derived half only). ValueError names the first index where it does not."""
    rows = bind(artifact, load_claims(claimsfile))
    by_index = {r[0]: r for r in rows}
    out = []
    for index, tok in logfmt.frames(log):
        t = split_token(tok)
        if index not in by_index:
            raise ValueError(f"the log's index {index} is not in the claim map ({len(by_index)} claims)")
        _i, d, ln, form, _status, quoted, _derived = by_index[index]
        if t["quoted"] != sha1(quoted):
            raise ValueError(f"the claim map does not describe this log at index {index} (the quoted hash differs)")
        out.append((index, d, ln, form, t["status"]))
    return out


def resolve_artifact(set_name, search_path, cwd=None):
    """`<set>.tsv` on the `;`-separated search path, each component made ABSOLUTE against cwd (bbh's
    drivers learned it on a relative one); the first directory that has it wins. Raises Unreadable
    naming the path when none does, or when a relative component does not resolve."""
    if not search_path:
        raise Unreadable(f"set DOCSET_PATH to the directory holding {set_name}.tsv")
    base = Path(cwd or Path.cwd())
    for comp in search_path.split(";"):
        if not comp:
            continue
        if comp.startswith("/"):
            d = Path(comp)                                   # an absent absolute component is skipped
        else:
            d = base / comp
            if not d.is_dir():                               # a relative one that resolves nowhere is an error
                raise Unreadable(f"search-path component '{comp}' does not resolve from {base}")
            d = d.resolve()
        if (d / f"{set_name}.tsv").is_file():
            return str(d / f"{set_name}.tsv")
    raise Unreadable(f"no {set_name}.tsv on DOCSET_PATH={search_path}")


# ── the self-test (every run, before any document is read) ────────────────────
SELFTEST_RECORDS = {"Zork": {"name": "Zork", "id": "0B1C", "weight": "53", "rank": "2"}}
SELFTEST_LINES = {   # form: (true, falsified — the value's mirror, loose)
    "has":   ("Zork has weight 53.", "Zork has weight 35.", "Zork has weight of 53."),
    "of-is": ("The weight of Zork is 53.", "The weight of Zork is 35.", "The weight of Zork is about 53."),
    "row":   ("| Zork | weight | 53 |", "| Zork | weight | 35 |", "| Zork | weight 53 |"),
}


def selftest():
    """-> [failure sentences], one per form that no longer behaves; empty = every extractor is alive."""
    bad = []
    for form, (true, false, loose) in SELFTEST_LINES.items():
        cs = ClaimSet(["synthetic.md"], [form], "artifact", {})
        try:
            got = bind_lines("synthetic.md", [true, false, "The header.", ""], cs, SELFTEST_RECORDS)
            statuses = [(r[0], r[2]) for r in got]
        except Refused as e:   # the guard refusing the TRUE line is the form not matching (the shadow control's shape)
            statuses = f"not found — {e}"
        if statuses != [(1, "BOUND"), (2, "MISMATCH")]:
            bad.append(f"form '{form}': expected line 1 BOUND and line 2 MISMATCH, got {statuses}")
        try:
            loose_got = bind_lines("synthetic.md", [loose], cs, SELFTEST_RECORDS)
        except Refused:
            loose_got = []   # the number guard refusing the loose line is "not found"
        if loose_got:
            bad.append(f"form '{form}': the loose sentence {loose!r} was bound as {loose_got[0][2]}")
    if set(FORMS) != set(SELFTEST_LINES):
        bad.append(f"the self-test covers {sorted(SELFTEST_LINES)} but the forms are {sorted(FORMS)}")
    return bad


# ── the CLI ───────────────────────────────────────────────────────────────────
def cmd_summary(log):
    """NOTE lines from a log: coverage <bound+paraphrase>/<END n>, paraphrase, unbindable, and the rest."""
    lines = logfmt.lines(log)
    end = [l for l in lines if l.startswith("END ")]
    if len(end) != 1:
        print(f"FAIL: {log} has {len(end)} END lines (one expected)"); return 1
    n = int(end[0].split()[1])
    counts = {s: 0 for s in STATUSES}
    for _idx, tok in logfmt.frames(log):
        counts[split_token(tok)["status"]] += 1
    seen = sum(counts.values())
    if seen != n:
        print(f"FAIL: {log} carries {seen} claim lines but END says {n}"); return 1
    print(f"NOTE: coverage {counts['BOUND'] + counts['PARAPHRASE']}/{n}")
    print(f"NOTE: paraphrase {counts['PARAPHRASE']}")
    print(f"NOTE: unbindable {counts['UNBINDABLE']}")
    print(f"NOTE: stale {counts['STALE']}")
    print(f"NOTE: mismatch {counts['MISMATCH']}")
    return 0


def main(argv):
    if not argv or argv[0] not in ("selftest", "run", "map", "summary", "rows", "resolve"):
        print(__doc__.split("\n\n")[1]); return 2
    try:
        if argv[0] == "selftest":
            bad = selftest()
            for b in bad:
                print(f"docset.py: self-test FAILED — {b}")
            if bad:
                return 1
            print(f"docset.py: self-test ok — {len(FORMS)} forms found true, falsified and loose lines as designed")
            return 0
        if argv[0] == "summary":
            return cmd_summary(argv[1])
        if argv[0] == "resolve":
            print(resolve_artifact(argv[1], os.environ.get("DOCSET_PATH", "")))
            return 0
        if argv[0] == "rows":
            try:
                for index, d, ln, form, status in run_rows(argv[1], argv[2], argv[3]):
                    print(f"{index}\t{d}\t{ln}\t{form}\t{status}")
            except ValueError as e:
                print(f"docset.py: {e}"); return 1
            return 0
        artifact, claimsfile = argv[1], argv[2]
        claims = load_claims(claimsfile)
        rows = bind(artifact, claims)
        if argv[0] == "map":
            for index, d, ln, form, status, quoted, derived in rows:
                print(f"{index}\t{d}\t{ln}\t{form}\t{status}\t{quoted}\t{derived}")
            return 0
        out = argv[3]
        write_log(rows, out, nondet="--nondet" in argv[4:])
        return 0
    except Refused as e:
        print(e); return 3
    except Unreadable as e:
        print(f"docset.py: {e}"); return 1


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
