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
}

# The kind profiles: the second layer. `frame-driven` is bbh's DEFAULTS for
# the keys above, verbatim, so a bbh config read here resolves to the same
# values it resolves to in bbh (fidelity F13); `self` is BBX reading its own
# tree (ruled R14).
KINDS = {
    "frame-driven": {
        "project": {"instrument_word": "emulator"},
        "registries": {"static_needs_env": "ROMDIR"},
        "tier": {"patterns": [r"run_(replay_)?(mame|fbneo)\.sh", r"run_replay_guarded\.sh",
                              r"MAME_BIN", r"FBNEO_BIN", r"autoboot_script", r"emu/fbneo/fbneo",
                              r"run_battery", r"run_sim_jtcps2\.sh",
                              r"run_inp_probe\.sh", r"run_inp_guarded\.sh"]},
    },
    "self": {
        "project": {"gates_dir": "gates", "lib_dir": "lib/sh", "instrument_word": "instrument"},
        "registries": {"portable": "gates/portable.txt", "static": "gates/static.txt",
                       "static_needs_env": "BBX_BBH_HOME"},
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
