#!/usr/bin/env python3
"""documents.py — the documents register checked against the pages it describes (BBX-20; R62).

    python3 -m bbx.documents --check [--root DIR] [--register PATH]

Reads, under the root (default: the tree this module sits in, D75), the register `docs/documents.toml`
(or --register, relative to the root) through the TOML subset, the universe `git ls-files '*.md'`, and
each page's leading lines. The contract (R62, D82):

  complete both ways   every tracked page has exactly one row; every row names a tracked page
  fields               every table carries exactly `file`, `shape`, `twin`, `routed_by`, all strings
  shape                one of SHAPES; a page whose first LEAD_LINES lines carry a `Shape:` line (bold
                       allowed) names the row's shape as that line's first word, quoted on a mismatch
  twin                 a `living` row names a `history` row whose twin names it back, or
                       `none — <reason>`; a `history` row names a `living` row that names it back, or
                       `none — <reason>`; every other row's twin is empty
  routed_by            exactly one row is `root`, and it is a `map`; every other row names a `map` or
                       `census` page whose text names this page by its path (the path not preceded or
                       followed by a path character)

Findings, each `ERROR: <finding> <where>`:
  undeclared-document, dead-document-row, duplicate-document, row-fields, unknown-shape,
  shape-disagrees, living-without-twin, history-without-twin, twin-not-back, twin-on-shape,
  root-count, unrouted-document
Summary line, parsed by field name:
    documents=docs/documents.toml rows=<n> pages=<n> shapes=<n> errors=<n>
Exit 0 when errors=0, 1 otherwise, 2 when the register or the universe cannot be read.
Written at bbx-29 (S6 step 2, K4; R62).
"""
import os
import re
import subprocess
import sys
from pathlib import Path

from . import toml_subset

REGISTER = "docs/documents.toml"
FIELDS = ("file", "shape", "twin", "routed_by")
SHAPES = ("map", "living", "history", "ledger", "register", "queue", "proposal", "reference", "procedure",
          "census", "readout", "generated", "constitution", "fixture", "kept-run")
ROUTERS = ("map", "census")
LEAD_LINES = 12
SHAPE_LINE = re.compile(r"^\s*\**\s*Shape:\s*\**\s*([A-Za-z][A-Za-z-]*)")
NONE_REASON = re.compile(r"^none — \S")


def default_root():
    return str(Path(__file__).resolve().parents[3])


def universe(root):
    out = subprocess.run(["git", "-C", root, "ls-files", "--", "*.md"], capture_output=True, text=True)
    if out.returncode != 0:
        raise OSError(f"git ls-files failed in {root}: {out.stderr.strip()}")
    return sorted(out.stdout.split())


def names_path(text, path):
    return re.search(r"(?<![A-Za-z0-9_./-])" + re.escape(path) + r"(?![A-Za-z0-9_/-])", text) is not None


def check(root, register):
    data = toml_subset.load(os.path.join(root, register))
    pages = universe(root)
    errors, rows = [], {}
    for table, row in data.items():
        if not isinstance(row, dict) or sorted(row) != sorted(FIELDS) or not all(isinstance(row[f], str) for f in row):
            errors.append(f"ERROR: row-fields [{table}] fields={','.join(sorted(row)) if isinstance(row, dict) else '?'}")
            continue
        f = row["file"]
        if f in rows:
            errors.append(f"ERROR: duplicate-document {f} tables={rows[f]['table']},{table}")
            continue
        rows[f] = dict(row, table=table)
    for p in pages:
        if p not in rows:
            errors.append(f"ERROR: undeclared-document {p}")
    for f, row in rows.items():
        if f not in pages:
            errors.append(f"ERROR: dead-document-row [{row['table']}] {f}")
    texts = {}
    for f in rows:
        if f in pages:
            try:
                texts[f] = open(os.path.join(root, f), encoding="utf-8").read()
            except (OSError, UnicodeDecodeError):
                texts[f] = ""
    for f, row in rows.items():
        shape = row["shape"]
        if shape not in SHAPES:
            errors.append(f"ERROR: unknown-shape [{row['table']}] {f} shape={shape!r}")
        lead = texts.get(f, "").split("\n")[:LEAD_LINES]
        for n, line in enumerate(lead, 1):
            m = SHAPE_LINE.match(line)
            if m:
                word = m.group(1).lower()
                if word != shape:
                    errors.append(f"ERROR: shape-disagrees {f} row={shape} page={word} line={n} quote={line.strip()[:80]!r}")
                break
        twin = row["twin"]
        if shape in ("living", "history"):
            want = "history" if shape == "living" else "living"
            if NONE_REASON.match(twin):
                pass
            elif twin in rows and rows[twin]["shape"] == want and rows[twin]["twin"] == f:
                pass
            elif twin in rows:
                errors.append(f"ERROR: twin-not-back {f} twin={twin} its_shape={rows[twin]['shape']} its_twin={rows[twin]['twin']!r}")
            else:
                errors.append(f"ERROR: {shape}-without-twin {f} twin={twin!r}")
        elif twin:
            errors.append(f"ERROR: twin-on-shape {f} shape={shape} twin={twin!r}")
    roots = [f for f, row in rows.items() if row["routed_by"] == "root"]
    if len(roots) != 1 or rows[roots[0]]["shape"] != "map":
        errors.append(f"ERROR: root-count roots={','.join(roots) or 'none'}")
    for f, row in rows.items():
        r = row["routed_by"]
        if r == "root":
            continue
        router = rows.get(r)
        if router is None or router["shape"] not in ROUTERS or not names_path(texts.get(r, ""), f):
            why = "not a row" if router is None else (
                f"shape {router['shape']}" if router["shape"] not in ROUTERS else "does not name the path")
            errors.append(f"ERROR: unrouted-document {f} routed_by={r} ({why})")
    return errors, len(rows), len(pages), len({row['shape'] for row in rows.values()})


def main(argv=None):
    argv = list(sys.argv[1:] if argv is None else argv)
    root, register = default_root(), REGISTER
    if "--root" in argv:
        i = argv.index("--root"); root = argv[i + 1] if i + 1 < len(argv) else ""; del argv[i:i + 2]
    if "--register" in argv:
        i = argv.index("--register"); register = argv[i + 1] if i + 1 < len(argv) else ""; del argv[i:i + 2]
    if argv != ["--check"] or not root or not register:
        print("usage: python3 -m bbx.documents --check [--root DIR] [--register PATH]", file=sys.stderr)
        return 2
    try:
        errors, nrows, npages, nshapes = check(root, register)
    except (OSError, toml_subset.SubsetError) as e:
        print(f"documents={register} error=unreadable detail={e}")
        return 2
    for e in errors:
        print(e)
    print(f"documents={register} rows={nrows} pages={npages} shapes={nshapes} errors={len(errors)}")
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main())
