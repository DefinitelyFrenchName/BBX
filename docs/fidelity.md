# The fidelity plan — the F-series from F12

**Shape: proposal (session 1, 2026-09-09), now partly measured: F13, F14 and F15 run in `gates/fidelity_bbh.sh` and diff empty (2026-09-09); F12, F16–F21 are open.**

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
| **F12** | `example/` on `roms/build-a`, `roms/base`, and the unregistered `roms/hook` (exit 1, "unregistered build fingerprint"); plus `FAKE_NONDET=1` (the NONDETERMINISTIC line) | `FAKE_ROOT=. FAKE_ROMPATH=… bin/bbh run-suite` | the BBX suite runner, same config, driver `fake` | bbh tree | **S2** (corrected 2026-09-09: the suite's verdict lines come from the comparators, which are S2's) |
| **F13** | a synthetic repo of 10 stub gates + MISSING + orphan + emulator gate + NOTE (F13a, plain and `--strict`); `example/` portable tier (F13b), both tiers with `FAKE_ROOT=.` and NOT RUN without it (F13c), `--list` (F13d); the tier classifier `--list`/`--unregistered` and the config `dump` over `example/bbh.toml` (F13e) | `bin/bbh run-static`, `bbh.tier`, `bbh.config` | `bin/bbx-run-static`, `bbx.tier`, `bbx.config` | bbh tree | S1 — **measured 2026-09-09: all 9 pairs identical**, must-fire `verdict-text` fired (`gates/fidelity_bbh.sh`) |
| **F14** | `example/` sweep: `--list`, `--list --scope all --lane all`, `--dry-run --scope all` (log dir normalised), a real `--scope all --strict` run (bbh's example gates under each runner, `BBH_HOME` exported on both sides — G11); F14f the fingerprint over every image in `example/roms` (registry lookup incl. the refused `hook`; `--sha-only`, `--set-key`, `--full`) | `bin/bbh run-sweep`, `bbh.fingerprint` | `bin/bbx-run-sweep`, `bbx.fingerprint` | bbh tree | S1 — **measured 2026-09-09: 12 pairs identical**; the one delta found on the way is a finding about bbh's example (G11), not a fidelity failure |
| **F15** | bbh's own 32 selftests, each run once, its (exit, log) classified by both classifiers | `bin/bbh-classify` | `bin/bbx-classify` | bbh tree; opt-in `BBX_FIDELITY_F15=1` in `gates/fidelity_bbh.sh` (~2–6 min) | S1 — **measured 2026-09-09: 32 selftests, both classifiers agree on every (exit, log)** |
| **F16** | every `.masked` in `example/expected` (10 files, all — no sampling) | `lib/sh/masked_compare.sh` | BBX comparator dispatcher | bbh tree | S2 |
| **F17** | synthetic point-indexed logs covering: exact PASS; flicker PASS with frozen inventory; FAIL-SHORT; first-divergence at exactly n, at n−1, absent; window with a bit-identical pair (must FAIL); composite; a nondeterministic pair | bbh `compare_*.py`, `check_diverge.py`, `describe_masked_shape.py` | BBX temporal family | bbh tree | S2 |
| **F18** | bbh's own skill (87 rules, 9 anchor pages, `skill/skills.toml`) | `bbh check-skills -v`; `bbh skill-guide --check` | BBX skills registry | bbh tree | S5 |
| **F19** | `example/` hygiene: `provenance`, `header-defaults`, `ref-rot`, `gate-index --check` (rendered index byte-compared), `demand-after-trap` | the five `bbh` sub-commands | BBX equivalents | bbh tree | S6 |
| **F20** | VampireSaved through `example/consumers/bbh.vampire.toml` (private copy, root substituted) — the rows bbh's own F1, F3, F4, F5 (sampled every 4th), F6, F7, F9, F10 exercise | bbh's `test_fidelity_vampire.sh` output | BBX run over the same inputs; the *three-way* diff bbh = BBX = VS | bbh + VS trees (~65 s in bbh's measurement) | S7 |
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
