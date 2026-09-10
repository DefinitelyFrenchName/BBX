"""finding.py — the FINDING behind a suite verdict line, so the kept run can count "the observation
ended before the comparison finished" apart from "the subject diverged" (abstraction C3, BBX-4).

    python3 -m bbx.finding "<the scenario's verdict text>"      prints one word

The suite's printed verdict lines are bbh's, frozen (C4; fidelity F12), and bbh folds FAIL-SHORT
into a FAIL line (`FAIL masked-flicker: got 'FAIL-SHORT …'`). Nothing printed changes; the kept
run's `results.tsv` carries this column instead, read by field name (BBX-12). The vocabulary is
closed; a line no rule names is `unclassified`, never silently one of the others.

    pass | skip | pending | no-expectation | nondeterministic | run-fail | frozen | authored |
    mask-mismatch | unknown-class | short | no-base-log | diverged | unclassified
"""
import sys

RULES = (
    ("PASS", "pass"), ("SKIP (", "skip"), ("PENDING", "pending"), ("NO-EXPECTATION", "no-expectation"),
    ("NONDETERMINISTIC", "nondeterministic"), ("RUN-FAIL", "run-fail"), ("GUARD TRIPPED", "run-fail"),
    ("frozen ", "frozen"), ("authored .masked", "authored"),
    ("FAIL mask mismatch", "mask-mismatch"), ("FAIL unknown .masked class", "unknown-class"), ("NO-BASE-LOG", "no-base-log"),
)


def finding(text):
    first = text.strip().split("\n", 1)[0].strip()
    for prefix, word in RULES:
        if first.startswith(prefix):
            return word
    if "FAIL-SHORT" in text:
        return "short"
    if first.startswith("FAIL"):
        return "diverged"
    return "unclassified"


if __name__ == "__main__":
    print(finding(sys.argv[1] if len(sys.argv) > 1 else ""))
