# STATE_HISTORY — what was true at each close

Shape: history twin of `STATE.md` (BBX-20); append-only; one paragraph per
sitting under its session key, the outgoing status paragraph verbatim.
Never rewritten; a correction is marked in place. Born at the bbx-1 close,
2026-09-09 (ruling R17).

## bbx-1 — 2026-09-09 (session 1: the census, the rulings, slice S1 steps 1–3)

**Status:** slice S1, steps 1–3 done (2026-09-09): the kernel exists and
BBX validates BBX — `bin/bbx selftest` is GREEN (9 gates, 12/12 controls
fired, 117 s); fidelity F13 (9 pairs), F14 (12 pairs) and F15 (32 logs)
diff empty against bbh (`docs/readout.md`, sections 3–4). In the tree:
`bin/bbx` (`run-static`, `run-sweep`, `classify`, `tier`, `config`,
`controls`, `fingerprint`, `recount`, `selftest`), `lib/sh/{classify,
config,registry}.sh`, `lib/py/bbx/{toml_subset,config,tier,controls,
fingerprint,recount}.py`, `bbx.toml` (the `self` kind), nine gates under
`gates/` with three registries, `docs/controls.md`, `docs/defaults.md`
D1–D16. No comparator, no suite runner, no expectation register, no
driver, no fixture yet.

Close tally (`bin/bbx selftest`, alone): `PASS 9     SKIP 0     FAIL 0     MISSING 0`;
`controls fired 12 / declared 12; gates with no declaration: 0; red: 0`.

## bbx-2 — 2026-09-09/10 (session 2: R18–R20, the readout generator, the close sweeps gate)

**Status (bbx-2, step 4, 2026-09-09):** the sitting opened red (VampireSaved
had moved; census re-measured at `0cdd9726`, G12); the maintainer ruled
R18–R20 and all three landed: `bbx-run-sweep --jobs N` is a pull queue (a
FIFO of slot tokens, 14z-144) with `[sweep].clone_per_slot` for a plain
clone of HEAD per worker (D21); the recount and the fidelity gate measure a PLAIN
LOCAL CLONE of the recorded commit under `TMPDIR` (never a lineage's working
tree; a moved lineage is a `drift` NOTE; the clone is proved clean after the
run, ignored paths included), and the rulings queue has a shape gate
(`rulings_shape`, G14). S1's readout generator exists: `bin/bbx selftest --log DIR` keeps a run and
`bin/bbx readout DIR --against DIR2` prints the one screen from it, blind
spots coming from every gate's `NOT-ASSERTED:` header. `bin/bbx selftest` is
GREEN twice at one HEAD (BBX-14 met): 11 gates, 23/23 controls fired,
~219 s on a loaded host. Fidelity F13 (9 pairs), F14 (12
pairs) and F15 (32 logs) diff empty against bbh f675710 on the clone. In the
tree: `bin/bbx` (`run-static`, `run-sweep`, `classify`, `tier`, `config`,
`controls`, `fingerprint`, `recount`, `selftest`), `lib/sh/`, `lib/py/bbx/`,
`bbx.toml` (the `self` kind), eleven gates under `gates/` with three
registries, `docs/controls.md`, `docs/defaults.md` D1–D22. No comparator,
suite runner, expectation register, driver or fixture yet.

Close tally (`bin/bbx selftest --log`, twice, alone): `PASS 12    SKIP 0     FAIL 0     MISSING 0`;
`controls fired 26 / declared 26; gates with no declaration: 0; red: 0`; BBX-14 met (0 verdict differences).

## bbx-3 — 2026-09-10 (session 3: the NOTE fix; S2 planned, STOPPED, ruled; S2 steps 1–3)

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

## bbx-4 — 2026-09-10 (session 4: S2 step 4, the suite screen, S2 complete)

**Status (bbx-4 close, 2026-09-10):** slice S2 COMPLETE (its readout in
`docs/readout.md`); slice S1 complete but for the platform run (R21). This
sitting: step 4 on R24 — `lib/py/bbx/provenance.py` (the TOML register,
R11's eight classes, complete both ways, `testimony` and `fixture` named as
not evidence), `gates/provenance.sh`; the readout's suite screen (findings
apart, the register's histogram, the real pairings by file) and the kept
run's untracked count on the tree line (G17's mechanism); D31, D32. bbh
moved to `10a82d2` at the open (G11 fixed in bbh, its four dirty files
committed); both fidelity gates PASS against it by the D20 override; R28
raised to re-baseline. `bin/bbx selftest` GREEN twice at one HEAD (BBX-14
met): 19 gates, 55/55 controls, ~6 min. Fidelity F12 (17), F16 (35), F17
(52) diff empty on the plain clone at `f675710`, beside F13–F15. Defaults
D1–D32. Gotchas G1–G18. In the tree beyond S1: the temporal family, the one
dispatcher, the kinds table, the suite with its kept run, the register tool.
No driver of BBX's own; no fixture subject; no consumer with a register.

## bbx-5 — 2026-09-10 (session 5: the re-baseline as a procedure; R29 raised, R30 built)

**Status (bbx-5 close, 2026-09-10):** slices S1 (but for R21's platform run)
and S2 complete. This sitting: the re-baseline of bbh to `10a82d2` as a
PROCEDURE (R28 answered and reclassified by the maintainer: R8/R20 applied,
never a queue entry) — measured first by the D20 override, then both fidelity
gates' default, D20, D12's five literals by definition, the dated line in
`docs/rebaselines.md`, the census re-measured (A2 19 → 20), G11 closed as
fixed in bbh. Two findings raised from bbh's own must-fire work: R30 ruled
and built (the gate header is the LEADING COMMENT BLOCK; one reader,
`controls.py`, imported by the readout; `body-is-not-header` control), R29
raised and open (executable controls — the runner drives each declared
control on the gate's real path and requires its own FAIL; recommended for
S6). `bin/bbx selftest` GREEN twice at one HEAD (BBX-14 met): 19 gates,
56/56 controls. Fidelity F12–F17 diff empty on the plain clone at
`10a82d2`. bbh's tip `447e5d2` (README: the remote renamed BBH-frame-based),
a NOTE. Defaults D1–D32. Gotchas G1–G18.

## bbx-6 — 2026-09-10 (session 6: S3 planned and STOPPED for R31–R34; G19, the generated sentence that outlived its slice)

**Status (bbx-6 close, 2026-09-10):** slices S1 (but for R21's platform run)
and S2 complete; **S3 planned and STOPPED** for rulings R31–R34
(`docs/plans/S3.md`): the document-set kind, the first slice with no ancestor
to diff against — the two ancestors (SMS `checkdocs.py`, VampireSaved
`checkdocs_rom.py`) measured on plain clones at their census commits, nothing
lifted verbatim, the SHAPE lifted (quote, derive, compare; a control per
check family; coverage printed and frozen shrink-only, never fatal; a
paraphrase declared, never skipped); the fixture `fixture/docset/` designed
as BBX's second consumer; fourteen controls in five gates named; the three
families (`exact`, `set`, `schema`) plugging into R23's kinds table. No tool
written. One rot found at the open and fixed (G19: the static screen's
generated sentence "the register is slice S2; until then …" outlived S2 by
two closes; the gate held only its prefix) — the first re-anchor of BBX-10.
`bin/bbx selftest` GREEN twice at one HEAD (BBX-14 met): 19 gates,
56/56 controls. Fidelity F12–F17 diff empty on the plain clone at
`10a82d2`. bbh's tip `447e5d2`, a NOTE. Defaults D1–D32. Gotchas G1–G19.

## bbx-7 — 2026-09-10 (session 7: S3 step 1 — the document-set profile, the scenario extension, the fixture)

**Status (bbx-7 close, 2026-09-10):** slices S1 (but for R21's platform run)
and S2 complete; **S3 step 1 built** (`docs/plans/S3.md` §8.1; R31–R34
answered, R34's TOML revision validated at this open): the `document-set`
kind profile (D33), `[suite].scenario_ext` per kind (D34, R32) read by the
suite loop and the enumeration helper, the fixture generator
`fixture/docset/mkdocset.py` with `--check` and ten named chirality
predicates (D35–D37), the fixture `fixture/docset/` as BBX's second consumer
(the artifact, three documents, three claim sets, nine expectations — every
register row `fixture` — the registry row on the whole-set key), and
`gates/docset_fixture.sh` (3 controls, portable). Built in a shadow tree
first, which caught one defect before the tree saw it. No driver, no
`set`/`schema`/`exact` comparator, no `.truth` kind yet (steps 2–4).
`bin/bbx selftest` GREEN twice at one HEAD (BBX-14 met): 20 gates,
59/59 controls. Fidelity F12–F17 diff empty on the plain clone at `10a82d2`
after the loop change (104 pairings). bbh's tip `447e5d2`, a NOTE. Defaults
D1–D37. Gotchas G1–G19.

## bbx-8 — 2026-09-10 (session 8: S3 step 2 — the extractor, the driver, the truth kind, the driver gate)

**Status (bbx-8 close, 2026-09-10):** slices S1 (but for R21's platform run)
and S2 complete; **S3 steps 1 and 2 built** (`docs/plans/S3.md` §8.1–8.2;
R31–R34 answered). Step 2: the extractor `lib/py/bbx/docset.py` (quote from
the document, derive from the artifact, bind; the closed status vocabulary
D37; the two strings and the token defined once, D38; the lexical classes and
the record key, D39; the unlisted-claim guards, D40; a self-test on synthetic
lines every run), the driver `drivers/docset.sh` (bbh's four arguments;
`DOCSET_PATH`; REFUSED exit 3 on a form no extractor implements, on
`DOCSET_VIEW`, `DOCSET_FORMS` and the frame-driven and guard families; exit 1
DISCARDED), `drivers/README.md`, the generator writing the `truth` kind from
the DESIGN (`expected/fixture/<s>.truth` + `logs/<s>.log`, register rows
`fixture`), and `gates/docset_driver.sh` (7 controls, portable). Built in a
shadow tree first, which caught one defect (G20) before the tree saw it; the
plan's shifted-artifact prediction corrected in its own commit (G21, X9).
Every scenario's log equals the design's truth byte for byte, twice
(`01_all` END 23, `02_weights` END 7, `03_rows` END 7; coverage 20/23 on
`01_all`). No `set` / `schema` / `exact` comparator, no suite loop over the
kinds yet (steps 3–4). `bin/bbx selftest` GREEN twice at one HEAD (BBX-14
met): 21 gates, 66/66 controls. Fidelity F12–F17 diff empty on the
plain clone at `10a82d2` (104 pairings). bbh's tip `447e5d2`, a NOTE.
Defaults D1–D40. Gotchas G1–G21. Retractions X1–X9.

## bbx-9 — 2026-09-10 (session 9: S3 step 3 — the exact, set and schema families; G22, G23)

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

## bbx-10 (2026-09-10)

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

## bbx-11 (2026-09-10)

**Status (bbx-11 close, 2026-09-10):** slices S1 (but for R21's platform run)
and S2 complete; **S3 steps 1–5 built** (`docs/plans/S3.md` §8.1–8.5;
R31–R34 answered) — **S3 is laid before the maintainer for the DONE ruling**
(CLAUDE.md §7's six conditions answered one by one in `docs/readout.md`, the
bbx-11 section; the contributor's reading: all six hold for the document-set
kind AS A FIXTURE). Step 5 wrote no tool: the slice readout — comparator
families per kind measured off the kinds tables (document-set 3: exact / set
/ schema; frame-driven 1: temporal), controls declared / fired per gate off
the kept run (the four S3 gates 21 / 21; the plan's design said fourteen),
the fixture register's 16 rows (fixture 15, registry 1), the defaults
D33–D44 by class (principled 6, ruled 2, arbitrary 2, split 2) — and the
first shared-vs-kind-specific FILE CENSUS, `docs/census/bbx_files.md`,
measured at runtime in a shadow tree (37 harness files: 11 executed by both
kinds' gates, 7 + 7 by one kind only, 5 + 3 by one kind and the kernel, 4 by
the kernel only, 0 by no gate; gates K 13 / F 6 / D 4), **measured once, not
gated** — the generator is in the census's §C and the gate is S4's plan to
decide. The plan's §6 screen line corrected in its own commit (X12, BBX-19).
G25: the instrument's first version ended every header (R30) and
`gates/docset_suite.sh` caught it in the shadow (paid 1 shadow gate run).
`bin/bbx selftest` GREEN twice at one HEAD (BBX-14 met): 23 gates, 78/78 controls (`build/selftest_20260910T141218Z`, `build/selftest_20260910T142107Z`).
Fidelity F12–F17 diff empty on the plain clone at `10a82d2` (104 pairings;
F13/F14 21). bbh's tip `447e5d2`, a NOTE. Defaults D1–D44. Gotchas G1–G25.
Retractions X1–X12.
