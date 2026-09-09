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
