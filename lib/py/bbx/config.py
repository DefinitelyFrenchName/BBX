"""config.py — load a consumer's config and answer `get <section.key>`.

    python3 -m bbx.config <config.toml> get <section.key> [--default VALUE]
    python3 -m bbx.config <config.toml> dump
    python3 -m bbx.config <config.toml> root
    python3 -m bbx.config <config.toml> kind

Paths in a config are RELATIVE TO THE CONFIG FILE'S DIRECTORY (the consumer
root); the sh side cd's there before reading any of them. A list prints one
item per line (an inner array as tab-joined fields); an inline table prints
`key=value` lines; a missing key without --default exits 3 with the key
named, so a runner cannot silently run on an empty value.

Lifted from bbh lib/py/bbh/config.py (S1, 2026-09-09) with one change of
shape: defaults resolve in three layers — the consumer's config, then the
KIND PROFILE named by [project].kind, then the kind-blind DEFAULTS — so a
value true of one subject kind (which files reach an instrument, which
variable enables the static tier) never poses as generic (BBX-24; bbh's own
DEFAULTS carried its lineage's build names and every freeze rotted them,
docs/gotchas.md G4). Every default below has a row in docs/defaults.md.
"""
import os
import sys

from . import toml_subset

# The kind-blind defaults: true of any subject the harness reads gates for.
DEFAULTS = {
    "project": {
        "root": ".",                 # the consumer tree, relative to the config file
        "kind": "frame-driven",      # D9: which KIND PROFILE fills the second layer (bbh configs carry no kind)
        "gates_dir": "tests",
        "gate_glob": "*.sh",
        "lib_dir": "tests/lib",
        "runner_prefixes": ["run_"],
        "manual_suffixes": ["_soak"],
        "instrument_word": "instrument",
    },
    "registries": {
        "portable": "tests/ci_portable.txt",
        "static": "tests/ci_static.txt",
        "sweep": "tests/ci_sweep.tsv",
        "static_needs_env": "",      # empty: the static tier always runs; a kind names its input variable
    },
    "tier": {
        "patterns": [],              # empty: nothing reaches an instrument; a kind or a consumer says what does
        "source_regex": r'^\s*\.\s+"?\$(?:REPO|\{REPO\})"?/(tests/lib/[a-z0-9_]+\.sh)',
        "source_depth": 2,
    },
    "classify": {
        "skip_regex": r"^ *SKIP",
        "shell_error_regex": r"\.sh: line [0-9]+: [A-Za-z_][A-Za-z0-9_]*: ",
        "timeout_exits": [124, 137],
        "fail_tail": 4,
    },
    "controls": {
        "enforce": False,            # D10: read MUST-FIRE declarations and require them to fire (off = bbh's behaviour, fidelity)
    },
    # the instrument-tier sweep (bin/bbx-run-sweep) — kind-blind: one lane, no instruments, no placeholders (D15)
    "sweep": {
        "lanes": ["prereq"],
        "default_lanes": ["prereq"],
        "prereq_lane": "prereq",
        "release_scope": "release",
        "cadences": ["always"],
        "freeze_cadence": "always",
        "cadence_drop_note": [],
        "default_timeout": 600,
        "precondition": "",
        "precondition_fail_text": "precondition FAILED — stop",
        "input_env": "BBX_INPUT",
        "log_dir_prefix": "build/sweep_",
        "placeholders": {},
        "rompath_placeholder_suffix": "_RP",
        "rompath_suffix": "",
        "build_sets": [],
        "instruments": [],
        "env_defaults": [],
        "scratch_lanes": [],
        "scratch_env": "",
        "scratch_default": "",
        "clone_per_slot": False,     # D21: every --jobs slot runs on its own plain clone of the consumer's HEAD (R19)
        "prereq_cite": "",
    },
    # the subject identity (lib/py/bbx/fingerprint.py) — kind-blind: the artifact is ONE file (D16)
    "fingerprint": {
        "kind": "file-sha1",
        "program_member_regex": r"\.(\d+)$",
        "parent_sets": [],
        "region_rules": [],
        "region_default": "other",
        "file_pattern": "{set}.bin",
        "program_command": "",
        "wholeset_command": "",
    },
    # the suite keys the fingerprint and the comparison libraries read; the suite runner is S2 step 3
    "suite": {
        "registry": "tests/expected/registry.tsv",
        "default_set": "",
        "replays_dir": "tests/replays",
        "scenario_ext": "rpl",       # D34 (R32): the scenario file extension per kind; bbh's literal is the kind-blind value
        "expected_dir": "tests/expected",
        "driver": "",                # a consumer names its driver (a path from its root, or a name under driver_home); none = FAIL at the entrance
        "driver_home": "$BBX_HOME/drivers",   # D28 (R26): where a bare driver NAME resolves — absent until S3 gives BBX a driver
        "runs_per_replay": 2,        # D29: every scenario runs twice; a difference is NONDETERMINISTIC before any class (BBX-14)
        "mask_env": "MASK_RANGES",   # the variable a driver reads the mask from (bbh drivers/README.md)
        "mask_default": "",          # D26: kind-blind, a set without a mask file runs UNMASKED; the frame-driven profile carries bbh's literal
        "rompath_env": "",           # the driver's search-path variable; empty = the input directory is the search path
        "input_env": "BBX_INPUT",    # the reference-input directory, demanded at the entrance and made absolute
        "hermetic_unset": [],        # scrubbed from the environment before any driver runs; the frame-driven profile carries bbh's eight
        "hash_cmd": "python3 -m bbx.sha1",   # D27: prints `<hex> <file>`; portable (bbh's `shasum` stays in the frame-driven profile)
        "log_summary": "",           # D43: the command that prints a run log's OWN NOTE-class numbers (the kinds loop, S3 step 4); none kind-blind
    },
    # the expectation REGISTER (E3; R11, R24): TOML inside the expectation tree; basenames that are not expectations (D31)
    "provenance": {
        "register": "PROVENANCE.toml",       # inside [suite].expected_dir
        "exclude": ["PROVENANCE.toml", "README.md", "mask", "MASK"],
    },
    # the expectation KINDS: [extension, family, disposition] — registered here and nowhere else (E1, R23; D25).
    # Kind-blind: the three kinds every subject can carry; a kind with a comparator family adds its own.
    "expectations": {
        "kinds": [["skip", "-", "SKIP"], ["sha1", "exact", "N/A"], ["pending", "-", "NOT-EVALUATED"]],
    },
}

# The kind profiles: the second layer. `frame-driven` is bbh's DEFAULTS for
# the keys above, verbatim, so a bbh config read here resolves to the same
# values it resolves to in bbh (fidelity F13); `self` is BBX reading its own
# tree (ruled R14).
KINDS = {
    "frame-driven": {
        "project": {"instrument_word": "emulator"},
        "registries": {"static_needs_env": "ROMDIR", "sweep": "tests/ci_emulator.tsv"},
        "tier": {"patterns": [r"run_(replay_)?(mame|fbneo)\.sh", r"run_replay_guarded\.sh",
                              r"MAME_BIN", r"FBNEO_BIN", r"autoboot_script", r"emu/fbneo/fbneo",
                              r"run_battery", r"run_sim_jtcps2\.sh",
                              r"run_inp_probe\.sh", r"run_inp_guarded\.sh"]},
        # bbh's [sweep] literals verbatim (lib/py/bbh/config.py at 10a82d2, the M18 re-point; f675710 before 2026-09-10) — including the
        # lineage's build directories in `placeholders`, the biased default of BBX-24 kept
        # here under its kind's name so a bbh consumer config resolves as it does in bbh (D12)
        "sweep": {
            "lanes": ["prereq", "fbneo", "mame", "mister"],
            "default_lanes": ["prereq", "fbneo", "mame"],
            "cadences": ["romset", "bitstream"],
            "freeze_cadence": "romset",
            "cadence_drop_note": ["These follow the .rbf, not the romset (ruled 2026-09-03). A",
                                  "RELEASE always runs them; this run does not.",
                                  ">> IS THIS FREEZE TARGETING MiSTer? If yes, re-run with",
                                  "   --cadence all --lane mister. If no, this is correct."],
            "default_timeout": 5400,
            "precondition": 'python3 tools/audit_roms.py "$ROMDIR" > /dev/null',
            "precondition_fail_text": "ROM audit FAILED — stop (CLAUDE.md §3)",
            "input_env": "ROMDIR",
            "log_dir_prefix": "build/emu_sweep_",
            "placeholders": {"MERGED": "build/m3b_merged26", "DON": "build/don_m22", "HUI": "build/hui56",
                             "PYR": "build/pyron41", "STOCK": "build/m5_stock17"},
            "rompath_suffix": "/rompath",
            "build_sets": ["vsavjw", "vsavj"],
            "instruments": [["mame-wide", "MAME_WIDE_BIN", "$HOME/.cache/vampire-saved/mame/cps2"],
                            ["mame-ref", "MAME_REF_BIN", "$HOME/.cache/vampire-saved/mame-ref/cps2"],
                            ["fbneo", "", "$REPO/emu/fbneo/fbneo"]],
            "env_defaults": [["MAME_BIN", "mame-wide"]],
            "scratch_lanes": ["mister"],
            "scratch_env": "JTSIM_SCRATCH",
            "scratch_default": "vampire-saved-jtsim",
            "prereq_cite": "[CPE-24]",
        },
        "fingerprint": {
            "kind": "zip-members",
            "program_member_regex": r"\.(0[3-9]|10|4[1-4])[a-ln-z]?$",
            "parent_sets": ["vsav"],
            "region_rules": [[r"\.key$", "key"], [r"\.0[12]$", "z80"],
                             [r"^vsw\..*m$", "gfx/qsnd"], [r"^vsw\.", "prg"],
                             ["@program", "prg"]],
            "region_default": "gfx/qsnd",
        },
        # bbh's [suite] defaults verbatim (lib/py/bbh/config.py at f675710; D26-D29), plus the driver home: bbh's own drivers/ (R26)
        "suite": {"default_set": "vsavj", "mask_default": "043c-043d,4182-41a2,7f00-8000",
                  "driver": "tools/run_replay_mame.sh", "driver_home": "$BBX_BBH_HOME/drivers",
                  "rompath_env": "MAME_ROMPATH", "input_env": "ROMDIR", "hash_cmd": "shasum",
                  "hermetic_unset": ["POKES", "DUMPS", "SNAP_FRAMES", "TAIL_FRAMES", "VIDEO_OUT", "INPUT_OUT", "INPUT_INJECT_TEST", "NO_INPUT_CHECK"]},
        # bbh's five kinds (enumerate_expectations.sh at f675710): masked and diverge are the temporal family over the
        # checksum-log view; fidelity F16c diffs the enumeration lines
        "expectations": {"kinds": [["skip", "-", "SKIP"], ["sha1", "exact", "N/A"], ["pending", "-", "NOT-EVALUATED"],
                                   ["masked", "temporal", "EVAL"], ["diverge", "temporal", "EVAL"]]},
        # the temporal family's thresholds: bbh's [thresholds] defaults verbatim (D23; R25 makes a
        # looser consumer value need a ruling). A kind with no temporal family carries none.
        "thresholds": {"flicker_max": 2, "reconverge": 60, "flicker_max_total": 8},
    },
    # the DOCUMENT-SET kind (docs/plans/S3.md §3; D33; R31–R34): a directory of documents plus the ARTIFACT they
    # describe; no instrument (portable); the scenario is a CLAIM SET (.claims, R32); the identity is file-sha1 over
    # the artifact with the whole-set key over its directory (documents + artifact); no temporal family.
    "document-set": {
        "project": {"instrument_word": "extractor"},
        "registries": {"static_needs_env": ""},
        "tier": {"patterns": []},
        "suite": {"scenario_ext": "claims", "driver": "docset",
                  "rompath_env": "DOCSET_PATH", "input_env": "DOCSET_PATH",
                  "hermetic_unset": ["DOCSET_FORMS", "DOCSET_NONDET", "DOCSET_VIEW"],
                  "log_summary": "python3 -m bbx.docset summary"},     # D43: NOTE: coverage / paraphrase / unbindable / stale / mismatch (D42)
        "fingerprint": {"kind": "file-sha1", "file_pattern": "{set}.tsv"},
        "expectations": {"kinds": [["skip", "-", "SKIP"], ["sha1", "exact", "N/A"], ["pending", "-", "NOT-EVALUATED"],
                                   ["truth", "exact", "EVAL"], ["claims", "set", "EVAL"],
                                   ["covered", "set", "EVAL"], ["schema", "schema", "EVAL"]]},
    },
    # the COMMAND-LINE kind (docs/plans/S4.md §3 S1; D45; R35–R40): an executable plus its declared interface; no
    # instrument (portable); the scenario is an INVOCATION (.cli, R35); the identity is file-sha1 over the tool with the
    # whole-set key over the tool's own directory; the driver family scrubbed (the search path CLI_PATH is the
    # suite's, as DOCSET_PATH is the document-set's); no temporal family; log_summary arrives with the driver (step 2).
    "command-line": {
        "project": {"instrument_word": "tool"},
        "registries": {"static_needs_env": ""},
        "tier": {"patterns": []},
        "suite": {"scenario_ext": "cli", "driver": "cli",
                  "rompath_env": "CLI_PATH", "input_env": "CLI_PATH",
                  "hermetic_unset": ["CLI_NONDET", "CLI_TIMEOUT", "CLI_KEEP_ENV"]},
        "fingerprint": {"kind": "file-sha1", "file_pattern": "{set}.py"},
        "expectations": {"kinds": [["skip", "-", "SKIP"], ["sha1", "exact", "N/A"], ["pending", "-", "NOT-EVALUATED"],
                                   ["truth", "exact", "EVAL"], ["unordered", "set", "EVAL"],
                                   ["schema", "schema", "EVAL"], ["band", "tolerant-numeric", "EVAL"]]},
    },
    "self": {
        "project": {"gates_dir": "gates", "lib_dir": "lib/sh", "instrument_word": "instrument"},
        "registries": {"portable": "gates/portable.txt", "static": "gates/static.txt",
                       "sweep": "gates/sweep.tsv", "static_needs_env": "BBX_BBH_HOME"},
        "sweep": {"input_env": "BBX_BBH_HOME", "log_dir_prefix": "build/sweep_"},
        "controls": {"enforce": True},
    },
}


def load(path):
    return toml_subset.load(path)


def kind_of(cfg):
    k = cfg.get("project", {}).get("kind", DEFAULTS["project"]["kind"])
    if k not in KINDS:
        raise KeyError(f"[project].kind = {k!r} names no kind profile (known: {', '.join(sorted(KINDS))})")
    return k


def root_of(cfg_path, cfg=None):
    """The consumer root: [project].root resolved against the config's dir."""
    cfg = cfg if cfg is not None else load(cfg_path)
    base = os.path.dirname(os.path.abspath(cfg_path))
    return os.path.normpath(os.path.join(base, get(cfg, "project.root")))


def consumer(config_path=None, root=None):
    """(cfg, root) for a tool: the config from `config_path`, else $BBX_CONFIG,
    else {} (every key at its default); the root from `root` when given, else
    [project].root resolved against the config, else the working directory."""
    path = config_path or os.environ.get("BBX_CONFIG")
    if path and os.path.isfile(path):
        cfg = load(path)
        r = root or root_of(path, cfg)
    else:
        cfg = {}
        r = root or os.getcwd()
    return cfg, os.path.abspath(r)


def get(cfg, dotted, default=None):
    """cfg['a']['b'] for 'a.b', then the kind profile, then DEFAULTS, then `default`."""
    parts = dotted.split(".")
    if len(parts) != 2:
        raise KeyError(f"a key is section.key, got {dotted!r}")
    sec, key = parts
    if sec in cfg and key in cfg[sec]:
        return cfg[sec][key]
    prof = KINDS[kind_of(cfg)]
    if sec in prof and key in prof[sec]:
        return prof[sec][key]
    if sec in DEFAULTS and key in DEFAULTS[sec]:
        return DEFAULTS[sec][key]
    if default is not None:
        return default
    raise KeyError(dotted)


def _emit(v):
    if isinstance(v, bool):
        print("true" if v else "false")
    elif isinstance(v, list):
        for item in v:
            if isinstance(item, list):
                print("\t".join(str(x) for x in item))
            else:
                print(item)
    elif isinstance(v, dict):
        for k, x in v.items():
            print(f"{k}={x}")
    else:
        print(v)


def main(argv):
    if len(argv) < 2:
        print(__doc__, file=sys.stderr)
        return 2
    path, cmd = argv[0], argv[1]
    try:
        cfg = load(path)
    except (OSError, toml_subset.SubsetError) as e:
        print(f"bbx config: {path}: {e}", file=sys.stderr)
        return 2
    if cmd == "root":
        print(root_of(path, cfg))
        return 0
    if cmd == "kind":
        try:
            print(kind_of(cfg))
        except KeyError as e:
            print(f"bbx config: {path}: {e.args[0]}", file=sys.stderr)
            return 3
        return 0
    if cmd == "dump":
        for sec, tab in cfg.items():
            print(f"[{sec}]")
            for k, v in tab.items():
                print(f"{k} = {v!r}")
        return 0
    if cmd == "get":
        if len(argv) < 3:
            print("bbx config: get needs <section.key>", file=sys.stderr)
            return 2
        key = argv[2]
        default = None
        if len(argv) >= 5 and argv[3] == "--default":
            default = argv[4]
        try:
            _emit(get(cfg, key, default))
        except KeyError as e:
            print(f"bbx config: {path}: no value for '{key}' and no default", file=sys.stderr)
            return 3
        return 0
    print(f"bbx config: unknown command {cmd!r}", file=sys.stderr)
    return 2


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
