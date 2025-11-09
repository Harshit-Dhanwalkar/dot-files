#!/bin/bash

set -eu

# Set default values for the variables as defined in the XDG base directory spec
# (https://specifications.freedesktop.org/basedir-spec/latest/):
XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.var/state}"

# Function to convert shell arguments ($@) to a JSON array string
# This ensures arguments like '--restore session_name' are correctly formatted for the socket.
args_to_json_array() {
    local arr=()
    for arg in "$@"; do
        # Escape quotes and backslashes
        local escaped_arg=$(printf '%s' "$arg" | sed 's/["\]/\\&/g')
        arr+=("\"$escaped_arg\"")
    done
    echo "[${arr[@]}]"
}

# Fast IPC launch attempt
_qb_version='1.0.4'
_proto_version=1
_ipc_socket="${XDG_RUNTIME_DIR}/qutebrowser/ipc-$(printf '%s' "$USER" | md5sum | cut -d' ' -f1)" # Identify the Communication Channel

# Construct the JSON payload with all arguments
JSON_ARGS=$(args_to_json_array "$@")
JSON_PAYLOAD=$(
    printf '{"args": %s, "target_arg": null, "version": "%s", "protocol_version": %d, "cwd": "%s"}\n' \
        "${JSON_ARGS}" \
        "${_qb_version}" \
        "${_proto_version}" \
        "${PWD}"
)

# Attempt to pass the command (e.g., --restore session_name) to the running instance
if echo "$JSON_PAYLOAD" | socat -lf /dev/null - UNIX-CONNECT:"${_ipc_socket}"; then
    exit 0
fi

#  Slow fallback
## Constants:
FALSE=0
TRUE=1

# Translate options: remove occurrences of -r/--restore from the list of
# command line arguments and save the session name for later; ignore -R (TODO):
session='default'
basedir_specified=$FALSE
opts_read=0
while [ $opts_read -lt $# ]; do
    opt="$1" && shift
    case "$opt" in
    --basedir) basedir_specified=$TRUE ;;
    -r | --restore) test $# -gt 0 && session="$1" && shift && continue ;;
    -[!-]*r) test $# -gt 0 && session="$1" && shift && opt=${opt%r} ;;
    -R) continue ;; # TODO
    esac
    set -- "$@" "$opt"
    opts_read=$((opts_read + 1))
done

# Persistent Argument Loading
QUTE_PROFILE_CONF_ROOT="$XDG_CONFIG_HOME/qutebrowser/profiles"
mkdir -p "$QUTE_PROFILE_CONF_ROOT"

PROFILE_ARGS_FILE="$QUTE_PROFILE_CONF_ROOT/$session.args"
PROFILE_ARGS_TO_ADD=""

if [ ! -f "$PROFILE_ARGS_FILE" ]; then
    DEFAULT_TITLE_ARGS="--set window.title_format \"{perc}{title_sep}{current_title} - qutebrowser [${session^^}]\""
    echo "$DEFAULT_TITLE_ARGS" >"$PROFILE_ARGS_FILE"
fi

if [ -f "$PROFILE_ARGS_FILE" ]; then
    PROFILE_ARGS_TO_ADD=$(cat "$PROFILE_ARGS_FILE")
    eval "set -- $PROFILE_ARGS_TO_ADD \"\$@\""
fi

# Set up session base directory, unless --basedir has been specified by the
# user:
if [ $basedir_specified -eq $FALSE ]; then
    basedir="$XDG_RUNTIME_DIR/qutebrowser/$session"
    set -- --basedir "$basedir" "$@"
    mkdir -p \
        "$basedir" \
        "$XDG_CONFIG_HOME/qutebrowser" \
        "$XDG_CACHE_HOME/qutebrowser/$session" \
        "$XDG_STATE_HOME/qutebrowser/$session" \
        "$basedir/runtime"
    ln -fsT "$XDG_CONFIG_HOME/qutebrowser" "$basedir/config"
    ln -fsT "$XDG_CACHE_HOME/qutebrowser/$session" "$basedir/cache"
    ln -fsT "$XDG_STATE_HOME/qutebrowser/$session" "$basedir/data"
    if [ -d "$XDG_DATA_HOME/qutebrowser/userscripts" ]; then
        ln -fsT "$XDG_DATA_HOME/qutebrowser/userscripts" \
            "$basedir/data/userscripts"
    fi
fi

# Search "real" qutebrowser executable:
spath="$(readlink -f "$0")"
IFS=:
for p in $PATH; do
    epath="$p"/qutebrowser
    if [ -x "$epath" ] && [ "$(readlink -f "$epath")" != "$spath" ]; then
        exec "$epath" "$@"
    fi
done

echo 'command not found: qutebrowser' >&2
exit 127
