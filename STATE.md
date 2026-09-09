# STATE — what is true now

Shape: living page, lean. Its history twin is `STATE_HISTORY.md` (one
paragraph per sitting, the outgoing status verbatim). Read `HANDOFF.md` first.

**Project:** BLACKBOX (working name, ruling R0 open), prefix `BBX`. The
generalization of `blackbox-harness` (bbh) to any subject with testable inputs
and outputs. Born 2026-09-09.

**Status (bbx-2 close, 2026-09-10):** slice S1 is complete but for the
platform run (R21, the maintainer's Linux/WSL host, procedure in the ruling).
This sitting: the VampireSaved re-measure (G12); R18–R20 ruled and built — the
census and the fidelity gate measure PLAIN CLONES of recorded commits, never a
working tree, a moved lineage is a `drift` NOTE; R19's pull queue and
`clone_per_slot` in `bbx-run-sweep`; the `rulings_shape` gate (G14); the
readout generator (`bin/bbx selftest --log DIR`, `bin/bbx readout DIR
--against DIR2`, every gate declaring `NOT-ASSERTED:`); the `close_sweeps`
gate with `docs/retractions.tsv`. `bin/bbx selftest` is GREEN twice at one
HEAD (BBX-14 met): 12 gates, 26/26 controls fired, ~222 s on a loaded host.
Fidelity F13 (9 pairs), F14 (12 pairs) and F15 (32 logs) diff empty against
bbh f675710 on the clone. In the tree: `bin/bbx` (`run-static`, `run-sweep`,
`classify`, `tier`, `config`, `controls`, `fingerprint`, `recount`,
`readout`, `selftest`), `lib/sh/`, `lib/py/bbx/`, `bbx.toml` (the `self`
kind), twelve gates under `gates/` with three registries, `docs/controls.md`
(the header API), `docs/defaults.md` D1–D22, `docs/retractions.tsv`. No
comparator, suite runner, expectation register, driver or fixture yet.

**In force:** `DECISIONS.md` — R0–R17 and method M1–M4. **Open rulings:** R21 (the platform runs: no Linux or WSL host here).
In force since bbx-2: R18 (the census and the tests
work on a clone or are explicitly, provably read-only), R19 (parallel work
is a pull queue; the FIFO token queue is the default implementation, the
principle is the ruling), R20 (fidelity on a plain clone of bbh at
`f675710`; the recount's clone plain too).
BBX = Black Box harness eXpanded; GPL-3; sh + Python 3 on macOS, Linux and
Windows/WSL; kinds: frame-driven (bbh), document set, command-line tool, plus
BBX itself as a subject (R14) and external test frameworks as drivers (R15).

**Lineage, measured 2026-09-09** (`docs/census/README.md`):

| repository | HEAD | tracked | note |
|---|---|---|---|
| bbh | `f675710` | 190 | fidelity baseline (R8); 4 uncommitted modifications recorded |
| VampireSaved | `0cdd9726` | 7497 | 555 rules across 8 skills; 311 gate scripts; 4,808 expectation files; re-measured at bbx-2 (was `5df1d8be`: one count and 13 line citations moved) |
| SMS-FrenchName-edition | `ecc5481` | 633 | 66 rules; 28 traps; the Measurement Rule's origin at `CLAUDE.md:19-33` |

**Rules:** all 30 in CLAUDE.md §4 remain `[inherited]` in the file (edits
need R16); incidents that re-anchor one in fact: G8 → §1, G9 → BBX-15,
G10 → BBX-8, G12 → BBX-29, G13 → BBX-16, G14 → BBX-20, G15 → §0/§1
(`docs/gotchas.md`, G1–G15). The formal promotion is slice S5.

**Constitution:** BBX-5's citation corrected to `MJC-52` (R12, own commit).
Every further edit to `CLAUDE.md` needs maintainer approval (R16). The counts
"304 gates / 4,000 expectations" are in bbh's README, not in CLAUDE.md
(measured 311 / 4,808; G3, G8).

**Census:** 300 count rows, 244 recountable by command on a plain clone of
the recorded commit (R18, R20), 56 not recountable (bbh 1, VS 27, SMS 28) — the
number to bring down; the two added at bbx-2 are host facts the clone
exposed (G13, rule 7), the only exception ever allowed to move it upward. Grammar in
`docs/census/README.md`.

**Next:** S2 (the comparators, the expectation kinds, the provenance
register with the R11 vocabulary, the suite runner, F12/F16/F17) in sitting
bbx-3, whose first small fix is the screen listing every NOTE line (the
drift NOTE was in the close run's log, not on the screen); the platform run
when R21's host exists. Then S2 (comparators, expectation kinds, the provenance register with the
R11 vocabulary, the suite runner, F12/F16/F17). One finding for the
maintainer: bbh's example lib has a wrong fallback path (G11); bbh is not
modified here.
