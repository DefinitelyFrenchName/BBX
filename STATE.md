# STATE — what is true now

Shape: living page, lean. Its history twin is `STATE_HISTORY.md` (one
paragraph per sitting, the outgoing status verbatim). Read `HANDOFF.md` first.

**Project:** BBX — Black Box harness eXpanded (R0), prefix `BBX`. The
generalization of `blackbox-harness` (bbh) to any subject with testable inputs
and outputs. Born 2026-09-09.

**Status (bbx-23 close, 2026-09-13):** slices S1 and S2 complete; **S3 DONE**;
**S4's BUILD IS COMPLETE — only step 7, the slice readout, remains.** One subject: the
combined build of what was answered after the bbx-22 close, paid once. **G50 fixed**
(`bffd698`): the readout names a gate header it cannot read as `NOT FOUND`, its blind
spots UNKNOWN, instead of counting it as declaring none. **R45 built** (`ff7c06f`): `bbx
tier --complete` and `gates/registry_complete.sh` (portable, 3 controls) make an orphan of
either tier and a dead sweep row FAIL — and the gate's first run against BBX's own tree,
before it was registered, failed naming itself. **R46 built** (`d2501cf`): the harness
identity has one definition, `bbx.fingerprint.harness_identity`; `idkey.sh` is a shim and
the census delegates, and the old and new paths gave one key each way. **R44 built**
(`5a449ed`): the passing `adapters` prints `NOTE: self-identity …`, and the refreeze
commit quotes its changed line (`3202a22` did). Each change was measured red on the old
code and green on the new, and a full battery over all four read PASS 32, controls fired
128 / declared 128, before the first commit. **The file census is CURRENT again**
(`367f5e7`): 32 gates run in its shadow, 45 rows, no kind lost, and the register check
reads no drift. A claim was corrected before any code (`f72a2e1`): R45's gate forces no
census run, because `gates/` is outside the census universe (G52, retraction X43). The
opening battery at `7b83477` was GREEN (PASS 31, controls 123 / 123); the close's pair is
quoted in `docs/readout.md` (CLOSE — bbx-23). **The WSL platform row stays GREEN at
`429d3f8` and attests that commit only:** the build changed the readout, the tier
classifier and the identity since. Gotchas G1–G52; retractions X1–X44.

**Open rulings: none.** Every ruling R0–R48 is answered and recorded in `DECISIONS.md`;
R21, R44 and R45 were answered after the bbx-22 close, and R44, R45 and R46 are built.
In force since bbx-2: R18 (the census and the tests
work on a clone or are explicitly, provably read-only), R19 (parallel work
is a pull queue; the FIFO token queue is the default implementation, the
principle is the ruling), R20 (fidelity on a plain clone of bbh at the
baseline; the recount's clone plain too).
BBX = Black Box harness eXpanded; GPL-3; sh + Python 3 on macOS, Linux and
Windows/WSL; kinds: frame-driven (bbh), document set, command-line tool, with BBX ITSELF a
subject and an external test framework a driver — five consumers:
bbh's `example/`, `fixture/docset/`, `fixture/fakecli/`, `fixture/unittest/`,
`fixture/selfgates/` (R14, R15, R37, R38). **BBX's own harness files are
measured by a gate**, not by a document (`docs/census/bbx_files.md`, generated;
R39, D62, D63): regenerated at bbx-23 at identity `afd52caf8a96`, 32 gates, 45 rows for
45 harness files, and `bbx file-census --self --check-register` reads no drift.

**Lineage, measured 2026-09-09** (`docs/census/README.md`):

| repository | HEAD | tracked | note |
|---|---|---|---|
| bbh | `10a82d2` | 190 | fidelity baseline (R8; re-baselined from `f675710` on 2026-09-10, `docs/rebaselines.md`); tip `529f9d2`, EIGHT past at the bbx-22 open (`bbh-drift baseline=10a82d2 tip=529f9d2 ahead=8`), a NOTE |
| VampireSaved | `0cdd9726` | 7497 | 555 rules across 8 skills; 311 gate scripts; 4,808 expectation files; re-measured at bbx-2 (was `5df1d8be`: one count and 13 line citations moved); its tip is past the census (a NOTE every run, `fb530857c4de` and 64 ahead at the bbx-22 close; not re-measured by design) |
| SMS-FrenchName-edition | `ecc5481` | 633 | 66 rules; 28 traps; the Measurement Rule's origin at `CLAUDE.md:19-33`; the S3 plan's rows A35–A41 re-derived on the clone at bbx-6 (7 of 7 match) |

**Rules:** all 30 in CLAUDE.md §4 remain `[inherited]` in the file (edits
need R16); incidents that re-anchor one in fact: G8 → §1, G9 → BBX-15,
G10 → BBX-8, G12 → BBX-29, G13 → BBX-16, G14 → BBX-20, G15 → §0/§1,
G16 → BBX-1, G17 → BBX-24/BBX-26, G18 → BBX-1, G19 → BBX-10, G20 → BBX-5,
G21 → §1/BBX-16, G22 → BBX-10/§1, G23 → BBX-1, G24 → BBX-10, G25 → BBX-5/BBX-16, G26 → §1/§3.3/BBX-19/BBX-25, G27 → §1, G28 → BBX-5/§1, G29 → §1,
G30 → BBX-28/§3.2/BBX-30, G31 → §3.3/BBX-30, G32 → BBX-9/BBX-10/§3.3,
G33 → §1/BBX-16/BBX-12, G34 → BBX-9/§1/BBX-6, G35 → BBX-25/§3.3/§1,
G36 → BBX-16/BBX-6/BBX-12, G37 → §1/BBX-6/BBX-16. From G38 on, every entry in
`docs/gotchas.md` names the rules it re-anchors in its own text (11 of 11 for G38–G48,
counted at bbx-22; G49–G52 were written with theirs), and this list is not copied
further. The formal promotion is slice S5.

**Constitution:** BBX-5's citation corrected to `MJC-52` (R12, own commit).
Every further edit to `CLAUDE.md` needs maintainer approval (R16). The counts
"304 gates / 4,000 expectations" are in bbh's README, not in CLAUDE.md
(measured 311 / 4,808; G3, G8).

**Census:** 300 count rows, 244 recountable by command on a plain clone of
the recorded commit (R18, R20), 56 not recountable (bbh 1, VS 27, SMS 28) — the
number to bring down; the two added at bbx-2 are host facts the clone
exposed (G13, rule 7), the only exception ever allowed to move it upward. Grammar in
`docs/census/README.md`.

**Next:** (1) **S4 step 7, the slice readout** (`docs/plans/S4.md` §8.7): the selftest
run twice, kept; the families per kind; controls declared and fired; provenance classes;
defaults rows; the file census from the gate with its three-kind rows; what the green does
not assert — after which S4 goes to the maintainer for a DONE ruling, as S3 did. It moves
no harness file. (2) **A WSL re-run** whenever the maintainer wants the platform row to
attest a commit newer than `429d3f8` (R21's procedure; its tree check still holds). (3)
**G48's sweep**, widened by G50: every count a runner in `bin/` — and every reader in the
readout — takes over something that may be absent, asking whether the absence reads as
zero or as silence. Measure before calling any of them a defect. For any future harness
change, the order that avoids paying twice is in HANDOFF.
