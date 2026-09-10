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
| `set` | the subject's name on the driver's search path — the artifact `<set>.tsv` for the document-set kind |
| `scenario` | the input: `<name>.<scenario_ext>` under `[suite].replays_dir` (R32: `claims` for the document-set kind) |
| `out.log` | the observation log to write: `<index> <token>` per point, `END <n>` last, `lib/py/bbx/logfmt.py` the one reader (R31); made absolute; **removed before the run** `[BBH-27]` |
| `sandbox` | optional: a directory the driver may write scratch into; a fresh temp dir when omitted `[BBH-36]` |

## The exit status

| exit | meaning |
|---|---|
| 0 | the log is complete (`END` present) |
| 1 | the subject or the scenario cannot be read, or the driver's own self-test failed: the run is DISCARDED, never compared |
| 2 | a guard tripped — no BBX driver has one yet; the vocabulary is bbh's |
| 3 | `REFUSED: <driver> cannot honour <what> (<why>)` — a variable, a form, a view or an unlisted claim this driver cannot honour `[BBH-28]` |

## The drivers

| driver | kind | search-path variable | its own family (scrubbed by the suite, D33) | since |
|---|---|---|---|---|
| `docset.sh` | `document-set` | `DOCSET_PATH` | `DOCSET_NONDET` (honoured), `DOCSET_VIEW`, `DOCSET_FORMS` (refused) | S3 step 2 (bbx-8, 2026-09-10) |

Every driver here refuses the frame-driven replay family (`MASK_RANGES`,
`DUMPS`, `POKES`, …) and the guard family (`GUARD_*`, `CRASH_VECTORS`,
`CODE_RANGES`): a caller that set one is measuring something a non-frame run
would silently not measure. Ground truth: the kind's driver gate
(`gates/docset_driver.sh`).
