#!/usr/bin/env bash

## Author  : Harshit Prashant Dhanwalkar
## Github  : @Harshit-Dhanwalkar

INPUT_FILE="$1"
MAX_VISIBLE_LINES=15
DMENU_CMD="dmenu"
BROWSER="firefox"

SUPPORTED_EXTENSIONS=("md" "txt" "html" "htm" "pdf")
SUPPORTED_MIME_TYPES=("text/markdown" "text/plain" "text/html" "application/pdf")

# --- Dependency Checks ---
check_dependency() {
    command -v "$1" >/dev/null 2>&1 || {
        echo "Error: '$1' is not installed. Please install it to proceed." >&2
        return 1
    }
    return 0
}

DEPENDENCIES=(awk grep sed "$DMENU_CMD" "$BROWSER")
for dep in "${DEPENDENCIES[@]}"; do
    check_dependency "$dep" || exit 1
done

# --- PDF optional ---
PDF_AVAILABLE=true
if ! command -v pdftotext >/dev/null 2>&1; then
    PDF_AVAILABLE=false
fi

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
        [ -n "$line" ] && printf "%2d. %s\n" "$count" "$line" && count=$((count+1))
    done <<<"$1"
}

remove_index_numbers() {
    sed 's/^[[:space:]]*[0-9]\+\. //'
}

get_file_type() {
    local file="$1"
    local ext="${file##*.}"
    local mime=""
    if command -v file >/dev/null 2>&1; then
        mime=$(file -b --mime-type "$file" 2>/dev/null)
    fi
    echo "$ext|$mime"
}

is_supported_file() {
    local file="$1"
    [ ! -f "$file" ] && return 1
    local info=$(get_file_type "$file")
    local ext="${info%|*}"
    local mime="${info#*|}"
    for e in "${SUPPORTED_EXTENSIONS[@]}"; do [[ "${ext,,}" = "$e" ]] && return 0; done
    for m in "${SUPPORTED_MIME_TYPES[@]}"; do [[ "$mime" = "$m" ]] && return 0; done
    return 1
}

# --- URL Extraction ---
extract_from_markdown() {
    awk '
    /^#/ { c=$0; sub(/^#+/, "", c); gsub(/^[ \t]+|[ \t]+$/, "", c); next }
    /http[s]?:\/\// {
        m = match($0, /(http[s]?:\/\/[^ )]+)/)
        if (m) { print c ": " substr($0, RSTART, RLENGTH) }
    }' "$1"
}

extract_from_text() {
    awk '
    /^#/ { c=$0; sub(/^#+/, "", c); gsub(/^[ \t]+|[ \t]+$/, "", c); next }
    /http[s]?:\/\// {
        m = match($0, /(http[s]?:\/\/[^ \t]+)/)
        if (m) { print c ": " substr($0, RSTART, RLENGTH) }
    }' "$1"
}

extract_from_html() {
    grep -o -E 'href="https?://[^"]*"' "$1" | sed 's/href="//;s/"$//' | awk '{print "HTML Links: " $0}'
}

extract_from_pdf() {
    if [ "$PDF_AVAILABLE" = false ]; then
        echo "Warning: pdftotext not installed. Skipping PDF link extraction." >&2
        return
    fi
    pdftotext "$1" - 2>/dev/null | grep -o -E 'https?://[^[:space:]]+' | awk '{print "PDF Links: " $0}'
}

extract_links() {
    local file="$1"
    local ext="${file##*.}"
    case "${ext,,}" in
        md) extract_from_markdown "$file" ;;
        txt) extract_from_text "$file" ;;
        html|htm) extract_from_html "$file" ;;
        pdf) extract_from_pdf "$file" ;;
        *) echo "" ;;
    esac
}

# --- Launch URL ---
launch_url() {
    local url="$1"
    echo "Opening URL: $url"
    $BROWSER "$url" &
}

# --- Main ---
if [ -z "$INPUT_FILE" ] || [ ! -f "$INPUT_FILE" ]; then
    echo "Usage: $0 /path/to/file" >&2
    exit 1
fi

if ! is_supported_file "$INPUT_FILE"; then
    echo "Error: Unsupported file type" >&2
    exit 1
fi

ALL_LINKS=$(extract_links "$INPUT_FILE")
if [ -z "$ALL_LINKS" ]; then
    echo "No URLs found in the file." >&2
    exit 1
fi

CATEGORIES=$(echo "$ALL_LINKS" | cut -d ':' -f1 | sort -u)
SELECTED_CATEGORY=$(add_index_numbers "$CATEGORIES" | $DMENU_CMD -l $(calculate_lines "$CATEGORIES") -p "Category:" | remove_index_numbers)
[ -z "$SELECTED_CATEGORY" ] && exit 0

CATEGORY_URLS=$(echo "$ALL_LINKS" | grep "^${SELECTED_CATEGORY}:" | sed "s/^${SELECTED_CATEGORY}:[ \t]*//")
SELECTED_URL=$(add_index_numbers "$CATEGORY_URLS" | $DMENU_CMD -l $(calculate_lines "$CATEGORY_URLS") -p "$SELECTED_CATEGORY:" | remove_index_numbers)
[ -z "$SELECTED_URL" ] && exit 0

launch_url "$SELECTED_URL"
