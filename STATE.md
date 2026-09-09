# STATE — what is true now

Shape: living page, lean. Its history twin is `STATE_HISTORY.md` (one
paragraph per sitting, the outgoing status verbatim). Read `HANDOFF.md` first.

**Project:** BLACKBOX (working name, ruling R0 open), prefix `BBX`. The
generalization of `blackbox-harness` (bbh) to any subject with testable inputs
and outputs. Born 2026-09-09.

**Status (bbx-1 close, 2026-09-09):** session 1 delivered the plan, the
maintainer ruled R0–R17, and slice S1 steps 1–3 landed the same sitting.
`bin/bbx selftest` is GREEN at the close: 9 gates, 12/12 controls fired,
~117 s. Fidelity F13 (9 pairs), F14 (12 pairs) and F15 (32 logs) diff empty
against bbh f675710. In the tree: `bin/bbx` (`run-static`, `run-sweep`,
`classify`, `tier`, `config`, `controls`, `fingerprint`, `recount`,
`selftest`), `lib/sh/`, `lib/py/bbx/`, `bbx.toml` (the `self` kind), nine
gates under `gates/` with three registries, `docs/controls.md`,
`docs/defaults.md` D1–D16. No comparator, suite runner, expectation
register, driver or fixture yet.

**In force:** `DECISIONS.md` — R0–R17 and method M1–M4. **Open rulings:** none.
BBX = Black Box harness eXpanded; GPL-3; sh + Python 3 on macOS, Linux and
Windows/WSL; kinds: frame-driven (bbh), document set, command-line tool, plus
BBX itself as a subject (R14) and external test frameworks as drivers (R15).

**Lineage, measured 2026-09-09** (`docs/census/README.md`):

| repository | HEAD | tracked | note |
|---|---|---|---|
| bbh | `f675710` | 190 | fidelity baseline (R8); 4 uncommitted modifications recorded |
| VampireSaved | `5df1d8be` | 7497 | 555 rules across 8 skills; 311 gate scripts; 4,808 expectation files |
| SMS-FrenchName-edition | `ecc5481` | 633 | 66 rules; 28 traps; the Measurement Rule's origin at `CLAUDE.md:19-33` |

**Rules:** all 30 in CLAUDE.md §4 remain `[inherited]` in the file (edits
need R16); incidents that re-anchor one in fact: G8 → §1, G9 → BBX-15,
G10 → BBX-8 (`docs/gotchas.md`, G1–G10). The formal promotion is slice S5.

**Constitution:** BBX-5's citation corrected to `MJC-52` (R12, own commit).
Every further edit to `CLAUDE.md` needs maintainer approval (R16). The counts
"304 gates / 4,000 expectations" are in bbh's README, not in CLAUDE.md
(measured 311 / 4,808; G3, G8).

**Census:** 300 count rows, 246 recountable by command at the recorded HEADs,
54 not recountable (VS 27, SMS 27) — the number to bring down. Grammar in
`docs/census/README.md`.

**Next in S1 (step 4, the last):** the readout generator (RO1–RO3 as a
tool over a run's results: verdicts, controls, provenance histogram,
coverage, what-is-not-asserted) and the platform gates (R3: Linux, WSL).
Then S2 (comparators, expectation kinds, the provenance register with the
R11 vocabulary, the suite runner, F12/F16/F17). One finding for the
maintainer: bbh's example lib has a wrong fallback path (G11); bbh is not
modified here.
