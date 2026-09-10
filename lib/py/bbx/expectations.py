"""expectations.py — the expectation KINDS table and the suite keys the sh libraries read, resolved
through the consumer config (ruled R23, 2026-09-10; abstraction E1).

    python3 -m bbx.expectations kinds           one `<ext>\\t<family>\\t<disposition>\\t<view>` line per kind
    python3 -m bbx.expectations family <ext>    the family of one kind, or `-` (exit 1) if unregistered
    python3 -m bbx.expectations view <ext>      the view of one kind (D57), or `-` (exit 1) if unregistered
    python3 -m bbx.expectations mask-default    [suite].mask_default for the kind in force
    python3 -m bbx.expectations scenario-ext    [suite].scenario_ext for the kind in force (R32: rpl / claims)

THE ONE PLACE. A kind is registered in the kind profile's `[expectations].kinds` table
(`lib/py/bbx/config.py`) and nowhere else, so an unknown extension is REPORTED, never ignored
(bbh `[BBH-50]`, whose `enumerate_expectations.sh` held the table as a shell `case`). The
family and the VIEW are declared by the kind, never inside a spec line (R23): `masked` is the
temporal family over the checksum-log view, and its spec line is bbh's verbatim; a kind whose
view column (the fourth, D57 — `log`, `subject`, `json`, `bands` or `-`) says what the kinds
loop hands the family as its artifact, resolved in one place (bin/bbx-run-suite view_path); a row
without its four fields is refused here, so a table of the old shape fails the suite at the
entrance, never silently reads as "no view". A kind whose
family a profile does not carry is unregistered under that profile. The consumer is $BBX_CONFIG
(exported by every runner and lib/sh/config.sh); absent, the frame-driven profile applies (D9),
which carries bbh's five kinds so bbh's expectation trees read as they do in bbh (fidelity F16).
"""
import sys

from . import config as C


def table(cfg):
    rows = []
    for r in C.get(cfg, "expectations.kinds"):
        if len(r) != 4:
            raise ValueError(f"kinds row {r!r} has {len(r)} fields, not 4 (extension, family, disposition, view — D57)")
        rows.append((str(r[0]), str(r[1]), str(r[2]), str(r[3])))
    return rows


def main(argv):
    if not argv:
        print(__doc__, file=sys.stderr)
        return 2
    cfg, _root = C.consumer()
    cmd = argv[0]
    try:
        rows = table(cfg)
    except ValueError as e:      # a table of the wrong shape: one line, exit 1 — the suite's entrance names the reader (never a traceback)
        print(f"bbx expectations: {e}", file=sys.stderr)
        return 1
    if cmd == "kinds":
        for ext, fam, disp, view in rows:
            print(f"{ext}\t{fam}\t{disp}\t{view}")
        return 0
    if cmd == "family" and len(argv) == 2:
        for ext, fam, _disp, _view in rows:
            if ext == argv[1]:
                print(fam)
                return 0
        print("-")
        return 1
    if cmd == "view" and len(argv) == 2:
        for ext, _fam, _disp, view in rows:
            if ext == argv[1]:
                print(view)
                return 0
        print("-")
        return 1
    if cmd == "mask-default":
        print(C.get(cfg, "suite.mask_default"))
        return 0
    if cmd == "scenario-ext":
        print(C.get(cfg, "suite.scenario_ext"))
        return 0
    print(f"bbx expectations: unknown command {argv!r}", file=sys.stderr)
    return 2


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
