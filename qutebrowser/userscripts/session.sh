#!/bin/bash

# Qutebrowser Session Launcher/Deleter using rofi or dmenu.

set -eu

# --- Configuration ---
XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.var/state}"
QUTE_SESSION_ROOT="$XDG_STATE_HOME/qutebrowser"
NEW_SESSION_OPTION="[NEW SESSION - Enter Name]"
DELETE_SESSION_OPTION="[DELETE SESSION]"
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
QUTEBROWSER_WRAPPER="$SCRIPT_DIR/qutebrowser-wrapper.sh"

MENU_CMD=""
PROMPT_CMD=""
NOTIFICATION_CMD="notify-send"

# --- Menu Detection ---
if command -v rofi >/dev/null 2>&1; then
    MENU_CMD="rofi -dmenu -i -theme android_notification -theme-str 'listview { lines: 8; }' -p 'Qutebrowser Session:'"
    PROMPT_CMD="rofi -dmenu -p 'New Session Name:' -theme android_notification"
elif command -v dmenu >/dev/null 2>&1; then
    DMENU_THEME_ARGS="-nb '#2e3440' -nf '#d8dee9' -sb '#88c0d0' -sf '#eceff4'"
    MENU_CMD="dmenu -i ${DMENU_THEME_ARGS} -p 'Qutebrowser Session:'"
    PROMPT_CMD="dmenu ${DMENU_THEME_ARGS} -p 'New Session Name:'"
else
    exit 1
fi

# --- Helper Functions ---
# send notifications
notify_user() {
    if command -v "$NOTIFICATION_CMD" >/dev/null 2>&1; then
        "$NOTIFICATION_CMD" "$@"
    fi
}

# perform silent deletion
delete_session_silently() {
    local SESSION_NAME="$1"

    # Configure XDG variables for deletion process
    local XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
    local XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
    local XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.var/state}"
    local XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"

    local QUTE_PROFILE_CONF_ROOT="$XDG_CONFIG_HOME/qutebrowser/profiles"
    local SESSION_DATA_DIR="$XDG_STATE_HOME/qutebrowser/$SESSION_NAME"
    local SESSION_CACHE_DIR="$XDG_CACHE_HOME/qutebrowser/$SESSION_NAME"
    local SESSION_RUNTIME_DIR="$XDG_RUNTIME_DIR/qutebrowser/$SESSION_NAME"
    local PROFILE_ARGS_FILE="$QUTE_PROFILE_CONF_ROOT/$SESSION_NAME.args"

    # Remove files silently
    rm -rf "$SESSION_DATA_DIR"
    rm -rf "$SESSION_CACHE_DIR"
    rm -f "$PROFILE_ARGS_FILE"
    rm -rf "$SESSION_RUNTIME_DIR"
    return 0
}

# --- Main Menu Logic ---
SESSIONS=""
if [ -d "$QUTE_SESSION_ROOT" ]; then
    # Filter out the 'default' session from the list
    SESSIONS=$(find "$QUTE_SESSION_ROOT" -maxdepth 1 -mindepth 1 -type d -printf '%f\n' | grep -v '^default$' | sort)
fi

OPTIONS="$NEW_SESSION_OPTION\n\n$SESSIONS\n\n\n$DELETE_SESSION_OPTION"
SESSION_CHOICE=$(echo -e "$OPTIONS" | eval "$MENU_CMD")

if [ -z "$SESSION_CHOICE" ]; then
    exit 0
fi

# --- Handle Menu Choice ---
if [ "$SESSION_CHOICE" = "$NEW_SESSION_OPTION" ]; then
    NEW_NAME=$(eval "$PROMPT_CMD")
    if [ -z "$NEW_NAME" ]; then
        exit 0 # Canceled
    fi
    SESSION_NAME=$(echo "$NEW_NAME" | tr '[:upper:]' '[:lower:]' | tr -c '[:alnum:]_-' '_' | sed 's/_$//')
    if [ -z "$SESSION_NAME" ]; then
        notify_user "Qutebrowser Session Error" "Invalid session name after sanitization." -i dialog-error -t 5000
        exit 1
    fi
    # Launch new session
    exec "$QUTEBROWSER_WRAPPER" --restore "$SESSION_NAME"

elif [ "$SESSION_CHOICE" = "$DELETE_SESSION_OPTION" ]; then
    # --- Deletion Logic ---
    DELETABLE_SESSIONS="$SESSIONS" # $SESSIONS already excludes 'default'
    if [ -z "$DELETABLE_SESSIONS" ]; then
        notify_user "Qutebrowser Session Delete" "No custom sessions found to delete." -i dialog-information -t 3000
        exit 0
    fi
    # Prompt user to choose session to delete
    DELETE_PROMPT_CMD=""
    if command -v rofi >/dev/null 2>&1; then
        DELETE_PROMPT_CMD="rofi -dmenu -i -no-custom -theme android_notification -p 'CONFIRM Session to DELETE:' -theme-str 'listview { lines: 6; }'"
    elif command -v dmenu >/dev/null 2>&1; then
        DELETE_PROMPT_CMD="dmenu -i ${DMENU_THEME_ARGS} -p 'CONFIRM Session to DELETE:'"
    fi
    DELETE_CHOICE=$(echo -e "$DELETABLE_SESSIONS" | eval "$DELETE_PROMPT_CMD" || true)

    if [ -z "$DELETE_CHOICE" ]; then
        exit 0
    fi

    CONFIRM_PROMPT_CMD=""
    if command -v rofi >/dev/null 2>&1; then
        CONFIRM_PROMPT_CMD="rofi -dmenu -i -no-custom -theme android_notification -p \"DELETE '$DELETE_CHOICE'?\""
    elif command -v dmenu >/dev/null 2>&1; then
        CONFIRM_PROMPT_CMD="dmenu -i ${DMENU_THEME_ARGS} -p \"DELETE '$DELETE_CHOICE'?\""
    fi

    # Final configuration
    CONFIRMATION=$(echo -e "No\nYes - DELETE PERMANENTLY" | eval "$CONFIRM_PROMPT_CMD" || true)

    if [ "$CONFIRMATION" = "Yes - DELETE PERMANENTLY" ]; then
        if delete_session_silently "$DELETE_CHOICE"; then
            notify_user "Qutebrowser Session Deleted" "Session '$DELETE_CHOICE' and all associated data have been permanently removed." -i trash-empty -t 5000
        else
            notify_user "Qutebrowser Delete Failed" "Failed to delete session '$DELETE_CHOICE'. Check the terminal for errors." -i dialog-error -t 5000
            exit 1
        fi
    else
        notify_user "Qutebrowser Session Delete" "Deletion of '$DELETE_CHOICE' cancelled." -i dialog-information -t 3000
    fi

else
    # --- Launch Existing Session ---
    exec "$QUTEBROWSER_WRAPPER" --restore "$SESSION_CHOICE"
fi
