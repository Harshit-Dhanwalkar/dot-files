#!/bin/bash
#
# Qutebrowser Session Launcher using rofi or dmenu.
# This script finds existing sessions created by the wrapper and allows
# the user to launch an existing session or create a new one.

set -eu

# --- Configuration ---
XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.var/state}"
QUTE_SESSION_ROOT="$XDG_STATE_HOME/qutebrowser"
NEW_SESSION_OPTION="[NEW SESSION - Enter Name]"
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
QUTEBROWSER_WRAPPER="$SCRIPT_DIR/qutebrowser-wrapper.sh"

MENU_CMD=""
PROMPT_CMD=""

if command -v rofi >/dev/null 2>&1; then
    MENU_CMD="rofi -dmenu -i -p 'Qutebrowser Session:' -theme-str 'listview { lines: 8; }'"
    PROMPT_CMD="rofi -dmenu -p 'New Session Name:'"
elif command -v dmenu >/dev/null 2>&1; then
    MENU_CMD="dmenu -i -p 'Qutebrowser Session:'"
    PROMPT_CMD="dmenu -p 'New Session Name:'"
else
    echo "Error: Neither 'rofi' nor 'dmenu' found. Please install one of them." >&2
    exit 1
fi

SESSIONS=""
if [ -d "$QUTE_SESSION_ROOT" ]; then
    SESSIONS=$(find "$QUTE_SESSION_ROOT" -maxdepth 1 -mindepth 1 -type d -printf '%f\n' | sort)
fi

OPTIONS="$NEW_SESSION_OPTION\n$SESSIONS"
SESSION_CHOICE=$(echo -e "$OPTIONS" | eval "$MENU_CMD")

if [ -z "$SESSION_CHOICE" ]; then
    exit 0
fi

if [ "$SESSION_CHOICE" = "$NEW_SESSION_OPTION" ]; then
    NEW_NAME=$(eval "$PROMPT_CMD")

    if [ -z "$NEW_NAME" ]; then
        echo "Canceled new session creation."
        exit 0
    fi

    SESSION_NAME=$(echo "$NEW_NAME" | tr '[:upper:]' '[:lower:]' | tr -c '[:alnum:]_-' '_')

    if [ -z "$SESSION_NAME" ]; then
        echo "Error: Invalid session name after sanitization." >&2
        exit 1
    fi

    echo "Launching new session: $SESSION_NAME" >&2
    exec "$QUTEBROWSER_WRAPPER" --restore "$SESSION_NAME"

else
    echo "Launching existing session: $SESSION_CHOICE" >&2
    exec "$QUTEBROWSER_WRAPPER" --restore "$SESSION_CHOICE"
fi
