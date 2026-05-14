#!/usr/bin/env bash

## Author: Harshit Prashant Dhanwalkar
## Github: @Harshit-Dhanwalkar

# Dependencies:
#   Screenshots: grim, slurp, swaymsg (for window geometry), jq
#   Notifications: dunstify or notify-send, sxiv (for viewing)
#   Screen Recording: wf-recorder, slurp (for area selection), pkill
#   Menu: dmenu

# Check for notification command
if command -v dunstify >/dev/null 2>&1; then
    notify_cmd() { dunstify -u low -t 3000 --replace=699 "$1"; }
else
    notify_cmd() { notify-send "$1"; }
fi

# Directories and file
dir="$(xdg-user-dir PICTURES)/Screenshots"
recordings_dir="$(xdg-user-dir VIDEOS)/ScreenRecordings"
mkdir -p "$dir" "$recordings_dir"
time=$(date +%Y-%m-%d-%H-%M-%S)
file="Screenshot_${time}.png"
record_file="Recording_${time}.mp4"

# Options
options=(
"  Capture Desktop"
" 󰹑 Capture Area"
"  Capture Window"
" 󱎫 Capture in 5s"
" 󱎫 Capture in 10s"
"󰑋 󰍹 Record Desktop"
"󰑋 󰍹 Record Desktop in 5s"
"󰑋 󰍹 Record Desktop in 10s"
"󰑋 󰹑 Record Area"
"󰑋 󰹑 Record Area in 5s"
"󰑋 󰹑 Record Area in 10s"
"󰑋  Stop Recording"
)

# Show dmenu
chosen=$(printf "%s\n" "${options[@]}" | dmenu -l 12 -i -p "Screenshot/Record: ")

# Countdown function
countdown() {
    for sec in $(seq $1 -1 1); do
        notify_cmd "$2 in : $sec"
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

# Notify for recording
notify_record() {
    if [[ -e "$recordings_dir/$record_file" ]] && [[ -s "$recordings_dir/$record_file" ]]; then
        notify_cmd "Recording Saved to $recordings_dir/$record_file"
    else
        notify_cmd "Recording Failed: File not found or empty"
    fi
}

# Screenshot functions
shotnow() {
    grim "$dir/$file"
    notify_view
}

shot5() {
    countdown 5 "Taking shot"
    grim "$dir/$file"
    notify_view
}

shot10() {
    countdown 10 "Taking shot"
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

# Recording functions
recordnow() {
    # Kill any existing wf-recorder process
    pkill wf-recorder 2>/dev/null
    rm -f /tmp/wf-recorder.pid /tmp/wf-recorder-file 2>/dev/null
    echo "$recordings_dir/$record_file" > /tmp/wf-recorder-file
    notify_cmd "Recording Desktop..."
    wf-recorder -f "$recordings_dir/$record_file" &
    echo $! > /tmp/wf-recorder.pid
    notify_cmd "Recording Started. Select 'Stop Recording' to end."
}

recordnow5() {
    countdown 5 "Starting recording"
    recordnow
}

recordnow10() {
    countdown 10 "Starting recording"
    recordnow
}

recordarea() {
    pkill wf-recorder 2>/dev/null
    rm -f /tmp/wf-recorder.pid /tmp/wf-recorder-file 2>/dev/null
    notify_cmd "Select area to record..."
    geom=$(slurp)
    if [[ -n "$geom" ]]; then
        echo "$recordings_dir/$record_file" > /tmp/wf-recorder-file
        notify_cmd "Recording Area..."
        wf-recorder -g "$geom" -f "$recordings_dir/$record_file" &
        echo $! > /tmp/wf-recorder.pid
        notify_cmd "Recording Started. Select 'Stop Recording' to end."
    else
        notify_cmd "Recording cancelled."
    fi
}

recordarea5() {
    countdown 5 "Starting area recording"
    recordarea
}

recordarea10() {
    countdown 10 "Starting area recording"
    recordarea
}

stop_recording() {
    if [[ -f /tmp/wf-recorder.pid ]]; then
        pid=$(cat /tmp/wf-recorder.pid)
        if kill -0 $pid 2>/dev/null; then
            # Get the file path before killing
            record_file_path=$(cat /tmp/wf-recorder-file 2>/dev/null)
            kill -SIGINT $pid
            rm /tmp/wf-recorder.pid

            # Wait for the file to be fully written
            sleep 2

            # Check if file exists and has content
            if [[ -n "$record_file_path" ]] && [[ -f "$record_file_path" ]] && [[ -s "$record_file_path" ]]; then
                notify_cmd "Recording Saved to $record_file_path"
            else
                notify_cmd "Recording Failed: File not found or empty"
            fi
            rm -f /tmp/wf-recorder-file 2>/dev/null
        else
            notify_cmd "No active recording found."
            rm -f /tmp/wf-recorder.pid /tmp/wf-recorder-file 2>/dev/null
        fi
    else
        notify_cmd "No active recording found."
    fi
}

# Execute based on selection
case "$chosen" in
"  Capture Desktop")              shotnow ;;
" 󰹑 Capture Area")                 shotarea ;;
"  Capture Window")               shotwin ;;
" 󱎫 Capture in 5s")                shot5 ;;
" 󱎫 Capture in 10s")               shot10 ;;
"󰑋 󰍹 Record Desktop")               recordnow ;;
"󰑋 󰍹 Record Desktop in 5s")         recordnow5 ;;
"󰑋 󰍹 Record Desktop in 10s")        recordnow10 ;;
"󰑋 󰹑 Record Area")                  recordarea ;;
"󰑋 󰹑 Record Area in 5s")            recordarea5 ;;
"󰑋 󰹑 Record Area in 10s")           recordarea10 ;;
"󰑋  Stop Recording")               stop_recording ;;
*) notify_cmd "Operation Cancelled." ;;
esac
