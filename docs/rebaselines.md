# Re-baselines — one dated line per verdict-text or classifier change that moved a fidelity row

Shape: append-only log. Newest line first; the newest line is printed at the
head of every fidelity run (`[BBH-83]`). Born 2026-09-09 with no entries. A re-baseline is a PROCEDURE under R8/R20, not a ruling
(the maintainer, R28's answer, 2026-09-10): the line here, D20, D12 by definition, the census.

- 2026-09-10 (bbx-5, R28): bbh `f675710` → `10a82d2` — bbh's commit "config: the M18 re-point that sat dirty since 14z-144; the example lib's root one level too high; the extraction counts dated" (7 files; G11 fixed there; the four dirty files of R8 committed). Measured before the move by the D20 override: F12, F13, F14, F14f, F16, F17 identical on a clone of `10a82d2`. Moved with it: D20; D12's five `[sweep].placeholders` (by definition); the census `docs/census/bbh.md` (A2 19 → 20). No verdict text changed on either side.
