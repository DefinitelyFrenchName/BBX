#!/usr/bin/env python3
"""mkdocset.py — the DOCUMENT-SET FIXTURE's generator (docs/generality.md kind A; docs/plans/S3.md §4).

    python3 fixture/docset/mkdocset.py            write the fixture under this directory
    python3 fixture/docset/mkdocset.py --check    the tree's fixture equals what this script writes,
                                                  and every chirality predicate holds on the tree's
                                                  artifact; non-zero naming the file or the predicate

WHAT IT WRITES, from the DESIGN table below and nothing else (the truth is known here, which is
why every expectation it freezes is class `fixture` — evidence about no real subject, R24):
  subject/records.tsv          the ARTIFACT: 12 records × (name, id, weight, rank), every value chiral
  subject/{overview,weights,ranks}.md   three documents quoting claims in the three bindable
                               sentence forms (`has`, `of-is`, `row`; D35) — 20 bindable claims,
                               one deliberately WRONG (weights.md: Dorin, the known positive of
                               BBX-5), one PARAPHRASE ("about forty" for 37), two UNBINDABLE
                               (an absence, BBX-7; a number no artifact settles)
  claims/*.claims              three scenarios (TOML subset, R32): which documents, forms, view;
                               the declared paraphrase and unbindable rows
  expected/fixture/<s>.claims  the claim INVENTORY per scenario (multiset, both ways; R33/R34)
  expected/fixture/<s>.covered the COVERED set per scenario (BOUND + PARAPHRASE; shrink-only)
  expected/fixture/<s>.schema  the artifact's shape (four columns, a rows line; R34)
  expected/registry.tsv        the WHOLE-SET key of subject/ (docs + artifact, dir-sha1) -> `fixture`
  expected/PROVENANCE.toml     every expectation file, class `fixture`; the registry row `registry`
The `.truth` logs (the expected token per claim) need the driver's token grammar and are written by
S3 step 2 (`--truth`, importing bbx.docset); until then the fixture has no truth kind.

CHIRAL BY CONSTRUCTION (BBX-15): a mirror, order or orientation error in a reader cannot hide if no
value equals its own mirror and no mirror of a value is another value. The predicates are asserted
in both modes, on the design AND on the tree's artifact under --check, and each is named when it
fails (gates/docset_fixture.sh's control `symmetric-fixture`).

SMS `tools/mk*.py` convention (6 generators there): a generated fixture is re-derived and diffed,
never hand-edited (BBX-21).
"""
import hashlib
import os
import sys
import tempfile
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent.parent / "lib" / "py"))

# ── the design ────────────────────────────────────────────────────────────────
# (name, id, weight, rank) — see the predicates below for why these values
RECORDS = [
    ("Aldric",  "3A7F", 41, 7),
    ("Bramble", "5C21", 58, 3),
    ("Corvin",  "19E4", 37, 11),
    ("Dorin",   "7B06", 57, 1),
    ("Elspet",  "2D93", 64, 9),
    ("Fenwick", "6F48", 29, 5),
    ("Gilda",   "0C5A", 71, 12),
    ("Hadrian", "4E17", 49, 2),
    ("Isolde",  "8A3D", 52, 8),
    ("Jorund",  "1F62", 38, 6),
    ("Kestrel", "9B0E", 61, 4),
    ("Lorcan",  "2C74", 45, 10),
]
COLUMNS = (("name", "str"), ("id", "hex"), ("weight", "int"), ("rank", "int"))
REC = {r[0]: r for r in RECORDS}

# the documents: (line-text, claim) — claim = (form, name, field, value, status) or None
def _has(n, f, v, status="BOUND"):   return (f"{n} has {f} {v}.", ("has", n, f, str(v), status))
def _ofis(n, f, v, status="BOUND"):  return (f"The {f} of {n} is {v}.", ("of-is", n, f, str(v), status))
def _row(n, f, v, status="BOUND"):   return (f"| {n} | {f} | {v} |", ("row", n, f, str(v), status))
def _val(n, f): return str(REC[n][{"name": 0, "id": 1, "weight": 2, "rank": 3}[f]])

DOCS = {
    "overview.md": [
        ("# Overview of the records", None),
        ("", None),
        _has("Aldric", "id", _val("Aldric", "id")),
        _has("Bramble", "rank", _val("Bramble", "rank")),
        ("Corvin weighs about forty.", ("paraphrase", "Corvin", "weight", _val("Corvin", "weight"), "PARAPHRASE")),
        _has("Dorin", "weight", _val("Dorin", "weight")),
        _has("Elspet", "id", _val("Elspet", "id")),
        _has("Fenwick", "rank", _val("Fenwick", "rank")),
        ("Nothing lists a weight for Zed.", ("unbindable", "-", "-", "absence", "UNBINDABLE")),
        _has("Gilda", "id", _val("Gilda", "id")),
        ("The table was measured in 3 runs.", ("unbindable", "-", "-", "no-source", "UNBINDABLE")),
    ],
    "weights.md": [
        ("# Weights", None),
        ("", None),
        _ofis("Aldric", "weight", _val("Aldric", "weight")),
        _ofis("Bramble", "weight", _val("Bramble", "weight")),
        _ofis("Dorin", "weight", 58, "MISMATCH"),          # the deliberately WRONG claim (57 in the artifact)
        _ofis("Hadrian", "weight", _val("Hadrian", "weight")),
        _ofis("Isolde", "weight", _val("Isolde", "weight")),
        _ofis("Jorund", "weight", _val("Jorund", "weight")),
        _ofis("Lorcan", "weight", _val("Lorcan", "weight")),
    ],
    "ranks.md": [
        ("# Ranks", None),
        ("", None),
        ("| name | field | value |", None),
        ("|---|---|---|", None),
        _row("Corvin", "rank", _val("Corvin", "rank")),
        _row("Dorin", "rank", _val("Dorin", "rank")),
        _row("Gilda", "rank", _val("Gilda", "rank")),
        _row("Hadrian", "rank", _val("Hadrian", "rank")),
        _row("Kestrel", "rank", _val("Kestrel", "rank")),
        _row("Lorcan", "rank", _val("Lorcan", "rank")),
        _row("Elspet", "rank", _val("Elspet", "rank")),
    ],
}
DOC_ORDER = ("overview.md", "weights.md", "ranks.md")

# the scenarios (claim sets): name -> (documents, forms)
SCENARIOS = {
    "01_all":     (("overview.md", "weights.md", "ranks.md"), ("has", "of-is", "row")),
    "02_weights": (("weights.md",), ("of-is",)),
    "03_rows":    (("ranks.md",), ("row",)),
}
SET = "records"          # the artifact is subject/<set>.tsv ([fingerprint].file_pattern, D33)
EXPSET = "fixture"       # the expectation set the registry maps the whole-set key to


# ── chirality (BBX-15) ────────────────────────────────────────────────────────
def predicates(records):
    """[(name, holds)] over a list of (name, id, weight, rank) — every predicate named."""
    names = [r[0] for r in records]; ids = [r[1] for r in records]
    weights = [int(r[2]) for r in records]; ranks = [int(r[3]) for r in records]
    n = len(records)
    inv = {ranks[i]: i + 1 for i in range(n)}
    out = [
        ("names-distinct", len(set(names)) == n),
        ("no-name-is-its-own-mirror", all(s != s[::-1] for s in names)),
        ("no-id-is-its-own-mirror", all(s != s[::-1] for s in ids)),
        ("no-id-mirror-is-another-id", all(s[::-1] not in ids for s in ids)),
        ("weights-distinct", len(set(weights)) == n),
        ("no-weight-is-its-own-mirror", all(str(w) != str(w)[::-1] for w in weights)),
        ("no-weight-mirror-is-another-weight", all(int(str(w)[::-1]) not in weights for w in weights)),
        ("ranks-are-a-permutation", sorted(ranks) == list(range(1, n + 1))),
        ("rank-permutation-is-not-its-own-inverse", any(inv.get(i + 1) != ranks[i] for i in range(n))),
        ("rank-permutation-is-not-the-reversal", any(ranks[i] != n - i for i in range(n))),
    ]
    return out


def failed_predicates(records):
    return [name for name, holds in predicates(records) if not holds]


# ── the files ─────────────────────────────────────────────────────────────────
def claims_of(scenario):
    """The claim rows of a scenario in EXTRACTION ORDER (R31): document order in the claim set,
    then line, then form — (document, line, form, name, field, value, status)."""
    docs, forms = SCENARIOS[scenario]
    rows = []
    for d in docs:
        for i, (_text, claim) in enumerate(DOCS[d], start=1):
            if claim is None:
                continue
            form, name, field, value, status = claim
            if form in forms or form in ("paraphrase", "unbindable"):
                rows.append((d, i, form, name, field, value, status))
    return rows


def toml_rows(spec, rows, prefix):
    lines = ["[spec]"] + [f'{k} = "{v}"' for k, v in spec] + [""]
    for i, (d, line, form, _n, _f, _v, status) in enumerate(rows, start=1):
        lines += [f"[{prefix}{i}]", f'document = "{d}"', f"line = {line}", f'form = "{form}"', f'status = "{status}"', ""]
    return "\n".join(lines).rstrip("\n") + "\n"


def files():
    """{relative path: text} — everything the fixture is."""
    out = {}
    out[f"subject/{SET}.tsv"] = "\t".join(c for c, _ in COLUMNS) + "\n" + "".join(
        f"{n}\t{i}\t{w}\t{r}\n" for n, i, w, r in RECORDS)
    for d in DOC_ORDER:
        out[f"subject/{d}"] = "".join(t + "\n" for t, _ in DOCS[d])
    for s, (docs, forms) in SCENARIOS.items():
        lines = ["# the claim set (the scenario; R32): which documents, which sentence forms, which view (D35)",
                 "[claims]",
                 "documents = [" + ", ".join(f'"{d}"' for d in docs) + "]",
                 "forms = [" + ", ".join(f'"{f}"' for f in forms) + "]",
                 'view = "artifact"', ""]
        p = u = 0
        for d, line, form, name, field, value, status in claims_of(s):
            if form == "paraphrase":
                p += 1
                lines += [f"[p{p}]", 'kind = "paraphrase"', f'document = "{d}"', f"line = {line}",
                          f'name = "{name}"', f'field = "{field}"', f"literal = {value}", ""]
            elif form == "unbindable":
                u += 1
                lines += [f"[u{u}]", 'kind = "unbindable"', f'document = "{d}"', f"line = {line}", f'reason = "{value}"', ""]
        out[f"claims/{s}.claims"] = "\n".join(lines).rstrip("\n") + "\n"
        rows = claims_of(s)
        out[f"expected/{EXPSET}/{s}.claims"] = toml_rows(
            (("class", "multiset"), ("baseset", EXPSET), ("mode", "inventory")), rows, "c")
        out[f"expected/{EXPSET}/{s}.covered"] = toml_rows(
            (("class", "multiset"), ("baseset", EXPSET), ("mode", "shrink-only")),
            [r for r in rows if r[6] in ("BOUND", "PARAPHRASE")], "c")
        sch = ["[spec]", 'class = "schema"', f'baseset = "{EXPSET}"', 'format = "tsv"', ""]
        for i, (c, t) in enumerate(COLUMNS, start=1):
            sch += [f"[col{i}]", f'name = "{c}"', f'type = "{t}"', ""]
        sch += ["[rows]", 'op = ">="', f"n = {len(RECORDS)}"]
        out[f"expected/{EXPSET}/{s}.schema"] = "\n".join(sch) + "\n"
    return out


def registry_and_register(root, written):
    from bbx.fingerprint import dir_sha1
    wkey = dir_sha1(root / "subject" / f"{SET}.tsv")
    reg = ("# registry.tsv — whole-set key (dir-sha1 over subject/: the documents AND the artifact) -> expectation set.\n"
           "# Written by mkdocset.py at generation, which is the freeze (a build decision, [BBH-67]); a changed\n"
           "# document or artifact is an UNREGISTERED identity before any claim is read (abstraction S2).\n"
           "# sha1\texpectation-set\tnotes\n"
           f"{wkey}\t{EXPSET}\tthe generated fixture; WHOLE-SET key (subject/*)\n")
    rows = ["# PROVENANCE.toml — the expectation register of the document-set fixture (E3; R11, R24). Every row is",
            "# class `fixture`: the truth is known to the generator, so these are evidence about no real subject.",
            "# GENERATED by mkdocset.py — do not edit; regenerate.", ""]
    i = 0
    for rel in sorted(written):
        if not rel.startswith("expected/") or rel.endswith("registry.tsv"):
            continue
        i += 1
        what = {"claims": "the claim inventory", "covered": "the covered set (shrink-only)", "schema": "the artifact's shape"}[rel.rsplit(".", 1)[1]]
        rows += [f"[e{i}]", f'file = "{rel[len("expected/"):]}"', f'describes = "{what} of scenario {Path(rel).stem}"',
                 'class = "fixture"', 'refreeze = "python3 fixture/docset/mkdocset.py"', ""]
    i += 1
    rows += [f"[e{i}]", 'file = "registry.tsv"', 'describes = "whole-set key of subject/ -> fixture"',
             'class = "registry"', 'refreeze = "python3 fixture/docset/mkdocset.py"', ""]
    return reg, "\n".join(rows).rstrip("\n") + "\n"


def write_all(root):
    out = files()
    for rel, text in out.items():
        p = root / rel; p.parent.mkdir(parents=True, exist_ok=True); p.write_text(text)
    reg, prov = registry_and_register(root, out)
    (root / "expected" / "registry.tsv").write_text(reg)
    (root / "expected" / "PROVENANCE.toml").write_text(prov)
    out["expected/registry.tsv"] = reg; out["expected/PROVENANCE.toml"] = prov
    return out


def read_records(path):
    rows = [l.split("\t") for l in Path(path).read_text().splitlines()[1:] if l.strip()]
    return [(r[0], r[1], r[2], r[3]) for r in rows]


def counts():
    allrows = claims_of("01_all")
    return {
        "records": len(RECORDS), "documents": len(DOCS),
        "claims": sum(1 for r in allrows if r[2] in ("has", "of-is", "row")),
        "wrong": sum(1 for r in allrows if r[6] == "MISMATCH"),
        "paraphrase": sum(1 for r in allrows if r[6] == "PARAPHRASE"),
        "unbindable": sum(1 for r in allrows if r[6] == "UNBINDABLE"),
        "scenarios": len(SCENARIOS),
        "expectations": 3 * len(SCENARIOS),
    }


def main(argv):
    check = "--check" in argv
    bad = failed_predicates(RECORDS)
    if bad:
        print("FAIL: the DESIGN is not chiral: " + ", ".join(bad)); return 1
    if not check:
        write_all(HERE)
        print("wrote " + ", ".join(f"{k}={v}" for k, v in counts().items()))
        return 0
    # --check: (1) the tree's artifact under the predicates, named; (2) regenerate elsewhere and diff
    art = HERE / "subject" / f"{SET}.tsv"
    if not art.is_file():
        print(f"FAIL: {art.relative_to(HERE)} is missing"); return 1
    bad = failed_predicates(read_records(art))
    if bad:
        print("FAIL: chirality predicate(s) do not hold on subject/records.tsv: " + ", ".join(bad)); return 1
    with tempfile.TemporaryDirectory() as tmp:
        fresh = write_all(Path(tmp))
        differ = [rel for rel, text in fresh.items() if not (HERE / rel).is_file() or (HERE / rel).read_text() != text]
        extra = [str(p.relative_to(HERE)) for p in HERE.rglob("*")
                 if p.is_file() and p.relative_to(HERE).parts[0] in ("subject", "claims", "expected")
                 and str(p.relative_to(HERE)) not in fresh]
    if differ or extra:
        for rel in differ: print(f"  DIFFERS  {rel}")
        for rel in extra:  print(f"  NOT-GENERATED  {rel}")
        print(f"FAIL: {len(differ)} file(s) differ from the generator, {len(extra)} not generated"); return 1
    print("  ok: every predicate holds on subject/records.tsv; every file equals the generator's")
    print("NOTE: docset-fixture " + " ".join(f"{k}={v}" for k, v in counts().items()))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
