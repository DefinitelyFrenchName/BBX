"""thresholds.py — THE comparison-class thresholds, declared ONCE, and the one place a
loosened value is REFUSED without a ruling (R25).

Three numbers govern every non-exact temporal class (bbh lib/py/bbh/thresholds.py at
f675710, whose wording this keeps):

    FLICKER_MAX   a divergent run this short or shorter is a FLICKER frame
    RECONVERGE    identical frames required after the last divergence (the non-propagation
                  proof; it governs the re-convergence TAIL and does not bind across the gap
                  between two separately attributed mechanisms)
    MAX_TOTAL     the cap on a flicker INVENTORY (never on a window run)

Lineage: VampireSaved's tools/s4_thresholds.py (14z-93, GitHub #44 there), where the pair
had been declared FOUR times with a comment saying they "must stay in step" and nothing
asserting it — and the tool whose purpose was "propose a line that drops in verbatim" could
propose one the checker rejected. The values are a consumer's RATIFIED comparison policy,
not a tuning knob.

WHAT BBX ADDS (S2 step 1, bbx-3, 2026-09-10). The values live in the KIND PROFILE
(`config.py` KINDS[kind]["thresholds"]): the frame-driven profile carries bbh's 2 / 60 / 8
(docs/defaults.md D23) and a kind with no temporal family carries none — a temporal
comparator run under such a kind is REFUSED, not defaulted. A consumer may set any key in
its `[thresholds]`; a value LOOSER than its profile's — LARGER `flicker_max` or
`flicker_max_total`, SMALLER `reconverge` (D24) — is accepted only when
`[thresholds].rulings` names a ruling for that key (`rulings = { flicker_max = "R31" }`),
else every importer (the enforcers, the proposer, the suite) prints ONE line and exits 3:

    REFUSED: [thresholds].<key> = <v> is looser than the <kind> profile's <p> and
    [thresholds].rulings names no ruling for it (BBX-13, R25)

Tighter needs nothing. Ruled R25 (2026-09-10): "a class may be tightened freely but
loosened only with a measured mechanism named and a maintainer ruling" (CLAUDE.md BBX-13).
Not asserted here: that the ruling id names a real ruling — that is the consumer's
rulings-shape gate's question.

Resolution: the environment's BBX_CONFIG (exported by every runner and by lib/sh/config.sh)
names the consumer config; absent, the frame-driven profile applies (D9).
"""
import os
import sys

from . import config as C

KEYS = ("flicker_max", "reconverge", "flicker_max_total")
LOOSER_WHEN = {"flicker_max": "larger", "reconverge": "smaller", "flicker_max_total": "larger"}   # D24


def _refuse(msg):
    print("REFUSED: " + msg)
    sys.exit(3)


def resolve(path=None):
    """The three values in force for the consumer config at `path` (default $BBX_CONFIG),
    or a REFUSED exit. Returns (values, kind)."""
    path = path or os.environ.get("BBX_CONFIG")
    cfg = C.load(path) if path and os.path.isfile(path) else {}
    kind = C.kind_of(cfg)
    prof = C.KINDS[kind].get("thresholds")
    if prof is None:
        _refuse(f"kind '{kind}' declares no [thresholds]: it has no temporal comparison family, so a temporal comparator cannot run under it")
    vals = dict(prof)
    own = cfg.get("thresholds", {})
    rulings = own.get("rulings", {})
    if not isinstance(rulings, dict):
        _refuse("[thresholds].rulings must be an inline table { <key> = \"R<n>\" }")
    for k in KEYS:
        if k not in own:
            continue
        v, p = int(own[k]), int(prof[k])
        looser = v > p if LOOSER_WHEN[k] == "larger" else v < p
        if looser and not str(rulings.get(k, "")).strip():
            _refuse(f"[thresholds].{k} = {v} is looser than the {kind} profile's {p} and [thresholds].rulings names no ruling for it (BBX-13, R25)")
        vals[k] = v
    return vals, kind


_V, KIND = resolve()
FLICKER_MAX = _V["flicker_max"]
RECONVERGE = _V["reconverge"]
MAX_TOTAL = _V["flicker_max_total"]


if __name__ == "__main__":
    print(f"kind={KIND} flicker_max={FLICKER_MAX} reconverge={RECONVERGE} flicker_max_total={MAX_TOTAL}")
