# Census — BBX's own harness files, by the kind of the gates that RUN them

`/Users/koneko/Developer/generalized-blackbox-harness/BBX` · the shared-vs-kind-specific FILE
CENSUS (`docs/generality.md` "What the proof measures"; `docs/plans/S3.md` §6, §8.5;
`docs/plans/S4.md` §8.6) · **GENERATED and GATED since bbx-19** (S4 step 6, ruled R39).

Shape: census. Its §A and §B are **generated** by `bbx file-census` and never hand-edited
(BBX-21); everything outside the `GENERATED` markers is prose. Two gates hold it:

| gate | tier | what it holds | runtime |
|---|---|---|---|
| `gates/file_census_tool.sh` | portable, every battery | the INSTRUMENT on a synthetic harness tree: the trace, the insertion point (G25 as a mode), the document check, the frozen register in every direction, and that the two writers of the subject's identity agree | ~13 s |
| `gates/file_census.sh` | `gates/sweep.tsv`, release scope (D63) | the MEASUREMENT on BBX's own tree: no file reached by no gate, no kind-set shrunk, this document byte-identical to the run | ~20 min |

Until bbx-19 this page was **measured once and not gated** — a scratchpad instrument run by hand
at bbx-11, recorded verbatim in this file's §C and reproduced in `docs/readout.md`'s bbx-11
section, which is where those numbers now live as history. The honest floor was for one sitting;
a number that is not gated rots (BBX-10).

## The question and the method

Which harness files are executed by gates of ONE subject kind and which by more (BBX-25: a
generic thing needs two instances). Measured at RUNTIME, not by reading: a shadow git tree is
built from HEAD (`git archive`), every `bin/*`, `drivers/*.sh` and `lib/sh/*.sh` gets one line
that appends its own path to a trace file — inserted AFTER the leading comment block, never
after the shebang (gotcha G25: the first run inserted it after the shebang, which ENDED the
header under R30, and `gates/docset_suite.sh` went red because the readout found no
`NOT-ASSERTED:` line in the driver; that run's trace was discarded and the generator corrected).
`lib/py/sitecustomize.py` appends every `lib/py/bbx/*.py` module loaded, and a module run as a
script, at interpreter exit. Every registered gate then runs once, alone, with a fresh trace,
`BBX_BBH_HOME` set so the static tier runs; each gate's log is classified by BBX's own
classifier. **A gate that is not PASS in the shadow contaminates its trace: the run is REFUSED
and discarded, never adjusted** (§1).

**A gate's KIND is derived from its trace, not from its vocabulary.** A grep over the gates'
text mis-files them, measured twice and declined twice: at bbx-11 on the word `masked`
(`gates/readout.sh`, `gates/provenance.sh` and `gates/expectation_kinds.sh` read as
frame-driven because their synthetic fixtures carry it), and again at bbx-19 on a rule that reads
each gate's consumer configs — FIVE of 29 gates wrong, `gates/config.sh` and `gates/readout.sh`
frame-driven on a synthetic `bbh.toml` and `gates/temporal.sh`, `gates/thresholds.sh`,
`gates/compare_dispatch.sh` kernel because they call the temporal comparators with no consumer
config at all. The trace is the instrument; the text is a witness (BBX-28).

A gate is **F** (frame-driven), **D** (document-set) or **C** (command-line) when it executed a
SEED of that kind, and **K** (kernel — BBX as its own subject) otherwise. Both halves are
DERIVED from the tree every run, where bbx-11 hand-listed them (BBX-9):

* a **seed** is a harness file one kind profile names and no other: the modules its comparator
  families reach (the families from `[expectations].kinds`, the modules from `lib/sh/compare.sh`'s
  own dispatch case followed through the functions it calls), the module its `[suite].log_summary`
  names, its `[suite].driver`, and the driver of every tracked consumer config of that kind. A
  file two kinds name is no seed, so `compare_set.py` and `compare_schema.py` correctly stopped
  discriminating the moment the command-line kind registered them — where a hand list would have
  gone on claiming them for the document set.
* **F also** covers a gate in the static registry whose body, comments stripped, names
  `[registries].static_needs_env`: it needs the lineage tree, which is the frame-driven kind's
  SUBJECT. Measured 2026-09-12, this reproduces bbx-11's hand list exactly — `fidelity_bbh` 4
  mentions, `fidelity_bbh_s2` 5, `suite` 10, `census_recount` 0.
* **the explainer rule.** The trace's python half records what a process LOADED, not what it ran,
  so a seed hit can be a shared module's import side effect. Measured at bbx-19:
  `compare_exact.py` and `compare_set.py` both import `docset.py`, so the document-set seed fired
  on `gates/adapters.sh`, a command-line gate, and it read `DC`. A seed hit therefore counts only
  when nothing else in the same trace imports it. bbx-11 could not have seen this: with two kinds,
  every gate that ran the exact family WAS a document-set gate — the third kind is the detector,
  which is BBX-25's own argument about itself.

The census is keyed by the **harness identity**, not by `HEAD`: R38's whole-set key, the tree
hash of `bin`, `lib`, `drivers` and `gates` hashed into one, the same key
`fixture/selfgates/idkey.sh wholeset` computes for the self subject and which the portable gate
proves the two writers agree on. `HEAD` is the wrong key for a census that lives in the tree it
describes — the commit that writes this page would move it, and `--check` would fail on its own
output for ever after (measured at bbx-19 as the new gate's first red; D62).

<!-- GENERATED by `bbx file-census`: BEGIN. Never hand-edited (BBX-21). -->

**Measured at harness identity `af2b1f08507068b3f5074067fb985515a4d7ec4f`** (R38's whole-set key over `bin`, `lib`, `drivers`, `gates` — NOT `HEAD`, so a commit that only rewrites this document leaves it checkable) over 45 tracked files under `lib/`, `bin/`, `drivers/` (`*.md` excluded) and 31 gates, each run ONCE in the shadow with a fresh trace. `bbx file-census --check` fails on any line below. **1 gate(s) SKIPPED in the shadow** and so under-report what they reach: `census_register`.

## A. Counts

| id | dimension | count | command / derivation |
|---|---|---|---|
| A1 | tracked files under lib/, bin/, drivers/ (README.md excluded) — the universe | 45 | `git ls-files lib bin drivers | grep -vc '\.md$'` |
| A2 | registered gates (both tiers) | 31 | `grep -hv '^#' gates/portable.txt gates/static.txt | wc -l` |
| A3 | gates run in the shadow, each once, alone, with a fresh trace | 31 | §B.1, one row each |
| A4 | harness files instrumented (one trace line each) | 16 | §C: every `bin/*`, `drivers/*.sh`, `lib/sh/*.sh` plus `lib/py/sitecustomize.py` |
| A5 | gates whose derived kind is `C` | 6 | §B.1 |
| A6 | gates whose derived kind is `D` | 4 | §B.1 |
| A7 | gates whose derived kind is `F` | 6 | §B.1 |
| A8 | gates whose derived kind is `K` | 15 | §B.1 |
| A9 | files: shared (frame AND document-set AND command-line) | 11 | §B.2 |
| A10 | files: frame-driven and command-line | 4 | §B.2 |
| A11 | files: document-set and command-line | 11 | §B.2 |
| A12 | files: frame-driven only | 8 | §B.2 |
| A13 | files: frame-driven only (+kernel) | 1 | §B.2 |
| A14 | files: document-set only | 1 | §B.2 |
| A15 | files: command-line only | 5 | §B.2 |
| A16 | files: kernel only | 4 | §B.2 |
| A17 | files: REACHED BY NO GATE | 0 | §B.2 |
| A18 | files executed by exactly one gate | 6 | §B.2, the `gates` column |
| A19 | files executed by 15 gates or more | 3 | §B.2, the `gates` column |

### B.1 Gates, by derived kind, with the number of harness files each executed and its verdict in the shadow

| gate | tier | kind | files executed | shadow verdict |
|---|---|---|---|---|
| `classify` | portable | K | 6 | PASS |
| `config` | portable | K | 3 | PASS |
| `tier` | portable | K | 4 | PASS |
| `static_runner` | portable | K | 8 | PASS |
| `controls` | portable | K | 9 | PASS |
| `sweep_runner` | portable | K | 8 | PASS |
| `fingerprint` | portable | K | 4 | PASS |
| `rulings_shape` | portable | K | 1 | PASS |
| `readout` | portable | K | 11 | PASS |
| `close_sweeps` | portable | K | 2 | PASS |
| `temporal` | portable | F | 11 | PASS |
| `thresholds` | portable | F | 10 | PASS |
| `compare_dispatch` | portable | F | 12 | PASS |
| `expectation_kinds` | portable | K | 5 | PASS |
| `provenance` | portable | K | 4 | PASS |
| `docset_fixture` | portable | D | 9 | PASS |
| `docset_driver` | portable | D | 5 | PASS |
| `set_schema` | portable | D | 15 | PASS |
| `docset_suite` | portable | D | 21 | PASS |
| `cli_fixture` | portable | C | 9 | PASS |
| `cli_driver` | portable | C | 5 | PASS |
| `band` | portable | C | 13 | PASS |
| `json_schema` | portable | C | 15 | PASS |
| `cli_suite` | portable | C | 22 | PASS |
| `adapters` | portable | C | 24 | PASS |
| `file_census_tool` | portable | K | 8 | PASS |
| `census_register` | portable | K | 0 | SKIP |
| `census_recount` | static | K | 1 | PASS |
| `fidelity_bbh` | static | F | 11 | PASS |
| `fidelity_bbh_s2` | static | F | 18 | PASS |
| `suite` | static | F | 16 | PASS |

### B.2 Files, by category, with every gate that executed them

**shared (frame AND document-set AND command-line): 11**

| file | gates | executed by |
|---|---|---|
| `bin/bbx-run-suite` | 5 | adapters cli_suite docset_suite fidelity_bbh_s2 suite |
| `lib/py/bbx/__init__.py` | 28 | adapters band classify cli_driver cli_fixture cli_suite close_sweeps compare_dispatch config controls docset_driver docset_fixture docset_suite expectation_kinds fidelity_bbh fidelity_bbh_s2 file_census_tool fingerprint json_schema provenance readout set_schema static_runner suite sweep_runner temporal thresholds tier |
| `lib/py/bbx/config.py` | 25 | adapters band classify cli_fixture cli_suite compare_dispatch config controls docset_fixture docset_suite expectation_kinds fidelity_bbh fidelity_bbh_s2 file_census_tool fingerprint json_schema provenance readout set_schema static_runner suite sweep_runner temporal thresholds tier |
| `lib/py/bbx/expectations.py` | 12 | adapters band cli_fixture cli_suite compare_dispatch docset_fixture docset_suite expectation_kinds fidelity_bbh_s2 json_schema set_schema suite |
| `lib/py/bbx/finding.py` | 7 | adapters band cli_suite docset_suite json_schema set_schema suite |
| `lib/py/bbx/fingerprint.py` | 10 | adapters cli_fixture cli_suite docset_fixture docset_suite fidelity_bbh fidelity_bbh_s2 fingerprint suite sweep_runner |
| `lib/py/bbx/logfmt.py` | 13 | adapters band cli_suite compare_dispatch docset_driver docset_fixture docset_suite fidelity_bbh_s2 json_schema set_schema suite temporal thresholds |
| `lib/py/bbx/toml_subset.py` | 27 | adapters band classify cli_driver cli_fixture cli_suite compare_dispatch config controls docset_driver docset_fixture docset_suite expectation_kinds fidelity_bbh fidelity_bbh_s2 file_census_tool fingerprint json_schema provenance readout set_schema static_runner suite sweep_runner temporal thresholds tier |
| `lib/sh/compare.sh` | 9 | adapters band cli_suite compare_dispatch docset_suite fidelity_bbh_s2 json_schema set_schema suite |
| `lib/sh/config.sh` | 12 | adapters classify cli_suite controls docset_suite fidelity_bbh fidelity_bbh_s2 file_census_tool readout static_runner suite sweep_runner |
| `lib/sh/expectation_kinds.sh` | 4 | cli_fixture docset_fixture expectation_kinds fidelity_bbh_s2 |

**frame-driven and command-line: 4**

| file | gates | executed by |
|---|---|---|
| `bin/bbx-run-static` | 5 | adapters controls fidelity_bbh readout static_runner |
| `lib/py/bbx/tier.py` | 7 | adapters controls fidelity_bbh readout static_runner sweep_runner tier |
| `lib/sh/classify.sh` | 8 | adapters classify controls fidelity_bbh file_census_tool readout static_runner sweep_runner |
| `lib/sh/registry.sh` | 5 | adapters controls fidelity_bbh readout static_runner |

**document-set and command-line: 11**

| file | gates | executed by |
|---|---|---|
| `bin/bbx` | 5 | adapters band file_census_tool json_schema set_schema |
| `lib/py/bbx/cli.py` | 8 | adapters band cli_driver cli_fixture cli_suite docset_suite json_schema set_schema |
| `lib/py/bbx/compare_exact.py` | 6 | adapters band cli_suite docset_suite json_schema set_schema |
| `lib/py/bbx/compare_schema.py` | 4 | cli_suite docset_suite json_schema set_schema |
| `lib/py/bbx/compare_set.py` | 4 | cli_suite docset_suite json_schema set_schema |
| `lib/py/bbx/controls.py` | 4 | cli_suite controls docset_suite readout |
| `lib/py/bbx/docset.py` | 7 | adapters cli_suite docset_driver docset_fixture docset_suite json_schema set_schema |
| `lib/py/bbx/provenance.py` | 7 | adapters cli_fixture cli_suite docset_fixture docset_suite provenance readout |
| `lib/py/bbx/readout.py` | 3 | cli_suite docset_suite readout |
| `lib/py/bbx/recount.py` | 9 | adapters band census_recount cli_driver cli_fixture cli_suite docset_suite json_schema set_schema |
| `lib/py/bbx/sha1.py` | 3 | adapters cli_suite docset_suite |

**frame-driven only: 8**

| file | gates | executed by |
|---|---|---|
| `lib/py/bbx/_mklog.py` | 4 | compare_dispatch fidelity_bbh_s2 temporal thresholds |
| `lib/py/bbx/check_diverge.py` | 4 | compare_dispatch fidelity_bbh_s2 suite temporal |
| `lib/py/bbx/compare_composite.py` | 5 | compare_dispatch fidelity_bbh_s2 suite temporal thresholds |
| `lib/py/bbx/compare_flicker.py` | 5 | compare_dispatch fidelity_bbh_s2 suite temporal thresholds |
| `lib/py/bbx/compare_window.py` | 5 | compare_dispatch fidelity_bbh_s2 suite temporal thresholds |
| `lib/py/bbx/propose_temporal.py` | 3 | fidelity_bbh_s2 temporal thresholds |
| `lib/py/bbx/thresholds.py` | 5 | compare_dispatch fidelity_bbh_s2 suite temporal thresholds |
| `lib/sh/baseline.sh` | 3 | fidelity_bbh fidelity_bbh_s2 suite |

**frame-driven only (+kernel): 1**

| file | gates | executed by |
|---|---|---|
| `bin/bbx-run-sweep` | 2 | fidelity_bbh sweep_runner |

**document-set only: 1**

| file | gates | executed by |
|---|---|---|
| `drivers/docset.sh` | 3 | docset_driver docset_suite set_schema |

**command-line only: 5**

| file | gates | executed by |
|---|---|---|
| `drivers/cli.sh` | 4 | band cli_driver cli_suite json_schema |
| `drivers/gates.sh` | 1 | adapters |
| `drivers/unittest.sh` | 1 | adapters |
| `lib/py/bbx/adapters.py` | 1 | adapters |
| `lib/py/bbx/compare_band.py` | 2 | band cli_suite |

**kernel only: 4**

| file | gates | executed by |
|---|---|---|
| `bin/bbx-classify` | 2 | classify file_census_tool |
| `lib/py/bbx/close_sweeps.py` | 1 | close_sweeps |
| `lib/py/bbx/file_census.py` | 1 | file_census_tool |
| `lib/py/bbx/rulings_shape.py` | 1 | rulings_shape |

**REACHED BY NO GATE: 0**

(none)

<!-- GENERATED by `bbx file-census`: END. -->

## What this census does NOT assert

- What a CONSUMER's run executes: only what BBX's own registered gates execute, once each, on
  this host, under `BBX_BBH_HOME`. A file reached by one kind's gates here may be reached by
  another in a consumer.
- That a file reached by a gate of some kind is USED by that kind. The trace records what a
  process loaded or executed, never why; the explainer rule attributes an imported module to its
  importer, not to the importer's caller.
- A BBX-25 verdict. The kind-specific rows are REPORTED, never moved. Whether a file reached by
  one kind only ought to be generic is a reading of this census, not its output.
- Python modules neither imported nor executed on the traced path, and shell files read but not
  sourced: the trace records interpreter exits and executed `printf` lines, nothing else. A gate
  killed by a timeout leaves an incomplete trace, which the contamination refusal catches.
- The instrument itself. `gates/file_census_tool.sh` is its ground truth and runs every battery.
- The selfgates registry row of the TREE. The shadow is an instrumented harness, so its self
  identity legitimately moves, and the measurement re-derives that fixture's expectation inside
  the throwaway shadow (`--shadow-refreeze`). `gates/adapters.sh` is what holds the tree's row.
- Any platform but Darwin arm64 (R21).

## C. The instrument

`lib/py/bbx/file_census.py`, reached as `bbx file-census`. It is a tree tool under the gates
above, and no longer the scratchpad pair (`filecensus.sh` + `fc_analyze.py`) this section held
between bbx-11 and bbx-19; that pair is preserved verbatim in `docs/readout.md`'s bbx-11 section
as the record of how these numbers were first taken.

```
bbx file-census --self   [--out DIR] [--document PATH] [--check] [--frozen PATH] [--freeze]
bbx file-census --root DIR --out DIR [--only g1,g2] [--insert-after-shebang]
                                     [--shadow-refreeze "<command>"] [--reuse]
```

`--freeze` writes `expected/file_census.toml`, one `[f<i>]` table per universe file with its
`file` and its `kinds`, class `self`, mode `shrink-only` (D62): a lost kind FAILs naming both
sides, a file reached by NO gate FAILs always and a fresh freeze cannot hide it, a frozen file
outside the universe is a dead row, a file frozen twice is hand-editing, and a gained kind is a
`NOTE: file-census-grew` that re-freezes. `--reuse` re-analyses a kept run without rebuilding the
shadow, which is how `gates/file_census.sh` proves it can fail without paying a battery per
control. `--insert-after-shebang` reproduces G25 on purpose.

## D. Runs

| run | identity | result | note |
|---|---|---|---|
| bbx-11, 2026-09-10 | `88278e9` (HEAD — the key was not yet the identity) | 22 gates PASS; `docset_suite` FAIL on the INSTRUMENT (the trace line after the shebang ended the header, G25), its trace discarded, the insertion corrected and the gate re-run PASS | the first numbers, now history in `docs/readout.md` |
| bbx-11, 2026-09-10 | `88278e9` | 23 gates PASS end to end with the corrected generator | every gate's file set byte-identical to run 1 (`cmp`, 23 of 23); BBX-14 met for the census |
| bbx-19, 2026-09-12 | the identity in the generated block above | the first GATED run: 29 gates, the document generated and `--check`ed, the register frozen | `docs/readout.md`'s bbx-19 section carries the screen |

Runtimes are deliberately **absent from the generated block**: measured at bbx-19 over two
runs whose every file count, kind and verdict was identical, 12 of 30 gate runtimes differed
by one to four seconds, so a checked block carrying them could never be stable and `--check`
would fail on every second run. Tolerating that difference is what BBX-14 forbids, and the
answer is to not freeze a non-deterministic field. Per-gate runtimes live in each kept run's
`verdicts.tsv` under `build/`, which is where a runtime question is answered. The census IS
the record of everything else.
