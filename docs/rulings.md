# Rulings — the open queue

Shape: queue. The maintainer rules; the contributor recommends. Each entry
carries the recommendation, the alternatives declined, and a slot for the
answer with its date. An answered ruling moves to `DECISIONS.md` (in force)
and its story to `DECISIONS_HISTORY.md`; the entry here keeps the answer line
so the queue is a complete record. **An entry lives under the heading of its
state:** an answered entry is moved under an `## Answered …` heading in the
same edit that answers it, never left under `## Open` with a note (the
maintainer, bbx-2: "typically the kind of dark pattern that leads to silent
issues" — gotcha G14). `gates/rulings_shape.sh` fails on an `Answer` line
that is not `(open)` under an Open heading, on `(open)` under an Answered
heading, and on an answered `R<n>` with no row in `DECISIONS.md`. Nothing below is a tool; no tool is
written until the ruling its slice needs is answered (CLAUDE.md §6, §9).

## Answered

### R6 — Where the BBX repository root is
- **Recommendation:** `git init` in `BBX/`, the directory holding `CLAUDE.md` (matches bbh and VampireSaved).
- **Declined:** the parent `generalized-blackbox-harness/`; no init this session.
- **Context measured:** `git rev-parse --show-toplevel` from BBX resolved to `/Users/koneko` — the HOME directory is an accidental repository (3 commits of unrelated design documents). Left alone; see `docs/gotchas.md` G1.
- **Answer:** BBX directory. — maintainer, 2026-09-09.

### R7 — Whether session 1 ends in a commit
- **Recommendation:** one commit: memory files, census, plan documents, rulings. No remote, no push.
- **Declined:** leave uncommitted for review first.
- **Answer:** commit at session end. — maintainer, 2026-09-09.

### R8 — Which bbh state is the fidelity baseline
- **Recommendation:** HEAD `f675710`; the 4 uncommitted modifications recorded as a finding, never touched by BBX.
- **Declined:** the working tree as-is (baseline not a commit hash); waiting for the maintainer to commit in bbh first.
- **Answer:** HEAD f675710, dirty files noted. — maintainer, 2026-09-09.

## Answered 2026-09-09 (batch 1–3) — carried from CLAUDE.md §8

### R0 — Name
- **Recommendation:** working name BLACKBOX, rule prefix `BBX`, repository `BBX`.
- **Declined:** keeping it inside bbh as a major version — bbh must stay the frame-driven lineage this project is proved against.
- **Answer:** BBX = **Black Box harness eXpanded**; short name and rule prefix `BBX`; repository directory `BBX`. — maintainer, 2026-09-09.

### R1 — Licence
- **Recommendation:** GPL-3, matching bbh (`~/Developer/blackbox-harness/LICENSE`), so the lineage chain has one licence. No `LICENSE` file is written until ruled; commit one carries none.
- **Declined:** MIT/BSD (a weaker licence downstream of a GPL lineage complicates the fidelity fixtures, which are bbh's files run in place, not copied).
- **Answer:** GPL-3, matching bbh. `LICENSE` added in the next commit. — maintainer, 2026-09-09.

### R2 — The second and third subject kinds
- **Recommendation:** a document set with re-derivable claims (no executable) and a command-line tool with deterministic output (executable, not frame-driven) — `docs/generality.md`.
- **Declined:** an FPGA fit/timing flow (needs a toolchain no fixture can stand in for); a data pipeline (a cli tool over files is its minimal case — add it as a fourth kind if the third proves too close to the second); a model evaluation (non-deterministic by default, would enter under R5 from day one).
- **Answer:** Document set + command-line tool, as recommended, **with two additions ruled as R14 and R15**: (1) the self-validation clause — BBX must be able to validate itself using itself without degrading its rules ("Quis custodiet ipsos custodes": without it, only an external tool could say whether the checker has rotted); (2) BBX is architected so that external testing tools and their frameworks can be interfaced or integrated as drivers — for legacy software, and so that agents working in any codebase can bring their tooling of choice or build ad hoc, with BBX as the guardrail wherever the tests considered are deterministic. — maintainer, 2026-09-09.

### R3 — Language and portability floor
- **Recommendation:** POSIX sh + Python 3, as bbh; macOS bash 3.2 and Linux; every platform guard has a gate on both platforms. The BBX classifier is bbh's `lib/sh/classify.sh` contract, reproduced not imported (fidelity diffs the two).
- **Declined:** Python only (bbh's gate contract is exit-status-first and shell-native; the demand-after-trap incident `[BBH-17]` is a shell fact that must stay testable); a compiled language (no runtime dependency beyond sh + python3 is a lineage ruling, bbh conventions row 1).
- **Answer:** POSIX sh + Python 3 as the floor, and **fully portable, OS-agnostic**: macOS, Linux, and Windows through Ubuntu emulation (WSL) — treated as Linux for agentic development. Variance and fragmentation are held in check by BBX validating BBX (R14) on each platform. — maintainer, 2026-09-09.

### R4 — The relationship to bbh's skill
- **Recommendation:** BBX carries its own skill, generated by the same H10 machinery (`bbh skill-guide` shape), citing `[BBH-N]` rules rather than copying them; `[BBH-` is *not* a forbidden token in BBX's skill, every other lineage prefix is.
- **Declined:** copying the 87 rules under new numbers (two copies drift — the reason VS moved its classes out of CLAUDE.md); extending bbh's skill in place (bbh is not modified).
- **Answer:** Own skill, generated by the H10 machinery, citing `[BBH-N]` by ID. — maintainer, 2026-09-09.

### R5 — What "any project" excludes
- **Recommendation:** nothing by kind; a subject that cannot be driven deterministically is admitted with BBX-14 reported *unmet* in every readout.
- **Declined:** excluding non-deterministic subjects outright (would exclude the model-evaluation kind before it is tried); admitting them silently (a readout that hides an unmet rule is the lie of omission BBX-30 forbids).
- **Answer:** Nothing excluded by kind; a non-deterministic subject is admitted with BBX-14 reported unmet in every readout. — maintainer, 2026-09-09.

## Answered 2026-09-09 (batch 2–3) — raised by session 1

### R9 — The census recount gate
- **Recommendation:** the first gate BBX ever runs (slice S1) is a recount: it re-runs every command in `docs/census/*.md` at the recorded HEADs and fails on any count that moved, and its must-fire is being pointed at a wrong HEAD. Not written this session (no tool before the STOP); the census files carry the commands so the recount is possible by hand today.
- **Declined:** writing the recount script this session (it is a tool); never automating it (the census would rot the way VampireSaved's own three counters did — `docs/census/vampiresaved.md`, the stale-counter rows).
- **Answer:** The recount gate is the first gate of slice S1, and the first instance of BBX validating its own documents (R14). — maintainer, 2026-09-09.

### R10 — Must-fire controls become a machine-readable contract (abstraction G3)
- **Recommendation:** a gate declares its control(s) in one header grammar; a controls registry is complete both ways; a declared control that does not fire refuses the verdict; the readout counts fired / declared.
- **Declined:** keeping the marker as prose (VampireSaved: 74 of 311 gates, 15+ spellings, no reader; the rot taxonomy's only silent class is exactly this); a separate registry file hand-maintained (BBX-9).
- **Cost of being wrong:** every bbh selftest gains a header line; bbh itself is not modified, so bbh's selftests are read under an *absent-declaration is not asserting* rule during fidelity, reported as such.
- **Answer:** Adopt the machine-readable must-fire contract (abstraction G3). — maintainer, 2026-09-09.

### R11 — One closed provenance vocabulary
- **Recommendation:** for expectations, ranked per CLAUDE.md §3.3: `reference` (independent of us: hardware, a specification, an upstream artifact, a reference implementation) > `corroborator` (a lineage-independent second implementation) > `self` (our own build: locks currency, never correctness) > `derived` (computed by a tool from something above; as good as the reader) > `hash-lock` > `registry` (a ledger of decisions) > `fixture` (synthesized by us with known truth; never evidence about a real subject) > `testimony` (a filed count, a witness — never reads green). For defaults: `principled` / `reference-calibrated` / `arbitrary` (BBX-24). Every register row names exactly one class; riders go in a notes column, never in the class.
- **Declined:** keeping bbh's six free-text classes (VampireSaved's register shows 13 distinct strings over 6 base classes — riders became classes); three vocabularies (VS today: expectations, rule-5 values, decisions).
- **Answer:** Adopt the closed vocabulary as stated. — maintainer, 2026-09-09.

### R12 — Corrections to CLAUDE.md, document first (BBX-19)
- **Finding 1:** BBX-5 cites `MFI-52`, which does not exist (MFI is 1..46; `git -C ~/Developer/Vampire_Saved/VampireSaved grep -ohE 'MFI-[0-9]+' | sort -uV`). The paragraph it describes — "separate the AUTHOR from the VERDICT … prove an instrument FIRES on a known positive, FAILS on a known negative, and name its IMPLAUSIBLE value before its first real use" — is **MJC-52**, `.claude/skills/mister-jtframe-core/SKILL.md:85`, anchored at `docs/project/gotchas.md:2913-2922`. A prefix typo.
- **Finding 2 (corrected 2026-09-09 before the edit):** bbh's README line 6 carries "304 gates, 4,000 frozen expectations" (measured today: 311 gates; 4,808 tracked expectation files, 3,814 verdict-bearing). The first draft of this finding said CLAUDE.md repeats them; a grep before editing showed **it does not** (`grep -n '304\|4,000' CLAUDE.md` → nothing). The constitution carries no lineage count; the filed counts stay labelled in `docs/census/`. Gotcha G8.
- **Recommendation:** correct BBX-5's citation to `MJC-52`, one commit, before any check is written against the wording. (The count-labelling half of the recommendation had no target once Finding 2 was corrected.)
- **Declined:** silently editing (BBX-22 requires the sweep and the shown empty result); leaving it (a constitution with a dangling citation teaches every reader that citations are decoration).
- **Answer:** The contributor edits CLAUDE.md once, now: `MFI-52` → `MJC-52` (done, commit "CLAUDE.md: BBX-5 cites MJC-52"); the count half of the edit had no target in CLAUDE.md (Finding 2 corrected). **From now on any edit to CLAUDE.md requires maintainer approval** (ruled as R16). — maintainer, 2026-09-09.

### R13 — SETUP-FAIL as a reported sub-outcome (abstraction G5)
- **Recommendation:** a gate whose fixture failed to stage prints `SETUP-FAIL:` and exits non-zero; the classifier still reads FAIL (byte-for-byte fidelity with bbh is untouched), and the readout reports the sub-outcome separately so a staging failure is never read as a rule failure (SMS `tools/test_clash_air.lua:39-42`, trap 28).
- **Declined:** a fifth verdict word (would change the classifier bbh fidelity diffs); ignoring the distinction (SMS paid for it: "a test that reports 'the rule is broken' when it merely failed to stage is the exact false verdict this project keeps paying for").
- **Answer:** Adopt SETUP-FAIL as a reported sub-outcome of FAIL; the four verdict words stay bbh's. — maintainer, 2026-09-09.

## Answered — created by the maintainer's answers (2026-09-09)

### R14 — The self-validation clause (the maintainer's "Juvenal Escape Clause")
- **Ruling (maintainer, 2026-09-09):** BBX must be able to validate itself using itself without degrading its rules. Without it, only an external tool could say whether the checker has rotted — *quis custodiet ipsos custodes*.
- **How it is met, by construction (contributor's reading, to be proved not asserted):** BBX's own tree is a SUBJECT of its own kinds — its documents through the document-set kind (every count in `docs/census/*.md` and every number in a readout re-derived: the recount gate R9 is the first instance), its gates and runners through the command-line kind, its registries through the registry contract (complete both ways). Self-consistency alone cannot catch a convention error shared with the checker (BBX-15), so the clause is paired with the two custodians BBX already has: the must-fire controls (a checker proven to fail, R10) and the fidelity rows against bbh (a lineage-independent third party, `docs/fidelity.md`). A self-validation gate whose controls are dead or whose fidelity row is red does not count. On every platform of R3.
- **Declined:** none — the maintainer added this to R2.

### R15 — External test frameworks as drivers (the adapter contract)
- **Ruling (maintainer, 2026-09-09):** BBX is architected so that existing testing tools and frameworks can be interfaced or integrated — for legacy software, and so that agents working in any codebase can bring their tooling of choice or build ad hoc, with BBX as the guardrail wherever the tests considered are deterministic.
- **How it is met (contributor's reading):** abstraction D7 — a test framework is a DRIVER under the four-argument contract: an ADAPTER runs the framework's own suite as the scenario, maps its results into the observation grammar (one point per test case, tokens = its verdict and any hashable output), refuses what it cannot honour, and reports non-determinism when the framework's own run differs between two invocations. The framework's verdict is an observation, never a BBX verdict: the comparator and the readout stay BBX's. The command-line kind (R2) is the minimal adapter; a framework adapter is one more driver of that kind, and BBX-25 applies (a generic adapter needs two frameworks).
- **Declined:** none — added by the maintainer to R2.

### R16 — Edits to CLAUDE.md require maintainer approval
- **Ruling (maintainer, 2026-09-09):** the R12 edit is approved once; from now on any edit to `CLAUDE.md` requires maintainer approval before it is made. A contributor who finds a defect in the constitution files it in `docs/rulings.md` with the proposed wording and waits.

### R17 — The session ritual and the session key
- **Ruling (maintainer, 2026-09-09):** the close ritual proposed at the bbx-1 close is adopted as written in `HANDOFF.md` ("The ritual"); sessions are keyed `bbx-N`, one key per sitting, never renamed.
- **Adapted from:** VampireSaved VSP-17 (begin by reading STATE, end by updating it; the rollover rule), VSP-18 (every measurement a rerunnable case before the session ends), VSP-13 (grep for the claim), VSP-162 (the key is a lookup index, never re-based), the CLOSE row that quotes the measured tallies.
- **Declined:** a separate NEXT_SESSION file (HANDOFF carries the orientation; one fewer page to rot); the three-group STATE window (the constitution wants STATE lean, so the history twin holds one paragraph per sitting); the ROM audit and freeze steps (consumer-specific).
- **To become a gate:** steps 8 and 9 (the sweeps, the lineage check) in S1 step 4.

## Answered 2026-09-10 (after the bbx-2 close) — R22, the remote

### R22 — A GitHub remote and pushing (supersedes R7's "no remote, no push")
- **Context:** R7 (session 1) ruled one commit per sitting, no remote, no push. Every commit since has been local; the R21 procedure carried BBX to another host as a bundle for that reason.
- **Answer (maintainer, 2026-09-10):** "You have my blessing to create a BBX repo on my github and push." Applied: `github.com/DefinitelyFrenchName/BBX` created from this tree (private — visibility was not stated, and private is the reversible choice; one command makes it public), `origin` set, `main` pushed after the bbx-2 close. R7's one-commit-per-sitting close stands; "no push" is replaced by: the close commit is pushed, and any post-close correction with it. R21's procedure becomes `git clone` of the remote.
- **Declined:** none asked.

## Answered 2026-09-09 (bbx-2) — R18 raised at the open, R19 by the maintainer, R20 by R18's answer

### R18 — What the census recount measures when a lineage repository moves
- **Context measured (bbx-2 open):** between the bbx-1 close and the bbx-2 open, VampireSaved received two commits (`5df1d8be` → `0cdd9726`: its `STATE.md` +3/−1 at line 42, one re-frozen expectation). `bin/bbx selftest` opened red on `census_recount` (`verdict=HEAD-MOVED rows=127`), so the sitting's first task was the re-measure: one count moved (A77, `wc -l < STATE.md`, 1509 → 1511), thirteen §B citations into `STATE.md` shifted by two (ten hand-read rows re-pointed by hand after diffing old line against new line; three regenerated by G1), three header numbers (commits, untracked). The 563 rule rows, the bins and every other recountable count were unchanged. Gotcha G12.
- **The question:** the census is a document keyed by (repository, HEAD) — BBX-29 — and the lineage repositories are live projects that commit daily. As ruled (R9, R17), a moved HEAD refuses every row and the sitting opens red until the census is re-measured at the tip. That is correct as a rot detector for the census file, but it makes the first task of most sittings clerical, and it conflates two findings: "the census no longer describes any tree" (the file rotted) and "the lineage moved on" (a fact about the lineage, not about BBX).
- **Recommendation:** recount at the recorded HEAD, and report drift at the tip separately. The recount tool obtains the recorded commit read-only — `git clone --shared --no-checkout <lineage> <scratch>` then `git -C <scratch> checkout <recorded HEAD>`, in `TMPDIR`, nothing written under the lineage's `.git` — and runs every §A command there; a mismatch there is the census file rotting and stays FATAL. The same commands are then run at the lineage's tip and the rows that differ are printed as a NOTE-class number (`lineage=vampiresaved recorded=5df1d8be tip=0cdd9726 ahead=2 rows_moved=1 (A77)`) in the selftest's NOTE block, never fatal. A re-measure of the census (moving its recorded HEAD) becomes a deliberate step a slice takes when it needs current lineage facts, recorded as a dated line in the census as done at bbx-2. Hand-read line citations (§B `read` rows) stay a known rot surface and are listed in the NOTE with the files whose line counts moved.
- **Declined:** the status quo (every lineage commit turns BBX's own self-validation red; the readout cannot tell the maintainer whether BBX rotted or VampireSaved worked); dropping the HEAD check (a count at an unknown HEAD is a filed count, CLAUDE.md §1); `git worktree add` inside the lineage repository (it writes under the lineage's `.git`; the lineage is read-only from here); `git archive` of the recorded commit (loses `.git`, and the census grammar's own rule 6 requires `git grep` / `git ls-files`).
- **Cost of being wrong:** a shared clone of VampireSaved (7497 tracked files) is written to `TMPDIR` per run and the VampireSaved rows run twice (recorded HEAD and tip); the gate's runtime, quoted in its header (D2), is re-measured and the header updated. A shared clone borrows the lineage's object store: if the lineage ever prunes objects, the recount says so (exit 2, "could not measure"), never a count.
- **Answer (maintainer, 2026-09-09, bbx-2):** "one thing that census and tests should do is either work on a clone or, if impossible, make very explicit that no change to the tree should be done"; clones also allow multiple instances on clones of the same commit for heavy tasks; and, on a follow-up: "clones are not mandatory but they are safe and we value safe. any similar implementation is fundamentally acceptable". Applied: the recount runs every command on a shared clone of the recorded commit under `TMPDIR` (nothing written under the lineage; the lineage's tip and porcelain are reported; a moved tip is a NOTE-class drift line, never fatal); a census command that names the repository's absolute path is REFUSED (the one way a clone could leak); the fidelity gate, which runs in bbh's tree in place, now declares READ-ONLY in its header and proves it (tracked porcelain before = after, or FAIL). Measured before ruling: a shared clone of VampireSaved takes 1.8 s and 363 MB, and the bbx-1 census recounts on it at `5df1d8be` 100/100 in 19.8 s while the lineage's tip is `0cdd9726` — and during this sitting VampireSaved's porcelain moved 373 → 377 under another session's hands, none of it BBX's. Wider than R18 asked: the maintainer's wording covers the tests too; the two tools that touch a lineage tree are covered (recount: clone; fidelity: declared and proved read-only), and R20 asks whether fidelity should move to a clone as well.

### R19 — Parallel work as a pull queue: N workers over N clones (raised by the maintainer, bbx-2)
- **The maintainer's direction (2026-09-09):** "batching is good, a pull system with a queue and N workers, kanban-style is even better"; clones allow multiple instances of a heavy task on clones of one commit.
- **Measured precedent:** VampireSaved `tests/run_all_emulator.sh` at `0cdd9726` (14z-144, lines 383–420): the barrier (`_running` up to N then `wait` for all) was replaced by a FIFO token semaphore where the token is the slot number; a worker blocks reading a token, runs, writes it back; the slot binds the scratch clone `<base>-slotN`. Measured there on the M17 sweep: barrier 1.65× at `--jobs 4` against a queue's 3.48×; at 8, 2.47× against 6.05×. bbh's `bbh-run-sweep` (and BBX's lift, `bin/bbx-run-sweep:366-368`) still carry the barrier; bash 3.2 has no `wait -n`, which is why.
- **Recommendation:** lift 14z-144's queue into `bin/bbx-run-sweep` as the `--jobs N` mechanism (slot = token = clone), keep the prereq lane serial, keep row order in `results.tsv` non-deterministic and keyed by name; fidelity F14 is unaffected at `--jobs 1` (bbh's default) and a new pair at `--jobs 2` over bbh's example diffs the sorted results, never the order. Generalize the scratch binding from `[sweep].scratch_lanes` to a kind-blind `[sweep].clone_per_slot = true|false` (D-row) whose clone is a shared clone of the consumer's own repository at HEAD, so any kind's heavy gates run N-wide on N pinned trees.
- **Declined:** `xargs -P` / GNU parallel (not in the R3 floor); Python workers (the runner is sh so its verdict contract stays shell-native, R3); a global BBX job server (BBX-25: one consumer).
- **Cost of being wrong:** one FIFO and N clones per run; a gate that is not clone-safe (writes outside its slot) is detected by the tree check, which each clone gets.
- **Answer (maintainer, 2026-09-09):** agreed — as a default implementation and recommendation. The principle must hold (parallel work is pulled from a queue by N workers, each on its own pinned tree); the exact implementation matters little. Applied when lifted: the FIFO token queue is BBX's default `--jobs` mechanism, documented as one implementation of the principle; a consumer or adapter may bring another as long as workers pull and trees are pinned per worker, and the readout says which. **Lifted the same sitting:** `bin/bbx-run-sweep` `--jobs N` is the FIFO token queue (slot = token, the loop in the main shell); `[sweep].clone_per_slot` (D21) gives every slot a plain clone of HEAD; `gates/sweep_runner.sh` sections 15–16 measure both from the gates' own stamps and trees, with `serial-order` and `no-clone-dirties` as the known negatives; F14 against bbh unchanged.

### R20 — Whether the fidelity gate runs on a clone of bbh at f675710 (raised bbx-2)
- **Context:** `gates/fidelity_bbh.sh` runs bbh's own runners and example in bbh's working tree in place; R8 fixed the baseline as the commit `f675710` while the tree carries 4 uncommitted modifications (`docs/config.md`, `example/consumers/bbh.vampire.toml`, `lib/py/bbh/config.py`, `selftest/test_fidelity_vampire.sh`). Every F13–F15 row so far was measured on the dirty tree.
- **Recommendation:** move it to a shared clone at `f675710` (R18's mechanism) and re-measure F13–F15 there; if any row's text differs from the in-place run, the difference is a finding about the 4 files, recorded as a dated line in `docs/rebaselines.md`, and the clone becomes the baseline (it is what R8 says the baseline is). Until ruled, the gate stays in place, declared and proved read-only.
- **Declined:** keeping the dirty tree as the instrument forever (a baseline that is not a commit cannot be re-created on another machine, R3).
- **Cost and risk, measured (bbx-2, 2026-09-09, on the maintainer's question):**

  | | shared clone (`--shared`) | plain local clone (hardlinked objects) | in place (today) |
  |---|---|---|---|
  | clone of bbh at `f675710` | 0.14 s, 1.7 MB | 0.32 s, 2.3 MB | — |
  | clone of VampireSaved (for F20 later) | 1.76 s, 363 MB | 3.40 s, 490 MB as `du` counts it (the 949 MB pack is a hardlink, 2 links: no extra disk) | — |
  | fidelity gate, whole run | 44.4 s (PASS) | not run separately (same tree) | 38.7 s (PASS) |
  | output diff, clone vs in place | empty except `porcelain=4` → `porcelain=0` (two lines) | same | — |
  | what the 4 dirty files change | nothing in F13–F15: they re-point VampireSaved build directories (`m3b_merged25` → `26`, `don_m21` → `22`, `hui55` → `56`, `pyron40` → `41`, `m5_stock16` → `17`), which matter to F20 only | | they are part of the measured input, undeclared |
  | read-only proof | complete: a clone starts with zero untracked AND zero ignored files, so `status --ignored` after the run must be empty — measured empty | same | blind to ignored paths (`example/build/`, `.DS_Store`) by construction; measured not written today, unprovable in general |
  | dependence on bbh's `.git` during the run | an `alternates` file points at bbh's object store: a `git gc --prune` in bbh during the ~45 s window would break the clone loudly (git errors → FAIL), never silently | none: objects are hardlinked at clone time; a repack in bbh leaves the inode | the tree itself; bbh's HEAD moving turns the gate red until re-baselined |
  | when bbh's HEAD moves | the gate keeps measuring `f675710` (the ruled baseline) and reports drift as a NOTE, as the census does | same | red |
  | portability | `git` only (R3 floor); hardlinks need the same filesystem, else git copies (bbh: 2.3 MB, trivial) | same | — |

  Risks that survive either clone: a fixture that depends on an ignored or untracked file in bbh's tree would pass in place and fail on a clone — that is the finding wanted, not a risk to avoid (measured: none today, F13–F15 identical); a consumer config with absolute paths into another lineage (bbh's `bbh.vampire.toml` → VampireSaved) is unaffected because the clone is only of bbh.
- **Recommendation, revised by the measurement:** a PLAIN local clone (not `--shared`) at `f675710` under `TMPDIR` — 0.2 s more than shared, and no live dependence on bbh's object store; the same choice is worth making in the recount (D17) for the same reason at +1.6 s on VampireSaved. The read-only proof on the clone then includes ignored files (`status --porcelain --ignored` empty after the run). The in-place path stays as `BBX_BBH_HOME` pointing at a tree, declared and proved as today, for a verifier who wants the dirty tree on purpose.
- **Answer (maintainer, 2026-09-09):** plain clone — "I'm happy not that my intuition was correct but that we measured and even you arrived at the conclusion that the risk/reward was not worth it". Applied: the fidelity gate runs bbh from a plain local clone of `f675710` under `TMPDIR`; the recount's clone becomes plain too (D17 re-measured); the read-only proof on a clone includes ignored files.

## Open

### R21 — How the platform runs of R3 are obtained (raised bbx-2)
- **Context measured (2026-09-09):** this host is macOS only — `docker`, `podman`, `limactl`, `multipass`, `orb` and `wsl.exe` are all absent (`command -v` each), so no Linux or WSL run of `bin/bbx selftest` can be produced from here. R3 rules every platform guard gated on each platform and BBX validating BBX per platform; today every green is macOS-only and every readout says so.
- **Recommendation:** the maintainer runs `BBX_BBH_HOME=<bbh> bin/bbx selftest --log build/selftest_<platform>_<stamp>` on a Linux or WSL host with the lineage cloned beside it, and brings back the kept run directory (results.tsv, run.txt, controls.txt, the logs); `bin/bbx readout` on that directory is the platform's screen, committed under `docs/platforms/<platform>/` with the run's HEAD. Until a run directory exists, the platform row in the readout reads *not run*, never *passed*. A run brought back by hand is a filed count until its directory is in the tree (CLAUDE.md §1); once in the tree it is a kept run keyed by version (BBX-29). A second recommendation, cheaper per sitting: a container runtime on this host (any of the six above), after which a `platform_linux` gate can run the battery inside it and the row becomes a measurement, not a delivery.
- **Declined:** marking the platform row green from the POSIX-ness of the scripts (a claim, not a run); a CI service (no remote exists, R7; a run nobody can re-derive locally is a filed count).
- **Procedure (the maintainer asked "can I just clone the repo and run the selftest?", 2026-09-10 — yes, with three facts measured here):** (1) `git clone https://github.com/DefinitelyFrenchName/BBX.git` (R22; before it, a bundle was the way); (2) bbh's baseline `f675710` is on `origin/main` of github.com/DefinitelyFrenchName/blackbox-harness (`git branch -r --contains f675710` → `origin/main`), so `git clone https://github.com/DefinitelyFrenchName/blackbox-harness.git` beside BBX is enough for the fidelity gate (it clones `f675710` from that tree, R20); (3) the census gate reads each census file's recorded absolute path (`/Users/koneko/…`) and SKIPs when it is absent — on the Linux host it will SKIP, asserting nothing, and the screen says so; a full census run there would need the three lineage trees at those exact paths, which is not asked. Then, needing only `sh`, `python3`, `git` and coreutils `timeout`: `cd BBX && BBX_BBH_HOME=../blackbox-harness bin/bbx selftest --log build/selftest_linux_$(date -u +%Y%m%dT%H%M%SZ)`, twice (BBX-14), and bring back `build/selftest_linux_*` (tar it); `bin/bbx readout <second> --against <first>` is the platform's screen. Expected: 10 gates with a verdict, `census_recount` SKIP. Anything red is the finding the run is for (BBX-26 applies to it on the next sitting, not to this one).
- **Status:** the maintainer will produce the run "in the coming days" (2026-09-10); it blocks nothing else.
- **Answer:** (open)

(A new ruling is added here with its recommendation, the alternatives declined, and `- **Answer:** (open)` until the maintainer answers, then moved.)
