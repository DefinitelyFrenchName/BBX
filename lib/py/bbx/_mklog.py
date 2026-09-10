"""_mklog.py — synthetic point-indexed logs for the temporal gates and the F17 fidelity rows.

    python3 -m bbx._mklog <path> <n> [<divergent>]

Writes frames 1..n as `<i> <hash>` then `END <n>`; `<divergent>` is a comma-separated list of
frame numbers and `lo-hi` ranges (inclusive) whose hash differs. Same shape as bbh's selftest
generators (test_compare_flicker.sh mklog, test_compare_window.sh mk, test_compare_composite.sh
write), so F17 feeds both implementations one file. A fixture, never evidence about a subject.
"""
import sys


def divergent(spec):
    out = set()
    if not spec:
        return out
    for part in spec.split(","):
        if "-" in part:
            lo, hi = part.split("-")
            out.update(range(int(lo), int(hi) + 1))
        else:
            out.add(int(part))
    return out


def main(argv):
    path, n = argv[0], int(argv[1])
    d = divergent(argv[2] if len(argv) > 2 else "")
    with open(path, "w") as f:
        for i in range(1, n + 1):
            f.write(f"{i} {'ffffffffffffffff' if i in d else '%016x' % i}\n")
        f.write(f"END {n}\n")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
