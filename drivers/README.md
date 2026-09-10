# The drivers — BBX's own, one per non-frame kind

Shape: reference page. The contract is bbh's `drivers/README.md` `[BBH-25]`–`[BBH-36]`,
cited, not copied (R4): four arguments, one log grammar, one exit vocabulary,
and the rule that a driver REFUSES a variable it cannot honour and never
ignores one `[BBH-28]`. This directory is `[suite].driver_home` for every
kind but `frame-driven`, whose drivers stay bbh's under `$BBX_BBH_HOME/drivers`
(D28, R26); a consumer may also name a driver by a path from its own root.

## The invocation (every driver here)

```
<driver> <set> <scenario> <out.log> [sandbox]
```

| argument | meaning |
|---|---|
| `set` | the subject's name on the driver's search path — the artifact `<set>.tsv` for the document-set kind; an executable `<set>` or a `<set>.py` for the command-line kind |
| `scenario` | the input: `<name>.<scenario_ext>` under `[suite].replays_dir` (R32: `claims` for the document-set kind, `cli` for the command-line kind — an INVOCATION, D46) |
| `out.log` | the observation log to write: `<index> <token>` per point, `END <n>` last, `lib/py/bbx/logfmt.py` the one reader (R31); made absolute; **removed before the run** `[BBH-27]` |
| `sandbox` | optional: a directory the driver may write scratch into; a fresh temp dir when omitted `[BBH-36]` — for the command-line kind the tool's working directory, `HOME` and `TMPDIR` too (D52), removed after the run when fresh |

## The exit status

| exit | meaning |
|---|---|
| 0 | the log is complete (`END` present) |
| 1 | the subject or the scenario cannot be read, or the driver's own self-test failed: the run is DISCARDED, never compared |
| 2 | a guard tripped: the log is the bug report — `cli.sh`'s guard is the signal that killed the tool (`CRASH signal:<n>:<NAME>`, `END-CRASH <n>`, D53); `docset.sh` has none |
| 3 | `REFUSED: <driver> cannot honour <what> (<why>)` — a variable, a form, a view or an unlisted claim this driver cannot honour `[BBH-28]` |

## The drivers

| driver | kind | search-path variable | its own family (scrubbed by the suite, D33) | since |
|---|---|---|---|---|
| `docset.sh` | `document-set` | `DOCSET_PATH` (resolved by `bbx.docset resolve`, the one resolver the schema comparator shares — S3 step 3) | `DOCSET_NONDET` (honoured), `DOCSET_VIEW`, `DOCSET_FORMS` (refused) | S3 step 2 (bbx-8, 2026-09-10) |
| `cli.sh` | `command-line` | `CLI_PATH` (resolved by `bbx.cli resolve`: per directory an executable `<set>` over `<set>.py`, the first directory that has either) | `CLI_NONDET` (honoured), `CLI_TIMEOUT` (honoured, D51), `CLI_KEEP_ENV` (refused, D52) | S4 step 2 (bbx-14, 2026-09-10); beside the log it writes the band view `<out>.bands` (D53) and the JSON view `<out>.json` (D54, step 3) |

Every driver here refuses the frame-driven replay family (`MASK_RANGES`,
`DUMPS`, `POKES`, …), the guard family (`GUARD_*`, `CRASH_VECTORS`,
`CODE_RANGES`); `cli.sh` refuses the document-set family too (`DOCSET_NONDET`,
`DOCSET_VIEW`, `DOCSET_FORMS`): a caller that set one is measuring something
this run would silently not measure. Ground truth: the kind's driver gate
(`gates/docset_driver.sh`, `gates/cli_driver.sh`).
