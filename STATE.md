# STATE — what is true now

Shape: living page, lean. Its history twin is `STATE_HISTORY.md` (one
paragraph per sitting, the outgoing status verbatim). Read `HANDOFF.md` first.

**Project:** BLACKBOX (working name, ruling R0 open), prefix `BBX`. The
generalization of `blackbox-harness` (bbh) to any subject with testable inputs
and outputs. Born 2026-09-09.

**Status (bbx-16 close, 2026-09-10):** slices S1 (but for R21's platform run)
and S2 complete; **S3 DONE** (ruled by the maintainer 2026-09-10, for the
document-set kind as a fixture). **S4 steps 1–4 built** (`docs/plans/S4.md`
§8.1–8.4; the readout's bbx-13 … bbx-16 sections): the `command-line` kind
profile (D45), the `.cli` grammar (D46), the token vocabulary (D47), the `band`
and JSON `schema` shapes (D48, D49), `fixture/fakecli/` (D50) and
`gates/cli_fixture.sh` at bbx-13; the driver (`bbx.cli`, `drivers/cli.sh`,
D51–D53) and `gates/cli_driver.sh` at bbx-14; the comparators over a
command-line log (`compare_band.py`, the json format, the line row shape, the
JSON view D54, D55–D56) with `gates/band.sh` and `gates/json_schema.sh` at
bbx-15; at bbx-16 **the suite over the fixture** — the kinds table's VIEW
column (D57: `-` / `log` / `subject` / `json` / `bands`), read by
`bin/bbx-run-suite` and resolved in one function (`view_path`) after the
identity and before any scenario runs, handed to every family as its artifact
(the band branch derives no path any more); `gates/cli_suite.sh` (7 controls,
43 printed lines frozen, ~99 s). The plan corrected first in `3d98d1d`
(X22–X24: the loop is not unchanged — 29 lines added, 5 removed; the band
branch; the screen's class words and `fixture 21`). **R41 raised** (open): the
comparator and the log summary both print `NOTE: band-fields <n>` — the screen
shows one number twice, frozen as printed until ruled. The four S2/S3
dispatcher functions untouched (measured). `bin/bbx selftest` GREEN at the
open on `4a5cc61` (`build/selftest_20260910T195936Z`: 27 gates, 98/98); the
close's two runs GREEN on `3d98d1d` with the step staged (BBX-14 met): **28 gates,
105/105 controls** (`build/selftest_20260910T203200Z`, `build/selftest_20260910T204058Z`).
Fidelity F12–F17 diff empty on the plain clone at `10a82d2`. bbh's tip
`02d58f3`, two past the baseline (it moved during the sitting), a NOTE. Defaults D1–D57. Gotchas G1–G29. Retractions X1–X24.

**In force:** `DECISIONS.md` — R0–R20, R22–R40 and method M1–M4. **Open
rulings:** R21 (the platform runs: no Linux or WSL host here), R41 (one writer
of the `band-fields` NOTE key; recommendation the log summary).
In force since bbx-2: R18 (the census and the tests
work on a clone or are explicitly, provably read-only), R19 (parallel work
is a pull queue; the FIFO token queue is the default implementation, the
principle is the ruling), R20 (fidelity on a plain clone of bbh at the
baseline; the recount's clone plain too).
BBX = Black Box harness eXpanded; GPL-3; sh + Python 3 on macOS, Linux and
Windows/WSL; kinds: frame-driven (bbh), document set, command-line tool, plus
BBX itself as a subject (R14) and external test frameworks as drivers (R15).

**Lineage, measured 2026-09-09** (`docs/census/README.md`):

| repository | HEAD | tracked | note |
|---|---|---|---|
| bbh | `10a82d2` | 190 | fidelity baseline (R8; re-baselined from `f675710` on 2026-09-10, `docs/rebaselines.md`); tip `02d58f3`, two past (moved during bbx-16), a NOTE |
| VampireSaved | `0cdd9726` | 7497 | 555 rules across 8 skills; 311 gate scripts; 4,808 expectation files; re-measured at bbx-2 (was `5df1d8be`: one count and 13 line citations moved); its tip is past the census (a NOTE every run, 19 ahead at the bbx-8 open; not re-measured by design) |
| SMS-FrenchName-edition | `ecc5481` | 633 | 66 rules; 28 traps; the Measurement Rule's origin at `CLAUDE.md:19-33`; the S3 plan's rows A35–A41 re-derived on the clone at bbx-6 (7 of 7 match) |

**Rules:** all 30 in CLAUDE.md §4 remain `[inherited]` in the file (edits
need R16); incidents that re-anchor one in fact: G8 → §1, G9 → BBX-15,
G10 → BBX-8, G12 → BBX-29, G13 → BBX-16, G14 → BBX-20, G15 → §0/§1,
G16 → BBX-1, G17 → BBX-24/BBX-26, G18 → BBX-1, G19 → BBX-10, G20 → BBX-5,
G21 → §1/BBX-16, G22 → BBX-10/§1, G23 → BBX-1, G24 → BBX-10, G25 → BBX-5/BBX-16, G26 → §1/§3.3/BBX-19/BBX-25, G27 → §1, G28 → BBX-5/§1, G29 → §1 (`docs/gotchas.md`, G1–G29). The
formal promotion is slice S5.

**Constitution:** BBX-5's citation corrected to `MJC-52` (R12, own commit).
Every further edit to `CLAUDE.md` needs maintainer approval (R16). The counts
"304 gates / 4,000 expectations" are in bbh's README, not in CLAUDE.md
(measured 311 / 4,808; G3, G8).

**Census:** 300 count rows, 244 recountable by command on a plain clone of
the recorded commit (R18, R20), 56 not recountable (bbh 1, VS 27, SMS 28) — the
number to bring down; the two added at bbx-2 are host facts the clone
exposed (G13, rule 7), the only exception ever allowed to move it upward. Grammar in
`docs/census/README.md`.

**Next:** **S4 step 5** (`docs/plans/S4.md` §8.5): the two adapters
`drivers/unittest.sh` and `drivers/gates.sh` over the same `bbx.cli` core
(R37), `fixture/fakecli/tests/` and `fixture/selfgates/` (R38: BBX's own
runners as a subject, the `command` identity), `gates/adapters.sh` (the
framework's verdict as an observation, `Ran 0 tests` discarded, the self
subject both ways, a framework run twice that differs). First small fix
(G28): the two suite gates guard the kept run's existence before copying it.
R41 when answered: one line in two gates and a docstring. Built in a shadow
first, the register rows written in the shadow too, the new gate run in the
tree before the battery. The platform run when R21's host exists. bbh's tip
past the baseline follows the R28 procedure when a sitting needs it.
