#!/usr/bin/env bash

## Author  : Harshit Prashant Dhanwalkar
## Github  : @Harshit-Dhanwalkar

# Qutebrowser Session Launcher/Deleter/Renamer using rofi or dmenu.
# supports command-line arguments
# run `bash session.sh -h` or `bash session.sh --help` for more

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
NOTIFICATION_CMD="dunst" #"notify-send"

# --- Help Function ---
show_help() {
    cat <<EOF
Usage: $0 [OPTIONS]

Qutebrowser Session Manager - Launch, create, rename, or delete qutebrowser sessions.

OPTIONS:
    -s, --session NAME    Launch specific session directly (bypasses menu)
    -h, --help           Show this help message and exit

EXAMPLES:
    $0                      # Show interactive session menu
    $0 -s work              # Launch 'work' session
    $0 --session=work       # Launch 'work' session
    $0 -h                   # Show this help message

INTERACTIVE MODE:
    When no arguments are provided, shows an interactive menu with options to:
    - Create new sessions
    - Rename existing sessions  
    - Launch existing sessions
    - Delete sessions

SESSION NAMES:
    Session names are automatically sanitized (lowercase, alphanumeric + underscores)
EOF
}

# --- Menu Detection ---
if command -v rofi >/dev/null 2>&1; then
    MENU_CMD="rofi -dmenu -i -theme android_notification -theme-str 'listview { lines: 8; }' -p 'Qutebrowser Session  ' "
    PROMPT_CMD="rofi -dmenu -p 'New Session Name:' -theme android_notification"
    RENAME_PROMPT_CMD_ROFI="rofi -dmenu -p 'New Session Name:' -theme android_notification"
elif command -v dmenu >/dev/null 2>&1; then
    DMENU_THEME_ARGS="-nb '#2e3440' -nf '#d8dee9' -sb '#88c0d0' -sf '#eceff4'"
    MENU_CMD="dmenu -i ${DMENU_THEME_ARGS} -p 'Qutebrowser Session:'"
    PROMPT_CMD="dmenu ${DMENU_THEME_ARGS} -p 'New Session Name:'"
    RENAME_PROMPT_CMD_DMENU="dmenu ${DMENU_THEME_ARGS} -p 'New Session Name:'"
else
    echo "Error: Neither rofi nor dmenu found. Please install one of them." >&2
    exit 1
fi

# ---- Helper Functions ----
# --- send notifications --
notify_user() {
    if command -v "$NOTIFICATION_CMD" >/dev/null 2>&1; then
        "$NOTIFICATION_CMD" "$@"
    fi
}

# --- RENAME ---
rename_session_silently() {
    local OLD_NAME="$1"
    local NEW_NAME="$2"

    # Define XDG variables for the process
    local XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
    local XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
    local XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.var/state}"
    local XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"

    local QUTE_PROFILE_CONF_ROOT="$XDG_CONFIG_HOME/qutebrowser/profiles"

    # Define paths to move/rename
    local OLD_SESSION_DATA_DIR="$XDG_STATE_HOME/qutebrowser/$OLD_NAME"
    local OLD_SESSION_CACHE_DIR="$XDG_CACHE_HOME/qutebrowser/$OLD_NAME"
    local OLD_PROFILE_ARGS_FILE="$QUTE_PROFILE_CONF_ROOT/$OLD_NAME.args"
    local OLD_SESSION_RUNTIME_DIR="$XDG_RUNTIME_DIR/qutebrowser/$OLD_NAME"

    local NEW_SESSION_DATA_DIR="$XDG_STATE_HOME/qutebrowser/$NEW_NAME"
    local NEW_SESSION_CACHE_DIR="$XDG_CACHE_HOME/qutebrowser/$NEW_NAME"
    local NEW_PROFILE_ARGS_FILE="$QUTE_PROFILE_CONF_ROOT/$NEW_NAME.args"
    local NEW_SESSION_RUNTIME_DIR="$XDG_RUNTIME_DIR/qutebrowser/$NEW_NAME"

    # 1. Rename the state directory
    if [ -d "$OLD_SESSION_DATA_DIR" ]; then
        mv "$OLD_SESSION_DATA_DIR" "$NEW_SESSION_DATA_DIR" || return 1
    fi

    # 2. Rename the cache directory
    if [ -d "$OLD_SESSION_CACHE_DIR" ]; then
        mv "$OLD_SESSION_CACHE_DIR" "$NEW_SESSION_CACHE_DIR" || return 1
    fi

    # 3. Rename the profile args file
    if [ -f "$OLD_PROFILE_ARGS_FILE" ]; then
        mv "$OLD_PROFILE_ARGS_FILE" "$NEW_PROFILE_ARGS_FILE" || return 1
    fi

    # 4. Cleanup old runtime directory
    if [ -d "$OLD_SESSION_RUNTIME_DIR" ]; then
        rm -rf "$OLD_SESSION_RUNTIME_DIR"
    fi

    return 0
}

# --- DELETE ---
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

# --- Command Line Argument Processing ---
process_command_line() {
    local SESSION_NAME=""
    while [[ $# -gt 0 ]]; do
        case $1 in
        -s | --session)
            if [ -z "${2:-}" ] || [[ "$2" =~ ^- ]]; then
                echo "Error: -s/--session requires a session name" >&2
                exit 1
            fi
            SESSION_NAME="$2"
            shift 2
            ;;
        -s=* | --session=*)
            SESSION_NAME="${1#*=}"
            if [ -z "$SESSION_NAME" ]; then
                echo "Error: -s/--session requires a session name" >&2
                exit 1
            fi
            shift
            ;;
        -h | --help)
            show_help
            exit 0
            ;;
        *)
            echo "Error: Unknown option: $1" >&2
            echo "Use '$0 -h' for help." >&2
            exit 1
            ;;
        esac
    done
    # If session name provided, launch directly
    if [ -n "$SESSION_NAME" ]; then
        echo "🌐 Launching qutebrowser with session: $SESSION_NAME"
        exec "$QUTEBROWSER_WRAPPER" --restore "$SESSION_NAME"
    fi
}

if [ $# -gt 0 ]; then
    process_command_line "$@"
    exit 1
fi

# ---- Main Menu Logic ----
SESSIONS=""
if [ -d "$QUTE_SESSION_ROOT" ]; then
    # Filter out the 'default' session from the list
    SESSIONS=$(find "$QUTE_SESSION_ROOT" -maxdepth 1 -mindepth 1 -type d -printf '%f\n' | grep -v '^default$' | sort)
fi

OPTIONS="$NEW_SESSION_OPTION\n$RENAME_SESSION_OPTION\n\n$SESSIONS\n\n$DELETE_SESSION_OPTION"
SESSION_CHOICE=$(echo -e "$OPTIONS" | eval "$MENU_CMD")

if [ -z "$SESSION_CHOICE" ]; then
    exit 0
fi

# ---- Handle Menu Choice ----
if [ "$SESSION_CHOICE" = "$NEW_SESSION_OPTION" ]; then
    # --- New Session Logic ---
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

elif [ "$SESSION_CHOICE" = "$RENAME_SESSION_OPTION" ]; then
    # --- Rename Session Logic ---
    RENAMABLE_SESSIONS="$SESSIONS"
    if [ -z "$RENAMABLE_SESSIONS" ]; then
        notify_user "Qutebrowser Rename" "No custom sessions found to rename." -i dialog-information -t 3000
        exit 0
    fi
    # 1. Prompt user to choose session to rename
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
    # 2. Prompt for the new name
    NEW_NAME_RAW=""
    if command -v rofi >/dev/null 2>&1; then
        NEW_NAME_RAW=$(echo "$OLD_NAME" | eval "$RENAME_PROMPT_CMD_ROFI" || true)
    elif command -v dmenu >/dev/null 2>&1; then
        NEW_NAME_RAW=$(echo "$OLD_NAME" | eval "$RENAME_PROMPT_CMD_DMENU" || true)
    fi
    if [ -z "$NEW_NAME_RAW" ]; then
        notify_user "Qutebrowser Rename" "Rename cancelled." -i dialog-information -t 3000
        exit 0
    fi
    # 3. Sanitize and validate the new name
    NEW_NAME=$(echo "$NEW_NAME_RAW" | tr '[:upper:]' '[:lower:]' | tr -c '[:alnum:]_-' '_' | sed 's/_$//')
    if [ -z "$NEW_NAME" ]; then
        notify_user "Qutebrowser Rename Error" "Invalid new session name after sanitization." -i dialog-error -t 5000
        exit 1
    fi
    if [ "$OLD_NAME" = "$NEW_NAME" ]; then
        notify_user "Qutebrowser Rename" "Old and new names are the same. Rename cancelled." -i dialog-information -t 3000
        exit 0
    fi
    # 4. Execute the rename
    if rename_session_silently "$OLD_NAME" "$NEW_NAME"; then
        notify_user "Qutebrowser Session Renamed" "Session '$OLD_NAME' has been renamed to '$NEW_NAME'." -i process-completed -t 5000
    else
        notify_user "Qutebrowser Rename Failed" "Failed to rename session '$OLD_NAME'." -i dialog-error -t 5000
        exit 1
    fi
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
        DELETE_PROMPT_CMD="rofi -dmenu -i -no-custom -theme android_notification -p 'CONFIRM Session to DELETE:' -theme-str 'listview { lines: 8; }'"
    elif command -v dmenu >/dev/null 2>&1; then
        DELETE_PROMPT_CMD="dmenu -i ${DMENU_THEME_ARGS} -p 'CONFIRM Session to DELETE:' -theme-str 'listview { lines: 2; }'"
    fi
    DELETE_CHOICE=$(echo -e "$DELETABLE_SESSIONS" | eval "$DELETE_PROMPT_CMD" || true)
    if [ -z "$DELETE_CHOICE" ]; then
        exit 0
    fi
    CONFIRM_PROMPT_CMD=""
    if command -v rofi >/dev/null 2>&1; then
        CONFIRM_PROMPT_CMD="rofi -dmenu -i -no-custom -theme android_notification -p \"DELETE '$DELETE_CHOICE'?\"  -theme-str 'listview { lines: 2; }'"
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
