# STATE — what is true now

Shape: living page, lean. Its history twin is `STATE_HISTORY.md` (created
when this page first rolls over). Read `HANDOFF.md` first.

**Project:** BLACKBOX (working name, ruling R0 open), prefix `BBX`. The
generalization of `blackbox-harness` (bbh) to any subject with testable inputs
and outputs. Born 2026-09-09.

**Status:** slice S1 open, step 1 done (2026-09-09): the census recount gate
is GREEN with both controls fired (`docs/readout.md`, second section). One
tool (`lib/py/bbx/recount.py`), one gate (`gates/census_recount.sh`), two
registries (`gates/static.txt`, `gates/portable.txt`), the controls contract
(`docs/controls.md`), the defaults register (`docs/defaults.md`, D1–D7). No
classifier, runner, comparator, driver or fixture yet.

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

**What does not exist yet:** `bin/`, the classifier, the runners, the
readout generator, any comparator, `fixture/`, a skill. Next in S1: the one
classifier and the gate contract over bbh's `example/`, toward F12–F15.
