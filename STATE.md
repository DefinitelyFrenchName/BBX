# STATE — what is true now

Shape: living page, lean. Its history twin is `STATE_HISTORY.md` (one
paragraph per sitting, the outgoing status verbatim). Read `HANDOFF.md` first.

**Project:** BLACKBOX (working name, ruling R0 open), prefix `BBX`. The
generalization of `blackbox-harness` (bbh) to any subject with testable inputs
and outputs. Born 2026-09-09.

**Status (bbx-21 close, 2026-09-13):** slices S1 and S2 complete; **S3 DONE**;
**S4's BUILD IS COMPLETE — only step 7, the slice readout, remains.** One subject
this sitting: **R21's first platform run came in, and it found a defect in BBX's own
controls contract.** The WSL battery read `PASS 30 SKIP 1 FAIL 0 MISSING 0` and then
NOT GREEN, because `gates/census_recount.sh` SKIPS off macOS (the three lineage
censuses record absolute paths from this host) and a gate that skips runs none of its
checks — so its four declared must-fire controls cannot fire, and
`docs/controls.md`'s "declared and not fired is red" turns a CORRECT skip into a red
battery. **Reproduced on macOS the same day** with `BBX_CENSUS_DIR` pointed at a
census naming an absent tree, so the finding is instrument-grade and the defect is
the contract's, not WSL's and not any gate's (G47). **Not fixed here:** the fix
amends a contract R10 ruled, so **R48 is raised** with its recommendation, four
declined alternatives and a narrower fallback — and **BBX-26 applies**, so it is the
next sitting's FIRST task. **The larger half of the result: everything else is
identical across the two hosts** — 31 gates, 119 declared controls, the same
anti-orphan and working-tree results, both fidelity gates, and every NOTE-class value
equal down to both fixtures' full count lines. Runtimes differ and are not gated.
Third sitting running in which a SECOND INSTANCE exposed what the first could not:
the third subject kind (G39), the second consumer of the exact family (G26), and now
the second host. `docs/platforms/wsl/` holds the run and what it does and does not
establish; the run file is a WITNESS because the kept directory is not in the tree.
Gotchas G1–G47.

**R21 HAS PRODUCED ITS FIRST RUN** (2026-09-13, WSL): `PASS 30 SKIP 1 FAIL 0 MISSING 0` and then
**NOT GREEN**, on a skip that was CORRECT — `gates/census_recount.sh` skips because the three lineage
censuses record absolute macOS paths, and a skipped gate cannot fire its four declared controls, which
`docs/controls.md` counts as dead. Reproduced on macOS the same day, so it is a contract defect and not
a WSL property (G47, R48 open, BBX-26 applies). Everything else is IDENTICAL across the two hosts: 31
gates, 119 declared controls, every NOTE-class value equal. `docs/platforms/wsl/`.

**Open
rulings, four:** R21 (its first run is in; the platform ROW is still not green, pending R48), R44's BUILD
(the ruling is answered; the printed-refreeze step is not yet written, and it
joins R46's one-definition work because both touch the single identity key), R45 (rescoped to three directions over three registries, with the tier-listing fix
measured and ruled out), and R48 (what a SKIPPED gate's declared controls mean — the
first platform run's finding, and the next sitting's FIRST task under BBX-26). Each carries a recommendation and its
declined alternatives; none blocks S4 step 7.
In force since bbx-2: R18 (the census and the tests
work on a clone or are explicitly, provably read-only), R19 (parallel work
is a pull queue; the FIFO token queue is the default implementation, the
principle is the ruling), R20 (fidelity on a plain clone of bbh at the
baseline; the recount's clone plain too).
BBX = Black Box harness eXpanded; GPL-3; sh + Python 3 on macOS, Linux and
Windows/WSL; kinds: frame-driven (bbh), document set, command-line tool, with BBX ITSELF a
subject and an external test framework a driver — five consumers:
bbh's `example/`, `fixture/docset/`, `fixture/fakecli/`, `fixture/unittest/`,
`fixture/selfgates/` (R14, R15, R37, R38). **BBX's own harness files are now
measured by a gate**, not by a document: 44 files, 30 gates, 0 unreached
(`docs/census/bbx_files.md`, generated; R39, D62, D63).

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
G30 → BBX-28/§3.2/BBX-30, G31 → §3.3/BBX-30, G32 → BBX-9/BBX-10/§3.3,
G33 → §1/BBX-16/BBX-12, G34 → BBX-9/§1/BBX-6, G35 → BBX-25/§3.3/§1,
G36 → BBX-16/BBX-6/BBX-12, G37 → §1/BBX-6/BBX-16 (`docs/gotchas.md`, G1–G37). The
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

**Next:** **S4 step 7, the slice readout** (`docs/plans/S4.md` §8.7) — the last
thing the slice asks for, after which S4 goes to the maintainer for a DONE ruling
as S3 did. **Then the first small fixes, which are now ONE step, not two:** R44's
printed-refreeze and R46's one-definition-of-the-identity-key both touch the
single key that `fixture/selfgates/idkey.sh`, `lib/py/bbx/file_census.py` and the
census document all read, so they are built together or they fight each other.
That step will itself move the identity, so it owes a census regeneration and a
reviewed refreeze at its own close — and with R47's gate in the battery, a harness
file added without a census run now REDS the battery, which is the cost the
maintainer accepted. **The order that avoids paying twice** (learned three times
this sitting): land every code change FIRST, then `bin/bbx file-census --self
--out build/file_census_<stamp> --shadow-refreeze 'python3
fixture/selfgates/mkselfgates.py' --document docs/census/bbx_files.md --frozen
expected/file_census.toml --freeze`, then commit the document and register
(docs-only, so the key holds), then refreeze the fixture row (fixture-only, so the
key still holds), then the battery twice. Prove any instrument change on a
two-gate `--only` probe before paying twenty minutes. R45 is rescoped and waiting;
R21's platform run when a host exists.
