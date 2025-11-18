#!/usr/bin/env bash

## Author  : Harshit Prashant Dhanwalkar
## Github  : @Harshit-Dhanwalkar

DIR="${HOME}/Desktop/temp/Notes/"
DMENU="/usr/local/bin/dmenu"
NOTIFY="/usr/bin/dunstify"

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
    # Run dmenu with explicit X11 backend
    name="$(echo "" | env DISPLAY=:0 XAUTHORITY="${HOME}/.Xauthority" $DMENU -p "Enter a name: ")" || exit 0
    [ -z "$name" ] && name=$(date +%F_%T | tr ':' '-')
    name="${name%.md}"  # Remove .md if user included it
    file_path="${DIR}${name}.md"

    touch "$file_path"
    "$TERMINAL" -e nvim "$file_path" &

    $NOTIFY -t 2000 "New Note Created" "File: <b>${name}.md</b>\nPath: <span font='9'>$DIR</span>"
}

selected() {
    if files=$(command ls -1t "$DIR"*.md 2>/dev/null 2>&1 | xargs -I {} basename {}); then
        choice=$(echo -e "New\n$files" | env DISPLAY=:0 XAUTHORITY="${HOME}/.Xauthority" $DMENU -l 5 -i -p "Choose note or create new: ")
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

            "$TERMINAL" -e nvim "${DIR}${choice}" &
            ;;
    esac
}

selected
