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

