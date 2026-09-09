# Census — blackbox-harness (bbh) @ f675710 — measured 2026-09-09
`/Users/koneko/Developer/blackbox-harness` · remote `https://github.com/DefinitelyFrenchName/blackbox-harness.git` · **190** tracked files · **19** commits · dirty: `docs/config.md example/consumers/bbh.vampire.toml lib/py/bbh/config.py selftest/test_fidelity_vampire.sh` — `4 files changed, 6 insertions(+), 6 deletions(-)`

Read-only survey. Every count in §A carries the command that reproduces it at this HEAD.
Purpose: enumerate everything a generalization of bbh to non-frame subjects must decide about.

## A. Counts

| id | dimension | count | command (run from repo root) |
|---|---|---|---|
| A1 | tracked files (total) | 190 | `git ls-files | wc -l` |
| A2 | commits on HEAD | 19 | `git log --oneline | wc -l` |
| A3 | dirty files in the working tree | 4 | `git status --porcelain | wc -l` |
| A4 | tracked files in example/ | 83 | `git ls-files example | wc -l` |
| A5 | tracked files in selftest/ | 33 | `git ls-files selftest | wc -l` |
| A6 | tracked files in lib/ | 32 | `git ls-files lib | wc -l` |
| A7 | tracked files in lua/ | 13 | `git ls-files lua | wc -l` |
| A8 | tracked files in docs/ | 9 | `git ls-files docs | wc -l` |
| A9 | tracked files in bin/ | 8 | `git ls-files bin | wc -l` |
| A10 | tracked files in drivers/ | 5 | `git ls-files drivers | wc -l` |
| A11 | tracked files in skill/ | 3 | `git ls-files skill | wc -l` |
| A12 | tracked files at the repo root | 4 | `git ls-files | grep -vc /` |
| A13 | bin/ entry points | 8 | `ls -1 bin/* | wc -l` |
| A14 | lib/py/bbh python modules | 23 | `ls -1 lib/py/bbh/*.py | wc -l` |
| A15 | lib/sh sourced shell libs | 9 | `ls -1 lib/sh/*.sh | wc -l` |
| A16 | lua/mame scripts + profiles | 13 | `git ls-files lua | wc -l` |
| A17 | machine profiles (lua/mame/profiles) | 3 | `ls -1 lua/mame/profiles/*.lua | wc -l` |
| A18 | shipped drivers | 4 | `ls -1 drivers/*.sh | wc -l` |
| A19 | bbh subcommands dispatched | 26 | `grep -cE '^[a-z-]+\)  *exec' bin/bbh` |
| A20 | distinct BBH rule IDs | 87 | `git grep -ohE '\[BBH-[0-9]+\]' | sed 's/[][]//g' | sort -u | wc -l` |
| A21 | distinct ANCHORED rule defs (bold, docs only) | 87 | `git grep -ohE '\*\*\[BBH-[0-9]+\]\*\*' -- docs README.md drivers/README.md | sed 's/[][*]//g' | sort -u | wc -l` |
| A22 | files that DEFINE rules (carry a bold anchor), excl. GUIDE.md | 9 | `git grep -lE '\*\*\[BBH-[0-9]+\]\*\*' | grep -v GUIDE.md | wc -l` |
| A23 | rule bullets in SKILL.md | 87 | `grep -cE '^- \[BBH-[0-9]+\]' skill/blackbox-harness/SKILL.md` |
| A24 | anchors in the GENERATED GUIDE.md | 87 | `grep -cE '^\*\*\[BBH-[0-9]+\]\*\*' skill/blackbox-harness/GUIDE.md` |
| A25 | distinct NON-BBH bracket IDs anywhere | 17 | `git grep -ohE '\[[A-Z]{2,5}-[0-9]+\]' | sed 's/[][]//g' | grep -v '^BBH-' | sort -u | wc -l` |
| A26 | files carrying the one real foreign rule ID [CPE-24] | 6 | `git grep -il 'CPE-24' | wc -l` |
| A27 | forbidden tokens in skill/skills.toml forbid list | 33 | `sed -n '/^forbid = /p' skill/skills.toml | grep -o '"[^"]*"' | wc -l` |
| A28 | forbidden BRACKET-prefix tokens (other skills' IDs) | 9 | `grep -o '"\[[A-Z]*-"' skill/skills.toml | wc -l` |
| A29 | oracle comparison classes (table rows) | 5 | `sed -n '/^## The classes/,/^Two rulings/p' docs/method/oracle_classes.md | grep -E '^\| ' | tail -n +2 | wc -l` |
| A30 | expectation KINDS registered in enumerate_expectations.sh | 5 | `grep -cE '^\s+(masked|skip|sha1|diverge|pending)\)' lib/sh/enumerate_expectations.sh` |
| A31 | comparator / checker modules under lib/py/bbh | 7 | `ls -1 lib/py/bbh/compare_*.py lib/py/bbh/check_*.py lib/py/bbh/describe_masked_shape.py | wc -l` |
| A32 | comparison thresholds declared in thresholds.py | 3 | `grep -oE '"[a-z_]+": [0-9]+' lib/py/bbh/thresholds.py | wc -l` |
| A33 | replay-family driver env vars (drivers/README.md §2) | 9 | `sed -n '/^## 2. The environment/,/^\*\*\[BBH-29\]/p' drivers/README.md | grep -cE '^\| `[A-Z_]+`'` |
| A34 | guard-family driver env vars | 9 | `sed -n '/\[BBH-29\]/,/\[BBH-28\]/p' drivers/README.md | grep -oE '`[A-Z_]+`' | sort -u | wc -l` |
| A35 | driver exit statuses defined | 4 | `sed -n '/^## 4. The exit status/,/^## 5/p' drivers/README.md | grep -cE '^\| [0-9]'` |
| A36 | hygiene checks (docs/hygiene.md table rows) | 8 | `sed -n '/^| check |/,/^$/p' docs/hygiene.md | grep -cE '^\| `'` |
| A37 | lineage evidence classes (closed vocabulary, hygiene.md) | 6 | `sed -n '/^\*\*\[BBH-53\]\*\*/,/^Files with no/p' docs/hygiene.md | grep -cE '^- `'` |
| A38 | example consumer evidence classes | 4 | `grep -cE '^- `' example/expected/PROVENANCE.md` |
| A39 | machine-profile keys documented (docs/lua.md §1 table) | 16 | `sed -n '/^| key | read by | meaning |/,/^$/p' docs/lua.md | grep -cE '^\| `'` |
| A40 | top-level keys in profiles/TEMPLATE.lua | 16 | `grep -cE '^\s+[a-z_]+ =' lua/mame/profiles/TEMPLATE.lua` |
| A41 | selftests (selftest/test_*.sh) | 32 | `ls -1 selftest/test_*.sh | wc -l` |
| A42 | selftests containing the marker 'must-fire' | 23 | `git grep -il 'must-fire' -- selftest | wc -l` |
| A43 | selftests containing any control marker (must-fire|negative control|control:) | 24 | `git grep -ilE 'must-fire|negative control|control:' -- selftest | wc -l` |
| A44 | total 'must-fire' occurrences across selftest/ | 54 | `git grep -oi 'must-fire' -- selftest | wc -l` |
| A45 | config keys DOCUMENTED (table rows in docs/config.md) | 121 | `grep -cE '^\| `' docs/config.md` |
| A46 | config sections in docs/config.md | 17 | `grep -cE '^## ' docs/config.md` |
| A47 | config keys in code (lib/py/bbh/config.py DEFAULTS) | 116 | `PYTHONPATH=lib/py python3 -c 'from bbh import config as C; print(sum(len(d) for d in C.DEFAULTS.values()))'` |
| A48 | config sections in code (DEFAULTS) | 16 | `PYTHONPATH=lib/py python3 -c 'from bbh import config as C; print(len(C.DEFAULTS))'` |
| A49 | docs/config.md rows with origin = config | 93 | `grep -oE '\| (code|config)[^|]*\|' docs/config.md | sed 's/|//g;s/^ *//;s/ *$//' | grep -cx 'config'` |
| A50 | docs/config.md rows with origin = code | 13 | `grep -oE '\| (code|config)[^|]*\|' docs/config.md | sed 's/|//g;s/^ *//;s/ *$//' | grep -cx 'code'` |
| A51 | docs/config.md rows with origin = config (policy) | 8 | `grep -oE '\| (code|config)[^|]*\|' docs/config.md | sed 's/|//g;s/^ *//;s/ *$//' | grep -cx 'config (policy)'` |
| A52 | docs/config.md rows with origin = config (a game fact) | 1 | `grep -oE '\| (code|config)[^|]*\|' docs/config.md | sed 's/|//g;s/^ *//;s/ *$//' | grep -cx 'config (a game fact)'` |
| A53 | docs/config.md rows with origin = code (policy) | 1 | `grep -oE '\| (code|config)[^|]*\|' docs/config.md | sed 's/|//g;s/^ *//;s/ *$//' | grep -cx 'code (policy)'` |
| A54 | literals binned in the lua defaults census (docs/lua.md §5) | 12 | `sed -n '/^## 5. The defaults census/,/^## 6/p' docs/lua.md | grep -E '^\| ' | tail -n +2 | wc -l` |
| A55 | ruled defaults in docs/conventions.md | 9 | `grep -cE '^[0-9]+\. ' docs/conventions.md` |
| A56 | re-baseline entries in docs/rebaselines.md | 1 | `grep -c '^- ' docs/rebaselines.md` |
| A57 | fidelity rows F1-F11 (header entries) | 11 | `grep -cE '^#   F[0-9]+ ' selftest/test_fidelity_vampire.sh` |
| A58 | F8 sub-rows F8a-F8h | 8 | `grep -cE '^#   F8[a-h] ' selftest/test_fidelity_mame.sh` |
| A59 | example gates (tests/g_*.sh) | 12 | `ls -1 example/tests/g_*.sh | wc -l` |
| A60 | example replays (.rpl) | 6 | `ls -1 example/replays/*.rpl | wc -l` |
| A61 | example fake ROM image dirs | 5 | `ls -1d example/roms/*/ | wc -l` |
| A62 | example expected .sha1 files | 11 | `git ls-files 'example/expected/*.sha1' | wc -l` |
| A63 | example expected .masked specs | 10 | `git ls-files 'example/expected/*.masked' | wc -l` |
| A64 | example expected .skip files | 2 | `git ls-files 'example/expected/*.skip' | wc -l` |
| A65 | example expected .diverge files | 1 | `git ls-files 'example/expected/*.diverge' | wc -l` |
| A66 | example expected frozen logs | 17 | `git ls-files 'example/expected/*.log' | wc -l` |
| A67 | example mask/MASK basis files | 3 | `git ls-files example/expected | grep -icE '(^|/)(MASK|mask)$'` |
| A68 | example registry.tsv fingerprint rows | 4 | `grep -vc '^#' example/expected/registry.tsv` |
| A69 | example PROVENANCE.md rows | 1 | `grep -cE '^\| `' example/expected/PROVENANCE.md` |
| A70 | example sweep registry rows | 5 | `grep -vc '^#' example/tests/ci_sweep.tsv` |
| A71 | example gate_index.tsv family rows | 12 | `grep -vc '^#' example/tests/gate_index.tsv` |
| A72 | example fields.tsv mapped fields | 7 | `grep -vc '^#' example/tests/fields.tsv` |
| A73 | fake machine feature/knob rows (example/README.md) | 7 | `sed -n '/^## What the fake machine is/,$p' example/README.md | grep -E '^\| ' | tail -n +2 | wc -l` |
| A74 | files mentioning 'cps2' (case-insensitive) | 18 | `git grep -il cps2 | wc -l` |
| A75 | files mentioning 'mame' (case-insensitive) | 43 | `git grep -il mame | wc -l` |
| A76 | files mentioning 'vampire' (case-insensitive) | 65 | `git grep -il vampire | wc -l` |
| A77 | files mentioning '68k' (case-insensitive) | 0 | `git grep -il 68k | wc -l` |
| A78 | files mentioning 'fbneo' (case-insensitive) | 20 | `git grep -il fbneo | wc -l` |
| A79 | files mentioning 'lua' (case-insensitive) | 40 | `git grep -il lua | wc -l` |

## B. Items

280 rows. Kinds: **R** 87, **C** 22, **K** 8, **T** 32, **D** 31, **G** 10, **F** 19, **P** 17, **X** 54  (R rule · C contract · K comparator · T control/selftest · D default · G registry · F fidelity row · P prose principle with no rule ID · X other).
Line numbers are at HEAD `f675710`. For a rule the source is the **anchor** (`**[BBH-N]**`), never the SKILL.md bullet.

| id | kind | item | source | row-provenance |
|---|---|---|---|---|
| B-R1 | R | **[BBH-1]** The extraction question decides every bin. | docs/doctrine.md:13 | gen:G1 |
| B-R2 | R | **[BBH-2]** No untested change survives. | docs/doctrine.md:26 | gen:G1 |
| B-R3 | R | **[BBH-3]** Every in-instrument measurement becomes a rerunnable case before the session ends. | docs/doctrine.md:35 | gen:G1 |
| B-R4 | R | **[BBH-4]** Verdict logic is itself tested, in both directions. | docs/doctrine.md:43 | gen:G1 |
| B-R5 | R | **[BBH-5]** A field report is a RECORDING before it is a theory. | docs/doctrine.md:52 | gen:G1 |
| B-R6 | R | **[BBH-6]** SKIP is not PASS. | docs/doctrine.md:63 | gen:G1 |
| B-R7 | R | **[BBH-7]** A red gate is a QUESTION whose first question is which side rests on a measurement. | docs/doctrine.md:71 | gen:G1 |
| B-R8 | R | **[BBH-8]** When a claim changes, grep for the claim. | docs/doctrine.md:80 | gen:G1 |
| B-R9 | R | **[BBH-9]** The docs stay LEAN and are searched by KEY; the complete LOG lives in `<name>_history.md` twins. | docs/doctrine.md:93 | gen:G1 |
| B-R10 | R | **[BBH-10]** The doctrine is not a tuning guide and not a claim about correctness. | docs/doctrine.md:120 | gen:G1 |
| B-R11 | R | **[BBH-11]** The runners read a gate's NAME, EXIT STATUS and OUTPUT — never its code. | docs/gate_contract.md:4 | gen:G1 |
| B-R12 | R | **[BBH-12]** Exit status decides FIRST. | docs/gate_contract.md:12 | gen:G1 |
| B-R13 | R | **[BBH-13]** The timeout wrapper's exits are TIMEOUT, never FAIL, | docs/gate_contract.md:13 | gen:G1 |
| B-R14 | R | **[BBH-14]** Exit 0 after the shell's OWN error line is a CRASH, not a PASS. | docs/gate_contract.md:14 | gen:G1 |
| B-R15 | R | **[BBH-15]** The SKIP marker is a line matching the skip regex on exit 0, and the word SKIP in PROSE is not a marker; | docs/gate_contract.md:15 | gen:G1 |
| B-R16 | R | **[BBH-16]** `--strict` makes SKIP fatal: | docs/gate_contract.md:19 | gen:G1 |
| B-R17 | R | **[BBH-17]** A demand is placed BEFORE any trap, and after a trap is armed a demand is an EXPLICIT TEST, never a parameter abort | docs/gate_contract.md:39 | gen:G1 |
| B-R18 | R | **[BBH-18]** Line 2 of a gate is an API: | docs/gate_contract.md:52 | gen:G1 |
| B-R19 | R | **[BBH-19]** A header names the default its CODE uses. | docs/hygiene.md:15 | gen:G1 |
| B-R20 | R | **[BBH-20]** A gate ends with ONE verdict line of its own | docs/gate_contract.md:65 | gen:G1 |
| B-R21 | R | **[BBH-21]** Every gate that asserts a property carries a MUST-FIRE control | docs/gate_contract.md:73 | gen:G1 |
| B-R22 | R | **[BBH-22]** A gate that is in no registry is not run. | docs/gate_contract.md:91 | gen:G1 |
| B-R23 | R | **[BBH-23]** Whether a gate reaches an instrument is decided TRANSITIVELY | README.md:18 | gen:G1 |
| B-R24 | R | **[BBH-24]** The harness will NOT read a gate's code, guess a skip from prose, count a self-skip as a pass, edit a running script, o… | docs/gate_contract.md:103 | gen:G1 |
| B-R25 | R | **[BBH-25]** A driver has four arguments — `<set> <replay> <out.log> [sandbox]` — and the suite, the comparators and the fidelity ch… | drivers/README.md:3 | gen:G1 |
| B-R26 | R | **[BBH-26]** The build under test is what the driver's SEARCH PATH resolves, | drivers/README.md:22 | gen:G1 |
| B-R27 | R | **[BBH-27]** The output log is REMOVED before the run, | drivers/README.md:19 | gen:G1 |
| B-R28 | R | **[BBH-28]** A driver that cannot honour a variable REFUSES it — `REFUSED: <driver> cannot honour <VAR>`, exit 3 — and never ignores… | drivers/README.md:47 | gen:G1 |
| B-R29 | R | **[BBH-29]** The replay family is one vocabulary for every driver: | drivers/README.md:42 | gen:G1 |
| B-R30 | R | **[BBH-30]** A masked log is a BASIS: | drivers/README.md:32 | gen:G1 |
| B-R31 | R | **[BBH-31]** The video log is a SECOND hash log over the framebuffer, in the same grammar, written to a separate file | drivers/README.md:36 | gen:G1 |
| B-R32 | R | **[BBH-32]** The input-integrity assertion is always on, and it has a must-fire: | drivers/README.md:40 | gen:G1 |
| B-R33 | R | **[BBH-33]** The log grammar is `<frame> <hash>` per frame then `END <n>`, | drivers/README.md:68 | gen:G1 |
| B-R34 | R | **[BBH-34]** The four exits mean four things: | drivers/README.md:78 | gen:G1 |
| B-R35 | R | **[BBH-35]** The suite scrubs the replay family from its environment before any driver runs, | drivers/README.md:55 | gen:G1 |
| B-R36 | R | **[BBH-36]** The sandbox is the machine's home | drivers/README.md:20 | gen:G1 |
| B-R37 | R | **[BBH-37]** A second implementation of the same machine is a driver under the same contract | drivers/README.md:90 | gen:G1 |
| B-R38 | R | **[BBH-38]** A mask is a basis, not a flag: | docs/method/oracle_classes.md:18 | gen:G1 |
| B-R39 | R | **[BBH-39]** Every non-exact class is a MEASURED MECHANISM with a FROZEN expectation; none is a tolerance. | docs/method/oracle_classes.md:3 | gen:G1 |
| B-R40 | R | **[BBH-40]** Flicker-tolerated asserts that the divergent frames are EXACTLY the frozen inventory | docs/method/oracle_classes.md:34 | gen:G1 |
| B-R41 | R | **[BBH-41]** The frozen first-divergence constant asserts line-identity through `frame−1` and a first divergence EXACTLY at `frame`; | docs/method/oracle_classes.md:35 | gen:G1 |
| B-R42 | R | **[BBH-42]** The bounded re-convergent window asserts ONE contiguous run, a FIXED onset, full re-convergence and the end state untou… | docs/method/oracle_classes.md:36 | gen:G1 |
| B-R43 | R | **[BBH-43]** Composite is the strict CONJUNCTION of flicker and window: | docs/method/oracle_classes.md:37 | gen:G1 |
| B-R44 | R | **[BBH-44]** The re-convergence rule is INTRA-mechanism: | docs/method/oracle_classes.md:41 | gen:G1 |
| B-R45 | R | **[BBH-45]** A divergence that does not re-converge is NOT expressible in the vocabulary. | docs/method/oracle_classes.md:46 | gen:G1 |
| B-R46 | R | **[BBH-46]** A replay is reclassified to a looser class only with a NEW MEASURED MECHANISM and the consumer's sign-off | docs/method/oracle_classes.md:53 | gen:G1 |
| B-R47 | R | **[BBH-47]** The standing watch: flickers growing beyond the frozen inventory, or divergences turning systematic, mean STOP AND ROOT… | docs/method/oracle_classes.md:55 | gen:G1 |
| B-R48 | R | **[BBH-48]** The proposer and the enforcers cannot disagree: | docs/method/oracle_classes.md:60 | gen:G1 |
| B-R49 | R | **[BBH-49]** Whole-state frame-exact remains the standard | docs/method/oracle_classes.md:64 | gen:G1 |
| B-R50 | R | **[BBH-50]** A self-frozen expectation answers "did this build change since I froze it" and can never see a regression against the r… | docs/method/oracle_classes.md:72 | gen:G1 |
| B-R51 | R | **[BBH-51]** A `.pending` expectation is REPORTED as unevaluated, never silently skipped | docs/method/oracle_classes.md:79 | gen:G1 |
| B-R52 | R | **[BBH-52]** Every frozen expectation FILE has a row in a register naming what it describes, a CLOSED evidence class it rests on, an… | docs/hygiene.md:14 | gen:G1 |
| B-R53 | R | **[BBH-53]** The evidence classes are a policy, not a format, | docs/hygiene.md:25 | gen:G1 |
| B-R54 | R | **[BBH-54]** A hard-coded path default the script READS as an image must not have ROTTED | docs/hygiene.md:58 | gen:G1 |
| B-R55 | R | **[BBH-55]** CURRENCY is the other question and it is REPORTED, never failed: | docs/hygiene.md:66 | gen:G1 |
| B-R56 | R | **[BBH-56]** A pick among several files is sorted first and then an ORDERED, NAMED preference; | docs/config.md:189 | gen:G1 |
| B-R57 | R | **[BBH-57]** The gate index is GENERATED from every gate's own header plus one hand-maintained family table, complete both ways, and… | docs/hygiene.md:17 | gen:G1 |
| B-R58 | R | **[BBH-58]** A battery cannot print GREEN while a gate self-skipped: | docs/hygiene.md:18 | gen:G1 |
| B-R59 | R | **[BBH-59]** A perturbation control edits a SHADOW COPY of the tool under a throwaway root whose siblings are symlinks; the tracked … | docs/hygiene.md:19 | gen:G1 |
| B-R60 | R | **[BBH-60]** The one header parser is the only reader of headers, | docs/hygiene.md:49 | gen:G1 |
| B-R61 | R | **[BBH-61]** Every key has a default and a BIN it came from, listed in one reference; | docs/config.md:19 | gen:G1 |
| B-R62 | R | **[BBH-62]** A missing key with no default is FATAL, never silent: | docs/config.md:3 | gen:G1 |
| B-R63 | R | **[BBH-63]** The config is a TOML SUBSET, refused where it is ambiguous: | docs/config.md:11 | gen:G1 |
| B-R64 | R | **[BBH-64]** The thresholds are a consumer's RATIFIED comparison policy, not tuning knobs: | docs/config.md:65 | gen:G1 |
| B-R65 | R | **[BBH-65]** A board is never implied: | docs/config.md:273 | gen:G1 |
| B-R66 | R | **[BBH-66]** A consumer config that lives outside the tree it describes carries ONE host's layout, | docs/conventions.md:45 | gen:G1 |
| B-R67 | R | **[BBH-67]** Registry rows are written only at freeze time, as a build decision | docs/config.md:88 | gen:G1 |
| B-R68 | R | **[BBH-68]** The sweep registry declares a release's instrument scope: | docs/config.md:114 | gen:G1 |
| B-R69 | R | **[BBH-69]** A recording is a directory of four things | docs/config.md:277 | gen:G1 |
| B-R70 | R | **[BBH-70]** A default that names one host's file, one project's build or one lineage's session is a dated assertion with no expiry: | docs/config.md:141 | gen:G1 |
| B-R71 | R | **[BBH-71]** Every board literal lives in ONE machine-profile table | docs/lua.md:14 | gen:G1 |
| B-R72 | R | **[BBH-72]** Two guards on one board must draw the same sketch of one crash: | docs/lua.md:32 | gen:G1 |
| B-R73 | R | **[BBH-73]** One strict grammar, whose two copies are diffed: | docs/lua.md:43 | gen:G1 |
| B-R74 | R | **[BBH-74]** Input staging is CANONICAL | docs/lua.md:64 | gen:G1 |
| B-R75 | R | **[BBH-75]** A memory tap is dropped silently whenever the machine re-installs handlers in the space; | docs/lua.md:70 | gen:G1 |
| B-R76 | R | **[BBH-76]** A written value and a read value are correlated in ONE run through a non-debug read-and-write tap, never across runs; | docs/lua.md:62 | gen:G1 |
| B-R77 | R | **[BBH-77]** Every reproducible crash is captured as a recording named after the freeze it was PLAYED on, tracked with its note, and… | docs/lua.md:80 | gen:G1 |
| B-R78 | R | **[BBH-78]** A playback that ran ZERO frames executes no code and can raise no exception: | docs/lua.md:89 | gen:G1 |
| B-R79 | R | **[BBH-79]** Every literal in the instrument layer is in one of three bins: | docs/lua.md:119 | gen:G1 |
| B-R80 | R | **[BBH-80]** Two implementations of one machine traverse identical states on different frame indices, | README.md:31 | gen:G1 |
| B-R81 | R | **[BBH-81]** An extraction is PROVED by running the generic tool and the original over the SAME input and diffing the verdict TEXT | docs/doctrine.md:108 | gen:G1 |
| B-R82 | R | **[BBH-82]** The generic classifier is the STRONGER copy, and a consumer's delta against it is a FINDING about the consumer | docs/conventions.md:56 | gen:G1 |
| B-R83 | R | **[BBH-83]** A verdict-text or classifier change is never silent: | docs/conventions.md:64 | gen:G1 |
| B-R84 | R | **[BBH-84]** A default that is not written down is a default nobody can veto: | docs/conventions.md:4 | gen:G1 |
| B-R85 | R | **[BBH-85]** The harness is found by an environment variable and never pinned as a submodule, | docs/conventions.md:15 | gen:G1 |
| B-R86 | R | **[BBH-86]** Lifted comments keep their incident citations as history lines and carry no consumer's rule anchor; | docs/conventions.md:24 | gen:G1 |
| B-R87 | R | **[BBH-87]** A driver for a lane one consumer has stays with that consumer until a second consumer exists; | docs/conventions.md:32 | gen:G1 |
| B-C1 | C | THE GATE CONTRACT — "The runners do not read its code; they read its NAME, its EXIT STATUS and its OUTPUT." 7 sections, 5 verdict rows. | docs/gate_contract.md:1 | read |
| B-C2 | C | THE VERDICT CLASSIFIER (impl) — the ONE copy sourced by every runner; regexes + exit list are `[classify]` config. | lib/sh/classify.sh:1 | read |
| B-C3 | C | THE DRIVER CONTRACT — `<driver> <set> <replay.rpl> <out.log> [sandbox]`; 9 replay vars + 9 guard vars; REFUSE-not-ignore; exits 0/1/2/3. | drivers/README.md:1 | read |
| B-C4 | C | THE LOG GRAMMAR — `<frame> <hash>` per frame, optional `INPUT-VIOLATION`, `END <n>` last; guarded variant ends `END-CRASH`. | drivers/README.md:59 | read |
| B-C5 | C | THE ORACLE CLASSES — the ratified comparison vocabulary (exact/flicker/diverge/window/composite) and what may never loosen one. | docs/method/oracle_classes.md:1 | read |
| B-C6 | C | THE .RPL GRAMMAR (python) — `<frame>[-<end>] <who>=<tokens>` / `<frame> wait`; token width per side; frame 1 is the first emulated frame. | lib/py/bbh/rpl.py:1 | read |
| B-C7 | C | THE .RPL GRAMMAR (Lua twin) — one strict parser for every MAME script; `bbh rpl dump` == `rpl_dump.lua` so the two can be diffed. | lua/mame/rpl_parse.lua:1 | read |
| B-C8 | C | THE EXPECTATION KINDS — masked/skip/sha1/diverge/pending + UNKNOWN-KIND fallback; "A new expectation KIND is registered HERE, and nowhere else." | lib/sh/enumerate_expectations.sh:11 | read |
| B-C9 | C | THE MASKED DISPATCHER — the ONE implementation of the vocabulary; verdict lines reproduced character-for-character; baseset/mask invariant guard. | lib/sh/masked_compare.sh:1 | read |
| B-C10 | C | THE GATE HEADER CONTRACT — line 2 is an API; first paragraph is the index sentence; one parser, `gate_header.py`. | docs/gate_contract.md:50 | read |
| B-C11 | C | THE CONFIG CONTRACT — one bbh.toml per consumer, paths relative to the config file, a key with no default and no --default is FATAL (exit 3). | docs/config.md:1 | read |
| B-C12 | C | THE TOML SUBSET — tables, basic/literal strings, ints, bools, arrays, inline tables of scalars; dotted names, arrays-of-tables, floats REFUSED. | lib/py/bbh/toml_subset.py:1 | read |
| B-C13 | C | THE CONVENTIONS REGISTER — 9 ruled defaults, each with the declined alternative; "A default that is not written down is a default nobody can veto." | docs/conventions.md:1 | read |
| B-C14 | C | THE PROVENANCE CONTRACT — a register row per frozen expectation FILE naming a CLOSED evidence class; complete both ways. | docs/hygiene.md:25 | read |
| B-C15 | C | THE PROVENANCE REGISTER (example instance) — 4 evidence classes, 1 row; directories deliberately out of scope. | example/expected/PROVENANCE.md:1 | read |
| B-C16 | C | THE RE-BASELINE REGISTER — one dated line per verdict-text/classifier change; the newest is printed at the head of every fidelity run. | docs/rebaselines.md:1 | read |
| B-C17 | C | THE DOCTRINE — 8 sentences + the extraction question, the docs convention, how an extraction is PROVED, what the doctrine is not. | docs/doctrine.md:1 | read |
| B-C18 | C | THE HYGIENE CONTRACT — 8 checks that keep a suite honest between runs, each with the incident it exists for. | docs/hygiene.md:1 | read |
| B-C19 | C | THE MACHINE PROFILE CONTRACT — 16 documented keys; `profile.load()` REFUSES a missing required key; a script never runs on an implied board. | docs/lua.md:12 | read |
| B-C20 | C | THE SKILLS LOCK CONTRACT — `[skills]`+`[skill_<PFX>]`; ID-lock both ways, forbidden tokens, numbers cite the log, cross-references resolve. | docs/config.md:235 | read |
| B-C21 | C | THE ACCOUNTING RULE — "GREEN" cannot print while a gate self-skipped; bbh_bat / bbh_bat_group_skip / bbh_bat_report. | lib/sh/accounting.sh:1 | read |
| B-C22 | C | THE FIDELITY CONTRACT — generic tool and original over the SAME input, verdict TEXT diffed; never re-derived by hand. | docs/doctrine.md:108 | read |
| B-K1 | K | compare_flicker.py — checksum-log comparison with bounded flicker tolerance (the FLICKER-TOLERATED class; docs/method/oracle_classes.… | lib/py/bbh/compare_flicker.py:2 | gen:G5 |
| B-K2 | K | compare_window.py — the "bounded re-convergent window" comparison class (docs/method/oracle_classes.md v3). | lib/py/bbh/compare_window.py:2 | gen:G5 |
| B-K3 | K | compare_composite.py — the CONJUNCTION of two already-ratified comparison classes, for replays whose masked comparison shows both (do… | lib/py/bbh/compare_composite.py:2 | gen:G5 |
| B-K4 | K | check_diverge.py — verify a checksum log diverges from a frozen base log at EXACTLY the expected frame (the suite's .diverge expectat… | lib/py/bbh/check_diverge.py:2 | gen:G5 |
| B-K5 | K | describe_masked_shape.py — the measured shape of a masked divergence, and a PROPOSED expectation line in the ratified vocabulary. | lib/py/bbh/describe_masked_shape.py:2 | gen:G5 |
| B-K6 | K | compare_fields.py — compare MAPPED FIELDS between two replay runs from their per-frame RAM dumps, at SYNC ANCHORS (bbh compare-fields… | lib/py/bbh/compare_fields.py:1 | gen:G5 |
| B-K7 | K | check_dumps.py — assert a per-frame RAM dump directory is COMPLETE (bbh check-dumps). | lib/py/bbh/check_dumps.py:1 | gen:G5 |
| B-K8 | K | logfmt.py — the checksum-log grammar, parsed in ONE place. | lib/py/bbh/logfmt.py:1 | gen:G5 |
| B-T1 | T | test_accounting.sh [NO must-fire marker]: ground truth for lib/sh/accounting.sh: "BATTERY GREEN" | selftest/test_accounting.sh:2 | gen:G2 |
| B-T2 | T | test_check_dumps.sh [MUST-FIRE x2]: ground truth for lib/py/bbh/check_dumps.py: a | selftest/test_check_dumps.sh:2 | gen:G2 |
| B-T3 | T | test_classify.sh [MUST-FIRE x2]: ground truth for lib/sh/classify.sh: every verdict case | selftest/test_classify.sh:2 | gen:G2 |
| B-T4 | T | test_compare_composite.sh [NO must-fire marker]: ground truth for the composite class (v4: frozen | selftest/test_compare_composite.sh:2 | gen:G2 |
| B-T5 | T | test_compare_fields.sh [MUST-FIRE x2]: ground truth for lib/py/bbh/compare_fields.py, the | selftest/test_compare_fields.sh:2 | gen:G2 |
| B-T6 | T | test_compare_flicker.sh [MUST-FIRE x1]: ground truth for the flicker comparator's verdict | selftest/test_compare_flicker.sh:2 | gen:G2 |
| B-T7 | T | test_compare_window.sh [NO must-fire marker]: ground truth for the "bounded re-convergent | selftest/test_compare_window.sh:2 | gen:G2 |
| B-T8 | T | test_config.sh [MUST-FIRE x2]: ground truth for the TOML-subset reader and `bbh config`: | selftest/test_config.sh:2 | gen:G2 |
| B-T9 | T | test_demand_after_trap.sh [MUST-FIRE x1]: ground truth for lib/py/bbh/demand_after_trap.py | selftest/test_demand_after_trap.sh:2 | gen:G2 |
| B-T10 | T | test_driver_contract.sh [MUST-FIRE x5]: ground truth for drivers/README.md against | selftest/test_driver_contract.sh:2 | gen:G2 |
| B-T11 | T | test_enumerate_expectations.sh [NO must-fire marker]: ground truth for | selftest/test_enumerate_expectations.sh:2 | gen:G2 |
| B-T12 | T | test_fidelity_mame.sh [MUST-FIRE x3]: FIDELITY F8: the MAME Lua layer, the MAME / FBNeo | selftest/test_fidelity_mame.sh:2 | gen:G2 |
| B-T13 | T | test_fidelity_vampire.sh [NO must-fire marker]: FIDELITY against the lineage: the generic runner | selftest/test_fidelity_vampire.sh:2 | gen:G2 |
| B-T14 | T | test_fingerprint.sh [MUST-FIRE x3]: ground truth for lib/py/bbh/fingerprint.py on | selftest/test_fingerprint.sh:2 | gen:G2 |
| B-T15 | T | test_gate_index.sh [MUST-FIRE x2]: ground truth for lib/py/bbh/gen_gate_index.py and the | selftest/test_gate_index.sh:2 | gen:G2 |
| B-T16 | T | test_header_defaults.sh [MUST-FIRE x2]: ground truth for lib/py/bbh/header_defaults.py: a | selftest/test_header_defaults.sh:2 | gen:G2 |
| B-T17 | T | test_inp_corpus.sh [MUST-FIRE x2]: ground truth for bin/bbh-inp-corpus, ROM-FREE: a STUB | selftest/test_inp_corpus.sh:2 | gen:G2 |
| B-T18 | T | test_mame_drivers.sh [MUST-FIRE x4]: the sh half of the contract for drivers/mame.sh, | selftest/test_mame_drivers.sh:2 | gen:G2 |
| B-T19 | T | test_masked_compare.sh [MUST-FIRE x1]: ground truth for lib/sh/masked_compare.sh, the ONE | selftest/test_masked_compare.sh:2 | gen:G2 |
| B-T20 | T | test_profiles.sh [MUST-FIRE x3]: the machine profiles: every shipped profile declares | selftest/test_profiles.sh:2 | gen:G2 |
| B-T21 | T | test_prologue.sh [NO must-fire marker]: ground truth for lib/sh/prologue.sh, the gate-author | selftest/test_prologue.sh:2 | gen:G2 |
| B-T22 | T | test_provenance.sh [MUST-FIRE x1]: ground truth for lib/py/bbh/provenance.py: the | selftest/test_provenance.sh:2 | gen:G2 |
| B-T23 | T | test_ref_rot.sh [MUST-FIRE x3]: ground truth for lib/py/bbh/ref_rot.py: a hard-coded | selftest/test_ref_rot.sh:2 | gen:G2 |
| B-T24 | T | test_rpl.sh [NO must-fire marker]: ground truth for lib/py/bbh/rpl.py, the .rpl grammar: every | selftest/test_rpl.sh:2 | gen:G2 |
| B-T25 | T | test_rpl_lua.sh [NO must-fire marker]: THE GRAMMAR EQUALITY CHECK: lua/mame/rpl_parse.lua and | selftest/test_rpl_lua.sh:2 | gen:G2 |
| B-T26 | T | test_run_static.sh [NO must-fire marker]: ground truth for bin/bbh-run-static, run against a | selftest/test_run_static.sh:2 | gen:G2 |
| B-T27 | T | test_run_sweep.sh [MUST-FIRE x2]: ground truth for bin/bbh-run-sweep: a synthetic repo of | selftest/test_run_sweep.sh:2 | gen:G2 |
| B-T28 | T | test_shadow_tools.sh [MUST-FIRE x1]: ground truth for lib/sh/shadow_tools.sh: a | selftest/test_shadow_tools.sh:2 | gen:G2 |
| B-T29 | T | test_skills.sh [MUST-FIRE x2]: ground truth for the skills lock (bbh check-skills) and the | selftest/test_skills.sh:2 | gen:G2 |
| B-T30 | T | test_suite_dispatch.sh [MUST-FIRE x3]: ground truth for bin/bbh-run-suite over the fake | selftest/test_suite_dispatch.sh:2 | gen:G2 |
| B-T31 | T | test_thresholds.sh [MUST-FIRE x1]: the comparison thresholds are declared ONCE and every | selftest/test_thresholds.sh:2 | gen:G2 |
| B-T32 | T | test_tier.sh [MUST-FIRE x1]: ground truth for lib/py/bbh/tier.py, the transitive | selftest/test_tier.sh:2 | gen:G2 |
| B-D1 | D | `[project]` — 9 documented keys / 9 code defaults; origin: config 9 | docs/config.md:23 | gen:G3 |
| B-D2 | D | `[registries]` — 4 documented keys / 4 code defaults; origin: config 4 | docs/config.md:37 | gen:G3 |
| B-D3 | D | `[tier]` — 3 documented keys / 3 code defaults; origin: code 1, config 2 | docs/config.md:46 | gen:G3 |
| B-D4 | D | `[classify]` — 4 documented keys / 4 code defaults; origin: code 3, config 1 | docs/config.md:54 | gen:G3 |
| B-D5 | D | `[thresholds]` — 3 documented keys / 3 code defaults; origin: config (policy) 3 | docs/config.md:63 | gen:G3 |
| B-D6 | D | `[suite]` — 12 documented keys / 12 code defaults; origin: code 2, code (policy) 1, config 9 | docs/config.md:76 | gen:G3 |
| B-D7 | D | `[fingerprint]` — 7 documented keys / 8 code defaults; origin: config 7 | docs/config.md:98 | gen:G3 |
| B-D8 | D | `[sweep]` — 22 documented keys / 22 code defaults; origin: code 1, config 21 | docs/config.md:112 | gen:G3 |
| B-D9 | D | `[gate_header]` — 10 documented keys / 10 code defaults; origin: code 2, config 8 | docs/config.md:143 | gen:G3 |
| B-D10 | D | `[header_defaults]` — 4 documented keys / 4 code defaults; origin: code 2, config 2 | docs/config.md:168 | gen:G3 |
| B-D11 | D | `[ref_rot]` — 10 documented keys / 10 code defaults; origin: config 10 | docs/config.md:181 | gen:G3 |
| B-D12 | D | `[provenance]` — 5 documented keys / 5 code defaults; origin: config 4, config (policy) 1 | docs/config.md:199 | gen:G3 |
| B-D13 | D | `[fields]` — 8 documented keys / 8 code defaults; origin: code 1, config 4, config (a game fact) 1, config (policy) 2 | docs/config.md:216 | gen:G3 |
| B-D14 | D | `[skills]` — 11 documented keys / 6 code defaults; origin: code 1, config 5, no-origin 5 | docs/config.md:235 | gen:G3 |
| B-D15 | D | `[machine]` — 1 documented keys / 0 code defaults; origin: config 1 | docs/config.md:269 | gen:G3 |
| B-D16 | D | `[inp]` — 8 documented keys / 8 code defaults; origin: config 6, config (policy) 2 | docs/config.md:275 | gen:G3 |
| B-D17 | D | lua literal — the code window (`0x400000` / `0x600000`) → bin **board** | docs/lua.md:106 | gen:G4 |
| B-D18 | D | lua literal — the exception store's width (the guard read `data & 0xFFFF`) → bin **board** | docs/lua.md:107 | gen:G4 |
| B-D19 | D | lua literal — the COLLECT record layout (stride 8, tile code 2 bytes at offset 4 — the CPS-2 spri… → bin **board** | docs/lua.md:108 | gen:G4 |
| B-D20 | D | lua literal — printed widths (`%04x` ports, `%06x` PCs and offsets) → bin **board** | docs/lua.md:109 | gen:G4 |
| B-D21 | D | lua literal — the STACK sketch: 64 longs walked, 16 listed → bin **policy** | docs/lua.md:110 | gen:G4 |
| B-D22 | D | lua literal — PCWEEDS suppressed after 10 lines → bin **policy** | docs/lua.md:111 | gen:G4 |
| B-D23 | D | lua literal — GUARD_BREAK stops before frame 100 are "the boot pass" → bin **policy** | docs/lua.md:112 | gen:G4 |
| B-D24 | D | lua literal — the ALIVE heartbeat every 600 frames → bin **policy** | docs/lua.md:113 | gen:G4 |
| B-D25 | D | lua literal — `TAIL_FRAMES` 120, `GUARD_PROBE_MAX` 400, `MAX_FRAMES` 200000, `STOP_AFTER` 600, `W… → bin **policy (the lineage's values, stated in each header)** | docs/lua.md:114 | gen:G4 |
| B-D26 | D | lua literal — `[machine].profile` → bin **config, NO default** | docs/lua.md:115 | gen:G4 |
| B-D27 | D | lua literal — `[inp].*` (`vsavjw`, a build dir, the pinned MAME) → bin **config, the lineage's literals** | docs/lua.md:116 | gen:G4 |
| B-D28 | D | lua literal — a maximum replay length → bin **none on the MAME side** | docs/lua.md:117 | gen:G4 |
| B-D29 | D | threshold `flicker_max` / FLICKER_MAX = 2 — a divergent run this short or shorter is a FLICKER frame. | lib/py/bbh/thresholds.py:28 | read |
| B-D30 | D | threshold `reconverge` / RECONVERGE = 60 — identical frames required after the last divergence (the non-propagation proof, intra-mechanism). | lib/py/bbh/thresholds.py:28 | read |
| B-D31 | D | threshold `flicker_max_total` / MAX_TOTAL = 8 — the cap on a flicker INVENTORY, never on a window run. | lib/py/bbh/thresholds.py:28 | read |
| B-G1 | G | `ci_portable.txt` — 6 gates a CLEAN CHECKOUT can run; "THE JOB MUST FAIL ON SKIP under --strict". | example/tests/ci_portable.txt:1 | read |
| B-G2 | G | `ci_static.txt` — 1 gate needing the reference input (FAKE_ROOT) but no driver. | example/tests/ci_static.txt:1 | read |
| B-G3 | G | `ci_sweep.tsv` — the instrument-tier registry, 5 rows: gate/lane/scope/cadence/args/note[/timeout]. | example/tests/ci_sweep.tsv:1 | read |
| B-G4 | G | `gate_index.tsv` — 12 rows, the ONE hand-maintained input of `bbh gate-index`; completeness enforced both ways. | example/tests/gate_index.tsv:1 | read |
| B-G5 | G | `registry.tsv` — 4 rows, build fingerprint → expectation set; 2 by PROGRAM key, 2 by WHOLE-SET key; `roms/hook` has none on purpose. | example/expected/registry.tsv:1 | read |
| B-G6 | G | `fields.tsv` — 7 mapped fields with base/addr/width/phase for the dual-implementation protocol. | example/tests/fields.tsv:1 | read |
| B-G7 | G | `docs/gate_index.md` — GENERATED from every gate header + the family TSV; `--check` in a portable gate. | example/docs/gate_index.md:1 | read |
| B-G8 | G | `skill/skills.toml` — the harness's own skills lock config: 1 prefix (BBH), 9 anchor docs, 12 log files, 33 forbidden tokens. | skill/skills.toml:1 | read |
| B-G9 | G | `bbh.toml.example` — the 15-section config template a consumer copies. | bbh.toml.example:1 | read |
| B-G10 | G | `example/consumers/bbh.vampire.toml` — the config of the LINEAGE, kept here because that consumer never consumes the harness. | example/consumers/bbh.vampire.toml:1 | read |
| B-F1 | F | F1: both static runners over one synthetic fake repo of stub gates: output identical (durations normalised); with a gate that exits 0 a… | selftest/test_fidelity_vampire.sh:8 | gen:G6 |
| B-F2 | F | F3: the tier classifier over the lineage's 304 gates: the INSTRUMENT set minus the plain registries minus `run_` names == its sweep reg… | selftest/test_fidelity_vampire.sh:14 | gen:G6 |
| B-F3 | F | F5: every .masked spec of the lineage through both masked_compare implementations, verdict text to the character (1,891/1,891 at H2). | selftest/test_fidelity_vampire.sh:17 | gen:G6 |
| B-F4 | F | F6: the fingerprint: both tools over the same images with every flag — a synthetic dual-key twin always, the real reference set and a s… | selftest/test_fidelity_vampire.sh:19 | gen:G6 |
| B-F5 | F | F7: the suite's dispatch: both suite runners over the lineage's real expectation trees in a shadow root with a STUB driver (no MAME), e… | selftest/test_fidelity_vampire.sh:23 | gen:G6 |
| B-F6 | F | F4: the sweep runner: --list (always) and --dry-run (with ROMDIR) over the lineage's whole registry through both runners, diffed. | selftest/test_fidelity_vampire.sh:26 | gen:G6 |
| B-F7 | F | F9: the hygiene tools: header-defaults, gate-index (--check, and the rendered index against the committed file), provenance (the lineag… | selftest/test_fidelity_vampire.sh:28 | gen:G6 |
| B-F8 | F | F10: the field comparator and the dump checker over SYNTHETIC dump directories shaped like the lineage's (its addresses, its fields tabl… | selftest/test_fidelity_vampire.sh:33 | gen:G6 |
| B-F9 | F | F8: lives in selftest/test_fidelity_mame.sh (opt-in, BBH_MAME_FIDELITY=1: the Lua layer, the drivers and the recording tools on the rea… | selftest/test_fidelity_vampire.sh:37 | gen:G6 |
| B-F10 | F | F11: the skills lock and the guide generator (H10): bbh check-skills -v with the lineage's GENERATED [skills] section == tools/checkskil… | selftest/test_fidelity_vampire.sh:39 | gen:G6 |
| B-F11 | F | F2: (BBH_FIDELITY_F2=1) the lineage's whole portable tier through both runners, verdict columns diffed — never alongside another gate r… | selftest/test_fidelity_vampire.sh:42 | gen:G6 |
| B-F12 | F | F8a: one short replay through tools/run_replay_mame.sh and | selftest/test_fidelity_mame.sh:9 | gen:G6 |
| B-F13 | F | F8b: VIDEO_OUT / INPUT_OUT / DUMPS / POKES / SNAP_FRAMES parity: every | selftest/test_fidelity_mame.sh:12 | gen:G6 |
| B-F14 | F | F8c: INPUT_INJECT_TEST: both drivers exit 1 with the same | selftest/test_fidelity_mame.sh:14 | gen:G6 |
| B-F15 | F | F8d: the guard, cheap mode, on the lineage's crash-guard negative control | selftest/test_fidelity_mame.sh:16 | gen:G6 |
| B-F16 | F | F8e: the guard, authoritative mode, on test_crash_guard's POSITIVE | selftest/test_fidelity_mame.sh:20 | gen:G6 |
| B-F17 | F | F8f: the .rpl grammar under MAME's own interpreter: rpl_dump.lua over | selftest/test_fidelity_mame.sh:24 | gen:G6 |
| B-F18 | F | F8g: a recording: tools/run_inp_guarded.sh vs bbh inp-play on the | selftest/test_fidelity_mame.sh:27 | gen:G6 |
| B-F19 | F | F8h: FBNeo: tools/run_replay_fbneo.sh vs drivers/fbneo.sh on the same | selftest/test_fidelity_mame.sh:31 | gen:G6 |
| B-P1 | P | THE FOUR BINS (prose, unnumbered): code / config / machine profile / stays with the consumer — "the config schema follows them". | README.md:60 | read |
| B-P2 | P | THE DOCTRINE, SHORT FORM (prose): seven sentences, from "No untested change survives" to "When a claim changes, grep for the claim." | README.md:72 | read |
| B-P3 | P | Ruled default 1 (unnumbered): a separate repository, this one; the CLI prefix is `bbh`; nothing depends on any consumer's tree. | docs/conventions.md:11 | read |
| B-P4 | P | Ruled default 5 (unnumbered): "Documentation tools are OUT" — their subject is a documentation discipline, not a test harness. | docs/conventions.md:40 | read |
| B-P5 | P | Ruled default 9 (unnumbered here): docs stay LEAN and anchored; the complete LOG lives in `<name>_history.md` twins. | docs/conventions.md:74 | read |
| B-P6 | P | "Each is a MEASURED MECHANISM with a FROZEN expectation; none is a tolerance." — the sentence that bars a class from being a knob. | docs/method/oracle_classes.md:7 | read |
| B-P7 | P | The one verdict row with no rule ID: "exits 0 otherwise → PASS". | docs/gate_contract.md:16 | read |
| B-P8 | P | "Directories are out of scope by design … two checks on one claim is one too many." — the provenance scope boundary. | docs/hygiene.md:44 | read |
| B-P9 | P | "The tier labels are derived, not configured" — from the registry file stems and `[project].instrument_word`. | docs/config.md:163 | read |
| B-P10 | P | header-defaults exemptions are CODE, not config: backticked tokens and a token followed by `<` (a template). | docs/config.md:177 | read |
| B-P11 | P | "A red gate is a question, and its first question is which side rests on a measurement." — the register's own headline. | example/expected/PROVENANCE.md:9 | read |
| B-P12 | P | `roms/hook` has NO registry row on purpose: the unregistered build the suite must refuse loudly (exit 2 / exit 1). | example/expected/README.md:21 | read |
| B-P13 | P | Every contract paragraph names its GROUND TRUTH selftest — the §5 closing paragraph of the driver contract is the pattern. | drivers/README.md:95 | read |
| B-P14 | P | "GREEN — the harness's own gates pass." / "NOT GREEN — see above." — the harness eats its own verdicts. | selftest/run.sh:34 | read |
| B-P15 | P | "License: GPL-3.0 (the lineage's)" — declared load-bearing on legal and use scope, and deliberately NOT a conventions row. | README.md:101 | read |
| B-P16 | P | "Break a control, watch it fire" — the example ships the perturbations that turn each check red, as commands. | example/README.md:35 | read |
| B-P17 | P | "What stayed with the lineage" — the explicit NOT-EXTRACTED list (Verilator driver, game-address gates, the lineage's own Lua). | docs/lua.md:125 | read |
| B-X1 | X | example gate `g_driver_ok.sh`: the INSTRUMENT check: drivers/fake.sh runs one replay to a | example/tests/g_driver_ok.sh:2 | gen:G7 |
| B-X2 | X | example gate `g_fields.sh`: the DUAL-IMPLEMENTATION protocol on the fake machine: the | example/tests/g_fields.sh:2 | gen:G7 |
| B-X3 | X | example gate `g_hygiene.sh`: the four hygiene checks are GREEN on this consumer: every | example/tests/g_hygiene.sh:2 | gen:G7 |
| B-X4 | X | example gate `g_needs_fake.sh`: reaches the driver ONLY through a sourced lib, so the | example/tests/g_needs_fake.sh:2 | gen:G7 |
| B-X5 | X | example gate `g_pass.sh`: the plainest gate: one assertion, one verdict line, exit 0. | example/tests/g_pass.sh:2 | gen:G7 |
| B-X6 | X | example gate `g_prose.sh`: the word SKIP in PROSE is not a marker: this gate PASSES. | example/tests/g_prose.sh:2 | gen:G7 |
| B-X7 | X | example gate `g_segv_prose.sh`: the BENIGN look-alike of a shell error: a driver | example/tests/g_segv_prose.sh:2 | gen:G7 |
| B-X8 | X | example gate `g_skip.sh`: the SKIP contract: a missing prerequisite prints `SKIP: reason` | example/tests/g_skip.sh:2 | gen:G7 |
| B-X9 | X | example gate `g_skip_indent.sh`: an indented SKIP marker is still a marker (`^ *SKIP`). | example/tests/g_skip_indent.sh:2 | gen:G7 |
| B-X10 | X | example gate `g_static_pass.sh`: a STATIC-tier gate: it needs the reference input named | example/tests/g_static_pass.sh:2 | gen:G7 |
| B-X11 | X | example gate `g_suite.sh`: the replay suite is GREEN on a registered build. The build dir | example/tests/g_suite.sh:2 | gen:G7 |
| B-X12 | X | example gate `g_suite_refuses.sh`: the suite REFUSES an unregistered image loudly: the | example/tests/g_suite_refuses.sh:2 | gen:G7 |
| B-X13 | X | fake machine feature `(none)` → the base machine → class exact / `.sha1`. | example/README.md:87 | read |
| B-X14 | X | fake machine feature `hook` → one byte written a frame LATE per player-button press + cycle-cost noise in $FF80-$FFFF → class flicker. | example/README.md:88 | read |
| B-X15 | X | fake machine feature `select` → after 1P start one byte held for frames +60..+159, then restored → class window. | example/README.md:89 | read |
| B-X16 | X | fake machine feature `attract` → the attract demo (frame 900 on, no coin) diverges permanently → class diverge. | example/README.md:90 | read |
| B-X17 | X | fake machine feature `hook,select` (`both`) → class composite. | example/README.md:91 | read |
| B-X18 | X | fake machine knob `FAKE_NONDET=1` → the clock mixed in → the NONDETERMINISTIC path. | example/README.md:92 | read |
| B-X19 | X | fake machine knob `FAKE_CRASH_AT=n` → CRASH/REGS/STACK, END-CRASH, exit 2 → the guarded grammar. | example/README.md:93 | read |
| B-X20 | X | `fakesys.py` — 64 KiB RAM (whole window), 3 ports with the lineage's token vocabulary, 16-hex-char blake2b-64 per-frame hash, 64x64 screen. | example/fakesys/fakesys.py:1 | read |
| B-X21 | X | `make_roms.py` — generates the 5 fake images byte-reproducibly; `--check` is the example's `[sweep].precondition`. | example/fakesys/make_roms.py:1 | read |
| B-X22 | X | `make_expected.sh` — regenerates the whole expectation tree in a documented 6-step order, so every frozen file has a producer. | example/make_expected.sh:1 | read |
| B-X23 | X | skills-lock assertion 1: ID-LOCK both ways — every rule definition has exactly ONE anchor, every anchor a definition. | lib/py/bbh/checkskills.py:11 | read |
| B-X24 | X | skills-lock assertion 2: LIFTABILITY — a fixed forbid list, grepped case-insensitively over the skill body. | lib/py/bbh/checkskills.py:15 | read |
| B-X25 | X | skills-lock assertion 3: NUMBERS CITE THE LOG — every numeric literal must appear verbatim in a log file, never only in a synthesis. | lib/py/bbh/checkskills.py:19 | read |
| B-X26 | X | skills-lock assertion 4: CROSS-REFERENCES RESOLVE — a plain `[PFX-N]` of a configured prefix must name a rule that skill defines. | lib/py/bbh/checkskills.py:24 | read |
| B-X27 | X | the forbid list: 33 tokens — 14 game/character names, 3 build-dir tokens, 6 board/romset/instrument, 1 session tag, 9 foreign ID prefixes. | skill/skills.toml:31 | read |
| B-X28 | X | `bin/bbh` — the one entry point, 26 dispatched subcommands; the MAME drivers and Lua are run by the suite, not dispatched. | bin/bbh:1 | read |
| B-X29 | X | driver `fake.sh` — the fake machine; honours the whole replay family, refuses the guard family; FAKE_BUILD/FAKE_NONDET/FAKE_CRASH_AT. | drivers/fake.sh:1 | read |
| B-X30 | X | driver `mame.sh` — MAME + replay.lua under a MACHINE PROFILE (BBH_PROFILE required); headless and sandboxed. | drivers/mame.sh:1 | read |
| B-X31 | X | driver `mame_guarded.sh` — crash detection via -debug vector breakpoints or cheap-mode PC classification; refuses MASK_RANGES; exit 2. | drivers/mame_guarded.sh:1 | read |
| B-X32 | X | driver `fbneo.sh` — a patched FBNeo frontend: a SECOND implementation of the same machine; symlink-overlay rompath. | drivers/fbneo.sh:1 | read |
| B-X33 | X | machine profile `cps2.lua` — the 4 MB code window board. | lua/mame/profiles/cps2.lua:1 | read |
| B-X34 | X | machine profile `cps2w.lua` — differs from cps2 ONLY in `crash.code` (6 MB). | lua/mame/profiles/cps2w.lua:1 | read |
| B-X35 | X | machine profile `TEMPLATE.lua` — every key with a comment; `test_profiles.sh` keeps it complete against what the scripts read. | lua/mame/profiles/TEMPLATE.lua:1 | read |
| B-X36 | X | `bbh-doctor` — host capability report: python3>=3.8, tomllib, timeout/gtimeout, git, standalone lua, MAME_BIN, FBNEO_BIN, sh `${VAR:?}`. | bin/bbh-doctor:1 | read |
| B-X37 | X | `selftest/run.sh` — the harness's own gate chain, classified by the same classify.sh, PASS/SKIP/FAIL tallied separately, `--strict`. | selftest/run.sh:1 | read |
| B-X38 | X | `lib/sh/shadow_tools.sh` — a perturbation control edits a COPY under a shadow root whose siblings are symlinks. | lib/sh/shadow_tools.sh:1 | read |
| B-X39 | X | `lib/sh/prologue.sh` — bbh_work / bbh_demand / bbh_skip / bbh_fail / bbh_absolutise; offered, never required. | lib/sh/prologue.sh:1 | read |
| B-X40 | X | `lib/sh/mame_sandbox.sh` — every host input provider off, SDL_VIDEODRIVER=dummy, a fresh cfg/nvram/diff/snap/sta/home per run. | lib/sh/mame_sandbox.sh:1 | read |
| B-X41 | X | `lib/sh/registry.sh` + `config.sh` — registry line reading and the sh-side config resolver that exports BBH_CONFIG/BBH_ROOT. | lib/sh/registry.sh:1 | read |
| B-X42 | X | `fingerprint.py` — PROGRAM key (ordered program members of the first image on the search path) and WHOLE-SET key; 3 kinds. | lib/py/bbh/fingerprint.py:1 | read |
| B-X43 | X | `tier.py` — the transitive "needs an instrument" classifier, following sourced libs to `[tier].source_depth`. | lib/py/bbh/tier.py:1 | read |
| B-X44 | X | `demand_after_trap.py` — lints the `${VAR:?}`-after-`trap … EXIT` shape that exits 0 on macOS bash 3.2. | lib/py/bbh/demand_after_trap.py:1 | read |
| B-X45 | X | `gate_header.py` — THE one header parser under gate-index, header-defaults and ref-rot. | lib/py/bbh/gate_header.py:1 | read |
| B-X46 | X | `gen_gate_index.py` / `header_defaults.py` / `ref_rot.py` / `provenance.py` — the four hygiene tools (F9 diffs all of them). | lib/py/bbh/gen_gate_index.py:1 | read |
| B-X47 | X | `checkskills.py` / `gen_skill_guide.py` — the skills lock and the GUIDE generator (F11). | lib/py/bbh/gen_skill_guide.py:1 | read |
| B-X48 | X | `bin/bbh-run-static` — two tiers tallied separately, `--strict`, anti-orphan report, working-tree snapshot. | bin/bbh-run-static:1 | read |
| B-X49 | X | `bin/bbh-run-suite` — fingerprint → set, each replay twice, dispatch skip→pending→masked→diverge→sha1→NO-EXPECTATION, `--freeze`, hermetic env. | bin/bbh-run-suite:1 | read |
| B-X50 | X | `bin/bbh-run-sweep` — lanes, prereq first and serial, scope/cadence, %PLACEHOLDER% args, per-row timeouts, --jobs/--resume, the banner. | bin/bbh-run-sweep:1 | read |
| B-X51 | X | `bin/bbh-inp-play` / `bbh-inp-corpus` — the recording corpus: `<name>.inp` + nvram + NOTE[+DEFECT], replayed under the guard at every freeze. | bin/bbh-inp-play:1 | read |
| B-X52 | X | THE BYTE-FOR-BYTE TARGET: the example's suite output block — `build fingerprint -> …`, `per-set mask: …`, `%-24s` name + class verdict, `SUITE GREEN`. | example/README.md:23 | read |
| B-X53 | X | the 6 example replays 01_idle 02_coin_start 03_press 04_both 05_attract 06_other_set — one per expectation class. | example/replays/03_press.rpl:1 | read |
| B-X54 | X | the 5 fake image dirs base / attract / build-a / build-b / hook; build-a and build-b share every program member (the DUAL-KEY case). | example/roms/base/fake.zip:1 | read |


## C. Generators

All generators run **from the bbh repo root** (`cd /Users/koneko/Developer/blackbox-harness`) and are
read-only. They were run once, at `f675710`, as a single python3 heredoc; the blocks below are that
script verbatim, split by the `gen:` tag each block emits.

**G1 — the 87 rule rows (`B-R*`).** For every `- [BBH-N] **…**` bullet in `SKILL.md`, take the bold
first sentence and resolve the anchor with `git grep -nE '\*\*\[BBH-N\]\*\*'`, excluding `GUIDE.md`
(which is generated and re-anchors all 87).

```python
g1=[]
for line in open("skill/blackbox-harness/SKILL.md"):
    m=re.match(r"^- \[(BBH-(\d+))\] (.*)$",line.rstrip("\n"))
    if not m: continue
    rid,num,rest=m.group(1),int(m.group(2)),m.group(3)
    b=re.match(r"^\*\*(.+?)\*\*",rest)
    sent=b.group(1) if b else rest.split(".")[0]
    anc=[l.split(":")[0]+":"+l.split(":")[1]
         for l in sh("git grep -nE '\\*\\*\\[%s\\]\\*\\*'"%rid).splitlines()
         if not l.startswith("skill/blackbox-harness/GUIDE.md")]
    g1.append((num,rid,sent,";".join(anc)))
g1.sort()
for i,(num,rid,sent,anc) in enumerate(g1,1):
    out.append(f"| B-R{i} | R | **[{rid}]** {clip(sent,120)} | {anc} | gen:G1 |")
```

**G2 — the 32 selftest rows (`B-T*`).** One row per `selftest/test_*.sh`; the must-fire flag is the
case-insensitive occurrence count of the marker string `must-fire`; the item is the gate's own line-2
claim after the em dash.

```python
g2=0
for t in sorted(sh("ls -1 selftest/test_*.sh").split()):
    g2+=1
    c=int((sh("grep -ci 'must-fire' %s || true"%t).strip() or "0"))
    claim=sh("sed -n '2p' %s"%t).strip().lstrip("# ")
    claim=claim.split("—",1)[1].strip() if "—" in claim else claim
    flag="MUST-FIRE x%d"%c if c else "NO must-fire marker"
    out.append(f"| B-T{g2} | T | {os.path.basename(t)} [{flag}]: {clip(claim,86)} | {t}:2 | gen:G2 |")
```

**G3 — the 16 config-section rows (`B-D1`..`B-D16`).** Documented key count and origin mix from
`docs/config.md` (first `## [section]` heading wins — `[project]` appears twice); code default count
from `lib/py/bbh/config.py` `DEFAULTS`.

```python
TAGS=re.compile(r"\| (config \(a game fact\)|config \(policy\)|code \(policy\)|config|code) \|")
sec=None; rows=OrderedDict(); secline={}
for i,line in enumerate(open("docs/config.md"),1):
    m=re.match(r"^## `?(\[[a-z_]+\])",line)
    if m:
        sec=m.group(1)
        if sec not in rows: rows[sec]=[]; secline[sec]=i
    if line.startswith("| `") and sec:
        mm=TAGS.search(line); rows[sec].append(mm.group(1) if mm else "no-origin")
code=json.loads(sh("PYTHONPATH=lib/py python3 -c 'import json;from bbh import config as C;"
                   "print(json.dumps({k:len(v) for k,v in C.DEFAULTS.items()}))'"))
gd=0
for s,v in rows.items():
    gd+=1
    mix=", ".join(f"{k} {n}" for k,n in sorted(Counter(v).items()))
    out.append(f"| B-D{gd} | D | `{s}` — {len(v)} documented keys / {code.get(s.strip('[]'),0)} "
               f"code defaults; origin: {mix} | docs/config.md:{secline[s]} | gen:G3 |")
```

**G4 — the 12 lua-literal rows (`B-D17`..`B-D28`).** The `docs/lua.md` §5 defaults-census table,
header row dropped.

```python
start=int(sh("grep -n '^## 5. The defaults census' docs/lua.md").split(":")[0])
blk=sh("sed -n '/^## 5. The defaults census/,/^## 6/p' docs/lua.md").splitlines()
for j,l in enumerate(blk):
    if l.startswith("| ") and not l.startswith("| literal"):
        gd+=1
        cells=[c.strip() for c in l.strip().strip("|").split("|")]
        lit=re.sub(r"\*\*","",cells[0]); binn=re.sub(r"\*\*","",cells[1])
        out.append(f"| B-D{gd} | D | lua literal — {clip(lit,84)} → bin **{binn}** "
                   f"| docs/lua.md:{start+j} | gen:G4 |")
```

**G5 — the 8 comparator rows (`B-K*`).** First docstring paragraph of each comparator plus the one
log-grammar reader.

```python
g5=0
for f in ["lib/py/bbh/compare_flicker.py","lib/py/bbh/compare_window.py","lib/py/bbh/compare_composite.py",
          "lib/py/bbh/check_diverge.py","lib/py/bbh/describe_masked_shape.py","lib/py/bbh/compare_fields.py",
          "lib/py/bbh/check_dumps.py","lib/py/bbh/logfmt.py"]:
    g5+=1
    m=re.search(r'"""(.*?)\n\n',open(f).read(),re.S)
    first=" ".join(m.group(1).split()) if m else ""
    ln=sh("grep -n '\"\"\"' %s | head -1"%f).split(":")[0]
    out.append(f"| B-K{g5} | K | {clip(first,134)} | {f}:{ln} | gen:G5 |")
```

**G6 — the 19 fidelity rows (`B-F*`).** F1–F11 from the vampire test's header block, F8a–F8h from the
MAME test's; continuation lines (`#       …`) are joined. The `\s+` (not two literal spaces) matters:
`F10` and `F11` are one character wider and carry a single space.

```python
g6=0
for src in ["selftest/test_fidelity_vampire.sh","selftest/test_fidelity_mame.sh"]:
    lines=open(src).read().splitlines()
    for i,line in enumerate(lines):
        m=re.match(r"^#   (F\d+[a-h]?)\s+(.*)$",line)
        if not m: continue
        g6+=1
        body=[m.group(2)]
        for k in range(i+1,len(lines)):
            c=re.match(r"^#       (\S.*)$",lines[k])
            if not c: break
            body.append(c.group(1))
        out.append(f"| B-F{g6} | F | {m.group(1)}: {clip(' '.join(body),132)} | {src}:{i+1} | gen:G6 |")
```

**G7 — the 12 example-gate rows (`B-X1`..`B-X12`).**

```python
g7=0
for t in sorted(sh("ls -1 example/tests/g_*.sh").split()):
    g7+=1
    claim=sh("sed -n '2p' %s"%t).strip().lstrip("# ")
    claim=claim.split("—",1)[1].strip() if "—" in claim else claim
    out.append(f"| B-X{g7} | X | example gate `{os.path.basename(t)}`: {clip(claim,94)} | {t}:2 | gen:G7 |")
```

Shared helpers used by all seven:

```python
def sh(c): return subprocess.run(["sh","-c",c],capture_output=True,text=True).stdout
def esc(s): return s.replace("|","\\|").strip()
def clip(s,k=140):
    s=esc(s); return s if len(s)<=k else s[:k-1]+"…"
```

Every §A row was produced by a separate `subprocess` call of the command printed in its own row, with
an assertion against the expected value; the build aborted loudly on any mismatch and reported none.

Rows marked `read` in §B were hand-read from the file at the cited line and are not machine-derived.

## D. Not looked at

Measured nothing about, and therefore claim nothing about:

- **Nothing was executed.** `bbh selftest`, `bbh run-static`, `bbh run-suite`, `bbh run-sweep`,
  `bbh doctor` and `example/make_expected.sh` were **not run**. The suite-output block quoted at
  `B-X52` is the one committed in `example/README.md:23-33`, not an observed run.
- **F8 not run** — no MAME, no FBNeo, no `ROMDIR`, no pinned emulator binary on this host. F8a–F8h
  rows are their header text only.
- **F1–F7, F9–F11 not run** — the VampireSaved lineage tree was not located or opened. Every figure
  the fidelity headers quote (304 gates, 1,891 `.masked` specs, 65 PASS rows, "eight skills",
  "two guides") is **quoted from bbh's own text**, not re-measured.
- **`skill/blackbox-harness/GUIDE.md` content not read** (871 lines). Only its anchor count (87) and
  its first 25 lines were examined; the 87 quoted incident blocks were not.
- **`example/consumers/bbh.vampire.toml` not opened** beyond its role and its dirty status.
- **Lua sources not read** except `profiles/TEMPLATE.lua` key names and `docs/lua.md`'s tables.
  `replay.lua`, `replay_guard.lua`, `inp_guard.lua`, `tap_writes.lua`, `trace_writes.lua`,
  `read_tap.lua`, `snapshot_frames.lua`, `rpl_parse.lua`, `rpl_dump.lua`, `profile.lua`,
  `cps2.lua`, `cps2w.lua` were listed, never opened.
- **Comparator bodies not read** — only the leading docstrings. The class arithmetic
  (`FAIL-SHORT` vs `FAIL`, the re-convergence tail accounting, the composite conjunction) is
  reported as the docs describe it, not as verified from code.
- **`bin/bbh-run-static` (230), `bin/bbh-run-sweep` (491), `bin/bbh-run-suite` (196) not read in
  full** — only `bbh-run-suite`'s `printf`/`echo` lines, which is where the frozen verdict text lives.
- **Binary artifacts not inspected**: the 5 `example/roms/*/fake.zip`, the 17 frozen `.log` files,
  the `.sha1` digests. Counted, never opened.
- **No cross-check that `docs/config.md`'s 121 documented rows and `config.py`'s 116 code defaults
  name the SAME keys** — only that the counts differ by exactly the 5 origin-less `[skill_<PFX>]`
  rows. A key documented under one name and defaulted under another would not have been caught.
- **`LICENSE` (GPL-3.0) not read.**
- **No timing measured.** The runtimes quoted anywhere above ("350 s", "~6 min", "~8 min") are the
  repo's own recorded figures.
- **The dirty working tree was not diffed line by line** — only `git status --porcelain` and
  `git diff --stat`. What the 6 changed lines say was inferred from the previous commit message.
