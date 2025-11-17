#!/usr/bin/env bash

## Author  : Harshit Prashant Dhanwalkar
## Github  : @Harshit-Dhanwalkar

DIR="${HOME}/Desktop/Notes/"
DMENU="/usr/local/bin/dmenu"
NOTIFY="/usr/bin/dunstify"
TERMINAL="${TERMINAL:-kitty}"

# Create directory if it doesn't exist
if [ ! -d "$DIR" ]; then
    if mkdir -p "$DIR"; then
        $NOTIFY -t 3000 "Notes Directory Created" "Directory: $(basename "$DIR")\nPath: <span font='9'>$DIR</span>"
    else
        $NOTIFY -u critical "Error" "Could not create directory:\n<span font='9'>$DIR</span>"
        exit 1
    fi
fi

newnote() {
    name="$(echo "" | $DMENU -p "Enter a name: ")" || exit 0
    [ -z "$name" ] && name=$(date +%F_%T | tr ':' '-')
    name="${name%.md}"  # Remove .md if user included it
    file_path="${DIR}${name}.md"

    touch "$file_path"
    setsid -f "$TERMINAL" -e nvim "$file_path" > /dev/null 2>&1

    $NOTIFY -t 3000 "New Note Created" "File: <b>${name}.md</b>\nPath: <span font='9'>$DIR</span>"
}

selected() {
    if files=$(command ls -1t "$DIR"*.md 2>/dev/null 2>&1 | xargs -I {} basename {}); then
        choice=$(echo -e "New\n$files" | $DMENU -l 5 -i -p "Choose note or create new: ")
    else
        choice="New"
    fi

    [ -z "$choice" ] && exit 0  # User cancelled

    case "$choice" in
        "New") 
            newnote 
            ;;
        *) 
            $NOTIFY -t 2000 "Opening Note" "File: <b>$choice</b>\nPath: <span font='9'>$DIR</span>"
            setsid -f "$TERMINAL" -e nvim "${DIR}${choice}" > /dev/null 2>&1 
            ;;
    esac
}

selected
