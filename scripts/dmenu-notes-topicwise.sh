#!/usr/bin/env bash

## Author  : Harshit Prashant Dhanwalkar
## Github  : @Harshit-Dhanwalkar

BASE_DIR="${HOME}/Desktop/Notes/"
DMENU="/usr/local/bin/dmenu"
NOTIFY="/usr/bin/dunstify"

NOTE_CATEGORIES=("philosophy" "work" "configuration" "research")

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

# Verify terminal exists
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

select_category() {
    choice=$(printf "%s\n" "${NOTE_CATEGORIES[@]}" | env DISPLAY=:0 XAUTHORITY="${HOME}/.Xauthority" $DMENU -l 10 -i -p "Select category: ")
    [ -z "$choice" ] && exit 0
    echo "$choice"
}

newnote() {
    local category="$1"
    local dir="${BASE_DIR}${category}/"
    
    name="$(echo "" | env DISPLAY=:0 XAUTHORITY="${HOME}/.Xauthority" $DMENU -p "Enter name for $category note: ")" || exit 0
    [ -z "$name" ] && name=$(date +%F_%T | tr ':' '-')
    name="${name%.md}"
    file_path="${dir}${name}.md"

    touch "$file_path"
    "$TERMINAL" -e nvim "$file_path" &

    $NOTIFY -t 2000 "New Note Created" "Category: <b>$category</b>\nFile: <b>${name}.md</b>"
}

list_all_notes() {
    local all_notes=""
    for category in "${NOTE_CATEGORIES[@]}"; do
        if [ "$category" != "all" ]; then
            local dir="${BASE_DIR}${category}/"
            if [ -d "$dir" ]; then
                while IFS= read -r -d '' file; do
                    if [ -n "$file" ]; then
                        filename=$(basename "$file")
                        all_notes="${all_notes}${category}/$filename"$'\n'
                    fi
                done < <(find "$dir" -name "*.md" -type f -print0 2>/dev/null)
            fi
        fi
    done

    if [ -n "$all_notes" ]; then
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

        choice=$(echo -e "New\n$sorted_notes" | env DISPLAY=:0 XAUTHORITY="${HOME}/.Xauthority" $DMENU -l 15 -i -p "Choose note: ")
    else
        choice="New"
    fi

    [ -z "$choice" ] && exit 0

    case "$choice" in
        "New") 
            category=$(select_category)
            [ -n "$category" ] && newnote "$category"
            ;;
        *) 
            # Extract category and filename from choice (format: category/filename.md)
            category="${choice%%/*}"
            filename="${choice#*/}"
            dir="${BASE_DIR}${category}/"
            $NOTIFY -t 2000 "Opening Note" "Category: <b>$category</b>\nFile: <b>$filename</b>"
            "$TERMINAL" -e nvim "${dir}${filename}" &
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
    
    if files=$(command ls -1t "${dir}"*.md 2>/dev/null 2>&1 | xargs -I {} basename {}); then
        choice=$(echo -e "New\n$files" | env DISPLAY=:0 XAUTHORITY="${HOME}/.Xauthority" $DMENU -l 15 -i -p "Choose/create $category note: ")
    else
        choice="New"
    fi

    [ -z "$choice" ] && exit 0

    case "$choice" in
        "New") 
            newnote "$category"
            ;;
        *) 
            $NOTIFY -t 2000 "Opening Note" "Category: <b>$category</b>\nFile: <b>$choice</b>"
            "$TERMINAL" -e nvim "${dir}${choice}" &
            ;;
    esac
}

# Main flow
category=$(select_category)
[ -n "$category" ] && list_notes "$category"
