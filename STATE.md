# STATE — what is true now

Shape: living page, lean. Its history twin is `STATE_HISTORY.md` (created
when this page first rolls over). Read `HANDOFF.md` first.

**Project:** BLACKBOX (working name, ruling R0 open), prefix `BBX`. The
generalization of `blackbox-harness` (bbh) to any subject with testable inputs
and outputs. Born 2026-09-09.

**Status:** session 1 complete — a plan, not a tool. **STOPPED for rulings.**
No harness code exists. No gate, comparator, driver or fixture exists.

**In force:** `DECISIONS.md` (R6, R7, R8; method M1–M3).
**Open rulings:** `docs/rulings.md` R0–R5, R9–R13. Nothing in slice S1 starts
before R0, R1, R3, R9 are answered (`docs/slices.md`).

**Lineage, measured 2026-09-09** (`docs/census/README.md`):

| repository | HEAD | tracked | note |
|---|---|---|---|
| bbh | `f675710` | 190 | fidelity baseline (R8); 4 uncommitted modifications recorded |
| VampireSaved | `5df1d8be` | 7497 | 555 rules across 8 skills; 311 gate scripts; 4,808 expectation files |
| SMS-FrenchName-edition | `ecc5481` | 633 | 66 rules; 28 traps; the Measurement Rule's origin at `CLAUDE.md:19-33` |

**Rules:** all 30 in CLAUDE.md §4 remain `[inherited]`. Incidents in this
project so far: `docs/gotchas.md` G1–G7 (none re-anchors a rule beyond
noting which it would).

**Known defects in the constitution, awaiting R12:** BBX-5 cites `MFI-52`
(does not exist; the paragraph is `MJC-52`); "304 gates / 4,000
expectations" are filed counts (measured 311 / 4,808).

**What does not exist yet, on purpose:** `LICENSE` (R1), any file under
`lib/`, `bin/`, `fixture/`, `gates/`, a skill, a recount script (R9).
