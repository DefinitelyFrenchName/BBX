"""provenance.py — EVERY FROZEN EXPECTATION FILE SAYS WHERE ITS NUMBERS CAME FROM (abstraction E3;
ruled R11 for the vocabulary, R24 for the format).

    python3 -m bbx.provenance [--config bbx.toml] [--root DIR] [--register FILE]     (default: <expected_dir>/PROVENANCE.toml)
    python3 -m bbx.provenance ... --histogram <set>        one `class=<c> count=<n>` line per class in that set

Lifted in purpose from bbh lib/py/bbh/provenance.py at f675710 (lineage: VampireSaved 14z-128 —
"A RED GATE IS A QUESTION, and its first question is which side rests on a measurement"; measured
there: 15 of 45 frozen expectation files declared their provenance nowhere a triage would look).
The FILE is what a triage opens, so the register sits beside the files.

WHAT BBX CHANGES. bbh's register is a markdown table matched by SUBSTRING against a consumer list
of classes — the mechanism by which VampireSaved's 6 classes became 13 strings. Here:
  * the vocabulary is CLOSED and ranked (R11): reference > corroborator > self > derived >
    hash-lock > registry > fixture > testimony; a row's `class` must EQUAL one of the eight;
  * the register is TOML (R24, the maintainer's objection to a spacer-separated file): one bare
    table per row, the FILE A VALUE, every field NAMED — `file`, `describes`, `class`, `refreeze`,
    `notes` (optional) — read by the subset parser BBX trusts for every config, which refuses a
    table declared twice; this tool refuses a `file` named twice (a duplicate is hand-editing,
    BBX-17), a missing field by name, and a class outside the eight;
  * the scope is the whole expectation tree ([suite].expected_dir), every regular file under it
    named by its path from that root, except the basenames in [provenance].exclude (D31);
    complete BOTH WAYS: a file with no row and a row naming a file that is gone both FAIL;
  * `testimony` never reads green (BBX-3: a filed count is not evidence) and `fixture` is counted
    as not evidence about a real subject — both reported by `--histogram`, which the readout
    prints as "expectations relied upon".
Not asserted here: that a row's `class` is TRUE of its file — the register is written by hand
at the freeze; this tool keeps it complete and inside the vocabulary. Exit 1 on any FAIL, 2
when the register or the tree is unreadable.
"""
import argparse
import os
import sys

from . import config as C
from . import toml_subset

CLASSES = ("reference", "corroborator", "self", "derived", "hash-lock", "registry", "fixture", "testimony")   # R11, ranked
FIELDS = ("file", "describes", "class", "refreeze")


def files_of(exp_root, exclude):
    out = set()
    for dirpath, dirnames, filenames in os.walk(exp_root):
        dirnames[:] = sorted(d for d in dirnames if not d.startswith("."))
        for f in sorted(filenames):
            if f.startswith(".") or f in exclude:
                continue
            out.add(os.path.relpath(os.path.join(dirpath, f), exp_root))
    return out


def read_register(path):
    """[(table, row-dict)] in file order; raises SubsetError/OSError; refuses a missing field, a bad class, a duplicate file."""
    data = toml_subset.load(path)
    rows, seen, errs = [], {}, []
    for tab, row in data.items():
        if not isinstance(row, dict):
            errs.append(f"[{tab}] is not a table of named fields"); continue
        missing = [k for k in FIELDS if k not in row or str(row[k]).strip() == ""]
        if missing:
            errs.append(f"[{tab}] lacks {', '.join(missing)}"); continue
        f = str(row["file"]); c = str(row["class"])
        if c not in CLASSES:
            errs.append(f"[{tab}] {f}: class '{c}' is not one of the eight (R11): {', '.join(CLASSES)}")
        if f in seen:
            errs.append(f"[{tab}] names {f} a second time (first in [{seen[f]}]) — a duplicate row is hand-editing (BBX-17)")
        seen.setdefault(f, tab)
        rows.append((tab, row))
    return rows, errs


def histogram(rows, setname):
    counts = {}
    prefix = setname.rstrip("/") + "/"
    for _tab, row in rows:
        if str(row["file"]).startswith(prefix):
            c = str(row["class"]); counts[c] = counts.get(c, 0) + 1
    return counts


def main(argv=None):
    ap = argparse.ArgumentParser()
    ap.add_argument("--config", default=None)
    ap.add_argument("--root", default=None)
    ap.add_argument("--register", default=None, help="the register (default [provenance].register under the root)")
    ap.add_argument("--histogram", default=None, metavar="SET", help="print the classes of one set's rows and exit")
    a = ap.parse_args(argv)
    cfg, root = C.consumer(a.config, a.root)
    exp_root = os.path.join(root, C.get(cfg, "suite.expected_dir"))
    reg = a.register or os.path.join(exp_root, C.get(cfg, "provenance.register"))   # D31: a name INSIDE the expectation tree
    exclude = set(C.get(cfg, "provenance.exclude")) | {os.path.basename(reg)}   # the register never needs a row for itself
    rel_reg = os.path.relpath(reg, root)
    if not os.path.isfile(reg):
        print(f"FAIL: {rel_reg} is missing")
        return 1
    try:
        rows, errs = read_register(reg)
    except toml_subset.SubsetError as e:
        print(f"FAIL: {rel_reg} is not a register the subset reads: {e}")
        return 2
    if a.histogram is not None:
        h = histogram(rows, a.histogram)
        for c in CLASSES:
            if c in h:
                print(f"class={c} count={h[c]}")
        if not h:
            print("class=none count=0")
        return 0
    rc = 0
    print("== 1. every expectation file has a row, every row an existing file")
    if not os.path.isdir(exp_root):
        print(f"  FAIL: the expectation tree {os.path.relpath(exp_root, root)} is not a directory"); return 1
    files = files_of(exp_root, exclude)
    named = [str(r["file"]) for _t, r in rows]
    missing = sorted(files - set(named)); dead = sorted(f for f in named if f not in files)
    if missing:
        rc = 1
        print(f"  FAIL: {len(missing)} expectation file(s) with NO provenance row:")
        for m in missing:
            print(f"      {m}")
        print(f"      Add a row to {rel_reg} saying what the")
        print("      numbers describe, which class of the eight they rest on, and how to")
        print("      re-freeze them. If you cannot say, that is the finding.")
    if dead:
        rc = 1
        print(f"  FAIL: {len(dead)} provenance row(s) naming a file that is gone:")
        for d in dead:
            print(f"      {d}")
    if not missing and not dead:
        print(f"  ok: {len(files)} expectation files, {len(rows)} rows, complete both ways")
    print("== 2. every row names every field, one class of the eight, and no file twice (R11, R24)")
    if errs:
        rc = 1
        print(f"  FAIL: {len(errs)} row(s) refused:")
        for e in errs:
            print(f"      {e}")
    else:
        print("  ok: every row complete, every class one of the eight, no file named twice")
    print("== 3. what the classes say about this tree")
    h = {}
    for _t, r in rows:
        c = str(r["class"]); h[c] = h.get(c, 0) + 1
    print("  " + ", ".join(f"{c} {h[c]}" for c in CLASSES if c in h) if h else "  (no rows)")
    if h.get("testimony"):
        print(f"  NOTE: testimony rows={h['testimony']} — a filed count never reads green (BBX-3); these files are not evidence")
    if h.get("fixture"):
        print(f"  NOTE: fixture rows={h['fixture']} — synthesized with known truth; evidence about no real subject")
    return rc


if __name__ == "__main__":
    sys.exit(main())
