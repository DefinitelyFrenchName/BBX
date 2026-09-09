# The fidelity plan — the F-series from F12

**Shape: proposal (session 1, 2026-09-09). Status: UNRATIFIED; no row runs yet.**

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
| **F12** | `example/` on `roms/build-a`, `roms/base`, and the unregistered `roms/hook` (exit 1, "unregistered build fingerprint"); plus `FAKE_NONDET=1` (the NONDETERMINISTIC line) | `FAKE_ROOT=. FAKE_ROMPATH=… bin/bbh run-suite` | the BBX suite runner, same config, driver `fake` | bbh tree | S1 |
| **F13** | `example/` portable tier, and static tier with `FAKE_ROOT=.` | `bin/bbh run-static` | BBX static runner | bbh tree | S1 |
| **F14** | `example/` sweep: `--list`, `--dry-run`, `--scope all` | `bin/bbh run-sweep` | BBX sweep runner | bbh tree | S1 |
| **F15** | bbh's own 32 selftests | `selftest/run.sh` tally (`PASS / SKIP / FAIL` + the closing sentence) | the 32 scripts classified by BBX's classifier, same tally | bbh tree (~6 min with VS present; the fidelity selftests SKIP without it and the tally line differs accordingly — both tallies are captured under the same conditions) | S1 |
| **F16** | every `.masked` in `example/expected` (10 files, all — no sampling) | `lib/sh/masked_compare.sh` | BBX comparator dispatcher | bbh tree | S2 |
| **F17** | synthetic point-indexed logs covering: exact PASS; flicker PASS with frozen inventory; FAIL-SHORT; first-divergence at exactly n, at n−1, absent; window with a bit-identical pair (must FAIL); composite; a nondeterministic pair | bbh `compare_*.py`, `check_diverge.py`, `describe_masked_shape.py` | BBX temporal family | bbh tree | S2 |
| **F18** | bbh's own skill (87 rules, 9 anchor pages, `skill/skills.toml`) | `bbh check-skills -v`; `bbh skill-guide --check` | BBX skills registry | bbh tree | S5 |
| **F19** | `example/` hygiene: `provenance`, `header-defaults`, `ref-rot`, `gate-index --check` (rendered index byte-compared), `demand-after-trap` | the five `bbh` sub-commands | BBX equivalents | bbh tree | S6 |
| **F20** | VampireSaved through `example/consumers/bbh.vampire.toml` (private copy, root substituted) — the rows bbh's own F1, F3, F4, F5 (sampled every 4th), F6, F7, F9, F10 exercise | bbh's `test_fidelity_vampire.sh` output | BBX run over the same inputs; the *three-way* diff bbh = BBX = VS | bbh + VS trees (~65 s in bbh's measurement) | S7 |
| **F21** (opt-in) | bbh's F8a–h through BBX's frame-driven kind with the real MAME/FBNeo drivers | `test_fidelity_mame.sh` | BBX | ROMs, a pinned MAME, FBNeo — SKIP otherwise, reported as *not covered* | S7 |

Rows F12–F15 are the first slice's DONE condition (CLAUDE.md §7.2): until they
diff empty, nothing in BBX is described as generic.

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
