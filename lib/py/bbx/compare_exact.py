#!/usr/bin/env python3
"""compare_exact.py — the EXACT family over a point-indexed log: the truth log against the run log,
BY INDEX, the first differing index named (docs/plans/S3.md §3 "C1, C2", "C3"; abstraction C3, C4;
BBX-4; ruling R34: `exact` by index).

    python3 -m bbx.compare_exact <truth.log> <run.log>        one verdict line; exit 0 PASS, 1 otherwise

WHY BY INDEX AND NOT `cmp`. A byte offset names nothing a triage can open; an index is the claim
(the scenario file maps it to `(document, line, form)` — R31). And "the run ended before the truth
did" is a different finding from "index 12 differs" (BBX-4): a claim set that lost a document reads
SHORT, a wrong value reads DIVERGED, and lib/py/bbx/finding.py counts them apart in the kept run.

Verdicts (stdout, one line; the text is FROZEN by gates/set_schema.sh — C4 with no ancestor):
  PASS exact (<n> indices, every token the truth's)
  FAIL-SHORT exact: the run ends at index <m>, the truth at <n> (the observation ended before the comparison finished)
  FAIL exact: index <i> differs (truth <status>, run <status>; quoted <same|differs>, derived <same|differs>)
      — the detail only when both tokens split as document-set tokens (bbx.docset.split_token, the
      one splitter); any other token grammar gets `FAIL exact: index <i> differs`
  FAIL exact: index <i> is absent from the run (a gap, not an early end)
  FAIL exact: the run has index <j> the truth does not (<m> indices, truth <n>)
  FAIL exact: index <i> appears twice in the <truth|run>
  FAIL exact: the <truth|run> END <n> does not equal its <m> indices
  FAIL exact: the truth has no indices — nothing compared        (lineage bbh 14z-90, GitHub #54: two
                                                                  empty logs must not read PASS)
  NO-BASE-LOG <path>                                              (bbh check_diverge's line, the same finding)

The tokens are compared AS TOKENS, never interpreted (O1); the detail line re-splits them only to
say which half moved. The log grammar is bbh's, read through lib/py/bbx/logfmt.py (R31, F17).
"""
import os
import sys

from . import logfmt


def _index_map(path, side):
    """{index: token} plus the END count, or a FAIL sentence."""
    seen = {}
    for idx, tok in logfmt.frames(path):
        if idx in seen:
            return None, None, f"FAIL exact: index {idx} appears twice in the {side}"
        seen[idx] = tok
    ends = [l for l in logfmt.lines(path) if l.startswith("END ")]
    end = int(ends[-1].split()[1]) if ends else None
    if end is not None and end != len(seen):
        return None, None, f"FAIL exact: the {side} END {end} does not equal its {len(seen)} indices"
    return seen, end, None


def _split(tok):
    try:
        from . import docset
        return docset.split_token(tok)
    except Exception:
        return None


def compare(truth_path, run_path):
    """-> (verdict line, exit status)."""
    if not os.path.isfile(truth_path):
        return f"NO-BASE-LOG {truth_path}", 1
    truth, _tend, err = _index_map(truth_path, "truth")
    if err:
        return err, 1
    run, _rend, err = _index_map(run_path, "run")
    if err:
        return err, 1
    if not truth:
        return "FAIL exact: the truth has no indices — nothing compared", 1
    run_max = max(run) if run else 0
    for i in sorted(truth):
        if i not in run:
            if i > run_max:
                return (f"FAIL-SHORT exact: the run ends at index {run_max}, the truth at {max(truth)} "
                        "(the observation ended before the comparison finished)"), 1
            return f"FAIL exact: index {i} is absent from the run (a gap, not an early end)", 1
        if truth[i] != run[i]:
            t, r = _split(truth[i]), _split(run[i])
            if t and r:
                q = "same" if t["quoted"] == r["quoted"] else "differs"
                d = "same" if t["derived"] == r["derived"] else "differs"
                return (f"FAIL exact: index {i} differs (truth {t['status']}, run {r['status']}; "
                        f"quoted {q}, derived {d})"), 1
            return f"FAIL exact: index {i} differs", 1
    extra = sorted(j for j in run if j not in truth)
    if extra:
        return f"FAIL exact: the run has index {extra[0]} the truth does not ({len(run)} indices, truth {len(truth)})", 1
    return f"PASS exact ({len(truth)} indices, every token the truth's)", 0


def main(argv):
    if len(argv) != 2:
        print(__doc__.split("\n\n")[1], file=sys.stderr)
        return 2
    line, rc = compare(argv[0], argv[1])
    print(line)
    return rc


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
