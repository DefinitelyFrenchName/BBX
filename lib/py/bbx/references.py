#!/usr/bin/env python3
"""references.py — the paths, `file:line` citations and ids in the pages that state what is true now resolve (BBX-10's
stale reference; R64, R67).

    python3 -m bbx.references --check [--root DIR] [--register PATH]

Reads, under the root (default: the tree this module sits in, D75), the documents register `docs/documents.toml` (or
--register, relative to the root) through the TOML subset, and every page whose shape there is one of SHAPES (R67).
The universe is the tracked files and their directories (`git ls-files`), never the working tree, whose ignored files
differ by host (G95). The contract (R64, R67, D89):

  a path claim   a backticked token with a directory part whose first segment is a top-level entry of the tree, or
                 which starts with one of LINEAGE_PREFIXES: it resolves to a tracked file or to a directory of one, or
                 it carries the lineage prefix; any other such token is counted as not a path claim, never a finding
  skipped        a token holding one of SKIP_CHARS or starting with one of SKIP_STARTS: a pattern, a URL, a host path
  a file:line    `path:N` or `path:N-M` naming a tracked file ends at or before the file's last line
  an id          G<n> is a `## G<n> ` heading of docs/gotchas.md, X<n> a row of docs/retractions.tsv, R<n> a
                 `### R<n> ` heading of docs/rulings.md

Findings, each `ERROR: <finding> <where>`: dead-path, line-past-end, undefined-id, page-not-found, no-pages
Summary line, parsed by field name:
    references=docs/documents.toml pages=<n> tokens=<n> resolve=<n> lineage=<n> not_a_path_claim=<n> file_lines=<n> ids=<n> errors=<n>
Exit 0 when errors=0, 1 otherwise, 2 when the register, an id source or the tracked files cannot be read.
Written at bbx-31 (S6 step 4, K6; R64, R67).
"""
import os
import re
import subprocess
import sys
from pathlib import Path

from . import toml_subset

REGISTER = "docs/documents.toml"
SHAPES = ("constitution", "living", "map", "procedure", "reference", "register")
# the lineage's own paths, as BBX's pages quote them: bbh's and VampireSaved's trees and consumer layouts (bbx-28's
# list, docs/plans/S6_probes/probe_bbx_refined.py), and bbh's example index `docs/gate_index.md` (D84's default)
LINEAGE_PREFIXES = ("lib/py/bbh/", "tools/", "tests/", "selftest/", "example/", "docs/project/", ".claude/", "lua/",
                    "roms/", "build/", "skill/blackbox-harness", "docs/game/", "bin/bbh", "drivers/fake.sh",
                    "drivers/mame.sh", "lib/sh/masked", "lib/sh/enumerate", "docs/config.md", "docs/conventions.md",
                    "docs/doc_shape.tsv", "docs/hygiene.md", "docs/gate_contract.md", "docs/doctrine.md",
                    "docs/gate_index.md")
PATH = re.compile(r"`((?:[A-Za-z0-9_.\-]+/)+[A-Za-z0-9_.\-]+)(?::(\d+)(?:[-–](\d+))?)?`")
SKIP_CHARS = "<>*{}$~"
SKIP_STARTS = ("http", "/", "github.com")
ID = re.compile(r"(?<![A-Za-z0-9_\-])([GXR])(\d{1,3})(?![A-Za-z0-9_])")
ID_SOURCES = {"G": ("docs/gotchas.md", r"^## G(\d+) "), "X": ("docs/retractions.tsv", r"^X(\d+)\t"),
              "R": ("docs/rulings.md", r"^### R(\d+) ")}
COUNTS = ("tokens", "resolve", "lineage", "not_a_path_claim", "file_lines", "ids")


def default_root():
    return str(Path(__file__).resolve().parents[3])


def universe(root):
    out = subprocess.run(["git", "-C", root, "ls-files"], capture_output=True, text=True)
    if out.returncode != 0:
        raise OSError(f"git ls-files failed in {root}: {out.stderr.strip()}")
    files = set(out.stdout.split("\n")) - {""}
    dirs = {"/".join(f.split("/")[:i]) for f in files for i in range(1, f.count("/") + 1)}
    return files, dirs, {f.split("/", 1)[0] for f in files}


def defined_ids(root):
    out = {}
    for kind, (path, pattern) in ID_SOURCES.items():
        with open(os.path.join(root, path), encoding="utf-8") as f:
            out[kind] = {int(x) for x in re.findall(pattern, f.read(), re.M)}
    return out


def line_count(path):
    with open(path, encoding="utf-8", errors="replace") as f:
        return sum(1 for _ in f)


def check(root, register):
    data = toml_subset.load(os.path.join(root, register))
    files, dirs, top = universe(root)
    ids = defined_ids(root)
    pages = sorted(row["file"] for row in data.values()
                   if isinstance(row, dict) and row.get("shape") in SHAPES and isinstance(row.get("file"), str))
    errors, n, lengths = [], dict.fromkeys(COUNTS, 0), {}
    if not pages:
        errors.append(f"ERROR: no-pages {register} shapes={','.join(SHAPES)}")
    for page in pages:
        if page not in files:
            errors.append(f"ERROR: page-not-found {page}")
            continue
        with open(os.path.join(root, page), encoding="utf-8", errors="replace") as f:
            lines = f.read().split("\n")
        for ln, line in enumerate(lines, 1):
            for m in PATH.finditer(line):
                p = m.group(1).rstrip(".")
                if any(c in p for c in SKIP_CHARS) or p.startswith(SKIP_STARTS):
                    continue
                n["tokens"] += 1
                if p.split("/", 1)[0] not in top and not p.startswith(LINEAGE_PREFIXES):
                    n["not_a_path_claim"] += 1
                elif p in files or p in dirs:
                    n["resolve"] += 1
                    if m.group(2) and p in files:
                        n["file_lines"] += 1
                        if p not in lengths:
                            lengths[p] = line_count(os.path.join(root, p))
                        if int(m.group(3) or m.group(2)) > lengths[p]:
                            errors.append(f"ERROR: line-past-end {page}:{ln} {m.group(0).strip('`')} lines={lengths[p]}")
                elif p.startswith(LINEAGE_PREFIXES):
                    n["lineage"] += 1
                else:
                    errors.append(f"ERROR: dead-path {page}:{ln} {p}")
            for kind, num in ID.findall(line):
                n["ids"] += 1
                if int(num) not in ids[kind]:
                    errors.append(f"ERROR: undefined-id {page}:{ln} {kind}{num}")
    return errors, len(pages), n


def main(argv=None):
    argv = list(sys.argv[1:] if argv is None else argv)
    root, register = default_root(), REGISTER
    if "--root" in argv:
        i = argv.index("--root"); root = argv[i + 1] if i + 1 < len(argv) else ""; del argv[i:i + 2]
    if "--register" in argv:
        i = argv.index("--register"); register = argv[i + 1] if i + 1 < len(argv) else ""; del argv[i:i + 2]
    if argv != ["--check"] or not root or not register:
        print("usage: python3 -m bbx.references --check [--root DIR] [--register PATH]", file=sys.stderr)
        return 2
    try:
        errors, npages, n = check(root, register)
    except (OSError, toml_subset.SubsetError) as e:
        print(f"references={register} error=unreadable detail={e}")
        return 2
    for e in errors:
        print(e)
    print(f"references={register} pages={npages} " + " ".join(f"{k}={n[k]}" for k in COUNTS) + f" errors={len(errors)}")
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main())
