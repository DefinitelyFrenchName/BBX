# The fidelity plan — the F-series from F12

**Shape: proposal (session 1, 2026-09-09), now partly measured: F13, F14 and F15 run in `gates/fidelity_bbh.sh` and diff empty (2026-09-09); F12, F16 and F17 run in `gates/fidelity_bbh_s2.sh` and diff empty (2026-09-10); F18 runs in `gates/fidelity_bbh_s5.sh` and diffs empty (2026-09-14); F19 runs in `gates/fidelity_bbh_s6.sh` and diffs empty (2026-09-15); F20 and F21 remain.**

## The obligation

bbh is not modified and is not served; it is the proof that nothing was lost
(CLAUDE.md §2, §7.2). When BBX is pointed at bbh's own fake machine and example
consumer it must produce bbh's verdicts byte for byte — the same way bbh proved
itself against VampireSaved with F1–F11 (`~/Developer/blackbox-harness/selftest/test_fidelity_vampire.sh`,
`test_fidelity_mame.sh`; `docs/census/bbh.md` rows F1–F11).

## The baseline (ruling R8)

- bbh at HEAD **f675710** (`git -C ~/Developer/blackbox-harness rev-parse --short HEAD`,
  measured 2026-09-09). The working tree carries 4 uncommitted modifications
  (`docs/config.md`, `example/consumers/bbh.vampire.toml`, `lib/py/bbh/config.py`,
  `selftest/test_fidelity_vampire.sh`; `git diff --stat` → 4 files, 6 insertions,
  6 deletions). BBX never touches them; the fidelity gate prints the bbh
  commit *and* its porcelain state at the head of every run, so a run against
  a moved bbh is visibly a different measurement.
- VampireSaved at HEAD **5df1d8be** for the transitive row F20.
  2026-09-09 (bbx-2): VampireSaved moved to `0cdd9726` (two commits: its
  `STATE.md` and one re-frozen expectation, `tests/expect/mister_prg_window.txt`);
  the census was re-measured there (`docs/census/vampiresaved.md`, last line).
  F20 is not written yet, so no row moved; when F20 is written its baseline is
  the HEAD measured that day, recorded here as a dated line.
- 2026-09-09 (bbx-2, ruling R20): the gate measures bbh on a PLAIN LOCAL CLONE
  of `f675710` under `TMPDIR` (`BBX_BBH_BASELINE`, D20), never in bbh's working
  tree; after the run the clone must be clean of tracked, untracked and
  ignored changes. Measured before ruling: every F13–F15 line identical on the
  clone and in place, so the 4 dirty files touch no row yet (they re-point
  VampireSaved build directories: F20's concern). bbh's tip past the baseline
  is `NOTE: bbh-drift ahead=N`; `BBX_FIDELITY_IN_PLACE=1` keeps the dirty tree
  as the input on purpose, read-only declared and proved on tracked paths.
- bbh is located by an environment variable (`BBX_BBH_HOME`), never a
  submodule `[BBH-85]`; when absent every F row SKIPs, and a SKIP is reported
  as *not proved*, never as green `[BBH-16]`.

## The mechanism (inherited verbatim from bbh, `test_fidelity_vampire.sh:76,292-296`)

1. Capture both sides as strings, the exit status appended as a line
   (`…; echo "exit=$?"`), so the exit is diffed too.
2. Normalise durations only: `sed -E 's/ +[0-9]+s( |$)/ Ns\1/g'`. Nothing else.
3. String-compare; on mismatch print `diff … | head -12`.
4. The lineage root is an INPUT substituted into a private copy of the
   consumer config `[BBH-66]` — never an environment override inside the
   resolver.
5. Every run prints the newest line of `docs/rebaselines.md` `[BBH-83]`; a
   verdict-text change lands on both sides in one sitting with a dated line.

## The rows

| F | input | bbh side | BBX side | needs | slice |
|---|---|---|---|---|---|
| **F12** | `example/` on `roms/build-a`, `build-b`, `base`, `attract`, and the unregistered `roms/hook` (exit 1, "unregistered build fingerprint"); `FAKE_NONDET=1` (the NONDETERMINISTIC line, the diff head's random hashes normalised) and `FAKE_CRASH_AT=50` (RUN-FAIL); a perturbed copy (a wrong `.sha1`, a deleted expectation, a moved inventory, a `.pending`, a moved `.diverge`, the mask guard); `SUITE_ONLY`; a `POKES` in the environment; the input demand; a set that resolves nowhere; `--freeze` twice on a copy per side | `FAKE_ROOT=. FAKE_ROMPATH=… bin/bbh run-suite` | `bin/bbx-run-suite`, the same config, the driver bbh's `fake` through the frame-driven profile's driver home (R26) | bbh tree (plain clone, R20) | S2 step 3 — **measured 2026-09-10: 17 pairs identical**, must-fire `verdict-text-f12` fired (`gates/fidelity_bbh_s2.sh`, ~70 s with F16 and F17) |
| **F13** | a synthetic repo of 10 stub gates + MISSING + orphan + emulator gate + NOTE (F13a, plain and `--strict`); `example/` portable tier (F13b), both tiers with `FAKE_ROOT=.` and NOT RUN without it (F13c), `--list` (F13d); the tier classifier `--list`/`--unregistered` and the config `dump` over `example/bbh.toml` (F13e) | `bin/bbh run-static`, `bbh.tier`, `bbh.config` | `bin/bbx-run-static`, `bbx.tier`, `bbx.config` | bbh tree | S1 — **measured 2026-09-09: all 9 pairs identical**, must-fire `verdict-text` fired (`gates/fidelity_bbh.sh`) |
| **F14** | `example/` sweep: `--list`, `--list --scope all --lane all`, `--dry-run --scope all` (log dir normalised), a real `--scope all --strict` run (bbh's example gates under each runner, `BBH_HOME` exported on both sides — G11); F14f the fingerprint over every image in `example/roms` (registry lookup incl. the refused `hook`; `--sha-only`, `--set-key`, `--full`) | `bin/bbh run-sweep`, `bbh.fingerprint` | `bin/bbx-run-sweep`, `bbx.fingerprint` | bbh tree | S1 — **measured 2026-09-09: 12 pairs identical**; the one delta found on the way is a finding about bbh's example (G11), not a fidelity failure |
| **F15** | bbh's own 32 selftests, each run once, its (exit, log) classified by both classifiers | `bin/bbh-classify` | `bin/bbx-classify` | bbh tree; opt-in `BBX_FIDELITY_F15=1` in `gates/fidelity_bbh.sh` (~2–6 min) | S1 — **measured 2026-09-09: 32 selftests, both classifiers agree on every (exit, log)** |
| **F16** | every `.masked` in `example/expected` (10 files, all — no sampling) against logs the fake driver writes on the clone (F16a); the dispatcher's synthetic ground truth — every class both ways, the two mask-guard shapes, the unknown class, the mask default three ways (F16b); the kind enumeration over `build-a`, `attract` and a tree with a `.pending` and an unknown kind (F16c) | `lib/sh/masked_compare.sh` `masked_check` / `masked_mask_for`; `lib/sh/enumerate_expectations.sh` | `lib/sh/compare.sh` `compare_temporal` / `compare_check` / `compare_mask_for`; `lib/sh/expectation_kinds.sh` | bbh tree (plain clone, R20) | S2 step 2 — **measured 2026-09-10: 35 pairs identical** (11 + 21 + 3; 10 fake-driver runs), must-fire `verdict-text-f16` fired (`gates/fidelity_bbh_s2.sh`, 11 s with F17) |
| **F17** | synthetic point-indexed logs covering: exact PASS; flicker PASS with frozen inventory; FAIL-SHORT; first-divergence at exactly n, at n−1, absent; window with a bit-identical pair (must FAIL); composite; a nondeterministic pair | bbh `compare_*.py`, `check_diverge.py`, `describe_masked_shape.py` | BBX `compare_*.py`, `check_diverge.py`, `propose_temporal.py` | bbh tree (plain clone, R20) | S2 step 1 — **measured 2026-09-10: 52 pairs identical** (13 flicker, 9 window, 15 composite, 6 first-divergence, 9 proposer; the consumer override with its R25 ruling rows included), must-fire `verdict-text-f17` fired (`gates/fidelity_bbh_s2.sh`, 5 s) |
| **F18** | bbh's own skill (`skill/skills.toml`: 87 rules at `10a82d2`, 91 at bbh's tip `f4094c2`; 9 anchor pages, 12 logs, 33 forbidden tokens — measured 2026-09-14, bbx-26) | `bbh check-skills --config skill/skills.toml -v`; `bbh skill-guide --config skill/skills.toml --check` (without `--config` and with `BBH_CONFIG` unset both tools read no config at all — every key at its default, `[skills].prefixes` empty — and exit 2 naming no skill; measured bbx-26 on a clone of `10a82d2`) | `bin/bbx check-skills` / `bin/bbx skill-guide` (the lifted lock and generator) over the same inputs; F18b bbh's synthetic test consumer and its perturbations, F18c the lock's selftest, F18d VampireSaved's eight skills at `0cdd9726` (R56) | bbh tree (plain clone, R20); VampireSaved clone for F18d | S5 step 1 — **measured 2026-09-14 (bbx-26): 26 pairs identical** (F18a 8, F18b 14, F18c 2, F18d 2; 2 regenerated guides byte-identical), must-fire `verdict-text-f18` fired (`gates/fidelity_bbh_s5.sh`, 9 s); **re-measured after S5 step 2's two deltas: 26 pairs identical** (R54: fidelity-neutral, as measured before the build — none of the 642 definitions F18 reads continues onto a second line); **S5 step 4 (bbx-27): 26 pairs still identical, and every `[BBH-N]` BBX's generated skill cites is resolved against bbh's skill on the same clone at `10a82d2` — `bbh-citations cited=6 distinct=6 defined_in_bbh=87 unresolved=0`, control `unresolved-bbh-citation` fired (R56)** |
| **F19** | `example/` hygiene at bbh `10a82d2`, as measured at bbx-28 on a plain clone: the example's hygiene gate runs four sub-commands — `provenance`, `header-defaults`, `ref-rot`, `gate-index --check` (`example/tests/g_hygiene.sh:13`) — and `demand-after-trap` is a fifth it does not run; `gate-index --check` compares decoded text (`lib/py/bbh/gen_gate_index.py:178`: a CRLF copy of the committed index passes, one appended line fails); the example's rendered index differs between `10a82d2` (`12 scripts` on its `ok` line) and bbh's tip `e7d6767` | the five `bbh` sub-commands, unchanged from `10a82d2` to `e7d6767` | `bin/bbx gate-index` and `bin/bbx demand-after-trap` (R63, R68); `header-defaults`, `ref-rot` and the markdown `provenance` binned consumer | bbh tree (plain clone, R20) | S6 — **measured 2026-09-15 (bbx-30): 19 pairs identical** in `gates/fidelity_bbh_s6.sh` — F19a 14 (bbh's example: its committed index under `--check` and `--stdout`, three perturbed copies, the index each side writes; and the eight cases of bbh's selftest root), F19b 5 (the example's `tests/` and the four selftest cases); control `verdict-text-f19`, one changed string in each lifted tool |
| **F20** | VampireSaved through `example/consumers/bbh.vampire.toml` (private copy, root substituted) — the rows bbh's own F1, F3, F4, F5 (sampled every 4th), F6, F7, F9, F10 exercise; **when written, BBX-25's scope and status are gone over again** (the maintainer's rider on S4's DONE ruling, 2026-09-14): VampireSaved is the candidate second consumer of the temporal family inside BBX, measured then and never assumed (`docs/generality.md`, R50) | bbh's `test_fidelity_vampire.sh` output | BBX run over the same inputs; the *three-way* diff bbh = BBX = VS | bbh + VS trees (~65 s in bbh's measurement) | S7 |
| **F21** (opt-in) | bbh's F8a–h through BBX's frame-driven kind with the real MAME/FBNeo drivers | `test_fidelity_mame.sh` | BBX | ROMs, a pinned MAME, FBNeo — SKIP otherwise, reported as *not covered* | S7 |

Rows F13–F15 are the first slice's DONE condition (CLAUDE.md §7.2): until they
diff empty, nothing in BBX is described as generic. **F13 (9 pairs), F14 (12
pairs) and F15 (32 logs) diff empty, 2026-09-09.**

## What fidelity does NOT prove

- bbh's own correctness — fidelity locks *equivalence*, and a bbh defect
  reproduced exactly is a green fidelity row (`[BBH-82]`: a delta is a finding
  about the consumer, never fixed by weakening the stronger copy).
- Anything about the document-set or command-line kinds: they have no
  ancestor to diff against. Their proof is the fixture and its controls
  (`docs/generality.md`).
- F21 unless it runs; the readout says so every time it SKIPs.

## The re-baseline register

`docs/rebaselines.md` exists from commit one with a header and no entries. A
verdict-text or classifier change on either side is a dated line here, the
same commit as the re-baseline, bbh's commit pushed first `[BBH-83]`.
