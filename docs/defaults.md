# Defaults — the register (BBX-24, ruled R11 for the classes)

Shape: register, one row per default the harness introduces, with its
provenance class — `principled` (follows from a contract), `reference-calibrated`
(set by a measurement on a named reference, quoted), `arbitrary` (a choice
that could have been otherwise; the second consumer is its detector).
Changing a row is a ruling, dated in `DECISIONS_HISTORY.md`. A default with no
row is a default nobody can veto (`[BBH-84]`).

| id | default | value | where it lives | class | why / measured on |
|---|---|---|---|---|---|
| D1 | seconds allowed per census command in the recount | 60 | `lib/py/bbx/recount.py` `--timeout`, env `BBX_CENSUS_TIMEOUT` | arbitrary | no census command has been measured above 5 s; 60 leaves room for a cold `python3 tools/checkskills.py -v` on VampireSaved without hiding a hang for a minute more |
| D2 | quoted runtime of `gates/census_recount.sh` | ~21 s (`real 21.13` user 29.50 sys 24.23) | the gate's header | reference-calibrated | `/usr/bin/time -p sh gates/census_recount.sh`, macOS Darwin 25.6, Apple Silicon, 300 rows, 2026-09-09; re-measured when the census grows (BBX-11: a gate that fails far faster than its quoted runtime bailed before measuring) |
| D3 | where a census file's repository root comes from | line 2 of the census file (first backtick-quoted absolute path); `--root` overrides | `lib/py/bbx/recount.py` | principled | the census is the record of what was measured where; the recount reads the record, and an override is an explicit, visible choice |
| D4 | which rows a recount can re-run | count = plain integer or one quoted string; command = one leading backtick pipeline | `lib/py/bbx/recount.py` `classify()` | principled | anything else is reported NOT-RECOUNTABLE with its id; coverage is printed, never assumed (BBX-18) |
| D5 | the platform floor | POSIX sh + Python 3; macOS, Linux, Windows via WSL | ruled R3 | principled (ruled) | every platform guard has a gate on each platform |
| D7 | where the gate finds the census files | `docs/census/` under the BBX root; env `BBX_CENSUS_DIR` overrides | `gates/census_recount.sh` | principled | the override exists so the SKIP path (an absent lineage tree) can be exercised on purpose without moving a repository |
| D6 | the environment every census command runs in | `PATH=/usr/bin:/bin:/usr/sbin:/sbin`, `LANG=LC_ALL=C.UTF-8`, `HOME`, `TMPDIR`, `PYTHONDONTWRITEBYTECODE=1`, nothing else | `lib/py/bbx/recount.py` `hermetic_env()` | principled | a count must not depend on which program answers to a name in the caller's shell (gotcha G9: ugrep vs BSD grep, six counts moved); bbh scrubs the replay family the same way `[BBH-35]` |

The lineage's biased default (bbh's `DEFAULTS` naming VampireSaved's build
directories, `docs/gotchas.md` G4) is the reason every row here names its
class.
