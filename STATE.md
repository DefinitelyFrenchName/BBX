# STATE — what is true now

Shape: living page, lean. Its history twin is `STATE_HISTORY.md` (one
paragraph per sitting, the outgoing status verbatim). Read `HANDOFF.md` first.

**Project:** BLACKBOX (working name, ruling R0 open), prefix `BBX`. The
generalization of `blackbox-harness` (bbh) to any subject with testable inputs
and outputs. Born 2026-09-09.

**Status (bbx-17 close, 2026-09-11):** slices S1 (but for R21's platform run)
and S2 complete; **S3 DONE**; **S4 steps 1–4 built**. This sitting built no
step and moved no feature: it answered two rulings, one of them raised by the
maintainer against the harness's effect on the host. **R41 answered against
the contributor's recommendation** — BOTH writers of the `band-fields` NOTE
are kept, the comparator's (R36) and the log summary's (D43), and `04_band`
prints the number twice by design; measured first that the two counts CANNOT
disagree under `drivers/cli.sh`, which writes the log's band tokens and the
band view from one list in one run, so the duplicate is one number by two
routes and not a cross-check. Nothing printed changed; the provisional
wording came off two gates, the plan and the slice table, and
`compare_band.py`'s docstring now says why its NOTE has a twin. **R42 raised
by the maintainer and answered the same sitting**: the maintainer reported
Python crashes "for a couple of days" traced to BBX sessions. Treated as a
witness, not an instrument (BBX-28) — the archaeology first (BBX-23): ZERO
Python crash reports on this host before 19:53 local on 2026-09-10 across
about forty kept battery runs, then 23 that evening and 2 the next day, all
25 carrying ONE signature (SIGABRT, `abort() called`). The cause was BBX's
own must-fire crash controls, whose fixture tool called `os.abort()`; macOS
files a ~10 KB crash report for every one, OUTSIDE the sandbox the driver
promises to remove and declared by no line of its contract. Nothing was
broken — the harm was that a genuine Python crash hid among deliberate ones.
The fixture now dies by SIGKILL (measured both ways: abort leaves one report,
SIGKILL none; the driver exits 2 either way, keeps the same three lines, and
the two crash logs differ only in the signal name), the naming of signal 6
stays under test in `bbx.cli`'s self-test, which spawns no process, and the
host artifact is now DECLARED in `drivers/cli.sh` because a real subject that
faults will still leave one. The plan corrected FIRST in its own commit (X25,
BBX-19). Defaults D1–D57 (none added). Gotchas G1–G31 (G31: an edit pattern anchored on an indent corrupted the
generated tool's docstring and every gate passed — a generated file's prose
is asserted by nobody; found by reading the staged diff). Retractions X1–X25.
`bin/bbx selftest` GREEN at the open on `d49294b` (`build/selftest_20260911T185841Z`: 28 gates, 105/105) and GREEN twice more at the close on `9f16238` with
the change staged (BBX-14 met): **PASS 28  SKIP 0  FAIL 0  TIMEOUT 0  MISSING 0** over 28 gates, controls fired 105 / declared 105
(`build/selftest_20260911T194343Z`, `build/selftest_20260911T200013Z`).

**In force:** `DECISIONS.md` — R0–R20, R22–R42 and method M1–M4. **Open
rulings:** R21 alone (the platform runs: no Linux or WSL host here). R41 and
R42 were answered at bbx-17, R41 against the contributor's recommendation.
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
| bbh | `10a82d2` | 190 | fidelity baseline (R8; re-baselined from `f675710` on 2026-09-10, `docs/rebaselines.md`); tip `1af19c7`, SIX past (it moved during bbx-16 and twice during bbx-17), a NOTE |
| VampireSaved | `0cdd9726` | 7497 | 555 rules across 8 skills; 311 gate scripts; 4,808 expectation files; re-measured at bbx-2 (was `5df1d8be`: one count and 13 line citations moved); its tip is past the census (a NOTE every run, `46ccb3b` and 36 ahead at the bbx-17 close; not re-measured by design) |
| SMS-FrenchName-edition | `ecc5481` | 633 | 66 rules; 28 traps; the Measurement Rule's origin at `CLAUDE.md:19-33`; the S3 plan's rows A35–A41 re-derived on the clone at bbx-6 (7 of 7 match) |

**Rules:** all 30 in CLAUDE.md §4 remain `[inherited]` in the file (edits
need R16); incidents that re-anchor one in fact: G8 → §1, G9 → BBX-15,
G10 → BBX-8, G12 → BBX-29, G13 → BBX-16, G14 → BBX-20, G15 → §0/§1,
G16 → BBX-1, G17 → BBX-24/BBX-26, G18 → BBX-1, G19 → BBX-10, G20 → BBX-5,
G21 → §1/BBX-16, G22 → BBX-10/§1, G23 → BBX-1, G24 → BBX-10, G25 → BBX-5/BBX-16, G26 → §1/§3.3/BBX-19/BBX-25, G27 → §1, G28 → BBX-5/§1, G29 → §1,
G30 → BBX-28/§3.2/BBX-30, G31 → §3.3/BBX-30 (`docs/gotchas.md`, G1–G31). The
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

**Next:** **S4 step 5** (`docs/plans/S4.md` §8.5), untouched by this sitting:
the two adapters `drivers/unittest.sh` and `drivers/gates.sh` over the same
`bbx.cli` core (R37), `fixture/fakecli/tests/` and `fixture/selfgates/` (R38:
BBX's own runners as a subject, the `command` identity), `gates/adapters.sh`.
First small fix, still open from bbx-16 (G28): the two suite gates guard the
kept run's existence before copying it. A framework that dies by a FAULT
signal files a host crash report the driver never removes: count
`~/Library/Logs/DiagnosticReports/*.ips` across the new gate and expect zero
growth (G30, R42); the gate that would make that a measurement rather than a
habit is S6's. Built in a shadow first, the register rows written in the
shadow too, the new gate run in the tree before the battery. The platform run
when R21's host exists. bbh's tip past the baseline follows the R28 procedure
when a sitting needs it.
