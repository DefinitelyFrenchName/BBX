# Bins — SMS-FrenchName-edition (census docs/census/sms.md @ ecc5481) — 2026-09-09

Shape: table, one row per census B item, ids identical to the census. Bins per CLAUDE.md §5. Every `drop` carries a reason. Totals at the end are produced by the command shown.

Vocabulary in the `becomes` column is `docs/abstraction.md` (S1–S5, D1–D6, O1–O6, E1–E6, C1–C6, G1–G5, R1–R3, RO1–RO3) and the `[BBX-N]` rules of CLAUDE.md §4.

| id | item (≤ 80 chars) | bin | becomes / reason |
|---|---|---|---|
| S-P1 | THE MEASUREMENT RULE — data comes from measurement, never guesses | keep | CLAUDE.md §1 verbatim; the constitution's first law |
| S-P2 | Certainty is the failure signal, not the safety signal | keep | §1 third clause; the trigger for a measurement |
| S-P3 | Corollary 1 — no number without a run that produced it that session | keep | §1; BBX-21 (a number in a skill appears in a log) |
| S-P4 | Corollary 2 — a number someone else reports is a filed count | keep | §1; §3.3 weakest evidence class |
| S-P5 | Corollary 3 — a number from defective tooling is contaminated | keep | §1; discard and re-measure, never adjust |
| S-P6 | Corollary 4 — measure the negative; a control is code | keep | BBX-5, BBX-8, G3 must-fire |
| S-P7 | Corollary 5 — reject on measurements, not on intuition | keep | §1 + RO3: the rejection is auditable |
| S-P8 | Corollary 6 — thresholds live where the run that produced them lives | keep | BBX-24 defaults register; C1 thresholds declared once |
| S-P9 | Corollary 7 — check the framing before trusting a verdict about a byte | generalize | framing → O2 BASIS / S4 VIEW; an unstated basis is not comparable |
| S-P10 | House rule — measure, don't infer, and hardest when you are sure | keep | §1 restated for a corpus meant to be lifted by others |
| S-P11 | House rule — find the interpreter before trusting the data | generalize | → S4 VIEWS / BBX-16: the wrong view yields plausible garbage |
| S-P12 | House rule — a probe that reports nothing is usually broken | keep | BBX-7 + G3: verify the instrument on a known-present signal |
| S-P13 | House rule — DMA is invisible to CPU write callbacks | consumer | SNES/Mesen; the absence-claim form is BBX-7 |
| S-P14 | House rule — the holes are documented too | keep | RO2 / BBX-30: a map that hides its gaps |
| S-P15 | Convention — never patch in place; builders take (src, out) | generalize | → D5 HYGIENE: the subject artifact is never mutated; the driver writes an out |
| S-P16 | Convention — never chain standalone .bps files | consumer | bps / bank-append fact |
| S-P17 | Convention — byte-identity is the refactor gate, across every knob | generalize | → C1 exact over the whole scenario-variable matrix (D2) |
| S-P18 | Convention — published artifacts are never redefined | keep | S3 VERSION / BBX-29: results keyed by (case, version) |
| S-P19 | Convention — generated files are generated (--check modes) | keep | BBX-21 + R1: re-derived every run, never hand-edited |
| S-P20 | Three verdict classes, not two: FAIL / SKIP / NOTE | keep | G1 / BBX-1: a check that cannot run must SKIP |
| S-P21 | Fixtures are shared, judgement is not | keep | fixture subject vs comparator: one staging, many verdicts |
| S-P22 | The sweep that set a default lives in the header of the file using it | keep | BBX-24 + G2: the header names the default the code uses |
| S-P23 | The honest weakness is printed (coverage, UNENCODABLE, ROUTINE_LEVEL) | keep | RO1 coverage as a number; a number never shown never moves |
| S-P24 | Generated artifacts are never committed as build output | keep | BBX-21: a hand-copied artifact goes stale silently |
| S-P25 | The gate names what it is not | keep | RO2 / BBX-30 |
| S-P26 | A census is not a gate, and says so in its own output | keep | G4 / RO2: an instrument that asserts nothing declares it |
| S-P27 | Wiring is checked separately from the function | keep | G4 anti-orphan: a passing selftest says nothing about reach |
| S-P28 | Validate against a different author's implementation where free | keep | §3.3 lineage-independent corroborator; D6 |
| S-P29 | Logs truncate, never append | generalize | → D5: the out file is removed before the run (BBH-27) |
| S-P30 | A claim nobody checked is never mistaken for one that held | keep | BBX-3 / E2 + RO1 coverage |
| S-P31 | Provenance is a first-class field in generated data | keep | E3: every frozen artifact carries its provenance class |
| S-I1 | Five documented facts died on first re-derivation of the doc tables | keep | the price tag of §1 and BBX-18 (a document set is a subject) |
| S-I2 | Dead fact — a special-move record is 7 bytes, not 8 | consumer | game fact |
| S-I3 | Dead fact — stz $47,X is at $C1:0E4F, wrong in four places | consumer | 65816 / game fact |
| S-I4 | Dead fact — the dispatcher tail is jsr ($BB6D,X), not jmp | consumer | 65816 |
| S-I5 | Dead fact — the bank-$DF engine has eight screens, not nine | consumer | game fact |
| S-I6 | Dead fact — Uranus's toss Y velocity is −$0580 | consumer | game fact |
| S-I7 | Four claims in the identity paragraph the port rests on died | keep | E4: the corpus a project builds on was the last one gated |
| S-I8 | Dead claim — scripts byte-identical only after stripping 0xC0 steps | consumer | cross-game fact |
| S-I9 | Dead claim — cel records same sizes is 97 of 98 | consumer | game fact |
| S-I10 | Dead claim — the cel banks span $D4-$D6 / $D6-$D7 | consumer | game fact |
| S-I11 | Dead claim — the box-index writer row contradicted itself | consumer | game fact |
| S-I12 | Trap 1 — per-character fixes must be tested with at least TWO shells | generalize | → scenario coverage: one instance never verifies the family (BBX-25) |
| S-I13 | Trap 2 — unreferenced, unchanging memory is not free memory | generalize | → BBX-7: absence over one channel is not absence |
| S-I14 | Trap 3 — data for a vanilla routine must respect the WRAM-mirror rule | consumer | SNES WRAM mirror |
| S-I15 | Trap 4 — a convention verified in one context is not verified elsewhere | keep | project-blind as written; scenario coverage (BBX-14) |
| S-I16 | Trap 5 — patch a bank and you must patch its COPIES | consumer | SNES bank copies |
| S-I17 | Trap 6 — an OVERRIDE is only as complete as the transfer carrying it | consumer | engine fact |
| S-I18 | Trap 7 — address a tile through the OBJ name base, never tile * 32 | consumer | SNES PPU |
| S-I19 | Trap 8 — sprite lists are emitted on ALTERNATE frames | consumer | game / PPU fact |
| S-I20 | Trap 9 — a probe that reports nothing is usually broken | keep | BBX-7 / G3; second anchor of S-P12 |
| S-I21 | Trap 10 — matching the measurement is not matching the request | keep | E4: the expectation must answer the question asked |
| S-I22 | Trap 11 — a verified issue report can still be false | keep | BBX-28: a witness is not an instrument |
| S-I23 | Trap 12 — throws inside a Mesen memory callback die without a message | consumer | Mesen |
| S-I24 | Trap 13 — prove the probe does ANYTHING before fixing its defect | keep | BBX-5 / G3: fire on a known positive before first use |
| S-I25 | Trap 14 — find what the waste protects, then move the COST | keep | BBX-23: archaeology before a change to a mechanism |
| S-I26 | Trap 15 — a builder change invalidates every recorded RECIPE | generalize | → S3 + E3: frozen results are keyed to the producer's version |
| S-I27 | Trap 16 — byte-identity must cover EVERY variant path | generalize | → C1 exact over the full scenario-variable matrix (D2) |
| S-I28 | Trap 17 — counts in filed issues are stale in BOTH directions | keep | §1 filed count; re-derive at HEAD |
| S-I29 | Trap 18 — a documented knob either works or does not exist | keep | BBX-18: a documented claim is derived and compared |
| S-I30 | Trap 19 — widening a patch's scope re-censuses the paths | generalize | → R1: a registry justified by a census is re-derived when scope moves |
| S-I31 | Trap 20 — a check that cannot fail at the WRONG address checks nothing | generalize | → BBX-8 / G3: the wrong-ANCHOR control (address → anchor) |
| S-I32 | Trap 21 — a recorded hash is a claim about a build, defaults included | keep | E3 + BBX-24: an expectation is keyed to its configuration |
| S-I33 | Trap 22 — a negative control is CODE, wrong until it fails on purpose | keep | BBX-5 verbatim |
| S-I34 | Trap 23 — relaxing a binding rule invents claims | keep | BBX-13 / E6: never loosen a class to make a gate green |
| S-I35 | Trap 24 — an undocumented knob is as bad as a missing documented one | keep | R1 / BBX-9: complete both ways |
| S-I36 | Trap 25 — is this ROM? depends on the bank you are executing in | consumer | SNES memory map |
| S-I37 | Trap 26 — a counter that looks like a frame index may be a timer | generalize | → O1: the OBSERVATION POINT key is proved by varying the input |
| S-I38 | Trap 27 — a write callback's PC is the NEXT instruction | consumer | Mesen / 65816 |
| S-I39 | Trap 28 — a probe default that was never run is a guess | keep | BBX-24 + G5: an unexercised default is a false verdict waiting |
| S-I40 | A recorded hash was stale in four docs; its default subtitle had changed | keep | E3 / BBX-24: a build includes its defaults |
| S-I41 | Six documented ROM facts were wrong and are corrected | consumer | game facts; the procedure they paid for is BBX-19 (see S-I1) |
| S-I42 | checkdocs found one error on its first run — in the check, not the docs | keep | BBX-2: a new instrument's first red is usually the instrument |
| S-I43 | The live defect was the opposite of the report: the extractor mis-bound | keep | BBX-28 + O3: parse by field name, never by adjacency |
| S-I44 | Three negative controls looked right and tested nothing | keep | BBX-6: the dead control is the only silent failure mode |
| S-I45 | A shipped decode table was wrong (BRK as 1 byte, 7 opcodes missing) | consumer | 65816 decode table |
| S-I46 | Nine screenshots were force-added past the traces rule and pushed | keep | an ignore rule with an escape hatch is not a rule; repo hygiene |
| S-I47 | The suite went green while skipping all 11 patch-13 tests | keep | BBX-1 SKIP is not PASS + BBX-9: a hand-maintained registry |
| S-I48 | mkarchpage.py --check, a mode it lacks, wrote a file and looked green | keep | D3 REFUSAL: a tool refuses options it does not define |
| S-I49 | The shipped clash was reported dead on a byte-identical build | keep | G5 SETUP-FAIL + BBX-24: an unexercised default faked a verdict |
| S-C1 | The three-step check shape: quote the doc, derive the fact, compare | generalize | → doc-set KIND: DRIVER (quote + derive) and COMPARATOR, anchored per E4 |
| S-C2 | A check that only did step 2 would test my memory of the docs | keep | quoted in CLAUDE.md §3.4; E4 anchored outside the artifact |
| S-C3 | Step 4 — re-run at a WRONG address or the WRONG GAME, require failure | generalize | → G3 control shapes: wrong anchor and wrong subject, declared |
| S-C4 | Bindable form 1 — quoted instruction attached to the address | generalize | → CLAIM FORM of the doc-set kind profile (O1 point grammar) |
| S-C5 | Bindable form 2 — quoted instruction before the address | generalize | → CLAIM FORM: binding direction is part of the grammar |
| S-C6 | Bindable form 3 — quoted byte run | generalize | → CLAIM FORM: an anchor plus a quoted token run |
| S-C7 | Bindable form 4 — file offset | generalize | → CLAIM FORM read in a second VIEW of the same anchor (S4) |
| S-C8 | Bindable form 5 — disassembly listing row | generalize | → CLAIM FORM read in a derived VIEW (S4) |
| S-C9 | Bindable form 6 — table row, subject in cell 1, quote later | generalize | → CLAIM FORM: structured-row binding |
| S-C10 | Quote something — an unquoted address is a claim nobody can falsify | generalize | → E4: an anchor without evidence is not a checkable claim |
| S-C11 | Describing an absence is fine and stays unchecked | keep | BBX-7 + RO1 coverage: asserting it would invert the claim |
| S-C12 | In a table row, name the subject first | generalize | → doc-set kind: binding order is part of the claim grammar |
| S-C13 | health.sh verdict classes: FAIL, SKIP, NOTE | keep | G1 / BBX-1; NOTE is a reported count, never fatal |
| S-C14 | SETUP-FAIL is a third verdict class | keep | G5, already lifted into abstraction §6 |
| S-C15 | Probe vs test — the exploratory instrument is not the gate | keep | G4: asserting gates are registered, probes are not |
| S-C16 | Fixture / judgement split — the caller decides what is true | keep | fixture subject vs comparator; second anchor of S-P21 |
| S-C17 | Instrument honesty — a gate-tester must say so in its own output | keep | RO2 / BBX-30 |
| S-C18 | Assert a measured string, never an exit code | keep | G1 + O1: exit decides first, but the gate asserts a value |
| S-C19 | Three failure modes distinct: died, no trace, wrong verdict | keep | D4 four exits + C3 fail-short (BBX-4) |
| S-C20 | Stated non-coverage, printed on every run | keep | RO2 / BBX-30 — the reason this repository exists |
| S-C21 | Validator purity — derive everything from the address plus the shift | generalize | → G3: a control is valid only if the validator takes the perturbation |
| S-C22 | CI names what it did not check | keep | RO2 / BBX-30 at the runner level |
| S-T1 | census_airroutes.py — 1 negative-control site | consumer | SMS tool; controls-census row (G3 input) |
| S-T2 | census_motionbudget.py — 2 negative-control sites | consumer | SMS tool; controls-census row |
| S-T3 | census_onhit_flags.py — 3 negative-control sites | consumer | SMS tool; controls-census row |
| S-T4 | checkdocs.py — 4 negative-control sites | consumer | SMS tool; controls-census row (tool itself is S-K1) |
| S-T5 | checkknobs.py — 1 negative-control site | consumer | SMS tool; controls-census row |
| S-T6 | checkpatchmap.py — 1 negative-control site | consumer | SMS tool; controls-census row |
| S-T7 | checkskills.py — 1 negative-control site | consumer | SMS tool; controls-census row |
| S-T8 | checktrainingdocs.py — 1 negative-control site | consumer | SMS tool; controls-census row |
| S-T9 | cliguard.py — 1 negative-control site | consumer | SMS tool; controls-census row |
| S-T10 | dis65816_oracle.py — 4 negative-control sites | consumer | SMS tool; controls-census row |
| S-T11 | exp_airbackdash.py — 1 negative-control site | consumer | SMS tool; controls-census row |
| S-T12 | probe_exp_airdash.lua — 1 negative-control site | consumer | SMS probe; controls-census row |
| S-T13 | probe_exp_airspecial.lua — 2 negative-control sites | consumer | SMS probe; controls-census row |
| S-T14 | probe_exp_roster.lua — 1 negative-control site | consumer | SMS probe; controls-census row |
| S-T15 | probe_juggle.lua — 3 negative-control sites | consumer | SMS probe; controls-census row |
| S-T16 | saturn/checksaturndocs.py — 1 negative-control site | consumer | SMS tool; controls-census row |
| S-T17 | saturn/verify_dspdiff.sh — 1 negative-control site | consumer | SMS tool; controls-census row |
| S-T18 | saturn/verify_wramdiff.sh — 1 negative-control site | consumer | SMS tool; controls-census row |
| S-K1 | checkdocs.py — quote, re-derive from the cartridge, compare, COVERAGE | generalize | → the doc-set KIND's reference driver, comparator and RO1 coverage |
| S-K2 | checksaturndocs.py — the corpus against BOTH cartridges, with controls | generalize | → doc-set kind over two SUBJECT SETs; wrong-subject control (G3) |
| S-K3 | checkpatchmap.py — patch docs vs .bps artifacts, regions disjoint | generalize | → build-artifact kind: set/schema comparator plus re-derived hashes |
| S-K4 | checkknobs.py — the knobs table vs the builders, both directions | generalize | → R1 both ways over the defaults register (BBX-24) |
| S-K5 | checktrainingdocs.py — the training docs vs the Lua package | generalize | → a second doc-set corpus under the same contract (BBX-25) |
| S-K6 | checkskills.py — the rule-ID sets, set-equal both ways, per pair | keep | R2 skills registry (rule ↔ anchor, both ways) |
| S-K7 | dis65816_oracle.py — our table vs an independent one, self-corrupting | keep | §3.3 corroborator + G3 perturbed-copy control; the tables are consumer |
| S-K8 | cliguard.py — tools refuse options they do not define, 12 sabotage cases | keep | D3 REFUSAL, validated in both directions (BBX-2) |
| S-K9 | docaddrs.py — the address census the checks are built on, not a gate | generalize | → the claim inventory and coverage census (RO1); address → ANCHOR |
| S-K10 | health.sh — one command for tree consistency, and not the gate | keep | the runner and READOUT shape (RO1); states its own non-coverage |
| S-K11 | test_regression.lua — 68 cases, detects patches from fingerprints | generalize | → SUITE: scenarios keyed by SUBJECT IDENTITY → expectation set (S2) |
| S-K12 | verify_dspdiff.sh — DETERMINISM / INERTNESS / SENSITIVITY / NEGATIVE | keep | the four-stage harness self-check protocol (O6 + G3) |
| S-K13 | verify_wramdiff.sh — DETERMINISM / SENSITIVITY / NEGATIVE | keep | the same protocol minus inertness; the instrument is consumer |
| S-K14 | verify_saturn.sh — the full headless Saturn gate | consumer | donor gate; its generic clauses are S-C18 and S-C19 |
| S-K15 | test_clash_ground.lua — 7-9 asserted checks per case on the fixture | consumer | game-mechanic gate |
| S-K16 | test_clash_air.lua — asserts both halves of the airborne ruling | consumer | game-mechanic gate; its SETUP-FAIL clause is S-C14 |
| S-G1 | patch_index.md — the one-page patch registry with recorded hashes | generalize | → R2: a deliverable registry carrying each artifact's expectation (E3) |
| S-G2 | tools/README.md — generated tool index, --check verifies sync | keep | R1/R2: a generated registry, complete both ways, never hand-edited |
| S-G3 | checkskills REPO_PAIRS / USER_PAIRS — the rendition registry | keep | R2 skills registry rows |
| S-G4 | EXPECTED_CHECKS = 65 — a check that never runs must fail the suite | keep | G3: controls fired vs declared; the dead-control detector |
| S-G5 | TABLES — 17 tables, each with validator, docs and control shifts | generalize | → G3 grammar: expectation, validator and perturbation in one row |
| S-G6 | SIGS — per-patch fingerprints generated from each builder's own export | generalize | → S2 IDENTITY: identity → expectation-set registry, written at freeze (R3) |
| S-G7 | The four docs maps (docs, game, project, characters READMEs) | keep | BBX-20 / R2 documents registry: reachable from the map |
| S-D1 | SMS_DIST = 64, established by sweeping 62 / 64 / 66 / 68 / 72 | consumer | fixture default; its provenance shape is BBX-24 (S-P22) |
| S-D2 | SMS_DIST old default 56 — clashes on nothing, kept as trap 28's evidence | consumer | superseded fixture default; the lesson is S-I39 |
| S-D3 | SMS_CFRAMES = 180 — the default is a claim about the build under test | generalize | → BBX-24 + E3: a default that must match the subject is an expectation |
| S-D4 | SMS_NEAR = 90 — swept 30-110; below a lead of 75 the run is VOID | consumer | fixture default; VOID-not-pass is G5 (S-C14) |
| S-D5 | HP boundary 153 — act $21 fires at 153/155/157, not at 149/151 | consumer | game fact, measured by sweep |
| S-D6 | The nine-combination air sweep that demoted jump to SETUP-FAIL | consumer | game sweep; the demotion rule is G5 |
| S-D7 | shifts=(1, 2) — the wrong-base offsets every validator must fail at | generalize | → G3 + BBX-24: the control PERTURBATION is a registered default |
| S-D8 | Structural enrolment floor: fails at base+1 and base+2, prints its % | generalize | → E4 + RO1: a claim is admitted with its control and reports specificity |
| S-D9 | REV_S / REV_SS resolved from smspaths, never hardcoded | generalize | → S2/S3: the harness computes the version; a hardcoded one verified an obsolete build |
| S-R1 | [SMS-1] clean ROM SHA-1, HiROM+FastROM, headerless, roster charIDs | consumer | game fact (an instance of S2 SUBJECT IDENTITY) |
| S-R2 | [SMS-2] the engine is data-driven and will faithfully do the wrong thing | consumer | engine fact |
| S-R3 | [SMS-3] the nine-wide-table law | consumer | engine fact |
| S-R4 | [SMS-4] on-hit tables are GLOBAL, strength-class indexed | consumer | engine fact |
| S-R5 | [SMS-5] the attacker's own proc resolves the hit | consumer | engine fact |
| S-R6 | [SMS-6] the step-0 init is a per-handler contract enforced by nothing | consumer | engine fact |
| S-R7 | [SMS-7] act tables are 107-122 entries, not 128 | consumer | game fact |
| S-R8 | [SMS-8] attacks start the frame after action start; inputs latch at 30 Hz | consumer | engine fact |
| S-R9 | [SMS-9] death is HP UNDERFLOW, not zero; damage has no RNG | consumer | engine fact |
| S-R10 | [SMS-10] there are MULTIPLE proc dispatchers | consumer | engine fact |
| S-R11 | [SMS-11] projectiles pick box tables by their OWN object id | consumer | engine fact |
| S-R12 | [SMS-12] $7E:008D mode byte; the vendor Lua comment is wrong | consumer | game fact |
| S-R13 | [SMS-13] practice mode draws NO HUD and the producer never runs | consumer | game fact |
| S-R14 | [SMS-14] in 1P-vs-COM, P1's pad confirms BOTH characters | consumer | game fact |
| S-R15 | [SMS-15] a live round flag does not mean the players can act | consumer | game fact |
| S-R16 | [SMS-16] round transitions re-init both player structs | consumer | engine fact |
| S-R17 | [SMS-17] OBJ palette rows are DYNAMIC, reloaded per effect | consumer | SNES PPU + game fact |
| S-R18 | [SMS-18] headless win-screen reachability | consumer | game fact |
| S-R19 | [SMS-19] $7E:1B1E names the CHARACTER, not the player | consumer | game fact |
| S-R20 | [SMS-20] the win-nameplate font is MATCHUP-LOADED | consumer | game fact |
| S-R21 | [SMS-21] LAW 1: a transition can clear all 64 KB of VRAM | consumer | SNES / engine fact |
| S-R22 | [SMS-22] LAW 2: blank is not unreferenced | consumer | SNES fact; the general form is BBX-7 |
| S-R23 | [SMS-23] LAW 3: DMA is invisible to CPU write callbacks | consumer | SNES / Mesen (same fact as S-P13) |
| S-R24 | [SMS-24] runtime records OVERDRAW baked map text | consumer | engine fact |
| S-R25 | [SMS-25] asset records are [vram16][len16][src24][dest24] | consumer | engine fact |
| S-R26 | [SMS-26] menu glyphs are 2x2 tiles; the kana base differs per screen | consumer | game fact |
| S-R27 | [SMS-27] the stock codec-1 encoder is WEAKER than the original's | consumer | game fact |
| S-R28 | [SMS-28] the bank-$DF engine executes from the $9F mirror | consumer | 65816 / SNES fact |
| S-R29 | [SMS-29] stage names: no terminator, zero-padded, 12-glyph ceiling | consumer | game fact |
| S-R30 | [SMS-30] verify glyph delivery with the POKE positive control | consumer | game fact; the control shape is G3 |
| S-R31 | [SMS-31] text may be on BG3, with its own CHR base and priority bit | consumer | SNES PPU |
| S-R32 | [SMS-32] flags parked in $7F must be MAGIC-VALUED | consumer | SNES fact; the fail-safe form is BBX-7 |
| S-R33 | [SMS-33] $7E:1F60+ is menu-engine state and runs between screens | consumer | game fact |
| S-R34 | [SMS-34] every Lua tool bootstraps sms_env.lua | consumer | Mesen / Lua tooling |
| S-R35 | [SMS-35] never hand-edit the regression suite's SIGS block | consumer | SMS tool; the law behind it is BBX-21 (S-G6) |
| S-R36 | [SMS-36] every chained builder step requires --stacked; smspaths resolves | consumer | SMS build convention |
| S-R37 | [SMS-37] savestates are tracked; screenshots and imagery never are | consumer | SMS repo policy (the incident is S-I46) |
| S-R38 | [SMS-38] button map Y=LP, X=HP, B=LK, A=HK | consumer | game fact |
| S-R39 | [SSP-1] SMS and Super S are the same engine with per-routine shifts | consumer | cross-game fact |
| S-R40 | [SSP-2] engine object ids are SHIFTED: Super S N == SMS N−1 | consumer | cross-game fact |
| S-R41 | [SSP-3] inherited tooling is donor-derived and must be re-validated | consumer | cross-game fact |
| S-R42 | [SSP-4] hash-check which cartridge a trace or dump came from | consumer | donor fact; the generic form is S-C3 / S2 identity |
| S-R43 | [SSP-5] cross-game identity claims are per subsystem, caveats inline | generalize | → D6 + RO2: an equivalence claim is per view and carries its caveats |
| S-R44 | [SSP-6] THE SHELL RULE: a fix keyed to character data works for one shell | consumer | game fact |
| S-R45 | [SSP-7] guard the thing that ARMS, not the things that act | consumer | game fact |
| S-R46 | [SSP-8] structural locks beat mode interrogation | consumer | game fact |
| S-R47 | [SSP-9] a summoned character's palette slots are 4-7 only | consumer | game fact |
| S-R48 | [SSP-10] transfers sized from the SHELL truncate ported data | consumer | game fact |
| S-R49 | [SSP-11] the hidden summon is the only select variant | consumer | game fact |
| S-R50 | [SSP-12] the build grafts a full COPY of the proc bank | consumer | game / patch fact |
| S-R51 | [SSP-13] when stacking, take bank copies AFTER other patches' edits | consumer | patch fact |
| S-R52 | [SSP-14] a donor sentinel record is LIVE data; a 0-length DMA wipes VRAM | consumer | cross-game fact |
| S-R53 | [SSP-15] truncated grafts fail LATE and silently | consumer | game fact |
| S-R54 | [SSP-16] LIFT donor tables rather than authoring where possible | consumer | cross-game fact |
| S-R55 | [SSP-17] only the sprite-attribute byte carries across from the donor | consumer | cross-game fact |
| S-R56 | [SSP-18] stages are SWAPPED, not added | consumer | game fact |
| S-R57 | [SSP-19] the per-character BRR directory is resident from BOOT | consumer | SNES APU / game fact |
| S-R58 | [SSP-20] the relocating uploader adds a DP offset to every destination | consumer | engine fact |
| S-R59 | [SSP-21] her samples have TWO native rates; one set is not the other | consumer | game fact |
| S-R60 | [SSP-22] the driver plays samples as NOTES ON A SCALE | consumer | SNES APU / game fact |
| S-R61 | [SSP-23] borrowing per-player sound ids covers all nine shells | consumer | game fact |
| S-R62 | [SSP-24] Super S ships exactly TWO palettes per character | consumer | cross-game fact |
| S-R63 | [SSP-25] cross-game doc checks: both cartridges, loud SKIP, own controls | generalize | → doc-set kind over two SUBJECT SETs; BBX-1 loud SKIP plus G3 controls |
| S-R64 | [SSP-26] ported blocks are gated byte-identical; the table is oracle-valid | consumer | port gate; the shapes are C1 exact and §3.3 corroboration |
| S-R65 | [SSP-27] port bundles are UNTRACKED; rebuild behind the named gate | consumer | SMS repo / donor-asset policy |
| S-R66 | [SSP-28] ROM is not scarce; ARAM is the only hard wall | consumer | SNES constraint model |
| S-X1 | The HEAD commit body carries the ruling, the hashes and a Gates: line | generalize | → RO1 at commit level: the evidence line travels with the change |
| S-X2 | Commit-subject prefixes: docs 64, p16 33, exp 25, tools 11 | drop | A histogram of commit-subject prefixes at one commit is a snapshot of one repository's working habits at one moment, not a rule, a subject fact or a control, and it is stale at the next commit; nothing in BBX or in SMS depends on it, and the point it makes (documentation is the largest workstream) is already carried by census A19/A20 and by the doc-set rows S-C1..S-C12. |
| S-X3 | traces/ is gitignored; only 30 .mss savestates are tracked | generalize | → FIXTURES are versioned, OBSERVATIONS are transient (D5) |
| S-X4 | build/ tracks only .bps/.ips; a build is reproduced from its patch | generalize | → S2: the SUBJECT SET is derived from a recorded recipe, never stored |
| S-X5 | Two docs are CI-rendered pages, never committed as build output | keep | BBX-21; an instance of S-P24 |
| S-X6 | The nine character pages are generated: do not hand-edit | generalize | → BBX-21 + E4: a generated document is an observation, never its own expectation |
| S-X7 | docs/ is split by lifetime: would this be true to an outsider? | keep | the ancestor of the extraction question (CLAUDE.md §5) |
| S-X8 | The playbook quotes no ROM addresses so the checked docs stay authority | generalize | → E4 / BBX-18: one authority per claim; the unchecked layer quotes nothing checkable |
| S-X9 | claude_code_spec.md — the superseded brief kept as how the map was derived | keep | BBX-20 history twin, in its ancestral form (0 _history.md twins measured, A66) |
| S-X10 | No reference to VampireSaved, bbh or black box exists in the repo | keep | §3.3: the lineage is independent, so SMS corroborates rather than repeats |

## Totals

| bin | rows |
|---|---|
| keep | 72 |
| generalize | 44 |
| consumer | 111 |
| drop | 1 |
| total | 228 |

Row counts, both measured on 2026-09-09:

- bins rows — `grep -cE '^\| S-' docs/bins/sms.md` → **228**
- census B rows — `grep -cE '^\| S-[A-Z][0-9]+ \|' docs/census/sms.md` → **228**
- ids identical and in the same order — `diff <(grep -oE '^\| S-[A-Z][0-9]+ ' docs/census/sms.md | tr -d '| ') <(grep -oE '^\| S-[A-Z][0-9]+ ' docs/bins/sms.md | tr -d '| ')` → empty
- bin column outside the four words — `grep -E '^\| S-' docs/bins/sms.md | awk -F'|' '{gsub(/ /,"",$4); if($4!="keep"&&$4!="generalize"&&$4!="consumer"&&$4!="drop") print}' | wc -l` → **0**

Command: `grep -E '^\| S-' docs/bins/sms.md | awk -F'|' '{gsub(/ /,"",$4); print $4}' | sort | uniq -c`

```
 111 consumer
   1 drop
  44 generalize
  72 keep
```

Drop rows with an empty reason: `grep -E '^\| S-[^|]*\|[^|]*\| drop \| *\|' docs/bins/sms.md | wc -l` → must print 0 (actual output):

```
       0
```
