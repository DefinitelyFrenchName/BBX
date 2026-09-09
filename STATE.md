# STATE — what is true now

Shape: living page, lean. Its history twin is `STATE_HISTORY.md` (created
when this page first rolls over). Read `HANDOFF.md` first.

**Project:** BLACKBOX (working name, ruling R0 open), prefix `BBX`. The
generalization of `blackbox-harness` (bbh) to any subject with testable inputs
and outputs. Born 2026-09-09.

**Status:** session 1 complete — a plan, not a tool. **All 16 rulings answered
(2026-09-09); slice S1 may open.** No harness code exists yet. No gate,
comparator, driver or fixture exists.

**In force:** `DECISIONS.md` — R0–R16 and method M1–M3. **Open rulings:** none.
BBX = Black Box harness eXpanded; GPL-3; sh + Python 3 on macOS, Linux and
Windows/WSL; kinds: frame-driven (bbh), document set, command-line tool, plus
BBX itself as a subject (R14) and external test frameworks as drivers (R15).

**Lineage, measured 2026-09-09** (`docs/census/README.md`):

| repository | HEAD | tracked | note |
|---|---|---|---|
| bbh | `f675710` | 190 | fidelity baseline (R8); 4 uncommitted modifications recorded |
| VampireSaved | `5df1d8be` | 7497 | 555 rules across 8 skills; 311 gate scripts; 4,808 expectation files |
| SMS-FrenchName-edition | `ecc5481` | 633 | 66 rules; 28 traps; the Measurement Rule's origin at `CLAUDE.md:19-33` |

**Rules:** all 30 in CLAUDE.md §4 remain `[inherited]`. Incidents in this
project so far: `docs/gotchas.md` G1–G8; G8 is the first re-anchoring
incident (CLAUDE.md §1, in the contributor's own conduct).

**Constitution:** BBX-5's citation corrected to `MJC-52` (R12, own commit).
Every further edit to `CLAUDE.md` needs maintainer approval (R16). The counts
"304 gates / 4,000 expectations" are in bbh's README, not in CLAUDE.md
(measured 311 / 4,808; G3, G8).

**What does not exist yet:** any file under `lib/`, `bin/`, `fixture/`,
`gates/`; a skill; the recount gate (first gate of S1, R9). `LICENSE` exists
(GPL-3, byte-identical to bbh's).
