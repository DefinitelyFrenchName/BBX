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
| D8 | the kind-blind layout defaults (`gates_dir` tests, `gate_glob` *.sh, `lib_dir` tests/lib, `runner_prefixes` run_, `manual_suffixes` _soak, registries `tests/ci_portable.txt` / `tests/ci_static.txt`, `source_regex`, `source_depth` 2) | as listed | `lib/py/bbx/config.py` DEFAULTS | arbitrary | bbh's layout literals kept so a bbh config reads unchanged; the second consumer (the `self` kind) overrides every one of them, which is BBX-25's detector working |
| D9 | `[project].kind` when a config names none | `frame-driven` | `lib/py/bbx/config.py` DEFAULTS | arbitrary | bbh's configs carry no kind and must resolve to bbh's values (F13); a config for any other kind names it. Revisit when a third kind exists |
| D10 | `[controls].enforce` | `false` | `lib/py/bbx/config.py` DEFAULTS; `bbx.toml` sets `true` | principled | off is bbh's behaviour byte for byte (fidelity); the harness's own tree enforces (R10, R14) |
| D11 | the classifier's literals (`skip_regex` `^ *SKIP`, `shell_error_regex`, `timeout_exits` 124 137, `fail_tail` 4) | as listed | `lib/sh/classify.sh`, `config.py` DEFAULTS | principled | bbh's gate contract `[BBH-12]`–`[BBH-15]`, each paid for in the lineage; a consumer overrides through `[classify]` and gates/classify.sh proves the override reaches the classifier |
| D12 | the `frame-driven` kind profile (`instrument_word` emulator, `static_needs_env` ROMDIR, bbh's ten `tier.patterns`) | bbh's DEFAULTS verbatim | `config.py` KINDS | reference-calibrated | bbh `lib/py/bbh/config.py` at f675710; F13 diffs a runner reading them against bbh |
| D13 | the `self` kind profile (`gates_dir` gates, `lib_dir` lib/sh, registries under gates/, `static_needs_env` BBX_BBH_HOME, controls enforced) | as listed | `config.py` KINDS; `bbx.toml` | principled | BBX reading its own tree (R14) |
| D14 | quoted runtime of `bin/bbx selftest` | ~117 s (`real 117.35`; was 47 s with 7 gates) | `HANDOFF.md` | reference-calibrated | `/usr/bin/time -p bin/bbx selftest` with BBX_BBH_HOME set, 9 gates (the sweep runner's ground truth carries three deliberately slow gates), macOS, 2026-09-09 |
| D15 | the kind-blind `[sweep]` defaults (one lane `prereq`, release scope `release`, cadence `always`, timeout 600, no precondition, `input_env` BBX_INPUT, `log_dir_prefix` build/sweep_, no placeholders, no instruments, no scratch) | as listed | `lib/py/bbx/config.py` DEFAULTS | arbitrary | a sweep with no instrument named; the frame-driven profile carries bbh's literals (incl. VampireSaved's build dirs and MAME paths) so a bbh config resolves as in bbh (F14); `self` names `BBX_BBH_HOME` as its input |
| D16 | the kind-blind `[fingerprint]` defaults (`kind` file-sha1, `file_pattern` {set}.bin, no parent sets, no region rules, `region_default` other) and `[suite].registry` tests/expected/registry.tsv, `default_set` "" | as listed | `config.py` DEFAULTS | principled | the most generic artifact is one file whose identity is its SHA-1 (abstraction S2); the frame-driven profile is bbh's zip-members literals verbatim (F14f) |
| D5 | the platform floor | POSIX sh + Python 3; macOS, Linux, Windows via WSL | ruled R3 | principled (ruled) | every platform guard has a gate on each platform |
| D7 | where the gate finds the census files | `docs/census/` under the BBX root; env `BBX_CENSUS_DIR` overrides | `gates/census_recount.sh` | principled | the override exists so the SKIP path (an absent lineage tree) can be exercised on purpose without moving a repository |
| D6 | the environment every census command runs in | `PATH=/usr/bin:/bin:/usr/sbin:/sbin`, `LANG=LC_ALL=C.UTF-8`, `HOME`, `TMPDIR`, `PYTHONDONTWRITEBYTECODE=1`, nothing else | `lib/py/bbx/recount.py` `hermetic_env()` | principled | a count must not depend on which program answers to a name in the caller's shell (gotcha G9: ugrep vs BSD grep, six counts moved); bbh scrubs the replay family the same way `[BBH-35]` |

The lineage's biased default (bbh's `DEFAULTS` naming VampireSaved's build
directories, `docs/gotchas.md` G4) is the reason every row here names its
class.
