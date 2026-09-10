# STATE — what is true now

Shape: living page, lean. Its history twin is `STATE_HISTORY.md` (one
paragraph per sitting, the outgoing status verbatim). Read `HANDOFF.md` first.

**Project:** BLACKBOX (working name, ruling R0 open), prefix `BBX`. The
generalization of `blackbox-harness` (bbh) to any subject with testable inputs
and outputs. Born 2026-09-09.

**Status (bbx-9 close, 2026-09-10):** slices S1 (but for R21's platform run)
and S2 complete; **S3 steps 1–3 built** (`docs/plans/S3.md` §8.1–8.3;
R31–R34 answered). Step 3: the three comparator families of the
document-set kind under the one dispatcher (R23) — `lib/py/bbx/compare_exact.py`
(the truth log against the run log BY INDEX; `FAIL-SHORT` apart from
`FAIL exact: index <i> differs`, BBX-4), `compare_set.py` (a frozen multiset of
`(document, line, form, status)` rows: `claims` inventory both ways, `covered`
shrink-only with `NOTE: covered-grew`, R33; a duplicate is hand-editing),
`compare_schema.py` (the artifact's shape before any value, the first
violation named; the type vocabulary D41); `compare_check` takes the scenario
file and the artifact as trailing arguments; `bbx.docset rows` / `resolve`
(the one artifact resolver, the driver calls it); `gates/set_schema.sh`
(5 controls; 38 verdict lines frozen and classified by `finding.py`). Every
verdict line is BBX's own, frozen by the gate (C4 with no ancestor). The
sitting's first finding was G22: the fixture's three truth logs were
`*.log`-ignored and never committed — every gate was green on the working
tree and would have been red on a clone; fixed with the logs added and a
mechanism (`bbx.provenance` refuses a registered file git does not track;
`gates/provenance.sh` control `row-untracked`). The plan's control placement
corrected in its own commit (X10, BBX-19). G23: the new gate's banner ran a
backticked word as a command; the tree's classifier read the shell error
that the shadow's bare run had not (two close batteries red, the quote
fixed, the shadow practice now runs gates through `bin/bbx classify`). No suite loop over the kinds yet
(step 4). `bin/bbx selftest` GREEN twice at one HEAD (BBX-14 met): 22 gates, 72/72 controls.
Fidelity F12–F17 diff empty on the plain clone at `10a82d2` (104 pairings).
bbh's tip `447e5d2`, a NOTE. Defaults D1–D42. Gotchas G1–G23. Retractions
X1–X10.

**In force:** `DECISIONS.md` — R0–R20, R22–R34 and method M1–M4. **Open
rulings:** R21 (the platform runs: no Linux or WSL host here). R31–R34
(the S3 plan's) validated 2026-09-10 — R33 to be reworked only if
experience proves it insufficient, R34 with the TSV caveat and its TOML
revision validated (the frozen rows of the new kinds are TOML-subset
tables, R24's shape).
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
| bbh | `10a82d2` | 190 | fidelity baseline (R8; re-baselined from `f675710` on 2026-09-10, `docs/rebaselines.md`); tip `447e5d2`, one past (README), a NOTE |
| VampireSaved | `0cdd9726` | 7497 | 555 rules across 8 skills; 311 gate scripts; 4,808 expectation files; re-measured at bbx-2 (was `5df1d8be`: one count and 13 line citations moved); its tip is past the census (a NOTE every run, 19 ahead at the bbx-8 open; not re-measured by design) |
| SMS-FrenchName-edition | `ecc5481` | 633 | 66 rules; 28 traps; the Measurement Rule's origin at `CLAUDE.md:19-33`; the S3 plan's rows A35–A41 re-derived on the clone at bbx-6 (7 of 7 match) |

**Rules:** all 30 in CLAUDE.md §4 remain `[inherited]` in the file (edits
need R16); incidents that re-anchor one in fact: G8 → §1, G9 → BBX-15,
G10 → BBX-8, G12 → BBX-29, G13 → BBX-16, G14 → BBX-20, G15 → §0/§1,
G16 → BBX-1, G17 → BBX-24/BBX-26, G18 → BBX-1, G19 → BBX-10, G20 → BBX-5,
G21 → §1/BBX-16, G22 → BBX-10/§1, G23 → BBX-1 (`docs/gotchas.md`, G1–G23). The
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

**Next:** S3 step 4 (`docs/plans/S3.md` §8.4: the suite loop in
`bin/bbx-run-suite` over the profile's kinds per scenario — frame-driven
precedence verbatim, F12 the control; `compare_check` with the scenario file
and the artifact as trailing arguments; kept-run rows `(scenario, kind)`;
`schema` first and `NOT-EVALUATED (schema failed)` for the value kinds;
the coverage NOTEs on the screen; `--freeze` for the shrink-only kind, which
must not overwrite a truth log a `.truth` names — HANDOFF hazard;
`gates/docset_suite.sh`), then step 5 (the slice readout with the first file
census). The platform run when R21's host exists. bbh's tip past the
baseline follows the R28 procedure when a sitting needs it.
