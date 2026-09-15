#!/usr/bin/env python3
"""rot.py — the rot register checked against the gates it names (BBX-10; R64).

    python3 -m bbx.rot --check [--root DIR] [--register PATH]

Reads, under the root (default: the tree this module sits in, D75), the register `docs/rot.toml` (or
--register, relative to the root) through the TOML subset, the tracked files (`git ls-files`), and each
named gate's header through the one header reader (bbx.controls, R30). The contract (R64, D87):

  classes        the seven ways a harness rots, BBX-10's list in its order: 1 orphan, 2 silent downgrade,
                 3 dead control, 4 stale reference, 5 outgrown parser, 6 deleted mechanism, 7 missing operand
  detector row   exactly `class`, `population`, `gate`, `control`: an integer class of the seven and three
                 non-empty strings; the gate a tracked file, the control one its header declares
  none row       exactly `class` and `none`: why the class has no detector, a non-empty string
  complete       every class has a detector row or one none row, never both and never two none rows; one
                 detector (class, gate, control) is named once

Findings, each `ERROR: <finding> <where>`:
  rot-row-fields, unknown-class, gate-not-found, rot-control-undeclared, duplicate-detector,
  none-beside-detector, duplicate-none, class-without-row
Two lines after the findings, the second parsed by field name:
    classes: <n> of 7 with a detector; none: <class> <name>[, <class> <name>]   (`none: -` when every class has one)
    rot=docs/rot.toml rows=<n> classes=7 detected=<n> none=<n> errors=<n>
A class counts as detected only through a detector row whose gate and control resolve. Exit 0 when
errors=0, 1 otherwise, 2 when the register or the tracked files cannot be read.
Written at bbx-31 (S6 step 4, K5; R64).
"""
import os
import subprocess
import sys
from pathlib import Path

from . import controls, toml_subset

REGISTER = "docs/rot.toml"
CLASSES = {1: "orphan", 2: "silent-downgrade", 3: "dead-control", 4: "stale-reference",
           5: "outgrown-parser", 6: "deleted-mechanism", 7: "missing-operand"}
DETECTOR_FIELDS = ("class", "control", "gate", "population")
NONE_FIELDS = ("class", "none")


def default_root():
    return str(Path(__file__).resolve().parents[3])


def tracked(root):
    out = subprocess.run(["git", "-C", root, "ls-files"], capture_output=True, text=True)
    if out.returncode != 0:
        raise OSError(f"git ls-files failed in {root}: {out.stderr.strip()}")
    return set(out.stdout.split("\n")) - {""}


def row_shape(row):
    """'detector', 'none', or None when the fields or their types are not one of the two forms."""
    if not isinstance(row, dict):
        return None
    cls = row.get("class")
    if not isinstance(cls, int) or isinstance(cls, bool):
        return None
    keys = tuple(sorted(row))
    if keys == DETECTOR_FIELDS and all(isinstance(row[k], str) and row[k].strip() for k in DETECTOR_FIELDS[1:]):
        return "detector"
    if keys == NONE_FIELDS and isinstance(row["none"], str) and row["none"].strip():
        return "none"
    return None


def check(root, register):
    data = toml_subset.load(os.path.join(root, register))
    files = tracked(root)
    errors = []
    detectors, resolved, nones, seen = {}, {}, {}, {}
    for table, row in data.items():
        shape = row_shape(row)
        if shape is None:
            fields = ",".join(sorted(row)) if isinstance(row, dict) else "?"
            errors.append(f"ERROR: rot-row-fields [{table}] fields={fields}")
            continue
        cls = row["class"]
        if cls not in CLASSES:
            errors.append(f"ERROR: unknown-class [{table}] class={cls}")
            continue
        if shape == "none":
            nones.setdefault(cls, []).append(table)
            continue
        gate, control = row["gate"], row["control"]
        key = (cls, gate, control)
        if key in seen:
            errors.append(f"ERROR: duplicate-detector [{table}] same=[{seen[key]}]")
            continue
        seen[key] = table
        detectors.setdefault(cls, []).append(table)
        if gate not in files or not os.path.isfile(os.path.join(root, gate)):
            errors.append(f"ERROR: gate-not-found [{table}] gate={gate}")
            continue
        names = [name for _, name, _ in controls.declared(os.path.join(root, gate))[0]]
        if control not in names:
            errors.append(f"ERROR: rot-control-undeclared [{table}] gate={gate} control={control}")
            continue
        resolved.setdefault(cls, []).append(table)
    for cls, name in CLASSES.items():
        d, n = detectors.get(cls, []), nones.get(cls, [])
        if len(n) > 1:
            errors.append(f"ERROR: duplicate-none class={cls} tables={','.join(n)}")
        if d and n:
            errors.append(f"ERROR: none-beside-detector class={cls} none=[{n[0]}] detectors={','.join(d)}")
        if not d and not n:
            errors.append(f"ERROR: class-without-row {cls} {name}")
    detected = [c for c in CLASSES if resolved.get(c)]
    without = [c for c in CLASSES if not resolved.get(c)]
    return errors, len(data), detected, without


def main(argv=None):
    argv = list(sys.argv[1:] if argv is None else argv)
    root, register = default_root(), REGISTER
    if "--root" in argv:
        i = argv.index("--root"); root = argv[i + 1] if i + 1 < len(argv) else ""; del argv[i:i + 2]
    if "--register" in argv:
        i = argv.index("--register"); register = argv[i + 1] if i + 1 < len(argv) else ""; del argv[i:i + 2]
    if argv != ["--check"] or not root or not register:
        print("usage: python3 -m bbx.rot --check [--root DIR] [--register PATH]", file=sys.stderr)
        return 2
    try:
        errors, nrows, detected, without = check(root, register)
    except (OSError, toml_subset.SubsetError) as e:
        print(f"rot={register} error=unreadable detail={e}")
        return 2
    for e in errors:
        print(e)
    none_txt = ", ".join(f"{c} {CLASSES[c]}" for c in without) or "-"
    print(f"classes: {len(detected)} of {len(CLASSES)} with a detector; none: {none_txt}")
    print(f"rot={register} rows={nrows} classes={len(CLASSES)} detected={len(detected)} none={len(without)} errors={len(errors)}")
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main())
