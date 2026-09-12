# Running BBX's battery on a Linux or WSL host — the step-by-step (R21)

Shape: procedure. Every fact below was **measured on the macOS host on 2026-09-12**
at BBX commit `48a9525`, by the command shown beside it. Where a number could
drift, the command is there so you re-derive it rather than trust this page (§1).

R21's question is narrow: **every platform guard BBX carries must be gated on
every platform** (R3), and today every green BBX has is Darwin arm64 only. This
procedure produces one kept run from a second platform. Anything red in it is the
finding the run exists for — it is not a failure of the exercise.

## 0. What the host needs

| need | why | check |
|---|---|---|
| `git` | the clones below, and BBX's own tree checks | `command -v git` |
| `python3`, 3.9 or newer | BBX's own floor; measured here on 3.9.6 | `python3 -V` |
| `sh` | the runners and gates are POSIX sh | already present |
| `timeout` | the gate timeout wrapper; GNU coreutils has it | `command -v timeout` |
| `shasum` **(optional)** | ONE gate wants a second SHA-1 implementation on purpose | `command -v shasum` |

`shasum` is perl's `Digest::SHA`. **If it is absent, nothing breaks**:
`gates/cli_driver.sh` prints `SKIP:` and exits 0 by design, because its point is
re-hashing with an implementation that is not Python's. Everything else hashes
through `python3 -m bbx.sha1` (default D27), which needs nothing but python3.

## 1. Clone the two repositories, side by side

```sh
mkdir -p ~/bbx && cd ~/bbx
git clone https://github.com/DefinitelyFrenchName/BBX.git
git clone https://github.com/DefinitelyFrenchName/BBH-frame-based.git blackbox-harness
```

**The explicit directory name on the second clone matters.** bbh's remote was
renamed from `blackbox-harness` on 2026-09-10; without the trailing name the clone
lands in `BBH-frame-based/` and the `BBX_BBH_HOME` below points at nothing.

BBX needs exactly **one** bbh commit, `10a82d2`, and the clone above contains it:
`git -C blackbox-harness branch -r --contains 10a82d2` prints `origin/main`
(measured 2026-09-12). The fidelity gates and the suite gate each make their own
plain local clone of it under `TMPDIR` and never touch your checkout. Until R43
landed this sitting, one gate needed a second, older commit; it does not any more.

## 2. Run the battery twice, in the background, alone

```sh
cd ~/bbx/BBX
BBX_BBH_HOME=~/bbx/blackbox-harness bin/bbx selftest --log build/selftest_linux_$(date -u +%Y%m%dT%H%M%SZ)
```

Then run the identical command a second time. Two runs at one commit is what
BBX-14 asks for, and the screen reports whether it was met.

Three things to hold to, each paid for here:

* **Run it alone.** Nothing else of BBX's, and no editing of the tree while it
  runs — the runner reports a tracked file that changed mid-run as `dirtied`, and
  such a run is not a clean measurement (G44).
* **It takes about eleven minutes** on the macOS host with 31 registered gates, so
  it is past a ten-minute foreground cap if you have one. Read the verdict off the
  **kept run**, never off a pipe: `| tail` keeps only the tail and hands you the
  pipe's exit instead of the command's (G16).
* **Do NOT pass `--strict`.** It makes a SKIP fatal, and this host is expected to
  skip (next section).

## 3. What is expected to SKIP, and why that is correct

| gate | expected | why |
|---|---|---|
| `census_recount` | **SKIP** | each of the three lineage census files records an absolute macOS path (`/Users/koneko/…`); a census naming an absent directory is skipped, asserting nothing |
| `cli_driver` | SKIP **only if `shasum` is absent** | it re-hashes two points with a second SHA-1 implementation on purpose |

Everything else is expected to PASS. Nothing else is *known* to skip off macOS —
which is precisely what this run is for.

`gates/file_census.sh` will **not** run and should not be invoked: it is registered
in `gates/sweep.tsv` at the release scope, takes about twenty minutes because it
runs the whole battery inside an instrumented shadow, and is not part of the
battery (D63).

## 4. Read the screen

```sh
bin/bbx readout build/selftest_linux_<second stamp> --against build/selftest_linux_<first stamp>
```

That one screen is the deliverable. On the macOS host at this commit it reads:

```
VERDICT: GREEN   PASS 31  SKIP 0  FAIL 0  TIMEOUT 0  MISSING 0   (gates 31)
  controls: fired 119 / declared 119; dead 0; undeclared firings 0; gates red 0
  each can fail: 31 of 31 gates proved a control fires on purpose
```

A Linux screen showing `PASS 30  SKIP 1` with `census_recount` skipped is the
expected shape, not a problem. Counts to re-derive rather than trust:
`grep -hv '^#' gates/portable.txt gates/static.txt | wc -l` for the gate total.

## 5. Bring the run back

```sh
cd ~/bbx/BBX && tar czf /tmp/bbx_linux_run.tgz build/selftest_linux_*
```

The kept directories hold `results.tsv`, `run.txt`, `controls.txt` and every gate's
log. They are committed here under `docs/platforms/<platform>/` with the commit
they ran at, which is what turns the run from a filed count into a kept result
keyed by version (§1, BBX-29). Also useful in the report, because they cannot be
re-derived from the archive: the output of `uname -a`, `python3 -V`, and
`command -v shasum timeout`.

## 6. If something is red

That is the finding. Nothing needs fixing on the Linux host, and nothing should be
edited there to make a gate green — a red gate is a question, and which side of it
is right is decided here with the log in hand (BBX-26 applies to the sitting that
reads it, not to the one that produced it). Send the archive and the screen.

## What this procedure does NOT cover

- **A full census recount on Linux.** It would need the three lineage trees at
  their exact recorded macOS paths, which is not asked and not useful.
- **`gates/file_census.sh`**, deliberately (see §3).
- **Windows outside WSL.** R3's floor treats WSL as Linux; a native Windows shell
  is not claimed.
- **A second architecture.** This gives a second OS, not a second CPU. Darwin arm64
  and Linux on whatever the host is.

## History of this page

- 2026-09-12 (bbx-20): written, every fact re-measured at `48a9525`. Supersedes the
  procedure held in `docs/rulings.md` R21, which was last corrected at bbx-18 and
  had since gone stale in three ways — it named a gate count from before two gates
  were added, and it told the reader to obtain a second bbh commit that R43 made
  unnecessary this sitting. Writing it also found a defect in `gates/census_register.sh`:
  it hashed with `shasum` unguarded, so on a host without perl's `Digest::SHA` it
  would have CRASHED rather than skipped. Fixed before the run, to `python3 -m
  bbx.sha1` — the point of a platform run is to find the differences nobody
  predicted, not the one that was sitting in the diff.
