# STATE — what is true now

Shape: living page, lean. Its history twin is `STATE_HISTORY.md` (one
paragraph per sitting, the outgoing status verbatim). Read `HANDOFF.md` first.

**Project:** BLACKBOX (working name, ruling R0 open), prefix `BBX`. The
generalization of `blackbox-harness` (bbh) to any subject with testable inputs
and outputs. Born 2026-09-09.

**Status (bbx-10 close, 2026-09-10):** slices S1 (but for R21's platform run)
and S2 complete; **S3 steps 1–4 built** (`docs/plans/S3.md` §8.1–8.4;
R31–R34 answered). Step 4: the suite's KINDS LOOP in `bin/bbx-run-suite` —
read off the kinds table, never configured: a table carrying the temporal
family gets bbh's precedence loop verbatim (F12 unchanged, 104 pairings
identical, the control that nothing moved for bbh), any other table gets every
EVAL kind present as its own pairing, `schema` first, then the table's order,
the self-frozen `.sha1` last; the printed shape `<scenario> <kind> <verdict>`
with the scenario named once; the kept run's rows keyed `(scenario, kind)`
and its `notes.tsv` (D44) carrying every `NOTE:` the scenario printed; on a
schema FAIL the value kinds print the suite's own `NOT-EVALUATED (schema
failed)` (finding `pending`, `finding.py`'s new prefix rule); `--freeze`
rewrites the shrink-only kind from the run (`bbx.compare_set --freeze`,
byte-identical to the generator's file on the fixture) and never self-freezes
beside an authored kind, which closes the bbx-9 HANDOFF hazard by
construction; `[suite].log_summary` (D43: the document-set profile's
`bbx.docset summary`) prints the log's own numbers at column 0; the readout's
suite screen counts pairings apart from scenarios, prints `coverage:` per
scenario and every other key as a note, meets BBX-14 over pairings, and lists
the DRIVER's blind spots (RO2). `gates/docset_suite.sh` (6 controls, every
printed line of the green run frozen and classified; ~55 s). The plan's §5
nondeterminism row corrected in its own commit (X11, BBX-19: the caller's
`DOCSET_NONDET=1` is scrubbed by D33's hermetic list, measured; the control
sets it inside a wrapper driver). G24: two blind-spot lines in
`gates/suite.sh` had named "S2 step 4" as their future since bbx-4 (G19's
shape, second instance; fixed, the S6 rot-gate case strengthened). Built in a
shadow first; two defects of the new gate caught there (paid 1 shadow run).
`bin/bbx selftest` GREEN twice at one HEAD (BBX-14 met): 23 gates, 78/78
controls. Fidelity F12–F17 diff empty on the plain clone at `10a82d2` (104
pairings). bbh's tip `447e5d2`, a NOTE. Defaults D1–D44. Gotchas G1–G24.
Retractions X1–X11.

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
G21 → §1/BBX-16, G22 → BBX-10/§1, G23 → BBX-1, G24 → BBX-10 (`docs/gotchas.md`, G1–G24). The
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

**Next:** S3 step 5 (`docs/plans/S3.md` §8.5: the slice readout — families
per kind, controls declared / fired, provenance classes, the defaults rows
D33–D44, the first shared-vs-kind-specific FILE CENSUS measured by the kinds'
gates, what the slice's green does not assert, §7's six conditions answered
one by one), then the STOP for S4's plan (R2's third kind, the command-line
tool: the second consumer of `schema` and of the kinds loop). The platform
run when R21's host exists. bbh's tip past the baseline follows the R28
procedure when a sitting needs it.
