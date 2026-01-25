#!/usr/bin/env bash

## Author  : Harshit Prashant Dhanwalkar
## Github  : @Harshit-Dhanwalkar

# Check for notification command
if command -v dunstify >/dev/null 2>&1; then
    notify_cmd() { dunstify -u low -t 3000 --replace=699 "$1"; }
else
    notify_cmd() { notify-send "$1"; }
fi

# Directories and file
dir="$(xdg-user-dir PICTURES)/Screenshots"
mkdir -p "$dir"
time=$(date +%Y-%m-%d-%H-%M-%S)
file="Screenshot_${time}.png"

# Options
options=(
" Capture Desktop"
"󰹑 Capture Area"
" Capture Window"
"󱎫 Capture in 5s"
"󱎫 Capture in 10s"
)

# Show dmenu
chosen=$(printf "%s\n" "${options[@]}" | dmenu -l 5 -i -p "Screenshot: ")

# Countdown function
countdown() {
    for sec in $(seq $1 -1 1); do
        notify_cmd "Taking shot in : $sec"
        sleep 1
    done
}

# Notify and open
notify_view() {
    sxiv "$dir/$file" &
    if [[ -e "$dir/$file" ]]; then
        notify_cmd "Screenshot Saved to $dir"
    else
        notify_cmd "Screenshot Failed."
    fi
}

# Screenshot functions
shotnow() {
    grim "$dir/$file"
    notify_view
}

shot5() {
    countdown 5
    grim "$dir/$file"
    notify_view
}

shot10() {
    countdown 10
    grim "$dir/$file"
    notify_view
}

shotwin() {
    geom=$(swaymsg -t get_tree | jq -r '.. | select(.focused? == true).rect | "\(.x),\(.y) \(.width)x\(.height)"')
    grim -g "$geom" "$dir/$file"
    notify_view
}

shotarea() {
    geom=$(slurp)
    grim -g "$geom" "$dir/$file"
    notify_view
}

# Execute based on selection
case "$chosen" in
" Capture Desktop") shotnow ;;
"󰹑 Capture Area")    shotarea ;;
" Capture Window")  shotwin ;;
"󱎫 Capture in 5s")   shot5 ;;
"󱎫 Capture in 10s")  shot10 ;;
*) notify_cmd "Screenshot Operation Cancelled." ;;
esac
