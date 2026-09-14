# The slice sequence — with a cost estimate in sessions

**Shape: proposal (session 1, 2026-09-09). All rulings answered 2026-09-09; S1 may
open.** Every slice ends in a readout the maintainer can read, with both
counts: green gates and controls that failed on purpose (CLAUDE.md §7.1).

## Calibration of the estimate (measured 2026-09-09)

The estimate column is an ESTIMATE, not a measurement. It is calibrated on
the one comparable run in the lineage and then adjusted by a factor that is
*arbitrary* (BBX-24 class) and says so:

| measured | value | command |
|---|---|---|
| bbh's H-slices H1–H10 | 10 slices, 19 commits, 3 calendar days (2026-09-06 → 2026-09-08) | `git -C ~/Developer/blackbox-harness log --format='%ad %s' --date=short` |
| VampireSaved sessions over those days | 14z-134 … 14z-140 = 7 sessions | `git -C ~/Developer/Vampire_Saved/VampireSaved log --format='%ad %s' --date=short \| grep -oE '^2026-09-0[6-8] 14z-[0-9]+' \| sort -u` |

So bbh extracted at roughly 1.4 slices per session — but every bbh slice
*lifted existing, already-green code* with its ancestor beside it to diff
against. BBX's S1–S2 are the same kind of work (lifting bbh with bbh beside
it). S3–S4 build two kinds that have no ancestor to diff against and are
therefore given **twice** the time; the factor 2 is arbitrary.

## The sequence

| slice | deliverable (contracts, `docs/abstraction.md`) | fidelity rows | must-fire controls demonstrated | readout says | rulings needed first | est. sessions |
|---|---|---|---|---|---|---|
| **S0** | this session: census, bins, abstraction, generality, fidelity plan, slices, rulings, memory files, commit one | — | — | what was measured / assumed / not looked at | R6–R8 (answered) | **1 (measured: this one)** |
| **S1 — the kernel** | the one classifier (G1), the gate header API (G2), the must-fire declaration and controls registry (G3, R10), the tiered gate registries (G4), the static and sweep runners, the suite dispatch loop, the readout (RO1–RO3) — all over bbh's `example/` as the first consumer; the census recount gate (R9, R14) as the first BBX gate; the platform gates of R3 (macOS, Linux, WSL) | F13 ✔ (9 pairs identical 2026-09-09), F14, F15 (F12 moved to S2: the suite's verdict lines come from S2's comparators) | classifier both directions `[BBH-4]`; anti-orphan both ways; a self-skip inside a battery; the recount gate pointed at a wrong HEAD; a declared control that does not fire refuses the verdict | F12–F15 diff empty; controls fired / declared; per-platform result; what the kernel does not assert (no comparator beyond exact yet) | answered | 2 |
| **S2 — comparison** (plan: `docs/plans/S2.md`; **built bbx-3 + bbx-4, 2026-09-10** — its readout in `docs/readout.md`) | the expectation kinds registry (E1–E2), the expectation register with the closed provenance vocabulary (E3, R11), the comparator spec grammar and dispatcher (C2), the temporal family lifted (C1), FAIL-SHORT (C3), verdict text frozen (C4), the proposer (C5) | F12, F16, F17 | window on a bit-identical pair; FAIL-SHORT vs FAIL; a nondeterministic pair; a loosened class with no ruling row refused | which classes exist, which have never PASSed on a real pairing | answered | 2 |
| **S3 — the document-set kind** (plan: `docs/plans/S3.md`, bbx-6, 2026-09-10 — STOPPED; R31–R34 answered the same day; built bbx-7 … bbx-11; **Ruled DONE by the maintainer, 2026-09-10** (after the bbx-12 close, on the bbx-11 table: "From what I see, S3 looks done")) | kind profile (S1), the doc-set driver (D1–D5), the claim-inventory and coverage kinds, set/multiset and schema families, the fixture `fixture/docset/` with its `--check` generator, the doc-set gate battery | — (no ancestor; proof by fixture) | the edited document; the shifted artifact; the planted wrong claim; the paraphrase; the unbindable claim | coverage as a number; "prose, reasoning and causal claims are not asserted" | answered | 3 (= 1.5 × 2) |
| **S4 — the command-line kind and the adapters** (plan: `docs/plans/S4.md`, bbx-12, 2026-09-10 — STOPPED at R35–R40, answered the same day; **step 1 built at bbx-13**: the profile D45, the `.cli` grammar D46, the token vocabulary D47, `fixture/fakecli/`, `gates/cli_fixture.sh`; **step 2 built at bbx-14**: the driver's core in `bbx.cli`, `drivers/cli.sh`, `gates/cli_driver.sh`, D51–D53; **step 3 built at bbx-15**: `compare_band.py` and the `tolerant-numeric)` branch, the json format of `compare_schema.py`, the line row shape of `compare_set.py`, the driver's JSON view, `gates/band.sh`, `gates/json_schema.sh`, D54–D56, the exact family's END rule generalized — X20; **step 4 built at bbx-16**: the kinds table's view column D57, `bin/bbx-run-suite`'s one resolver, `gates/cli_suite.sh` (7 controls), X22–X24; R41 raised, answered 2026-09-11 as both writers kept; R42 answered 2026-09-11 over step 2's crash control, the fixture's deliberate death changed from `os.abort()` to SIGKILL — X25; **step 5 built at bbx-18**: `lib/py/bbx/adapters.py` over the same `bbx.cli` core, `drivers/unittest.sh` and `drivers/gates.sh`, `fixture/unittest/` and `fixture/selfgates/` — BBX's fourth and fifth consumers, the second of them having BBX ITSELF as its subject (R14, R38's `command` identity) — `gates/adapters.sh` with 6 controls, D58–D61, X29–X34; R43, R44 and R45 raised; **step 6 built at bbx-19**: the file census lifted into the tree and GATED — `lib/py/bbx/file_census.py`, `bin/bbx file-census`, `gates/file_census_tool.sh` (portable, the instrument on a synthetic tree) and `gates/file_census.sh` (the first `gates/sweep.tsv` row, release scope), D62, D63, X36–X38; then the rulings built on the slice's work, read off each sitting's close commit: R43, R47 and G46's deadlock fix at bbx-20, R48 and G48's fix at bbx-22, G50's fix and R45, R46, R44 at bbx-23, R49 (G53: a header entry is one line, checked) at bbx-24; **step 7 at bbx-24**: the slice readout in `docs/readout.md`, with CLAUDE.md §7's six conditions answered one by one — S4 laid before the maintainer for the DONE ruling, and **ruled not yet DONE, option A (after the bbx-24 close)**: the tolerant-numeric family's single consumer to be declared (BBX-25) and `gates/file_census.sh` run at the final commit, then ruled again; **option A built at bbx-25**: R50 raised and ruled — BBX-25 judged per comparison family or contract, every single-consumer format, row shape, view and driver declared in the gate that holds it (eight gate headers; the tolerant-numeric and temporal families the two unmet) — G57 fixed in the same harness cycle, `gates/file_census.sh` PASS at `e81417d` with its 3 controls fired, and S4 laid before the maintainer again; **Ruled DONE by the maintainer, 2026-09-14** (after the bbx-25 close, on the amended table: "S4 is done but we should note to go over the BBX-25 scope and status as we F20 and cover more ground") — the rider is filed on S7's row) | kind profile, the cli driver with sandbox and env scrub, the tolerant-numeric family, `fixture/fakecli/`, the cli gate battery; the framework adapter contract (D7, R15) over two frameworks; BBX's own runners as subjects (R14); the shared/kind-specific file census that measures generality | — | the perturbed shadow copy; `--nondet`; `--crash-at`; the unknown option; the ruling-less class; a framework run twice that differs | shared vs kind-specific counts; BBX-25 applied to every component and to the adapter | R35–R40 (queued bbx-12) | 3 (= 1.5 × 2) |
| **S5 — the skill** (**ruled next by the maintainer, 2026-09-14**, after S4's DONE ruling: "next is S5"; opens at bbx-26 with its plan, which STOPs for rulings before any tool — CLAUDE.md §6; **plan: `docs/plans/S5.md`, bbx-26, 2026-09-14 — STOPPED at R51–R57, answered the same sitting, all as recommended**; **step 1 built at bbx-26**: bbh's lock and guide generator lifted, `gates/fidelity_bbh_s5.sh` F18 — 26 pairs identical, `verdict-text-f18` fired — D64, D65; G68 and X55 found on the way) | `BBX` rules re-anchored or still `[inherited]`, the skill generated by the H10 machinery citing `[BBH-N]` (R4), the skills registry (R2) | F18 | a rule with no anchor; an anchor with no rule; a number in no log; a forbidden token | which BBX rules are re-anchored by an incident *here* and which remain inherited | R51–R57 (queued bbx-26) | 1 |
| **S6 — rot and registers** | the controls registry (G3, R10), the defaults register with provenance class (BBX-24), the documents register with shape and twin (BBX-20), the seven-rot-classes checklist as gates (BBX-10), the header/ref-rot/gate-index hygiene | F19 | a dead control (a declared control that does not fire) → the gate refuses its verdict; a default with no class; a document with no twin | controls fired / declared for the whole tree | answered | 2 |
| **S7 — transitive fidelity** | F20 over VampireSaved; F21 opt-in with MAME; **BBX-25's scope and status gone over again as F20 lands** (the maintainer's rider on S4's DONE ruling, 2026-09-14): the temporal family's one consumer inside BBX, for which VampireSaved through F20 is the candidate second — measured then, never assumed — R50's unit against the ground covered by then, and where a one-kind component lives (`docs/generality.md`) | F20, F21 | the fidelity gate pointed at a moved bbh (porcelain non-empty) reports it | the three-way diff bbh = BBX = VS; F21 covered or not | — | 1 |
| | | | | | **total** | **15 sessions, estimate** |

## What a slice's readout must carry (from CLAUDE.md §7)

1. gates: PASS / SKIP / FAIL / TIMEOUT, counted separately;
2. controls: declared / fired, and the run in which each failed on purpose;
3. fidelity: every F row of the slice, `diff` empty or the first 12 lines;
4. every frozen expectation's provenance class;
5. every new default's row in the register;
6. what this green does NOT assert;
7. rules re-anchored this slice, by incident, with its price.

## Anti-hyperfocus checkpoint (BBX-27)

At the end of every slice, before the readout: is the next slice still the
most valuable one, and does the last green mean what the plan treats it as
meaning? The answer is a line in `DECISIONS_HISTORY.md`.
