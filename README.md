<!-- Shape: living page, for visitors. Every number in it is dated to a commit, and "Try it" re-derives them. -->
# BBX — Black Box harness eXpanded

**A test harness for proving that work is good to someone who cannot read how it was made.**

BBX runs a subject — a program, a set of documents, a command-line tool, a test suite, or BBX itself —
through scripted scenarios, compares what it observes with expectations frozen in advance, and ends every
run with one screen a non-programmer can act on. That screen says what passed, what the result rests on,
and, always, **what the green does not prove**.

## Why it exists

"All tests pass" is only as trustworthy as the tests, and tests decay without anyone noticing:

- a check that can no longer fail keeps reporting success;
- a skipped test gets counted as a passed one;
- a number is copied from last month's notes instead of being measured again;
- an expected value is written from the very thing it is supposed to test.

Each of these produces a green result that means nothing. BBX is built so that each of them turns into a
visible failure.

## How it works

- **Scenarios and expectations.** A *driver* runs the subject through a scenario and records what it
  observes. Each observation is compared with an *expectation* frozen earlier, under a declared comparison
  rule (exact, unordered, a schema, or a measured numeric band). Every expectation records where it came
  from — an independent reference, a derivation, or our own earlier output — and the screen says which
  kind a green rests on.
- **Checks that have proved they can fail.** Each check (a *gate*) declares *controls*: deliberate defects
  it must catch. Every run plants them, and a control that no longer fires turns the run red. Today each
  check reports its own controls; having the runner replay them independently is designed, not yet built.
- **Every scenario runs twice.** Any difference between the two runs is a failure before anything else is
  compared.
- **One screen at the end.** Pass, skip, fail, timeout and missing are counted separately — a skip is never
  a pass — beside the controls that fired, where the expectations came from, and every check's declared
  blind spots.
- **Measure, never guess.** No number enters a document without a run that produced it. When a written
  claim turns out to be wrong, its wording is registered, and a sweep fails wherever it reappears.

## What exists today

- **Three kinds of subject**: frame-by-frame systems such as an emulated game board (where BBX comes from);
  document sets, whose claims are re-checked against the data they describe; and command-line tools. **Two
  adapters** run an external test framework (Python's `unittest`) and BBX's own battery of checks as
  subjects.
- **BBX checks itself with itself.** Its own battery is a subject of its own runner, and a file census
  records which parts of BBX each check actually executes — so a component called shared is shown to be
  used by every kind, not assumed to be.
- **It proves nothing was lost.** BBX generalizes an earlier harness and must reproduce that harness's
  verdicts byte for byte on the same inputs; the comparison is part of every full battery.

At commit `bf557d0` (2026-09-13), on macOS: 32 checks passed in each of two runs, all 133 of their
controls fired, and the two runs gave identical verdicts. Earlier commits have also run on Windows (WSL,
the full battery) and on native Linux (the checks that need no external reference). Re-derive these
numbers rather than trusting this page.

## How it is built

BBX is written entirely by AI agents — Anthropic's Claude, working through Claude Code — for a human
maintainer who does not read the code.

That is deliberate. The maintainer brings twenty years of product, development and management work in
mostly large, often critical, largely undocumented systems, and runs this project the way such systems are governed: by
evidence rather than by reading every line. The agent measures, proposes and builds. For any decision that
changes how BBX behaves, it writes a recommendation beside the alternatives it rejected, and waits. The
maintainer rules, and accepts work only on what the readout shows, never on the agent's word. Every ruling
and every mistake is recorded, each mistake with what it cost. In the maintainer's words: *"We don't
compromise on discipline. The only arbitrations may be on time/practicality but even so they would be
arbitrations on method of application, not on how to compromise on the discipline."*

None of this is specific to AI: any lead who cannot personally verify every line is in the same position.
BBX exists to make that position safe.

## Lineage

BBX generalizes [blackbox-harness](https://github.com/DefinitelyFrenchName/BBH-frame-based) ("bbh"), a
harness for systems that can be driven and checked frame by frame, such as an emulated game board. Its
discipline was first worked out in [SMS-FrenchName-edition](https://github.com/DefinitelyFrenchName/SMS-FrenchName-edition)
and scaled up in [VampireSaved](https://github.com/DefinitelyFrenchName/VampireSaved) (two retro-game
projects based on SNES and CPS-II architecture), before bbh extracted it. BBX never modifies bbh; it only has to agree with it.

## Try it

Needs a POSIX shell, Python 3 and git — nothing else.

```sh
git clone https://github.com/DefinitelyFrenchName/BBX.git
git clone https://github.com/DefinitelyFrenchName/BBH-frame-based.git blackbox-harness
cd BBX
stamp=$(date -u +%Y%m%dT%H%M%SZ)
BBX_BBH_HOME=../blackbox-harness bin/bbx selftest --log build/selftest_$stamp
bin/bbx readout build/selftest_$stamp
```

The battery takes 10 to 15 minutes on M2 Pro silicon. Run it twice and add
`--against build/selftest_<first stamp>` to the readout to compare the two runs. Two things to expect:

- Without `BBX_BBH_HOME`, the four checks that need external references do not run at all, and the screen
  does not yet count them as skipped — a known defect, scheduled to be fixed next.
- One of those four recounts figures from the ancestor projects, and it skips on any machine that has no
  copies of them at the paths it records. That skip is expected and says so.

## Reading further

| file | what it is |
|---|---|
| `docs/readout.md` | the screen of every working session's runs, with what changed and what was not proved |
| `STATE.md` / `HANDOFF.md` | what is true now / the map for the next working session |
| `DECISIONS.md` | the maintainer's rulings in force |
| `docs/gotchas.md` | every mistake found, with what it cost and what it taught |
| `CLAUDE.md` | the project's constitution: the rules every contributor, human or AI, works under |
| `docs/platforms/` | runs on other operating systems |

## License

GPL-3.0 — see `LICENSE`.
