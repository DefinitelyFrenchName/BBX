# STATE — what is true now

Shape: living page, lean. Its history twin is `STATE_HISTORY.md` (one
paragraph per sitting, the outgoing status verbatim). Read `HANDOFF.md` first.

**Project:** BLACKBOX (working name, ruling R0 open), prefix `BBX`. The
generalization of `blackbox-harness` (bbh) to any subject with testable inputs
and outputs. Born 2026-09-09.

**Status (bbx-3 close, 2026-09-10):** slice S1 complete but for the platform
run (R21); slice S2 steps 1–3 built and green, step 4 (the expectation
register) waiting on R24. This sitting: the screen lists every NOTE line (the
handoff's first fix, with a control); S2 planned on a measured census of the
lift (`docs/plans/S2.md`), STOPPED, and ruled — R23, R25, R26 in force, R24
revised to a TOML register (measured against the subset parser) and open;
then built: the temporal family (`lib/py/bbx/compare_*.py`,
`check_diverge.py`, `propose_temporal.py`, `thresholds.py` with R25's
refusal, `logfmt.py`), the one dispatcher (`lib/sh/compare.sh`, R23: family
by kind) and the kinds table in the profile (`lib/sh/expectation_kinds.sh`,
`bbx.expectations`), the suite (`bin/bbx-run-suite`; `--log` keeps a FINDING
column, `bbx.finding`, `short` apart from `diverged`; R26's driver home is
bbh's `drivers/`). Six new gates (temporal, thresholds, compare_dispatch,
expectation_kinds, fidelity_bbh_s2, suite). `bin/bbx selftest` GREEN twice at
one HEAD (BBX-14 met): 18 gates, 48/48 controls, ~6 min on a loaded host.
Fidelity F12 (17 pairs), F16 (35), F17 (52) diff empty against bbh f675710
on the plain clone, beside F13–F15. Defaults D1–D30. Gotchas G1–G18 (G17,
G18 this sitting, both caught by the harness). No expectation register yet;
no driver of BBX's own; no fixture subject; `compare_fields.py` not lifted
(BBX-25).

**In force:** `DECISIONS.md` — R0–R20, R22–R27 and method M1–M4. **Open rulings:** R21 (the platform runs: no Linux or WSL host here). R23–R27 ruled 2026-09-10 (R24 answered before the close and recorded after it); S2 step 4 may open.
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
G10 → BBX-8, G12 → BBX-29, G13 → BBX-16, G14 → BBX-20, G15 → §0/§1,
G16 → BBX-1, G17 → BBX-24/BBX-26, G18 → BBX-1 (`docs/gotchas.md`, G1–G18). The formal promotion is slice S5.

**Constitution:** BBX-5's citation corrected to `MJC-52` (R12, own commit).
Every further edit to `CLAUDE.md` needs maintainer approval (R16). The counts
"304 gates / 4,000 expectations" are in bbh's README, not in CLAUDE.md
(measured 311 / 4,808; G3, G8).

**Census:** 300 count rows, 244 recountable by command on a plain clone of
the recorded commit (R18, R20), 56 not recountable (bbh 1, VS 27, SMS 28) — the
number to bring down; the two added at bbx-2 are host facts the clone
exposed (G13, rule 7), the only exception ever allowed to move it upward. Grammar in
`docs/census/README.md`.

**Next:** S2 step 4 on R24 (the TOML expectation register,
`gates/provenance.sh`, the screen's provenance histogram and "never PASSed on
a real pairing" line); then the S2 slice readout and close (CLAUDE.md §7).
The platform run when R21's host exists. One finding for the maintainer:
bbh's example lib has a wrong fallback path (G11); bbh is not modified here.
