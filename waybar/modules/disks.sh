#!/usr/bin/env bash

## Author  : Harshit Prashant Dhanwalkar
## Github  : @Harshit-Dhanwalkar

# Array of disks and matching icons
DISKS=("/" "/home")
ICONS=(" ")

# Define a file to save current disk and format, and initialize if not found
DISKS_FILE="/tmp/disk_info"
[ -f "$DISKS_FILE" ] || echo "0 0" >"$DISKS_FILE"

# Scroll up/down through disks array
# Left-click for notification with lsblk
# Middle-click to change format
# Module used to wrap around when it reaches end of disks array or format
if [ -n "$BLOCK_BUTTON" ]; then
    read INDEX FORMAT <"$DISKS_FILE"
    case $BLOCK_BUTTON in
        1) notify-send -t 60000 "$(dysk --color no -c free+mp+use+size)" ;;
        3) echo "$INDEX $((($FORMAT + 1) % 2))" >"$DISKS_FILE" ;;
        4) echo "$((($INDEX + 1) % ${#DISKS[@]})) $FORMAT" >"$DISKS_FILE" ;;
        5) echo "$((($INDEX - 1) % ${#DISKS[@]})) $FORMAT" >"$DISKS_FILE" ;;
        6) setsid -f "$TERMINAL" -e "$EDITOR" "$0" ;;
    esac
    exit 0
fi

# Read INDEX number and FORMAT number from the file
read INDEX FORMAT <"$DISKS_FILE"

# Set the current disk and icon per INDEX #
CURRENT_DISK="${DISKS[$INDEX]}"
ICON="${ICONS[$INDEX]}"

# Pull usage % and space remaining of that disk
PERCENT=$(df -h "$CURRENT_DISK" | awk 'NR==2 {print $5}')
SPACE=$(df -h "$CURRENT_DISK" | awk 'NR==2 {print $4}')

# If format is 0, display usage %, otherwise, space remaining
[ "$FORMAT" -eq 0 ] && INFO="$PERCENT" || INFO="$SPACE"

printf '{"text":"%s", "tooltip":"<b>Disk space used is %s</b>"}\n' "$INFO" "$INFO"
