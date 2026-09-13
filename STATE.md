# STATE — what is true now

Shape: living page, lean. Its history twin is `STATE_HISTORY.md` (one
paragraph per sitting, the outgoing status verbatim). Read `HANDOFF.md` first.

**Project:** BBX — Black Box harness eXpanded (R0), prefix `BBX`. The
generalization of `blackbox-harness` (bbh) to any subject with testable inputs
and outputs. Born 2026-09-09.

**Status (bbx-24 close, 2026-09-13):** slices S1 and S2 complete; **S3 DONE**;
**S4 BUILT AND READ OUT — its step 7, the slice readout, is in `docs/readout.md` with
CLAUDE.md §7's six conditions answered one by one, and S4 waits on the maintainer's DONE
ruling.** The sitting's first finding came off the opening screen, not off a gate: two blind
spots written over several header lines were printed cut mid-sentence, one of them on seven
committed screens since bbx-17 (**G53**). **R49 was raised and ruled the same sitting — option
1, the maintainer adding: "We don't compromise on discipline."** The two headers were put back
on one line first (`398a64f`), then the check (`64dfd85`): `gates/close_sweeps.sh` fails the
tree on a header entry that runs past its one line, naming it, and the readout marks a cut
blind spot `^ TRUNCATED` instead of printing a shorter whole. Three new controls, each DEAD on
the old code in a scratch clone and FIRED on the new; a battery over the uncommitted build read
PASS 32, controls fired 131 / declared 131. **The file census is current** (`c2e654c`, identity
`4465efe8a453`: 32 gates, 45 rows, no kind lost — `controls.py` gains the close sweep, which is
the build and nothing else), and the self subject was refrozen in one quoted line (`af8846c`).
**The stale spot HANDOFF carried is fixed, with G54 and X45:** three living-page sentences kept
the 31-gate count after R45 made it 32, one of them on the page followed on WSL. The opening
battery at `f6f136d` was GREEN (PASS 32, controls 128 / 128); the close's pair is quoted in
`docs/readout.md` (CLOSE — bbx-24). **The WSL platform row stays GREEN at `429d3f8` and attests
that commit only**; the platform README's tree check now names a count this sitting moved.
Gotchas G1–G54; retractions X1–X45.

**Open rulings: none.** Every ruling R0–R49 is answered and recorded in `DECISIONS.md`; R49 was
raised and answered at bbx-24 and is built. The maintainer's words with it stand as a rule of
method: discipline is never arbitrated — only the method of applying it, on time or practicality.
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
R39, D62, D63): regenerated at bbx-24 at identity `4465efe8a453`, 32 gates, 45 rows for
45 harness files, and `bbx file-census --self --check-register` reads no drift.

**Lineage, measured 2026-09-09** (`docs/census/README.md`):

| repository | HEAD | tracked | note |
|---|---|---|---|
| bbh | `10a82d2` | 190 | fidelity baseline (R8; re-baselined from `f675710` on 2026-09-10, `docs/rebaselines.md`); tip `529f9d2`, EIGHT past at the bbx-24 open (`bbh-drift baseline=10a82d2 tip=529f9d2 ahead=8`), a NOTE |
| VampireSaved | `0cdd9726` | 7497 | 555 rules across 8 skills; 311 gate scripts; 4,808 expectation files; re-measured at bbx-2 (was `5df1d8be`: one count and 13 line citations moved); its tip is past the census (a NOTE every run, `322682504c9e` and 66 ahead at the bbx-24 open; not re-measured by design) |
| SMS-FrenchName-edition | `ecc5481` | 633 | 66 rules; 28 traps; the Measurement Rule's origin at `CLAUDE.md:19-33`; the S3 plan's rows A35–A41 re-derived on the clone at bbx-6 (7 of 7 match) |

**Rules:** all 30 in CLAUDE.md §4 remain `[inherited]` in the file (edits
need R16); incidents that re-anchor one in fact: G8 → §1, G9 → BBX-15,
G10 → BBX-8, G12 → BBX-29, G13 → BBX-16, G14 → BBX-20, G15 → §0/§1,
G16 → BBX-1, G17 → BBX-24/BBX-26, G18 → BBX-1, G19 → BBX-10, G20 → BBX-5,
G21 → §1/BBX-16, G22 → BBX-10/§1, G23 → BBX-1, G24 → BBX-10, G25 → BBX-5/BBX-16, G26 → §1/§3.3/BBX-19/BBX-25, G27 → §1, G28 → BBX-5/§1, G29 → §1,
G30 → BBX-28/§3.2/BBX-30, G31 → §3.3/BBX-30, G32 → BBX-9/BBX-10/§3.3,
G33 → §1/BBX-16/BBX-12, G34 → BBX-9/§1/BBX-6, G35 → BBX-25/§3.3/§1,
G36 → BBX-16/BBX-6/BBX-12, G37 → §1/BBX-6/BBX-16. From G38 on, every entry in
`docs/gotchas.md` names the rules it re-anchors in its own text (G26–G52 extracted at bbx-24,
0 without one; G53 and G54 were written with theirs), and this list is not copied further. The
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

**Next:** (1) **The maintainer's DONE ruling on S4**, on the §7 table of bbx-24's slice readout
in `docs/readout.md`, as S3 had. (2) **Which slice comes next** — S5 (the skill) by the table, or
R29's executable controls (S6) first, since every controls count a readout quotes is still a
gate's self-report; the contributor's answer is in `DECISIONS_HISTORY.md` (bbx-24) and the
question goes to the maintainer with the DONE ruling. (3) **A WSL re-run** whenever the platform
row should attest a commit newer than `429d3f8` (`docs/platforms/README.md`; its tree check now
reads `gates/close_sweeps.sh` → `4`). (4) **G48's sweep, widened by G50 and G53**: every reader
that may read LESS than is there — a count over something absent, a header read one line at a
time — asking whether the shortfall reads as silence. Measure before calling any of them a
defect. (5) **The candidate ruling G54 names**: BBX's own `docs/` checked as a document-set
subject, so a count a registry defines cannot go stale in prose. For any future harness change,
the order that avoids paying twice is in HANDOFF.
