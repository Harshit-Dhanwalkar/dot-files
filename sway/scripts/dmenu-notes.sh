#!/usr/bin/env bash

## Author  : Harshit Prashant Dhanwalkar
## Github  : @Harshit-Dhanwalkar

BASE_DIR="${HOME}/Desktop/Notes/"
DMENU="/usr/local/bin/dmenu"
NOTIFY="/usr/bin/dunstify"

NOTE_CATEGORIES=("philosophy" "work" "configuration")

if [ -x "${HOME}/.local/kitty.app/bin/kitty" ]; then
    TERMINAL="${HOME}/.local/kitty.app/bin/kitty"
elif command -v kitty >/dev/null 2>&1; then
    TERMINAL="$(command -v kitty)"
elif [ -x "/usr/bin/kitty" ]; then
    TERMINAL="/usr/bin/kitty"
elif [ -x "/usr/bin/st" ]; then
    TERMINAL="/usr/bin/st"
elif [ -x "/usr/bin/foot" ]; then
    TERMINAL="/usr/bin/foot"
else
    echo "Error: no terminal found" >&2
    exit 1
fi

if ! [ -x "$TERMINAL" ]; then
    echo "Error: Terminal not found: $TERMINAL" >&2
    exit 1
fi

# Force XWayland environment for dmenu
export DISPLAY=:0
export XAUTHORITY="${HOME}/.Xauthority"

# Create base directory and all category directories
mkdir -p "$BASE_DIR"
for category in "${NOTE_CATEGORIES[@]}"; do
    if [ "$category" != "all" ]; then
        mkdir -p "${BASE_DIR}${category}"
    fi
done

# Function to count notes in a directory
count_notes() {
    local dir="$1"
    local count=0
    if [ -d "$dir" ]; then
        count=$(find "$dir" -name "*.md" -type f 2>/dev/null | wc -l)
    fi
    echo "$count"
}

pad_category() {
    local category="$1"
    local count="$2"
    local padded_category
    local title_case=$(echo "$category" | sed 's/.*/\L&/; s/[a-z]*/\u&/g')

    case "$category" in
        "philosophy") padded_category="Philosophy      " ;;
        "work") padded_category="Work            " ;;
        "configuration") padded_category="Configuration   " ;;
        "all") padded_category="All             " ;;
        *) padded_category="${title_case}          " ;;
    esac

    echo "${padded_category}(${count} notes)"
}

# --- Menu launcher ---
menu() {
    env DISPLAY=:0 XAUTHORITY="${HOME}/.Xauthority" $DMENU -l "$2" -i -p "$1"
}

# --- Back/Exit handling functions ---
is_back_selection() {
    local selection="$1"
    [ -z "$selection" ] || [ "$selection" = "Back (ESC)" ] || [ "$selection" = "Exit (ESC)" ]
}

is_exit_selection() {
    local selection="$1"
    [ "$selection" = "Exit (ESC)" ]
}

select_category() {
    local categories_with_count=""
    for category in "${NOTE_CATEGORIES[@]}"; do
        if [ "$category" != "all" ]; then
            local dir="${BASE_DIR}${category}/"
            local count=$(count_notes "$dir")
            local padded_line=$(pad_category "$category" "$count")
            categories_with_count="${categories_with_count}${padded_line}"$'\n'
        fi
    done

    local total_count=0
    for category in "${NOTE_CATEGORIES[@]}"; do
        if [ "$category" != "all" ]; then
            local dir="${BASE_DIR}${category}/"
            total_count=$((total_count + $(count_notes "$dir")))
        fi
    done
    local all_padded=$(pad_category "all" "$total_count")
    categories_with_count="Exit (ESC)"$'\n'"${categories_with_count}${all_padded}"

    choice=$(echo -e "$categories_with_count" | menu "Select category:" 12)

    if is_back_selection "$choice"; then
        echo "EXIT"
        return
    fi

    local clean_choice=$(echo "$choice" | sed 's/^\([^ ]* *\).*/\1/' | sed 's/ *$//' | tr '[:upper:]' '[:lower:]')
    echo "$clean_choice"
}

newnote() {
    local category="$1"
    local dir="${BASE_DIR}${category}/"

    name="$(echo "" | menu "Enter name for $category note:" 1)" || exit 0
    [ -z "$name" ] && name=$(date +%F_%T | tr ':' '-')
    name="${name%.md}"
    file_path="${dir}${name}.md"

    touch "$file_path"
    "$TERMINAL" -e nvim "$file_path" &

    $NOTIFY -t 2000 "New Note Created" "Category: <b>$category</b>\nFile: <b>${name}.md</b>"
    echo "SUCCESS"
}

list_all_notes() {
    local all_notes=""
    local note_count=0

    for category in "${NOTE_CATEGORIES[@]}"; do
        if [ "$category" != "all" ]; then
            local dir="${BASE_DIR}${category}/"
            if [ -d "$dir" ]; then
                while IFS= read -r -d '' file; do
                    if [ -n "$file" ]; then
                        filename=$(basename "$file")
                        all_notes="${all_notes}${category}/$filename"$'\n'
                        note_count=$((note_count + 1))
                    fi
                done < <(find "$dir" -name "*.md" -type f -print0 2>/dev/null)
            fi
        fi
    done

    if [ -n "$all_notes" ] && [ "$note_count" -gt 0 ]; then
        # Sort by modification time
        sorted_notes=$(echo "$all_notes" | while IFS= read -r note; do
            if [ -n "$note" ]; then
                category="${note%%/*}"
                filename="${note#*/}"
                file_path="${BASE_DIR}${category}/${filename}"
                if [ -f "$file_path" ]; then
                    printf "%d\t%s\n" "$(stat -c %Y "$file_path" 2>/dev/null || echo 0)" "$note"
                fi
            fi
        done | sort -nr | cut -f2-)

        choice=$(echo -e "Back (ESC)\nNew\n$sorted_notes" | menu "All notes (${note_count} total):" 15)
    else
        choice=$(echo -e "Back (ESC)\nNew" | menu "All notes (0 total):" 15)
    fi

    if is_back_selection "$choice"; then
        echo "BACK"
        return
    fi

    case "$choice" in
        "New") 
            category=$(select_category)
            if [ "$category" = "EXIT" ]; then
                echo "EXIT"
                return
            fi
            [ -n "$category" ] && newnote "$category"
            ;;
        *) 
            # Extract category and filename from choice (format: category/filename.md)
            category="${choice%%/*}"
            filename="${choice#*/}"
            dir="${BASE_DIR}${category}/"
            $NOTIFY -t 2000 "Opening Note" "Category: <b>$category</b>\nFile: <b>$filename</b>"
            "$TERMINAL" -e nvim "${dir}${filename}" &
            echo "SUCCESS"
            ;;
    esac
}

list_notes() {
    local category="$1"

    if [ "$category" = "all" ]; then
        list_all_notes
        return
    fi

    local dir="${BASE_DIR}${category}/"
    local count=$(count_notes "$dir")

    if files=$(command ls -1t "${dir}"*.md 2>/dev/null 2>&1 | xargs -I {} basename {}); then
        choice=$(echo -e "Back (ESC)\nNew\n$files" | menu "${category} notes (${count} total):" 15)
    else
        choice=$(echo -e "Back (ESC)\nNew" | menu "${category} notes (0 total):" 15)
    fi

    if is_back_selection "$choice"; then
        echo "BACK"
        return
    fi

    case "$choice" in
        "New") 
            result=$(newnote "$category")
            echo "$result"
            ;;
        *) 
            $NOTIFY -t 2000 "Opening Note" "Category: <b>$category</b>\nFile: <b>$choice</b>"
            "$TERMINAL" -e nvim "${dir}${choice}" &
            echo "SUCCESS"
            ;;
    esac
}

main_navigation() {
    while true; do
        category=$(select_category)

        if [ "$category" = "EXIT" ]; then
            $NOTIFY -t 1000 "Notes" "Exiting notes manager"
            exit 0
        fi

        if [ -n "$category" ]; then
            while true; do
                result=$(list_notes "$category")

                case "$result" in
                    "BACK")
                        # Go back to category selection
                        break
                        ;;
                    "EXIT")
                        # Exit completely
                        $NOTIFY -t 1000 "Notes" "Exiting notes manager"
                        exit 0
                        ;;
                    "SUCCESS")
                        # Stay in current category menu after successful operation
                        continue
                        ;;
                    *)
                        # Handle any other case by staying in current menu
                        continue
                        ;;
                esac
            done
        fi
    done
}

main_navigation
