#!/usr/bin/env bash

## Author  : Harshit Prashant Dhanwalkar
## Github  : @Harshit-Dhanwalkar

# Dependencies: colordiff entr

# Function to select a file using fzf
select_file() {
    find . -type f -name "*.md" | fzf --height 40% --reverse --prompt="Select $1 file: "
}

# Use arguments if provided ($1 and $2), otherwise use fzf
FILE1="${1:-$(select_file "first")}"
if [ -z "$FILE1" ]; then echo "No file selected. Exiting."; exit 1; fi

FILE2="${2:-$(select_file "second")}"
if [ -z "$FILE2" ]; then echo "No file selected. Exiting."; exit 1; fi

# Debug: Print selected files
echo "Monitoring for changes..."
echo "File 1: $FILE1"
echo "File 2: $FILE2"

# Function to perform diff
perform_diff() {
    local f1="$1"
    local f2="$2"
    if [ -f "$f1" ] && [ -f "$f2" ]; then
        clear
        echo "--- Diff: $f1 vs $f2 ---"
        diff --unified=0 "$f1" "$f2" | colordiff
    else
        echo "Error: Files missing."
    fi
}

# Export the function so 'entr' can see it
export -f perform_diff

# Use entr to watch for changes
# We use -c to clear the screen on every update
printf "%s\n%s\n" "$FILE1" "$FILE2" | entr -c bash -c "perform_diff '$FILE1' '$FILE2'"
