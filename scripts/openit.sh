#!/usr/bin/env bash

## Author  : Harshit Prahant Dhanwalkar
## Github  : @Harshit-Dhanwalkar

INPUT_FILE="$1"
MAX_VISIBLE_LINES=15

DMENU_CMD="rofi -dmenu -i -theme android_notification"
SESSION_SCRIPT="$HOME/.config/qutebrowser/userscripts/session.sh"

# --- Supported File Types ---
SUPPORTED_EXTENSIONS=("md" "txt" "html" "htm" "pdf" "json" "csv")
SUPPORTED_MIME_TYPES=("text/markdown" "text/plain" "text/html" "application/pdf" "application/json" "text/csv")

# --- Line Calculation ---
calculate_lines() {
    local items="$1"
    local item_count=$(echo "$items" | wc -l)

    # If no items, show at least 1 line
    if [[ $item_count -eq 0 ]]; then
        echo 1
    # If items are less than or equal to max visible lines, show exact count
    elif [[ $item_count -le $MAX_VISIBLE_LINES ]]; then
        echo $item_count
    # If items exceed max visible lines, show max and enable scrolling
    else
        echo $MAX_VISIBLE_LINES
    fi
}

# --- Index Numbers ---
add_index_numbers() {
    local items="$1"
    local count=1
    while IFS= read -r line; do
        if [[ -n "$line" ]]; then
            printf "%2d. %s\n" "$count" "$line"
            ((count++))
        fi
    done <<<"$items"
}

remove_index_numbers() {
    sed 's/^[[:space:]]*[0-9]\+\. //'
}

# --- Browser Detection ---
detect_browser() {
    # Primary browser with session support
    if command -v qutebrowser >/dev/null 2>&1; then
        echo "qutebrowser"
        return 0
    fi

    # Fallback browsers
    local fallback_browsers=("firefox" "chromium" "google-chrome" "brave-browser" "edge" "vivaldi")

    for browser in "${fallback_browsers[@]}"; do
        if command -v "$browser" >/dev/null 2>&1; then
            echo "$browser"
            echo "  qutebrowser not found, using $browser instead" >&2
            return 0
        fi
    done

    # Last resort: use xdg-open
    if command -v xdg-open >/dev/null 2>&1; then
        echo "xdg-open"
        echo "  No dedicated browser found, using xdg-open" >&2
        return 0
    fi

    return 1
}

BROWSER=$(detect_browser)
if [[ $? -ne 0 ]]; then
    echo " Error: No browser found on system. Please install a browser." >&2
    exit 1
fi

# Check if we can use session features
CAN_USE_SESSIONS=false
if [[ "$BROWSER" == "qutebrowser" ]] && [[ -f "$SESSION_SCRIPT" ]]; then
    CAN_USE_SESSIONS=true
fi

# --- Session Management ---
get_available_sessions() {
    # Only available for qutebrowser with session script
    if [[ "$CAN_USE_SESSIONS" != "true" ]]; then
        echo ""
        return
    fi

    local XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.var/state}"
    local QUTE_SESSION_ROOT="$XDG_STATE_HOME/qutebrowser"

    if [ -d "$QUTE_SESSION_ROOT" ]; then
        find "$QUTE_SESSION_ROOT" -maxdepth 1 -mindepth 1 -type d -printf '%f\n' | grep -v '^default$' | sort
    else
        echo ""
    fi
}

select_session() {
    # If not using qutebrowser sessions, return immediately
    if [[ "$CAN_USE_SESSIONS" != "true" ]]; then
        echo "default"
        return
    fi

    local SESSIONS=$(get_available_sessions)
    local SESSION_OPTIONS=""

    if [ -n "$SESSIONS" ]; then
        SESSION_OPTIONS="$SESSIONS"
    else
        SESSION_OPTIONS="default"
    fi

    # Add "New Session" option
    SESSION_OPTIONS="[NEW SESSION]\n$SESSION_OPTIONS"

    local indexed_options=$(add_index_numbers "$(echo -e "$SESSION_OPTIONS")")
    local line_count=$(calculate_lines "$(echo -e "$SESSION_OPTIONS")")

    local selected=$(echo -e "$indexed_options" | $DMENU_CMD -l $line_count -p "Choose Session:")

    # Remove index number and return the actual selection
    if [[ -n "$selected" ]]; then
        echo "$selected" | remove_index_numbers
    else
        echo ""
    fi
}

create_new_session() {
    # If not using qutebrowser sessions, return default
    if [[ "$CAN_USE_SESSIONS" != "true" ]]; then
        echo "default"
        return
    fi

    local NEW_NAME=$(echo "" | $DMENU_CMD -p "Enter New Session Name:")
    if [ -z "$NEW_NAME" ]; then
        echo "default"
        return
    fi

    local SESSION_NAME=$(echo "$NEW_NAME" | tr '[:upper:]' '[:lower:]' | tr -c '[:alnum:]_-' '_' | sed 's/_$//')
    if [ -z "$SESSION_NAME" ]; then
        echo "default"
        return
    fi
    echo "$SESSION_NAME"
}

# --- File Type Detection ---
get_file_type() {
    local file="$1"
    local extension="${file##*.}"
    local mime_type=""

    if command -v file >/dev/null 2>&1; then
        mime_type=$(file -b --mime-type "$file" 2>/dev/null)
    fi

    echo "$extension|$mime_type"
}

is_supported_file() {
    local file="$1"

    if [[ ! -f "$file" ]]; then
        return 1
    fi

    local file_info=$(get_file_type "$file")
    local extension="${file_info%|*}"
    local mime_type="${file_info#*|}"

    # Check by extension
    for ext in "${SUPPORTED_EXTENSIONS[@]}"; do
        if [[ "${extension,,}" == "$ext" ]]; then
            return 0
        fi
    done

    # Check by MIME type
    for mime in "${SUPPORTED_MIME_TYPES[@]}"; do
        if [[ "$mime_type" == "$mime" ]]; then
            return 0
        fi
    done

    return 1
}

# --- Link Extraction Functions ---
extract_from_markdown() {
    local file="$1"
    awk '
        /^# /{
            category = $0;
            sub(/^#+/, "", category);
            gsub(/^[ \t]+|[ \t]+$/, "", category);
            next
        }
        /http(s)?:\/\// {
            if (match($0, /\((http(s)?:\/\/[^)]+)\)/, a)) {
                print category ": " a[1]
            } else if (match($0, /(http(s)?:\/\/[^ \t]*)/, a)) {
                print category ": " a[1]
            }
        }
    ' "$file"
}

extract_from_text() {
    local file="$1"
    awk '
        /^# / || /^## / || /^### / {
            category = $0;
            sub(/^#+/, "", category);
            gsub(/^[ \t]+|[ \t]+$/, "", category);
            next
        }
        /http(s)?:\/\// {
            if (match($0, /(http(s)?:\/\/[^ \t]*)/, a)) {
                print category ": " a[1]
            }
        }
    ' "$file"
}

extract_from_html() {
    local file="$1"
    grep -o -E 'href="https?://[^"]*"' "$file" | sed 's/href="//;s/"$//' | awk '{print "HTML Links: " $0}'
}

extract_from_pdf() {
    local file="$1"
    if command -v pdftotext >/dev/null 2>&1; then
        pdftotext "$file" - | grep -o -E 'https?://[^[:space:]]+' | awk '{print "PDF Links: " $0}'
    else
        echo "Error: pdftotext not installed. Please install poppler-utils." >&2
        return 1
    fi
}

extract_links() {
    local file="$1"
    local file_info=$(get_file_type "$file")
    local extension="${file_info%|*}"
    local mime_type="${file_info#*|}"

    case "${extension,,}" in
    md)
        extract_from_markdown "$file"
        ;;
    txt)
        extract_from_text "$file"
        ;;
    html | htm)
        extract_from_html "$file"
        ;;
    pdf)
        extract_from_pdf "$file"
        ;;
    *)
        # Fallback to text extraction for unknown types
        if [[ "$mime_type" == text/* ]]; then
            extract_from_text "$file"
        else
            echo "Unsupported file type: $extension ($mime_type)" >&2
            return 1
        fi
        ;;
    esac
}

# --- Usage Help ---
show_help() {
    cat <<EOF
Usage: $0 FILE [OPTIONS]

Open URLs from various file types in browser sessions.

ARGUMENTS:
    FILE              Path to file containing URLs

SUPPORTED FILE TYPES:
    - Markdown (.md)      - Extract links from markdown format
    - Text files (.txt)   - Extract links from plain text
    - HTML (.html, .htm)  - Extract links from HTML href attributes  
    - PDF (.pdf)          - Extract links from PDF documents
    - JSON (.json)        - Extract URLs from JSON strings
    - CSV (.csv)          - Extract URLs from CSV files

OPTIONS:
    -h, --help          Show this help message
    -s, --session       Pre-select session (qutebrowser only)

EXAMPLES:
    $0 notes.md                    # Interactive session selection
    $0 links.txt -s work           # Open links in 'work' session (qutebrowser only)
    $0 document.pdf --session=research
    $0 webpage.html -s personal

BROWSER SUPPORT:
    Primary: qutebrowser (with session support)
    Fallback: firefox, chromium, google-chrome, brave, edge, vivaldi
    Final fallback: xdg-open

FEATURES:
    - Extract URLs from multiple file formats
    - Choose which browser session to open each link in (qutebrowser only)
    - Create new sessions on the fly (qutebrowser only)
    - Automatic browser fallback
    - Supports both existing and new sessions
    - Numbered options for easy selection
EOF
}

# --- Launch URL in Session ---
launch_url_in_session() {
    local url="$1"
    local session="$2"

    echo " Opening URL: $url"

    if [[ "$CAN_USE_SESSIONS" == "true" ]]; then
        echo " Using session: $session"

        if [[ "$session" == "default" ]]; then
            # Open in default session
            $BROWSER "$url" &
        else
            # Use the session script with URL support
            "$SESSION_SCRIPT" -s "$session" -u "$url" &
        fi
    else
        # For non-qutebrowser browsers, just open the URL
        echo " Using browser: $BROWSER"
        if [[ "$BROWSER" == "xdg-open" ]]; then
            xdg-open "$url" &
        else
            $BROWSER "$url" &
        fi
    fi
}

# --- Command Line Argument Processing ---
process_arguments() {
    local PRESELECTED_SESSION=""

    while [[ $# -gt 0 ]]; do
        case $1 in
        -h | --help)
            show_help
            exit 0
            ;;
        -s | --session)
            if [[ "$CAN_USE_SESSIONS" != "true" ]]; then
                echo "  Session option ignored: Only available with qutebrowser" >&2
                shift 2
                continue
            fi
            if [ -z "${2:-}" ] || [[ "$2" =~ ^- ]]; then
                echo "Error: -s/--session requires a session name" >&2
                exit 1
            fi
            PRESELECTED_SESSION="$2"
            shift 2
            ;;
        -s=* | --session=*)
            if [[ "$CAN_USE_SESSIONS" != "true" ]]; then
                echo "  Session option ignored: Only available with qutebrowser" >&2
                shift
                continue
            fi
            PRESELECTED_SESSION="${1#*=}"
            if [ -z "$PRESELECTED_SESSION" ]; then
                echo "Error: -s/--session requires a session name" >&2
                exit 1
            fi
            shift
            ;;
        -*)
            echo "Error: Unknown option: $1" >&2
            echo "Use '$0 -h' for help." >&2
            exit 1
            ;;
        *)
            # file should be the input file, already handled
            shift
            ;;
        esac
    done
    echo "$PRESELECTED_SESSION"
}

# --- Check if no arguments provided ---
if [[ $# -eq 0 ]]; then
    echo "Error: No arguments provided." >&2
    echo >&2
    show_help >&2
    exit 1
fi

# --- Main Script ---
if [[ -z "$INPUT_FILE" ]]; then
    echo "Error: Please provide a file path as the first argument." >&2
    echo "Usage: $0 /path/to/file" >&2
    exit 1
fi

if [[ ! -f "$INPUT_FILE" ]]; then
    echo "Error: File '$INPUT_FILE' does not exist." >&2
    exit 1
fi

# Check if file is supported
if ! is_supported_file "$INPUT_FILE"; then
    echo "Error: Unsupported file type or format." >&2
    echo "Supported types: ${SUPPORTED_EXTENSIONS[*]}" >&2
    exit 1
fi

# Show browser info
echo " Detected browser: $BROWSER"
if [[ "$CAN_USE_SESSIONS" == "true" ]]; then
    echo " Session support: Available"
else
    echo " Session support: Not available (qutebrowser required)"
fi

# Process command line arguments for session pre-selection
PRESELECTED_SESSION=$(process_arguments "$@")

# If session is pre-selected, validate it exists or use default
if [[ -n "$PRESELECTED_SESSION" ]] && [[ "$CAN_USE_SESSIONS" == "true" ]]; then
    if [[ "$PRESELECTED_SESSION" != "default" ]]; then
        SESSIONS=$(get_available_sessions)
        if ! echo "$SESSIONS" | grep -q "^$PRESELECTED_SESSION$"; then
            echo "  Session '$PRESELECTED_SESSION' not found. Will create when first link is opened."
        fi
    fi
    echo " Using pre-selected session: $PRESELECTED_SESSION"
elif [[ -n "$PRESELECTED_SESSION" ]] && [[ "$CAN_USE_SESSIONS" != "true" ]]; then
    echo "  Session selection ignored: $PRESELECTED_SESSION"
    PRESELECTED_SESSION=""
fi

# Show file info
file_info=$(get_file_type "$INPUT_FILE")
extension="${file_info%|*}"
mime_type="${file_info#*|}"
echo " Processing file: $INPUT_FILE"
echo " Type: $extension ($mime_type)"

while true; do
    ALL_LINKS=$(extract_links "$INPUT_FILE")

    if [[ -z "$ALL_LINKS" ]]; then
        echo " No URLs found in the file."
        exit 1
    fi

    CATEGORIES=$(echo "$ALL_LINKS" | cut -d ':' -f 1 | sort -u)
    CATEGORY_LINES=$(calculate_lines "$CATEGORIES")

    INDEXED_CATEGORIES=$(add_index_numbers "$CATEGORIES")

    SELECTED_CATEGORY_WITH_INDEX=$(echo "$INDEXED_CATEGORIES" | $DMENU_CMD -l $CATEGORY_LINES -p "Select Category (ESC to Quit):")

    if [[ -z "$SELECTED_CATEGORY_WITH_INDEX" ]]; then
        echo " Script terminated by user."
        break
    fi

    SELECTED_CATEGORY=$(echo "$SELECTED_CATEGORY_WITH_INDEX" | remove_index_numbers)

    CATEGORY_URLS=$(echo "$ALL_LINKS" | grep "^${SELECTED_CATEGORY}:" | sed "s/^${SELECTED_CATEGORY}:[ \t]*//")
    URL_LINES=$(calculate_lines "$CATEGORY_URLS")

    INDEXED_URLS=$(add_index_numbers "$CATEGORY_URLS")

    SELECTED_URL_WITH_INDEX=$(echo "$INDEXED_URLS" | $DMENU_CMD -l $URL_LINES -p "URLs in $SELECTED_CATEGORY (ESC to go back):")

    if [[ -z "$SELECTED_URL_WITH_INDEX" ]]; then
        echo " Returning to category selection."
        continue
    fi

    SELECTED_URL=$(echo "$SELECTED_URL_WITH_INDEX" | remove_index_numbers)

    SESSION_NAME=""
    if [[ -n "$PRESELECTED_SESSION" ]] && [[ "$CAN_USE_SESSIONS" == "true" ]]; then
        SESSION_NAME="$PRESELECTED_SESSION"
    elif [[ "$CAN_USE_SESSIONS" == "true" ]]; then
        SELECTED_SESSION_OPTION=$(select_session)
        if [[ -z "$SELECTED_SESSION_OPTION" ]]; then
            echo " Returning to category selection."
            continue
        fi
        if [[ "$SELECTED_SESSION_OPTION" == "[NEW SESSION]" ]]; then
            SESSION_NAME=$(create_new_session)
        else
            SESSION_NAME="$SELECTED_SESSION_OPTION"
        fi
    else
        SESSION_NAME="default"
    fi

    if [[ -z "$SESSION_NAME" ]]; then
        SESSION_NAME="default"
    fi

    launch_url_in_session "$SELECTED_URL" "$SESSION_NAME"

    echo " URL opened in session: $SESSION_NAME"

    # Exit rofi after opening the link
    break
done

exit 0
