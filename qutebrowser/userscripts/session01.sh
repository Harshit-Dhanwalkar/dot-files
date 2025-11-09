# Working on how to rename existing session.
# [ IMPORTANT ]
#   This script renaming session does not work.

#!/bin/bash

# Qutebrowser Session Launcher/Deleter/Renamer using rofi or dmenu.

set -eu

# --- Configuration ---
XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.var/state}"
QUTE_SESSION_ROOT="$XDG_STATE_HOME/qutebrowser"

# --- Action Options ---
NEW_SESSION_OPTION="[NEW SESSION - Enter Name]"
DELETE_SESSION_OPTION="[DELETE SESSION]"
RENAME_SESSION_OPTION="[RENAME SESSION]"

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
QUTEBROWSER_WRAPPER="$SCRIPT_DIR/qutebrowser-wrapper.sh"

MENU_CMD=""
PROMPT_CMD=""
NOTIFICATION_CMD="dunst"

# --- Menu Detection ---
if command -v rofi >/dev/null 2>&1; then
    MENU_CMD="rofi -dmenu -i -theme android_notification -theme-str 'listview { lines: 8; }' -p 'Qutebrowser Session  ' "
    PROMPT_CMD="rofi -dmenu -p 'New Session Name:' -theme android_notification -theme-str 'listview { lines: 0; }'"
    RENAME_PROMPT_CMD_ROFI="rofi -dmenu -p 'Rename old Session:' -theme android_notification -theme-str 'listview { lines: 1; }'"
elif command -v dmenu >/dev/null 2>&1; then
    DMENU_THEME_ARGS="-nb '#2e3440' -nf '#d8dee9' -sb '#88c0d0' -sf '#eceff4'"
    MENU_CMD="dmenu -i ${DMENU_THEME_ARGS} -p 'Qutebrowser Session:'"
    PROMPT_CMD="dmenu ${DMENU_THEME_ARGS} -p 'New Session Name:'"
    RENAME_PROMPT_CMD_DMENU="dmenu ${DMENU_THEME_ARGS} -p 'New Session Name:'"
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

# --- RENAME Helper Function ---
rename_session_silently() {
    local OLD_NAME="$1"
    local NEW_NAME="$2"

    local XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
    local XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
    local XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.var/state}"
    local XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
    local QUTE_PROFILE_CONF_ROOT="$XDG_CONFIG_HOME/qutebrowser/profiles"

    local OLD_SESSION_DATA_DIR="$XDG_STATE_HOME/qutebrowser/$OLD_NAME"
    local OLD_SESSION_CACHE_DIR="$XDG_CACHE_HOME/qutebrowser/$OLD_NAME"
    local OLD_PROFILE_ARGS_FILE="$QUTE_PROFILE_CONF_ROOT/$OLD_NAME.args"
    local OLD_SESSION_RUNTIME_DIR="$XDG_RUNTIME_DIR/qutebrowser/$OLD_NAME"

    local NEW_SESSION_DATA_DIR="$XDG_STATE_HOME/qutebrowser/$NEW_NAME"
    local NEW_SESSION_CACHE_DIR="$XDG_CACHE_HOME/qutebrowser/$NEW_NAME"
    local NEW_PROFILE_ARGS_FILE="$QUTE_PROFILE_CONF_ROOT/$NEW_NAME.args"

    if [ -d "$OLD_SESSION_DATA_DIR" ]; then
        mv "$OLD_SESSION_DATA_DIR" "$NEW_SESSION_DATA_DIR" || return 1
    fi

    if [ -d "$OLD_SESSION_CACHE_DIR" ]; then
        mv "$OLD_SESSION_CACHE_DIR" "$NEW_SESSION_CACHE_DIR" || return 1
    fi

    if [ -f "$OLD_PROFILE_ARGS_FILE" ]; then
        mv "$OLD_PROFILE_ARGS_FILE" "$NEW_PROFILE_ARGS_FILE" || return 1
    fi

    if [ -d "$OLD_SESSION_RUNTIME_DIR" ]; then
        rm -rf "$OLD_SESSION_RUNTIME_DIR"
    fi

    return 0
}

delete_session_silently() {
    local SESSION_NAME="$1"

    local XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
    local XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
    local XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.var/state}"
    local XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"

    local QUTE_PROFILE_CONF_ROOT="$XDG_CONFIG_HOME/qutebrowser/profiles"
    local SESSION_DATA_DIR="$XDG_STATE_HOME/qutebrowser/$SESSION_NAME"
    local SESSION_CACHE_DIR="$XDG_CACHE_HOME/qutebrowser/$SESSION_NAME"
    local SESSION_RUNTIME_DIR="$XDG_RUNTIME_DIR/qutebrowser/$SESSION_NAME"
    local PROFILE_ARGS_FILE="$QUTE_PROFILE_CONF_ROOT/$SESSION_NAME.args"

    rm -rf "$SESSION_DATA_DIR"
    rm -rf "$SESSION_CACHE_DIR"
    rm -f "$PROFILE_ARGS_FILE"
    rm -rf "$SESSION_RUNTIME_DIR"
    return 0
}

# --- Main Menu Logic ---
SESSIONS_RAW=""
# Get all session names (excluding 'default') separated by newlines
if [ -d "$QUTE_SESSION_ROOT" ]; then
    SESSIONS_RAW=$(find "$QUTE_SESSION_ROOT" -maxdepth 1 -mindepth 1 -type d -printf '%f\n' | grep -v '^default$' | sort)
fi

INDEX_NUMBER=1
SESSIONS_OPTIONS="" # Initialise array for containing the numbered list for the menu (e.g., "1. session_a\n2. session_b")
SESSIONS_MAP=""     # Will contain the mapping for lookup (e.g., "1;session_a\n2;session_b")

# Loop through each session name and build the options list with numbers
while IFS= read -r SESSION_NAME; do
    if [ -n "$SESSION_NAME" ]; then
        SESSIONS_OPTIONS+="${INDEX_NUMBER}. ${SESSION_NAME}\n"
        SESSIONS_MAP+="${INDEX_NUMBER};${SESSION_NAME}\n"
        ((INDEX_NUMBER++))
    fi
done <<<"$SESSIONS_RAW"

OPTIONS="$NEW_SESSION_OPTION\n$RENAME_SESSION_OPTION\n$DELETE_SESSION_OPTION\n\n$SESSIONS_OPTIONS"
SESSION_CHOICE=$(echo -e "$OPTIONS" | eval "$MENU_CMD")

if [ -z "$SESSION_CHOICE" ]; then
    exit 0
fi

# --- Handle Menu Choice ---
# Check 1: Check if the choice starts with a number
if [[ "$SESSION_CHOICE" =~ ^[0-9]+\. ]]; then
    # Extract the number from the user's selection
    SELECTED_INDEX=$(echo "$SESSION_CHOICE" | grep -oE '^[0-9]+')

    # Lookup the original session name using the index map
    SESSION_NAME=$(echo -e "$SESSIONS_MAP" | grep "^${SELECTED_INDEX};" | cut -d';' -f2 | head -n 1)

    if [ -n "$SESSION_NAME" ]; then
        # Launch existing session
        exec "$QUTEBROWSER_WRAPPER" --restore "$SESSION_NAME"
    else
        notify_user "Qutebrowser Session Error" "Failed to map session number to name." -i dialog-error -t 5000
        exit 1
    fi

# Check 2: New Session
elif [ "$SESSION_CHOICE" = "$NEW_SESSION_OPTION" ]; then
    NEW_NAME=$(eval "$PROMPT_CMD")
    if [ -z "$NEW_NAME" ]; then
        exit 0 # Canceled
    fi
    SESSION_NAME=$(echo "$NEW_NAME" | tr '[:upper:]' '[:lower:]' | tr -c '[:alnum:]_-' '_' | sed 's/_$//')
    if [ -z "$SESSION_NAME" ]; then
        notify_user "Qutebrowser Session Error" "Invalid session name after sanitization." -i dialog-error -t 5000
        exit 1
    fi
    exec "$QUTEBROWSER_WRAPPER" --restore "$SESSION_NAME"

# Check 3: Rename Session
elif [ "$SESSION_CHOICE" = "$RENAME_SESSION_OPTION" ]; then
    # Use the raw list of sessions for this prompt
    RENAMABLE_SESSIONS="$SESSIONS_RAW"
    if [ -z "$RENAMABLE_SESSIONS" ]; then
        notify_user "Qutebrowser Rename" "No custom sessions found to rename." -i dialog-information -t 3000
        exit 0
    fi
    # Prompt user to choose session to rename
    RENAME_CHOICE_CMD=""
    if command -v rofi >/dev/null 2>&1; then
        RENAME_CHOICE_CMD="rofi -dmenu -i -no-custom -theme android_notification -p 'Session to RENAME:' -theme-str 'listview { lines: 8; }'"
    elif command -v dmenu >/dev/null 2>&1; then
        RENAME_CHOICE_CMD="dmenu -i ${DMENU_THEME_ARGS} -p 'Session to RENAME:'"
    fi
    OLD_NAME=$(echo -e "$RENAMABLE_SESSIONS" | eval "$RENAME_CHOICE_CMD" || true)
    if [ -z "$OLD_NAME" ]; then
        exit 0
    fi
    # Prompt for the new name
    NEW_NAME_RAW=""
    if command -v rofi >/dev/null 2>&1; then
        RENAME_NEW_PROMPT_ROFI="${RENAME_NEW_NAME_PROMPT_ROFI_BASE}'$OLD_NAME:'"
        NEW_NAME_RAW=$(eval "$RENAME_NEW_PROMPT_ROFI" || true)
    elif command -v dmenu >/dev/null 2>&1; then
        NEW_NAME_RAW=$(echo "$OLD_NAME" | eval "$RENAME_NEW_NAME_PROMPT_DMENU" || true)
    fi
    if [ -z "$NEW_NAME_RAW" ]; then
        notify_user "Qutebrowser Rename" "Rename cancelled." -i dialog-information -t 3000
        exit 0
    fi
    # Sanitize and validate the new name
    NEW_NAME=$(echo "$NEW_NAME_RAW" | tr '[:upper:]' '[:lower:]' | tr -c '[:alnum:]_-' '_' | sed 's/_$//')
    if [ -z "$NEW_NAME" ]; then
        notify_user "Qutebrowser Rename Error" "Invalid new session name after sanitization." -i dialog-error -t 5000
        exit 1
    fi
    if [ "$OLD_NAME" = "$NEW_NAME" ]; then
        notify_user "Qutebrowser Rename" "Old and new names are the same. Rename cancelled." -i dialog-information -t 3000
        exit 0
    fi
    # Execute the rename
    if rename_session_silently "$OLD_NAME" "$NEW_NAME"; then
        notify_user "Qutebrowser Session Renamed" "Session '$OLD_NAME' has been renamed to '$NEW_NAME'." -i process-completed -t 5000
    else
        notify_user "Qutebrowser Rename Failed" "Failed to rename session '$OLD_NAME'. Is Qutebrowser currently running with this session?" -i dialog-error -t 5000
        exit 1
    fi

# Check 4: Delete Session
elif [ "$SESSION_CHOICE" = "$DELETE_SESSION_OPTION" ]; then
    DELETABLE_SESSIONS="$SESSIONS_RAW"
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
        CONFIRM_PROMPT_CMD="rofi -dmenu -i -no-custom -theme android_notification -p \"DELETE '$DELETE_CHOICE'?\" -theme-str 'listview { lines: 3; }'"
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
fi
