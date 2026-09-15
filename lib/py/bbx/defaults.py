#!/usr/bin/env python3
"""defaults.py — the defaults register checked in R61's form, both ways against the code, and every default's reader (R66).

    python3 -m bbx.defaults --check [--root DIR] [--register PATH]

Reads, under the root (default: the tree this module sits in, D75):
  the register     `docs/defaults.md` (or --register, relative to the root)
  the defaults     the kind-blind `DEFAULTS` of `lib/py/bbx/config.py`, read as a SYNTAX TREE and never
                   imported, so a perturbed copy under TMPDIR is read as itself
  the fallbacks    every `${BBX_<NAME>:-` under bin, lib, drivers and gates
  the readers      every `<section>.<key>` token under bin, lib and drivers — markdown files, lines whose
                   first non-blank character is `#`, and the lines of config.py's DEFAULTS and KINDS
                   literals do not count — plus the keys of the RUNTIME_READERS below

The form (R61, D81): one table header; no line between the first row and the last that is not a table
line; ids D1..DN in order; six cells per row, a pipe inside a cell written `\\|`; the class cell
`<class>[ (<qualifier>)]`, parts joined by ` / `, each class `principled`, `reference-calibrated` or
`arbitrary`. Both ways against the code: every DEFAULTS key named as `[section].key` in the default
cell (the second) of exactly one row, and every such token naming a DEFAULTS key; every fallback named
in a row, and every `BBX_<NAME>` a row names present in the code. R66's third direction: every DEFAULTS
key has a reader naming it in full, or is in a declared run-time reader's key list; a short name never
counts.

Findings, each `ERROR: <finding> <where>`:
  table-headers, table-cut, ids-out-of-order, cells, no-class, class-outside-vocabulary,
  key-without-row, key-in-several-rows, row-without-key, fallback-without-row, name-without-code,
  key-without-reader, runtime-reader-gone, runtime-reader-unknown-key
Summary line, parsed by field name:
    defaults=docs/defaults.md rows=<n> keys=<n> fallbacks=<n> read=<n> errors=<n>
Exit 0 when errors=0, 1 otherwise, 2 when a file is unreadable or the usage is wrong.
Written at bbx-29 (S6 step 2, K3; R61, R66).
"""
import ast
import os
import re
import sys
from pathlib import Path

REGISTER = "docs/defaults.md"
CONFIG = "lib/py/bbx/config.py"
READER_DIRS = ("bin", "lib", "drivers")
FALLBACK_DIRS = ("bin", "lib", "drivers", "gates")

# A reader that builds a key's name at run time is invisible to a search for the name, so it is
# DECLARED here: (file, the name of the tuple of keys it iterates, the section, the builder text the
# file must still hold). The tuple is read from the file itself, so the list cannot drift from the
# code; a file, tuple or builder that is gone is `runtime-reader-gone` (D81, measured bbx-29).
RUNTIME_READERS = (
    ("lib/py/bbx/fingerprint.py", "_KEYS", "fingerprint", '"fingerprint." + k'),
)

CLASS = r"(?:principled|reference-calibrated|arbitrary)"
QUALIFIER = r"(?: \((?:[^()]|\([^()]*\))*\))?"
PART = CLASS + QUALIFIER
CLASS_CELL = re.compile(r"^" + PART + r"(?: / " + PART + r")*$")
HEADER = re.compile(r"^\| id \|")
ROW = re.compile(r"^\| D(\d+) \|")
CELL_SPLIT = re.compile(r"(?<!\\)\|")
KEY_TOKEN = re.compile(r"\[([a-z_]+)\]\.([a-z_]+)")
READ_TOKEN = re.compile(r"(?<![A-Za-z0-9_.])([a-z_]+)\.([a-z_]+)(?![A-Za-z0-9_])")
FALLBACK = re.compile(r"\$\{(BBX_[A-Z0-9_]+):-")
NAME = re.compile(r"(?<![A-Za-z0-9_])(BBX_[A-Z0-9_]+)(?![A-Za-z0-9_])")


def default_root():
    return str(Path(__file__).resolve().parents[3])


def literal_assigns(tree, names):
    """{name: (value, first_line, last_line)} for module-level assignments of literals."""
    out = {}
    for node in tree.body:
        if isinstance(node, ast.Assign):
            for t in node.targets:
                if isinstance(t, ast.Name) and t.id in names:
                    out[t.id] = (ast.literal_eval(node.value), node.lineno, node.end_lineno)
    return out


def code_files(root, dirs):
    for d in dirs:
        base = os.path.join(root, d)
        for dirpath, dirnames, filenames in os.walk(base):
            dirnames[:] = sorted(x for x in dirnames if x != "__pycache__")
            for name in sorted(filenames):
                if name.endswith((".md", ".pyc")):
                    continue
                path = os.path.join(dirpath, name)
                try:
                    with open(path, encoding="utf-8") as f:
                        yield os.path.relpath(path, root), f.read().split("\n")
                except (UnicodeDecodeError, OSError):
                    continue


def read_register(lines):
    errors, rows = [], []
    headers = [n for n, l in enumerate(lines, 1) if HEADER.match(l)]
    if len(headers) != 1:
        errors.append(f"ERROR: table-headers count={len(headers)}")
    numbered = [(n, l) for n, l in enumerate(lines, 1) if ROW.match(l)]
    if numbered:
        first, last = numbered[0][0], numbered[-1][0]
        for n in range(first, last + 1):
            if not lines[n - 1].startswith("|"):
                errors.append(f"ERROR: table-cut line={n}")
    ids = [int(ROW.match(l).group(1)) for _, l in numbered]
    if ids != list(range(1, len(ids) + 1)):
        where = [f"D{b}" for a, b in zip([0] + ids, ids) if b != a + 1]
        errors.append(f"ERROR: ids-out-of-order at={','.join(where)}")
    for n, l in numbered:
        rid = "D" + ROW.match(l).group(1)
        cells = [c.strip() for c in CELL_SPLIT.split(l)[1:-1]]
        if len(cells) != 6:
            errors.append(f"ERROR: cells {rid} count={len(cells)} line={n}")
            continue
        if not cells[4]:
            errors.append(f"ERROR: no-class {rid} line={n}")
        elif not CLASS_CELL.match(cells[4]):
            errors.append(f"ERROR: class-outside-vocabulary {rid} class={cells[4][:60]!r} line={n}")
        rows.append((rid, n, cells, l))
    return rows, errors


def check(root, register):
    reg_text = open(os.path.join(root, register), encoding="utf-8").read()
    cfg_text = open(os.path.join(root, CONFIG), encoding="utf-8").read()
    lits = literal_assigns(ast.parse(cfg_text), ("DEFAULTS", "KINDS"))
    defaults = lits["DEFAULTS"][0]
    literal_lines = [(a, b) for _, a, b in lits.values()]
    keys = {(s, k) for s, t in defaults.items() for k in t}
    rows, errors = read_register(reg_text.split("\n"))

    # both ways: the default cell and DEFAULTS
    named = {}
    for rid, n, cells, _ in rows:
        for s, k in set(KEY_TOKEN.findall(cells[1])):
            named.setdefault((s, k), []).append(rid)
            if (s, k) not in keys:
                errors.append(f"ERROR: row-without-key {rid} [{s}].{k} line={n}")
    for s, k in sorted(keys):
        where = named.get((s, k), [])
        if not where:
            errors.append(f"ERROR: key-without-row [{s}].{k}")
        elif len(where) > 1:
            errors.append(f"ERROR: key-in-several-rows [{s}].{k} rows={','.join(where)}")

    # both ways: the fallbacks and the names rows carry
    fallbacks, code_names = set(), set()
    for rel, lines in code_files(root, FALLBACK_DIRS):
        for line in lines:
            fallbacks.update(FALLBACK.findall(line))
            code_names.update(NAME.findall(line))
    body = "\n".join(l for _, _, _, l in rows)
    for name in sorted(fallbacks):
        if not re.search(r"(?<![A-Za-z0-9_])" + re.escape(name) + r"(?![A-Za-z0-9_])", body):
            errors.append(f"ERROR: fallback-without-row {name}")
    for rid, n, _, l in rows:
        for name in sorted(set(NAME.findall(l))):
            if name not in code_names:
                errors.append(f"ERROR: name-without-code {rid} {name} line={n}")

    # R66: every default's reader
    read = set()
    for rel, lines in code_files(root, READER_DIRS):
        for i, line in enumerate(lines, 1):
            if line.lstrip().startswith("#"):
                continue
            if rel == CONFIG and any(a <= i <= b for a, b in literal_lines):
                continue
            for s, k in READ_TOKEN.findall(line):
                if (s, k) in keys:
                    read.add((s, k))
    for rel, tuple_name, section, builder in RUNTIME_READERS:
        path = os.path.join(root, rel)
        try:
            text = open(path, encoding="utf-8").read()
            found = literal_assigns(ast.parse(text), (tuple_name,))
        except (OSError, SyntaxError, ValueError):
            found, text = {}, ""
        # the builder ends at a word boundary: as a bare substring, `"fingerprint." + k` was still found in
        # `"fingerprint." + key`, and a rewritten builder read as live (the gate's control, bbx-29)
        pattern = re.compile(re.escape(builder) + r"(?![A-Za-z0-9_])")
        live = [l for l in text.split("\n") if pattern.search(l) and not l.lstrip().startswith("#")]
        if tuple_name not in found or not live:
            errors.append(f"ERROR: runtime-reader-gone {rel} {tuple_name} builder={builder!r}")
            continue
        for k in found[tuple_name][0]:
            if (section, k) in keys:
                read.add((section, k))
            else:
                errors.append(f"ERROR: runtime-reader-unknown-key {rel} {tuple_name} [{section}].{k}")
    for s, k in sorted(keys - read):
        errors.append(f"ERROR: key-without-reader [{s}].{k}")
    return errors, len(rows), len(keys), len(fallbacks), len(keys & read)


def main(argv=None):
    argv = list(sys.argv[1:] if argv is None else argv)
    root, register = default_root(), REGISTER
    if "--root" in argv:
        i = argv.index("--root"); root = argv[i + 1] if i + 1 < len(argv) else ""; del argv[i:i + 2]
    if "--register" in argv:
        i = argv.index("--register"); register = argv[i + 1] if i + 1 < len(argv) else ""; del argv[i:i + 2]
    if argv != ["--check"] or not root or not register:
        print("usage: python3 -m bbx.defaults --check [--root DIR] [--register PATH]", file=sys.stderr)
        return 2
    try:
        errors, nrows, nkeys, nfall, nread = check(root, register)
    except (OSError, SyntaxError, ValueError, KeyError) as e:
        print(f"defaults={register} error=unreadable detail={e}")
        return 2
    for e in errors:
        print(e)
    print(f"defaults={register} rows={nrows} keys={nkeys} fallbacks={nfall} read={nread} errors={len(errors)}")
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main())
