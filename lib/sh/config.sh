# config.sh — the sh side of the consumer config. sh has no TOML, so every
# read is one `python3 -m bbx.config` call; a runner reads a dozen keys at
# start and never again. Lifted from bbh lib/sh/config.sh (S1, 2026-09-09).
#
#   bbx_config_init [path]   resolve the config (arg, $BBX_CONFIG, ./bbx.toml,
#                            ./bbh.toml), export BBX_CONFIG (absolute),
#                            BBX_ROOT (its dir), PYTHONPATH (the harness lib)
#   bbx_cfg <section.key> [default]
#                            print the value; a list one item per line; a
#                            missing key with no default is FATAL (exit 3):
#                            a runner never runs on an empty value silently
#
# BBX_HOME must be set by the caller (every bin/ script derives it from $0).
# A consumer config may be a bbh.toml: the frame-driven kind's keys are bbh's.

bbx_config_init() {
    _c="${1:-${BBX_CONFIG:-}}"
    if [ -z "$_c" ]; then
        if [ -f bbx.toml ]; then _c=bbx.toml; elif [ -f bbh.toml ]; then _c=bbh.toml; else _c=bbx.toml; fi
    fi
    if [ ! -f "$_c" ]; then
        echo "bbx: config '$_c' not found (pass --config, set BBX_CONFIG, or run from the consumer root)" >&2
        exit 2
    fi
    BBX_CONFIG="$(cd "$(dirname "$_c")" && pwd)/$(basename "$_c")"
    PYTHONPATH="$BBX_HOME/lib/py${PYTHONPATH:+:$PYTHONPATH}"
    export BBX_CONFIG PYTHONPATH
    # the consumer root is [project].root relative to the config file — so a
    # consumer config may live OUTSIDE the tree it describes
    BBX_ROOT="$(python3 -m bbx.config "$BBX_CONFIG" root)" || exit 2
    [ -d "$BBX_ROOT" ] || { echo "bbx: consumer root '$BBX_ROOT' (from [project].root) is not a directory" >&2; exit 2; }
    export BBX_ROOT
}

bbx_cfg() {
    if [ $# -ge 2 ]; then
        python3 -m bbx.config "$BBX_CONFIG" get "$1" --default "$2" || exit 3
    else
        python3 -m bbx.config "$BBX_CONFIG" get "$1" || exit 3
    fi
}
