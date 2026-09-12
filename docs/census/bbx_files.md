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
(not yet measured at this identity — run `bbx file-census --self --out <dir> --document docs/census/bbx_files.md`)
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

Runtimes are not gated. The census IS the record; the kept runs live under `build/`.
