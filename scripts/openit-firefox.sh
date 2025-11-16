#!/usr/bin/env bash

## Author  : Harshit Prashant Dhanwalkar
## Github  : @Harshit-Dhanwalkar

INPUT_FILE="$1"
MAX_VISIBLE_LINES=10

DMENU_CMD="dmenu"
# DMENU_CMD="rofi -dmenu
# DMENU_CMD="rofi -dmenu -theme $HOME/.config/rofi/dracula.rasi"

BROWSER="firefox"

# --- Help Function ---
show_help() {
    cat << EOF
Usage: $0 [OPTIONS] FILE

Extract and organize URLs from markdown files into a hierarchical menu.

OPTIONS:
    -h, --help    Show this help message

EXAMPLES:
    $0 todo-links.md
    $0 --help
    $0 -h

SUPPORTED FILE TYPES:
    - Markdown (.md)
    - Text (.txt)
    - HTML (.html, .htm)
    - PDF (.pdf) - requires pdftotext

FEATURES:
    - Hierarchical navigation based on markdown headings
EOF
}

# Check for help flags
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_help
    exit 0
fi

# --- Dependency Checks ---
check_dependency() {
    command -v "$1" >/dev/null 2>&1 || {
        echo "Error: '$1' is not installed. Please install it to proceed." >&2
        return 1
    }
    return 0
}

# Check dependencies
if [[ "$DMENU_CMD" == "rofi -dmenu" ]]; then
    check_dependency "rofi" || exit 1
else
    check_dependency "dmenu" || exit 1
fi

DEPENDENCIES=(awk grep sed "$BROWSER")
for dep in "${DEPENDENCIES[@]}"; do
    check_dependency "$dep" || exit 1
done

# --- Helpers ---
calculate_lines() {
    local items="$1"
    local count=$(echo "$items" | wc -l)
    if [ "$count" -eq 0 ]; then echo 1
    elif [ "$count" -le "$MAX_VISIBLE_LINES" ]; then echo "$count"
    else echo "$MAX_VISIBLE_LINES"
    fi
}

add_index_numbers() {
    local count=1
    while IFS= read -r line; do
        clean_line=$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        [[ -z "$clean_line" ]] && continue
        case "$clean_line" in
            "󰁍 Back"|"󰅖 Exit")
                printf "%s\n" "$clean_line"
                ;;
            *)
                printf "%2d. %s\n" "$count" "$clean_line"
                count=$((count+1))
                ;;
        esac
    done <<< "$1"
}

remove_index_numbers() {
    sed 's/^[[:space:]]*[0-9]\+\. //'
}

# --- Icon Functions ---
append_category_icon() {
    local category="$1"
    echo "󰉋  $category"
}

append_url_icon() {
    local url="$1"
    case "$url" in
        *github.com*)               echo "  $url" ;;
        *gitlab.com*)               echo "  $url" ;;
        *youtube.com*|*youtu.be*)   echo "  $url" ;;
        *reddit.com*)               echo "  $url" ;;
        *wikipedia.org*)            echo "󰖬  $url" ;;
        *stackoverflow.com*)        echo "  $url" ;;
        *stackexchange.com*)        echo "  $url" ;;
        *archlinux.org*)            echo "  $url" ;;
        *debian.org*)               echo "  $url" ;;
        *ubuntu.com*)               echo "  $url" ;;
        *fedora.org*)               echo "  $url" ;;
        *twitter.com*|*x.com*)      echo "  $url" ;;
        *discord.com*|*discord.gg*) echo "  $url" ;;
        *linkedin.com*)             echo "  $url" ;;
        *google.com*)               echo "  $url" ;;
        https://*|http://*)         echo "󰌷  $url" ;;
        *)                          echo "$url" ;;
    esac
}

# --- URL Extraction ---
extract_from_markdown() {
    awk '
    BEGIN {
        current_section = "Uncategorized"
        delete headings
        headings[0] = "Uncategorized"
        max_level = 0
    }

    /^#/ {
        level = 0
        while (substr($0, level+1, 1) == "#") {
            level++
        }

        heading_text = substr($0, level+1)
        gsub(/^[[:space:]]+|[[:space:]]+$/, "", heading_text)

        headings[level-1] = heading_text
        max_level = level

        for (i = level; i < 6; i++) {
            delete headings[i]
        }

        current_section = ""
        for (i = 0; i < max_level; i++) {
            if (i in headings) {
                if (current_section != "") current_section = current_section " > "
                current_section = current_section headings[i]
            }
        }
        next
    }

    /https?:\/\// {
        line = $0
        while (match(line, /https?:\/\/[^[:space:]]+/)) {
            url = substr(line, RSTART, RLENGTH)
            gsub(/[.,;:!?)]+$/, "", url)
            if (url ~ /^https?:\/\//) {
                print current_section ": " url
            }
            line = substr(line, RSTART + RLENGTH)
        }
    }' "$1"
}

# --- Launch URL ---
launch_url() {
    local url="$1"
    $BROWSER "$url" >/dev/null 2>&1 &
}

# --- Main ---
if [ -z "$INPUT_FILE" ] || [ ! -f "$INPUT_FILE" ]; then
    echo "Error: No input file provided or file does not exist." >&2
    echo >&2
    show_help
    exit 1
fi

# Check if file is supported
file_ext="${INPUT_FILE##*.}"
supported_extensions=("md" "txt" "html" "htm" "pdf")
if [[ ! " ${supported_extensions[@]} " =~ " ${file_ext,,} " ]]; then
    echo "Error: Unsupported file type '$file_ext'. Supported types: ${supported_extensions[*]}" >&2
    exit 1
fi

# Extract links
ALL_LINKS=$(extract_from_markdown "$INPUT_FILE")

# Check if we found any links
if [ -z "$ALL_LINKS" ] || [ "$(echo "$ALL_LINKS" | grep -c .)" -eq 0 ]; then
    echo "No URLs found in the file." >&2
    exit 1
fi

# Remove duplicates while preserving order
ALL_LINKS=$(echo "$ALL_LINKS" | awk '!seen[$0]++')

# --- Main Menu Loop ---
CURRENT_PATH=""
while true; do
    if [ -z "$CURRENT_PATH" ]; then
        # Root level - show only top-level categories
        CATEGORIES=$(echo "$ALL_LINKS" | awk -F': ' '{print $1}' | awk -F' > ' '{if ($1 != "Uncategorized") print $1}' | sort -u)

        # Build menu with icons
        MENU_ITEMS="󰅖 Exit"
        MENU_ITEMS+=$'\n'"󰈙  Uncategorized"
        while IFS= read -r category; do
            MENU_ITEMS+=$'\n'"$(append_category_icon "$category")"
        done <<< "$CATEGORIES"

        PROMPT="Main Category:"

        # Show menu and get selection
        SELECTION=$(
            add_index_numbers "$MENU_ITEMS" |
            $DMENU_CMD -l $(calculate_lines "$MENU_ITEMS") -p "$PROMPT" |
            remove_index_numbers
        )

        # Handle selection
        [[ -z "$SELECTION" ]] && exit 0

        case "$SELECTION" in
            "󰅖 Exit") exit 0 ;;
            "󰈙  Uncategorized") CURRENT_PATH="Uncategorized" ;;
            *)
                # Remove icon and navigate to category
                CLEAN_SELECTION=$(echo "$SELECTION" | sed 's/^[^ ]*  //')
                CURRENT_PATH="$CLEAN_SELECTION"
                ;;
        esac

    else
        # Sub-level - show items under current path

        # Get all items under current path (both subcategories and direct links)
        ALL_UNDER_CURRENT=$(echo "$ALL_LINKS" | awk -F': ' -v path="$CURRENT_PATH" '
            $1 == path {
                # Direct links under current path
                print "LINK: " $2
            }
            $1 != path && $1 ~ "^" path " > " {
                # Extract the immediate next part after current path
                rest = substr($1, length(path) + 4)
                if (index(rest, " > ") > 0) {
                    # More sublevels exist
                    split(rest, parts, " > ")
                    print "CATEGORY: " parts[1]
                } else {
                    # This is a leaf category
                    print "LEAF: " rest
                }
            }' | sort -u)

        # Build menu with icons
        MENU_ITEMS="󰁍 Back"

        # Process all items
        while IFS= read -r item; do
            if [[ "$item" == "CATEGORY: "* ]]; then
                # Subcategory with further nesting
                category="${item#CATEGORY: }"
                MENU_ITEMS+=$'\n'"$(append_category_icon "$category")"
            elif [[ "$item" == "LEAF: "* ]]; then
                # Leaf category
                category="${item#LEAF: }"
                MENU_ITEMS+=$'\n'"󰈙  $category"
            elif [[ "$item" == "LINK: "* ]]; then
                # Direct URL
                url="${item#LINK: }"
                MENU_ITEMS+=$'\n'"$(append_url_icon "$url")"
            fi
        done <<< "$ALL_UNDER_CURRENT"

        PROMPT="$CURRENT_PATH:"

        # Show menu and get selection
        SELECTION=$(
            add_index_numbers "$MENU_ITEMS" |
            $DMENU_CMD -l $(calculate_lines "$MENU_ITEMS") -p "$PROMPT" |
            remove_index_numbers
        )

        # Handle selection
        [[ -z "$SELECTION" ]] && exit 0

        case "$SELECTION" in
            "󰁍 Back")
                if [[ "$CURRENT_PATH" == *" > "* ]]; then
                    CURRENT_PATH="${CURRENT_PATH% > *}"
                else
                    CURRENT_PATH=""
                fi
                ;;
            *)
                # Remove icon to get clean name
                CLEAN_SELECTION=$(echo "$SELECTION" | sed 's/^[^ ]*  //')

                # Check if it's a URL
                if [[ "$CLEAN_SELECTION" =~ ^https?:// ]]; then
                    launch_url "$CLEAN_SELECTION"
                else
                    # It's a category - navigate to it
                    CURRENT_PATH="$CURRENT_PATH > $CLEAN_SELECTION"
                fi
                ;;
        esac
    fi
done
