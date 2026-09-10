# Census — BBX's own harness files, by the kind of the gates that RUN them @ 88278e9 — measured 2026-09-10 (bbx-11, S3 step 5)
`/Users/koneko/Developer/generalized-blackbox-harness/BBX` · the first shared-vs-kind-specific FILE CENSUS (`docs/generality.md` "What the proof measures"; `docs/plans/S3.md` §6, §8.5) · **37** tracked files under `lib/`, `bin/`, `drivers/` (`drivers/README.md` excluded: not executable) · **23** gates

Shape: census (a measured document; its history is in `docs/readout.md`, the bbx-11 section). **Measured once, not gated** (the close ritual's honest floor): the instrument in §C is a scratchpad generator run by hand, not a gate — the gate is S4's plan (`HANDOFF.md`: "if the census wants a tool, that is S4's plan"). Its rows are NOT in the census recount (`gates/census_recount.sh` reads the three lineage files only). Two runs of the generator on the same HEAD gave byte-identical per-gate file sets (BBX-14; the stamps in §D).

## The question and the method

Which harness files are executed by gates of ONE subject kind and which by TWO (BBX-25: a generic thing needs two instances). Measured at RUNTIME, not by reading: a shadow git tree is built from HEAD (`git archive`), every `bin/*`, `drivers/*.sh` and `lib/sh/*.sh` gets one line that appends its own path to a trace file — inserted AFTER the leading comment block, never after the shebang (gotcha G25: the first run inserted it after the shebang, which ENDED the header under R30, and `gates/docset_suite.sh` went red because the readout found no `NOT-ASSERTED:` line in the driver; that run's trace was discarded and the generator corrected before the numbers below were taken) — and `lib/py/sitecustomize.py` appends every `lib/py/bbx/*.py` module loaded (and a module run as a script) at interpreter exit. Every registered gate then runs once, alone, with a fresh trace, `BBX_BBH_HOME` set (the static tier runs); each gate's log is classified by the TREE's `bin/bbx classify`. A gate that is not PASS in the shadow contaminates its trace (§1): the run is discarded, never adjusted.

**A gate's KIND is derived from its trace, not from its vocabulary** (a grep over the gates' text mis-files `gates/readout.sh`, `gates/provenance.sh` and `gates/expectation_kinds.sh` as frame-driven on the word `masked` in their synthetic fixtures — measured first, declined): a gate is **F** (frame-driven) if it executed a module only the frame-driven profile's kinds table registers (the temporal family: `compare_flicker.py`, `compare_window.py`, `compare_composite.py`, `check_diverge.py`, `propose_temporal.py`) or needs bbh's tree (`gates/static.txt` minus the census: `fidelity_bbh`, `fidelity_bbh_s2`, `suite`); **D** (document-set) if it executed a module only the document-set profile registers (`docset.py`, `compare_exact.py`, `compare_set.py`, `compare_schema.py`) or the document-set driver; **K** (kernel — BBX as its own subject, kind D of `docs/generality.md`) otherwise. The kinds tables are read with `python3 -m bbx.expectations kinds` under each profile's config (§A rows A3, A4). A file's category is the set of kinds of the gates that executed it.

## A. Counts

| id | dimension | count | command / derivation |
|---|---|---|---|
| A1 | tracked files under lib/, bin/, drivers/ (README.md excluded) — the universe | 37 | `git ls-files lib bin drivers \| grep -vc '\.md$'` |
| A2 | registered gates (both tiers) | 23 | `grep -hv '^#' gates/portable.txt gates/static.txt \| wc -l` |
| A3 | EVAL comparator families the document-set profile registers (exact, set, schema) | 3 | `BBX_CONFIG=fixture/docset/bbx.toml python3 -m bbx.expectations kinds \| awk '$3=="EVAL"{print $2}' \| sort -u \| wc -l` |
| A4 | EVAL comparator families the frame-driven profile registers (temporal) | 1 | `BBX_CONFIG=$BBX_BBH_HOME/example/bbh.toml python3 -m bbx.expectations kinds \| awk '$3=="EVAL"{print $2}' \| sort -u \| wc -l` |
| A5 | gates of kind K (kernel) | 13 | §B.1, derived from the traces as stated above |
| A6 | gates of kind F (frame-driven) | 6 | §B.1 |
| A7 | gates of kind D (document-set) | 4 | §B.1 |
| A8 | gates of both kinds F and D | 0 | §B.1 (none: no gate drives both fixtures) |
| A9 | files executed by gates of BOTH kinds (shared — the abstraction, proved by two instances) | 11 | §B.2 |
| A10 | files executed by frame-driven gates only (kind-specific, no kernel gate reaches them) | 7 | §B.2 |
| A11 | files executed by frame-driven gates AND kernel gates, never by a document-set gate | 5 | §B.2 |
| A12 | files executed by document-set gates only (kind-specific, no kernel gate reaches them) | 7 | §B.2 |
| A13 | files executed by document-set gates AND kernel gates, never by a frame-driven gate | 3 | §B.2 |
| A14 | files executed by kernel gates only | 4 | §B.2 |
| A15 | files executed by NO gate (rot class 1, orphan) | 0 | §B.2 |
| A16 | files executed by exactly one gate | 6 | §B.2, the `gates` column |
| A17 | files executed by 15 gates or more | 3 | §B.2 |

## B. The rows

### B.1 Gates, by derived kind, with the number of harness files each executed and its verdict in the shadow

| gate | tier | kind | files executed | shadow verdict | seconds |
|---|---|---|---|---|---|
| `classify` | portable | K | 6 | PASS | 2 |
| `config` | portable | K | 3 | PASS | 1 |
| `tier` | portable | K | 4 | PASS | 0 |
| `static_runner` | portable | K | 8 | PASS | 9 |
| `controls` | portable | K | 9 | PASS | 8 |
| `sweep_runner` | portable | K | 8 | PASS | 98 |
| `fingerprint` | portable | K | 4 | PASS | 2 |
| `rulings_shape` | portable | K | 1 | PASS | 1 |
| `readout` | portable | K | 11 | PASS | 5 |
| `close_sweeps` | portable | K | 2 | PASS | 2 |
| `temporal` | portable | F | 11 | PASS | 4 |
| `thresholds` | portable | F | 10 | PASS | 2 |
| `compare_dispatch` | portable | F | 12 | PASS | 2 |
| `expectation_kinds` | portable | K | 5 | PASS | 1 |
| `provenance` | portable | K | 4 | PASS | 2 |
| `docset_fixture` | portable | D | 9 | PASS | 0 |
| `docset_driver` | portable | D | 5 | PASS | 4 |
| `set_schema` | portable | D | 13 | PASS | 11 |
| `docset_suite` | portable | D | 19 | PASS | 83 |
| `census_recount` | static | K | 1 | PASS | 63 |
| `fidelity_bbh` | static | F | 10 | PASS | 48 |
| `fidelity_bbh_s2` | static | F | 17 | PASS | 102 |
| `suite` | static | F | 15 | PASS | 86 |

`gates/docset_suite.sh`'s row is the corrected instrument's re-run (the first run FAILed on the instrument, G25; 86 s, discarded).

### B.2 Files, by category, with every gate that executed them

**files executed by gates of BOTH kinds (shared — the abstraction, proved by two instances): 11**

| file | gates | executed by |
|---|---|---|
| `bin/bbx-run-suite` | 3 | docset_suite fidelity_bbh_s2 suite |
| `lib/py/bbx/__init__.py` | 21 | classify close_sweeps compare_dispatch config controls docset_driver docset_fixture docset_suite expectation_kinds fidelity_bbh fidelity_bbh_s2 fingerprint provenance readout set_schema static_runner suite sweep_runner temporal thresholds tier |
| `lib/py/bbx/config.py` | 19 | classify compare_dispatch config controls docset_fixture docset_suite expectation_kinds fidelity_bbh fidelity_bbh_s2 fingerprint provenance readout set_schema static_runner suite sweep_runner temporal thresholds tier |
| `lib/py/bbx/expectations.py` | 7 | compare_dispatch docset_fixture docset_suite expectation_kinds fidelity_bbh_s2 set_schema suite |
| `lib/py/bbx/finding.py` | 3 | docset_suite set_schema suite |
| `lib/py/bbx/fingerprint.py` | 7 | docset_fixture docset_suite fidelity_bbh fidelity_bbh_s2 fingerprint suite sweep_runner |
| `lib/py/bbx/logfmt.py` | 9 | compare_dispatch docset_driver docset_fixture docset_suite fidelity_bbh_s2 set_schema suite temporal thresholds |
| `lib/py/bbx/toml_subset.py` | 20 | classify compare_dispatch config controls docset_driver docset_fixture docset_suite expectation_kinds fidelity_bbh fidelity_bbh_s2 fingerprint provenance readout set_schema static_runner suite sweep_runner temporal thresholds tier |
| `lib/sh/compare.sh` | 5 | compare_dispatch docset_suite fidelity_bbh_s2 set_schema suite |
| `lib/sh/config.sh` | 9 | classify controls docset_suite fidelity_bbh fidelity_bbh_s2 readout static_runner suite sweep_runner |
| `lib/sh/expectation_kinds.sh` | 3 | docset_fixture expectation_kinds fidelity_bbh_s2 |

**files executed by frame-driven gates only (kind-specific, no kernel gate reaches them): 7**

| file | gates | executed by |
|---|---|---|
| `lib/py/bbx/_mklog.py` | 4 | compare_dispatch fidelity_bbh_s2 temporal thresholds |
| `lib/py/bbx/check_diverge.py` | 4 | compare_dispatch fidelity_bbh_s2 suite temporal |
| `lib/py/bbx/compare_composite.py` | 5 | compare_dispatch fidelity_bbh_s2 suite temporal thresholds |
| `lib/py/bbx/compare_flicker.py` | 5 | compare_dispatch fidelity_bbh_s2 suite temporal thresholds |
| `lib/py/bbx/compare_window.py` | 5 | compare_dispatch fidelity_bbh_s2 suite temporal thresholds |
| `lib/py/bbx/propose_temporal.py` | 3 | fidelity_bbh_s2 temporal thresholds |
| `lib/py/bbx/thresholds.py` | 5 | compare_dispatch fidelity_bbh_s2 suite temporal thresholds |

**files executed by frame-driven gates AND kernel gates, never by a document-set gate: 5**

| file | gates | executed by |
|---|---|---|
| `bin/bbx-run-static` | 4 | controls fidelity_bbh readout static_runner |
| `bin/bbx-run-sweep` | 2 | fidelity_bbh sweep_runner |
| `lib/py/bbx/tier.py` | 6 | controls fidelity_bbh readout static_runner sweep_runner tier |
| `lib/sh/classify.sh` | 6 | classify controls fidelity_bbh readout static_runner sweep_runner |
| `lib/sh/registry.sh` | 4 | controls fidelity_bbh readout static_runner |

**files executed by document-set gates only (kind-specific, no kernel gate reaches them): 7**

| file | gates | executed by |
|---|---|---|
| `bin/bbx` | 1 | set_schema |
| `drivers/docset.sh` | 3 | docset_driver docset_suite set_schema |
| `lib/py/bbx/compare_exact.py` | 2 | docset_suite set_schema |
| `lib/py/bbx/compare_schema.py` | 2 | docset_suite set_schema |
| `lib/py/bbx/compare_set.py` | 2 | docset_suite set_schema |
| `lib/py/bbx/docset.py` | 4 | docset_driver docset_fixture docset_suite set_schema |
| `lib/py/bbx/sha1.py` | 1 | docset_suite |

**files executed by document-set gates AND kernel gates, never by a frame-driven gate: 3**

| file | gates | executed by |
|---|---|---|
| `lib/py/bbx/controls.py` | 3 | controls docset_suite readout |
| `lib/py/bbx/provenance.py` | 4 | docset_fixture docset_suite provenance readout |
| `lib/py/bbx/readout.py` | 2 | docset_suite readout |

**files executed by kernel gates only: 4**

| file | gates | executed by |
|---|---|---|
| `bin/bbx-classify` | 1 | classify |
| `lib/py/bbx/close_sweeps.py` | 1 | close_sweeps |
| `lib/py/bbx/recount.py` | 1 | census_recount |
| `lib/py/bbx/rulings_shape.py` | 1 | rulings_shape |

**files executed by NO gate (rot class 1, orphan): 0**

(none)

## What this census does NOT assert

- What a CONSUMER's run executes: only what BBX's 23 gates execute on this host, once each, under `BBX_BBH_HOME`. A file reached by one kind's gates here may be reached by the other kind in a consumer (`bin/bbx`, the dispatcher, is executed by ONE gate — `gates/set_schema.sh` through `bbx compare` — because every other gate calls the runners directly, bbh's shape; that is a fact about the gates' reach, not about the dispatcher's genericity).
- A BBX-25 verdict: the proof's end is S4's third kind (`docs/plans/S3.md` §6: "S4 completes it with the third kind"). The kind-specific rows are reported, not moved.
- Python modules imported but never executed on the traced path, and shell files read but not sourced: the trace records interpreter exits and executed `printf` lines, nothing else. A gate killed by a timeout leaves an incomplete trace (none was).
- Any platform but Darwin arm64 (R21).

## C. The generator (scratchpad instrument, run by hand; verbatim)

`filecensus.sh <out dir>` builds and instruments the shadow and runs every gate; `fc_analyze.py <out dir> auto` derives the gate kinds and prints §B. Both are reproduced here so the census can be re-run; neither is a tree tool (S4 decides the gate).

```sh
#!/bin/sh
# filecensus.sh — S3 step 5's FILE CENSUS instrument (session bbx-11, scratchpad only; not a tree tool).
# Builds a shadow git tree from BBX's HEAD, instruments every bin/*, drivers/*.sh and lib/sh/*.sh with one
# line that appends its own path to a trace file, and a lib/py/sitecustomize.py that appends every bbx
# module file loaded (and the script run) at interpreter exit; then runs every registered gate once,
# each with a fresh trace, and keeps per gate: the sorted set of harness files it executed, its log,
# its exit and its classified verdict. Nothing under the tree is written.
set -u
BBX=/Users/koneko/Developer/generalized-blackbox-harness/BBX
OUT=${1:?out dir}; mkdir -p "$OUT/files" "$OUT/logs" "$OUT/verdicts"
S="$OUT/shadow"; TRACE="$OUT/trace.txt"
rm -rf "$S"; mkdir -p "$S"
( cd "$BBX" && git archive HEAD ) | tar -x -C "$S"
( cd "$BBX" && git rev-parse HEAD ) > "$OUT/head.txt"
# instrument sh: bin/* and drivers/*.sh after the shebang; lib/sh/*.sh at the end (they are sourced)
# AFTER THE HEADER (the leading comment block after the shebang, R30): a line inserted right after the
# shebang ENDS the header, and the readout then finds no NOT-ASSERTED line in the driver (the first run
# of this instrument turned gates/docset_suite.sh red exactly there; gotcha G25).
for f in bin/bbx bin/bbx-classify bin/bbx-run-static bin/bbx-run-suite bin/bbx-run-sweep drivers/docset.sh; do
  n=$(awk 'NR==1{next} /^#/{last=NR; next} {exit} END{print last+0}' "$S/$f"); [ "$n" -eq 0 ] && n=1
  { sed -n "1,${n}p" "$S/$f"; printf "printf '%%s\\\\n' '%s' >> '%s'\n" "$f" "$TRACE"; sed -n "$((n+1)),\$p" "$S/$f"; } > "$S/$f.tmp"
  mv "$S/$f.tmp" "$S/$f"; chmod +x "$S/$f"
done
for f in lib/sh/classify.sh lib/sh/compare.sh lib/sh/config.sh lib/sh/expectation_kinds.sh lib/sh/registry.sh; do
  printf "\nprintf '%%s\\\\n' '%s' >> '%s'\n" "$f" "$TRACE" >> "$S/$f"
done
cat > "$S/lib/py/sitecustomize.py" <<PY
import atexit, os, sys
_T = '$TRACE'
_ROOT = '$S' + os.sep
def _dump():
    seen = set()
    for m in list(sys.modules.values()):
        f = getattr(m, "__file__", None)
        if f and f.startswith(_ROOT) and "/lib/py/bbx/" in f:
            seen.add(os.path.relpath(f, _ROOT))
    a = sys.argv[0] if sys.argv else ""
    if a:
        a = os.path.abspath(a)
        if a.startswith(_ROOT) and "/lib/py/bbx/" in a:
            seen.add(os.path.relpath(a, _ROOT))
    if seen:
        with open(_T, "a") as fh:
            for s in sorted(seen):
                fh.write(s + "\n")
atexit.register(_dump)
PY
( cd "$S" && git init -q && git add -A && git commit -qm shadow-instrumented >/dev/null )
cd "$S"
export PYTHONDONTWRITEBYTECODE=1
gates=$(grep -v '^#' gates/portable.txt; grep -v '^#' gates/static.txt)
for g in $gates; do
  rm -f "$TRACE"
  t0=$(date +%s)
  PYTHONPATH="$S/lib/py" BBX_BBH_HOME="$HOME/Developer/blackbox-harness" sh "gates/$g.sh" > "$OUT/logs/$g.log" 2>&1; rc=$?
  t1=$(date +%s)
  if [ -f "$TRACE" ]; then sort -u "$TRACE" > "$OUT/files/$g.txt"; else : > "$OUT/files/$g.txt"; fi
  v=$(PYTHONPATH="$BBX/lib/py" "$BBX/bin/bbx" classify $rc "$OUT/logs/$g.log" 2>&1 | head -1)
  printf '%s\t%s\t%s\t%s\n' "$g" "$rc" "$((t1-t0))" "$v" >> "$OUT/verdicts.tsv"
done
echo DONE >> "$OUT/verdicts.tsv"
```

```python
"""fc_analyze.py <fc dir> <gate-kinds.tsv> — the file census over the shadow traces (bbx-11, scratchpad).
gate-kinds.tsv: <gate>\t<K|F|D|FD> ; universe: git ls-files lib bin drivers of the BBX tree."""
import os, subprocess, sys
from collections import defaultdict
fc, kinds_tsv = sys.argv[1], sys.argv[2]
BBX = "/Users/koneko/Developer/generalized-blackbox-harness/BBX"
universe = subprocess.run(["git", "-C", BBX, "ls-files", "lib", "bin", "drivers"], capture_output=True, text=True).stdout.split()
universe = [u for u in universe if not u.endswith(".md")]
if kinds_tsv == "auto":
    # gate kinds DERIVED FROM THE TRACES: seeds are the files only one kind's profile registers (the kinds tables:
    # temporal family = frame-driven only; exact-by-index / set / schema = document-set only), the document-set
    # driver, and the gates that need bbh's tree (gates/static.txt minus the census). Everything else is K (kernel).
    F_SEED = {"lib/py/bbx/compare_flicker.py", "lib/py/bbx/compare_window.py", "lib/py/bbx/compare_composite.py",
              "lib/py/bbx/check_diverge.py", "lib/py/bbx/propose_temporal.py"}
    F_GATES = {"fidelity_bbh", "fidelity_bbh_s2", "suite"}
    D_SEED = {"lib/py/bbx/docset.py", "lib/py/bbx/compare_exact.py", "lib/py/bbx/compare_set.py",
              "lib/py/bbx/compare_schema.py", "drivers/docset.sh"}
    kinds = {}
    for fn in sorted(os.listdir(os.path.join(fc, "files"))):
        g = fn[:-4]; fs = set(open(os.path.join(fc, "files", fn)).read().split())
        k = ("F" if (fs & F_SEED or g in F_GATES) else "") + ("D" if fs & D_SEED else "")
        kinds[g] = k or "K"
    print("gate kinds (derived):", " ".join(f"{g}={k}" for g, k in kinds.items()))
    from collections import Counter as _C; print("gate kinds histogram:", dict(_C(kinds.values())))
else:
    kinds = dict(l.rstrip("\n").split("\t") for l in open(kinds_tsv) if l.strip())
reach = defaultdict(set)          # file -> set of gates
for g in kinds:
    p = os.path.join(fc, "files", g + ".txt")
    for f in open(p).read().split():
        reach[f].add(g)
def classes(gs): return "".join(c for c in "KFD" if any(c in kinds[g] for g in gs))
rows = []
for f in universe:
    gs = sorted(reach.get(f, ()))
    rows.append((f, classes(gs), len(gs), gs))
cat = defaultdict(list)
for f, c, n, gs in rows:
    if "F" in c and "D" in c: k = "shared (frame AND document-set)"
    elif "F" in c: k = "frame-driven only" + (" (+kernel)" if "K" in c else "")
    elif "D" in c: k = "document-set only" + (" (+kernel)" if "K" in c else "")
    elif "K" in c: k = "kernel only"
    else: k = "REACHED BY NO GATE"
    cat[k].append((f, n, gs))
print(f"universe: {len(universe)} tracked files under lib/ bin/ drivers/ (README.md excluded); gates: {len(kinds)}")
for k in ["shared (frame AND document-set)", "frame-driven only", "frame-driven only (+kernel)", "document-set only", "document-set only (+kernel)", "kernel only", "REACHED BY NO GATE"]:
    if k in cat:
        print(f"\n{k}: {len(cat[k])}")
        for f, n, gs in sorted(cat[k]): print(f"  {f}  gates={n}  [{' '.join(gs)}]")
traced = [f for f in reach if f not in universe]
if traced: print("\ntraced but not in universe:", traced)
```

## D. Runs

| run | HEAD of the shadow | result | note |
|---|---|---|---|
| 1 | `88278e9` | 22 gates PASS; `docset_suite` FAIL on the INSTRUMENT (the trace line after the shebang ended the header, G25) — its trace discarded; the insertion corrected, the gate alone re-run PASS (83 s) with a fresh trace | the numbers in §A/§B were first read off this run |
| 2 | `88278e9` (the same HEAD: both shadows were built before the sitting's first commit) | 23 gates PASS with the corrected generator end to end (`sweep_runner` 98 s, `fidelity_bbh_s2` 103 s, `suite` 92 s, `docset_suite` 86 s, `census_recount` 65 s, `fidelity_bbh` 47 s, the rest under 13 s) | every gate's file set byte-identical to run 1 (`cmp`, 23 of 23); §B re-derived by `fc_analyze.py` identical — BBX-14 met for the census |

Both runs 2026-09-10, bbx-11, Darwin arm64, this host loaded (runtimes are not gated). Kept under the session's scratchpad only; the census IS the record.
