# WSL — the first platform run of R21 (reported 2026-09-13)

**Status: this run was NOT GREEN, and the red was a defect in BBX's own controls
contract, not in any gate and not in WSL.** The run did exactly what R21 exists for.
**The defect is fixed at bbx-22** (R48 answered and built, `8d5f97d`): a gate the
classifier calls SKIP now reads `verdict=SKIPPED`, its declared controls set aside
and named, and the battery can be green; `--strict` still refuses every skip. **A
re-run at the fix has reported GREEN** (below, a witness); until its kept pair is
committed, this page records one NOT GREEN run and no kept green one. R21 is answered
(after the bbx-22 close): a platform reads green only on a kept pair.

| | |
|---|---|
| reported by | the maintainer, from a WSL host |
| BBX commit | `84442f8` or later (the head the procedure names) |
| verdict | `PASS 30  SKIP 1  FAIL 0  MISSING 0` — then `NOT GREEN` |
| controls | `fired 115 / declared 119; gates with no declaration: 0; red: 1` |
| the one red | `controls=census_recount declared=4 fired=0 dead=4 undeclared=0 verdict=RED` |
| working tree | `ok: no tracked file changed during the run` |
| the run itself | `run_2026-09-13.txt`, the runner's printed output as reported |

## What the run found

`gates/census_recount.sh` SKIPPED, exactly as `docs/platforms/README.md` predicted,
because the three lineage census files record absolute paths from the macOS host. A
skipped gate asserts nothing and runs none of its checks — so none of its four
declared must-fire controls could fire. The controls reader then counted a declared
control that did not fire as DEAD, the runner made that RED, and the whole battery
read NOT GREEN (the contract until R48, bbx-22).

**Reproduced on macOS the same day**, so it is a contract defect and not a platform
difference: pointing `BBX_CENSUS_DIR` at a census naming an absent tree gives
`controls=census_recount declared=4 fired=0 dead=4 verdict=RED` here too. The
finding is therefore instrument-grade, not a witness (BBX-28). It is filed as G47
and raised as ruling R48.

Why macOS could never show it: no gate skips here, because the three lineage trees
are present at the paths the censuses record. The SECOND PLATFORM is the detector,
which is BBX-25's argument about consumers applied to hosts.

## What the run also established, and this is the strong part

Everything else is **identical between Darwin arm64 and WSL**. Same 31 registered
gates, same per-gate declared-control counts summing to 119, and every NOTE-class
number the same on both hosts:

```
band              verdict-lines-frozen 22        json_schema   verdict-lines-frozen 30
set_schema        verdict-lines-frozen 38        cli_suite     suite-runs 15
docset_suite      suite-runs 17                  suite         suite-runs 25
file_census_tool  file-census-tool-runs 12       docset_driver coverage 20/23
census_register   files 45  rows 45              fidelity      bbh-drift ahead=8
cli_fixture       records=9 commands=5 options=9 refusals=7 scenarios=9 expectations=12 truth_logs=9 band_fields=1
docset_fixture    records=12 documents=3 claims=20 wrong=1 paraphrase=1 unbindable=2 scenarios=3 expectations=12 truth_logs=3
```

The anti-orphan check, the working-tree check and both fidelity gates behave the
same. Runtimes differ and are not gated: the WSL host is faster on the heavy gates
(`sweep_runner` 58 s against 91 s, `cli_suite` 59 s against 132 s, `adapters` 37 s
against 135 s).

The expected `census-drift` NOTE appeared and was correctly ignored, as the
procedure said it should be.

## What this run does NOT establish

- **A green battery on any platform but macOS.** This run could not be green: the
  skip that was correct there was also what reddened it, until R48 (bbx-22). A green
  WSL battery needs the re-run.
- **The census recount on Linux.** It skipped, asserting nothing, by design.
- **`gates/file_census.sh`**, which is release-scoped and was not run.
- **A second architecture.** A second operating system only.
- **Anything about a native Windows shell** outside WSL.

## The re-runs after R48 (reported 2026-09-13)

- **A re-run pulled while the fix was still unpushed** met `fd63797` and reproduced the run above
  exactly — `controls fired 115 / declared 119; red: 1`, NOT GREEN (G49). A witness of the pre-fix
  behaviour, and evidence about nothing R48 changed.
- **A re-run at the fix** reported `PASS 30    SKIP 1     FAIL 0     MISSING 0`, `skipped:
  census_recount`, `GREEN — every registered instrument-free gate passed.` Three lines pasted: a
  WITNESS, not a kept result. That it ran the fix is inferred from the output, not measured: no
  pushed commit before `429d3f8` prints GREEN beside that skip. The kept pair, when committed here,
  replaces this line as the evidence.
