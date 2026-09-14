# STATE — what is true now

Shape: living page, lean. Its history twin is `STATE_HISTORY.md` (one
paragraph per sitting, the outgoing status verbatim). Read `HANDOFF.md` first.

**Project:** BBX — Black Box harness eXpanded (R0), prefix `BBX`. The
generalization of `blackbox-harness` (bbh) to any subject with testable inputs
and outputs. Born 2026-09-09.

**Status (bbx-25 close, 2026-09-13; S4's ruling after it, 2026-09-14):** slices S1 and S2 complete; **S3 DONE**;
**S4 DONE — ruled by the maintainer after the bbx-25 close, on the amended §7 table, with a rider: BBX-25's scope
and status are gone over again as F20 lands and BBX covers more ground. S5 is next (ruled the same day).**
Both gaps the bbx-24 layout found are closed, and the build met a ruling first. **R50 was raised and
ruled before option A was built:** re-deriving bbx-24's claim that every S4 component had two instances
except the tolerant-numeric family, it held per comparison family and failed per format and per driver;
the maintainer chose "Family decides, all declared" — BBX-25 is judged per family or contract, and every
format, row shape, view and driver with one consumer is declared in the gate that holds it. Eight gate
headers now say so (`7b7af0e`, `1cad369`), the tolerant-numeric and temporal families the two unmet. The
question as put named band alone; the temporal family was measured after the answer and the maintainer
was told (**G58**). The sweep that followed found two blind spots S4 had made false, corrected first in
their own commit (`7b7af0e`, X47, X48). **G57 is fixed** (`da4a4b8`): the gate screen reconciles its rows
with `run.txt`'s tallies, counts gates the runner did not keep as `(gates N kept, M not run)` and names
the unrun tier; its two controls read DEAD on the old code in a scratch clone and FIRED on the new, the
native Linux pair's screen now reads `SKIP 4` and names the static tier, and the macOS screen is
byte-identical. **`gates/file_census.sh` PASSed at `e81417d`** (633 s; `edited-census-row`,
`shrunk-kind-set` and `contaminated-trace` fired; 45 files each reached by a gate, kind-sets frozen 45
measured 45). **The file census is current** (`610bba7`, identity `c26e5a94b344`: 32 gates, 45 rows, only
the identity line moved) and the self subject was refrozen in one quoted line (`e81417d`). The opening
battery at `a2ec618` was GREEN (PASS 32, controls 131 / 131); a battery over the uncommitted build read
PASS 32, controls 133 / 133; the close's pair is quoted in `docs/readout.md` (CLOSE — bbx-25). **The WSL
platform row stays GREEN at `429d3f8` and attests that commit only; native Linux is a PARTIAL row** at
`f6f136d` (the static tier not run). Gotchas G1–G66; retractions X1–X51.

**Open rulings: R51–R57**, raised by S5's plan at bbx-26 (`docs/plans/S5.md` §12, `docs/rulings.md`); no S5
tool is written until they are answered. R0–R50 are answered and recorded in `DECISIONS.md`. The maintainer's words with R49 stand as a rule of
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
R39, D62, D63): regenerated at bbx-25 at identity `c26e5a94b344`, 32 gates, 45 rows for
45 harness files, and `bbx file-census --self --check-register` reads no drift.

**Lineage, measured 2026-09-09** (`docs/census/README.md`):

| repository | HEAD | tracked | note |
|---|---|---|---|
| bbh | `10a82d2` | 190 | fidelity baseline (R8; re-baselined from `f675710` on 2026-09-10, `docs/rebaselines.md`); tip `529f9d2`, 8 past with bbh's own tree at `porcelain=3`, at the bbx-25 open; `f4094c2` (the maintainer's commit, a selftest capture fix in 3 files), NINE past with `porcelain=0`, at the close pair (`bbh-drift baseline=10a82d2 tip=f4094c2 ahead=9`) — a NOTE; every fidelity pair runs on a clone of the baseline, untouched by construction |
| VampireSaved | `0cdd9726` | 7497 | 555 rules across 8 skills; 311 gate scripts; 4,808 expectation files; re-measured at bbx-2 (was `5df1d8be`: one count and 13 line citations moved); its tip is past the census (a NOTE every run, `b48e8cc0b53b` and 69 ahead at the bbx-25 open; not re-measured by design) |
| SMS-FrenchName-edition | `ecc5481` | 633 | 66 rules; 28 traps; the Measurement Rule's origin at `CLAUDE.md:19-33`; the S3 plan's rows A35–A41 re-derived on the clone at bbx-6 (7 of 7 match) |

**Rules:** 29 of the 30 rule lines in CLAUDE.md §4 carry `[inherited]` and BBX-30 is
`[this project]`, as it was written (re-measured at bbx-25); none is promoted (edits
need R16); incidents that re-anchor one in fact: G8 → §1, G9 → BBX-15,
G10 → BBX-8, G11 → BBX-16/BBX-15, G12 → BBX-29/BBX-9, G13 → BBX-16/BBX-15, G14 → BBX-20/BBX-9, G15 → §0/§1,
G16 → BBX-1/§1, G17 → BBX-24/BBX-26, G18 → BBX-1, G19 → BBX-10, G20 → BBX-5,
G21 → §1/BBX-16, G22 → BBX-10/§1, G23 → BBX-1, G24 → none written (its entry calls itself G19's shape, BBX-10's rot class 4, and carries no re-anchor line), G25 → BBX-5/BBX-16, G26 → §1/§3.3/BBX-19/BBX-25, G27 → §1, G28 → BBX-5/§1, G29 → §1,
G30 → BBX-28/§3.2/BBX-30, G31 → §3.3/BBX-30, G32 → BBX-9/BBX-10/§3.3,
G33 → §1/BBX-16/BBX-12, G34 → BBX-9/§1/BBX-6, G35 → BBX-25/§3.3/§1,
G36 → BBX-16/BBX-6/BBX-12, G37 → §1/BBX-6/BBX-16. From G38 on, every entry in
`docs/gotchas.md` names the rules it re-anchors in its own text (G26–G52 extracted at bbx-24,
0 without one; G53–G59 were written with theirs), and this list is not copied further. The
formal promotion is slice S5.

**Constitution:** BBX-5's citation corrected to `MJC-52` (R12, own commit).
Every further edit to `CLAUDE.md` needs maintainer approval (R16). The counts
"304 gates / 4,000 expectations" are in bbh's README, not in CLAUDE.md
(measured 311 / 4,808; G3, G8).

**Census:** 300 count rows, 244 recountable by command on a plain clone of
the recorded commit (R18, R20), 56 not recountable (bbh 1, VS 27, SMS 28) — the
number to bring down (the bbx-25 opening battery: `NOTE: coverage rows=300 recountable=244
not_recountable=56`); the two added at bbx-2 are host facts the clone
exposed (G13, rule 7), the only exception ever allowed to move it upward. Grammar in
`docs/census/README.md`.

**Next:** (1) **S5 — the skill** (ruled next by the maintainer, 2026-09-14): its plan, `docs/plans/S5.md` — a
measured census of what the skill is generated from, the bins, the fidelity plan (F18), the open rulings — is
written at bbx-26 and STOPs for the maintainer's rulings before any tool (CLAUDE.md §6).
**Standing with S4's DONE ruling:** BBX-25's scope and status are gone over again as F20 lands and BBX covers more
ground (the maintainer's rider, filed on S7's row in `docs/slices.md`).
(2) **Named, not queued (bbx-25):** `docs/generality.md` says a component used by one kind is moved to
that kind's profile, and neither single-kind family's comparators were — they sit in `lib/py/bbx/` beside
the kind-blind families, reported by the census and moved by nothing. (3) **A full native Linux pair**
(with `BBX_BBH_HOME` set) and **a WSL re-run** whenever the platform row should attest a commit newer than
`429d3f8` (`docs/platforms/README.md`). (4) **G48's sweep, widened by G50, G53, G59 and G60**: every reader —
the contributor's probes included — that may read LESS than is there, asking whether the shortfall reads
as silence. (5) **The candidate ruling G54 names**: BBX's own `docs/` checked as a document-set subject.
For any future harness change, the order that avoids paying twice is in HANDOFF.
