"""expectations.py — the expectation KINDS table and the suite keys the sh libraries read, resolved
through the consumer config (ruled R23, 2026-09-10; abstraction E1).

    python3 -m bbx.expectations kinds           one `<ext>\\t<family>\\t<disposition>` line per kind
    python3 -m bbx.expectations family <ext>    the family of one kind, or `-` (exit 1) if unregistered
    python3 -m bbx.expectations mask-default    [suite].mask_default for the kind in force
    python3 -m bbx.expectations scenario-ext    [suite].scenario_ext for the kind in force (R32: rpl / claims)

THE ONE PLACE. A kind is registered in the kind profile's `[expectations].kinds` table
(`lib/py/bbx/config.py`) and nowhere else, so an unknown extension is REPORTED, never ignored
(bbh `[BBH-50]`, whose `enumerate_expectations.sh` held the table as a shell `case`). The
family and the VIEW are declared by the kind, never inside a spec line (R23): `masked` is the
temporal family over the checksum-log view, and its spec line is bbh's verbatim; a kind whose
family a profile does not carry is unregistered under that profile. The consumer is $BBX_CONFIG
(exported by every runner and lib/sh/config.sh); absent, the frame-driven profile applies (D9),
which carries bbh's five kinds so bbh's expectation trees read as they do in bbh (fidelity F16).
"""
import sys

from . import config as C


def table(cfg):
    return [(str(r[0]), str(r[1]), str(r[2])) for r in C.get(cfg, "expectations.kinds")]


def main(argv):
    if not argv:
        print(__doc__, file=sys.stderr)
        return 2
    cfg, _root = C.consumer()
    cmd = argv[0]
    if cmd == "kinds":
        for ext, fam, disp in table(cfg):
            print(f"{ext}\t{fam}\t{disp}")
        return 0
    if cmd == "family" and len(argv) == 2:
        for ext, fam, _disp in table(cfg):
            if ext == argv[1]:
                print(fam)
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
