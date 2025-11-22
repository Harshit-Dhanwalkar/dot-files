#!/usr/bin/env bash

## Author  : Harshit Prashant Dhanwalkar
## Github  : @Harshit-Dhanwalkar

PACTL="/usr/bin/pactl"
JQ="/usr/bin/jq"
DUNST="dunst"
MAKO="mako"
NOTIFY_SEND="notify-send"

TIMER_PID_FILE="/tmp/controllers_timer.pid"
TIMER_NOTIF_FILE="/tmp/controllers_timer.notif"

# --- Notification function ---
notify() {
    if pgrep -x "$DUNST" >/dev/null 2>&1; then
        notify-send "$@"
    elif pgrep -x "$MAKO" >/dev/null 2>&1; then
        notify-send "$@"
    elif command -v "$NOTIFY_SEND" >/dev/null 2>&1; then
        notify-send "$@"
    else
        echo "Notification: $*" >&2
    fi
}

# --- Menu launcher ---
if command -v dmenu >/dev/null 2>&1; then
    menu() { dmenu -i -l 10 -p "$1"; }
elif command -v rofi >/dev/null 2>&1; then
    menu() { rofi -dmenu -i -p "$1"; }
else
    echo "Error: neither dmenu nor rofi found!" >&2
    notify "Error: neither dmenu nor rofi found!"
    exit 1
fi

# --- Utility to kill and cleanup ---
kill_timer_process() {
    local current_pid=$(cat "$TIMER_PID_FILE" 2>/dev/null)
    local current_notif_id=$(cat "$TIMER_NOTIF_FILE" 2>/dev/null)

    if [ -f "$TIMER_PID_FILE" ] && kill -0 "$current_pid" 2>/dev/null; then
        kill "$current_pid" 2>/dev/null
    fi
    if [ -n "$current_notif_id" ]; then
        dunstify -C "$current_notif_id" 2>/dev/null
    fi

    rm -f "$TIMER_PID_FILE" "$TIMER_NOTIF_FILE"
}

# --- Audio switcher Menu ---
audio_switch() {
    # Get available sinks
    sinks=$($PACTL -f json list sinks | $JQ -r '.[] | .description')

    local menu_options="Back (ESC)\n$sinks"

    [ -z "$sinks" ] && notify "No audio outputs found!" && return

    selection=$(echo -e "$menu_options" | menu "Select Audio Output:")

    # Check for Cancel or 'Back' selection
    if [ -z "$selection" ] || [ "$selection" == "Back" ]; then
        notify "Audio switch operation cancelled"
        return
    fi

    # Process selection
    sink_name=$($PACTL -f json list sinks | $JQ -r --arg s "$selection" '.[] | select(.description == $s) | .name')
    if [ -n "$sink_name" ]; then
        $PACTL set-default-sink "$sink_name" && notify "Audio switched to: $selection"
    else
        notify "Audio Switch Failed"
    fi
}

# --- Bluetooth Menu ---
bluetooth_menu() {
    if ! command -v bluetoothctl &>/dev/null || ! bluetoothctl show &>/dev/null; then
        notify "Bluetooth not available or service not running."
        return
    fi

    local power_state=$(bluetoothctl show | grep "Powered:" | awk '{print $2}' | tr '[:lower:]' '[:upper:]')

    # List connected or paired devices, including MAC address and name
    local devices=$(bluetoothctl devices Paired | sed 's/^Device //' | awk '{print $2 " (" $1 ")"}' | sed 's/(/MAC: /')

    # Options for the main Bluetooth menu
    SPACES=$(printf '%*s' 25 "")
    local options="Back (ESC)\nPower:$SPACES$power_state\nScan\nPairable\nDiscoverable\nConnect/Disconnect Device"

    local choice=$(echo -e "$options" | menu "Bluetooth           :")

    # Check for Cancel/Back
    if [ "$choice" == "Back" ] || [ -z "$choice" ]; then
        notify "Bluetooth operation cancelled."
        return 0
    fi

    case "$choice" in
    "Power: yes")
        bluetoothctl power off
        notify "Bluetooth turned OFF"
        ;;
    "Power: no")
        bluetoothctl power on
        notify "Bluetooth turned ON"
        ;;
    "Scan")
        bluetoothctl --timeout 5 scan on & # Run scan in background
        notify "Bluetooth scanning for 5 seconds..."
        ;;
    "Pairable")
        bluetoothctl pairable on
        notify "Bluetooth set to pairable mode"
        ;;
    "Discoverable")
        bluetoothctl discoverable on
        notify "Bluetooth is now discoverable"
        ;;
    "Connect/Disconnect Device")
        local device_options=$(echo -e "Back (ESC)\n$devices")
        local device_selection=$(echo -e "$device_options" | menu "Select Device (MAC: Name):")

        if [ "$device_selection" == "Back" ] || [ -z "$device_selection" ]; then
            return 0 # Return to main bluetooth menu
        fi

        # Extract MAC address
        local mac=$(echo "$device_selection" | awk '{print $1}')
        local name=$(echo "$device_selection" | sed 's/ (MAC:.*//') # Keep only the name

        if [ -n "$mac" ]; then
            # Check if already connected
            if bluetoothctl info "$mac" | grep -q "Connected: yes"; then
                bluetoothctl disconnect "$mac" && notify "Disconnected $name" || notify "Failed to disconnect $name"
            else
                # Attempt to connect
                bluetoothctl connect "$mac" && notify "Connected to $name" || notify "Failed to connect $name"
            fi
        fi
        ;;
    *) ;;
    esac
}

# --- TIMER / STOPWATCH FUNCTION ---
run_timer_loop() {
    local MODE="$1"
    local duration="$2"
    local start_time="$3"
    local initial_message="$4"

    local notification_id=0
    local current_time=0

    # Check for dunstify, since this function runs outside the main script's environment
    if ! command -v dunstify &>/dev/null; then
        echo "dunstify not found in background process." >&2
        return
    fi

    trap "rm -f \"$TIMER_PID_FILE\" \"$TIMER_NOTIF_FILE\"" EXIT

    while true; do
        if [ "$MODE" == "COUNTDOWN" ]; then
            current_time=$((duration))
        else
            current_time=$(($(date +%s) - start_time))
        fi

        local hours=$((current_time / 3600))
        local minutes=$(((current_time % 3600) / 60))
        local seconds=$((current_time % 60))

        local time_formatted
        if [ "$hours" -gt 0 ]; then
            time_formatted=$(printf "%02d:%02d:%02d" "$hours" "$minutes" "$seconds")
        else
            time_formatted=$(printf "%02d:%02d" "$minutes" "$seconds")
        fi

        if [ "$notification_id" -eq 0 ]; then
            # Capture the persistent notification ID and store it in a file
            notification_id=$(dunstify -p -t 0 "Timer ($MODE)" "$initial_message $time_formatted")
            echo "$notification_id" >"$TIMER_NOTIF_FILE"
        else
            if [ "$MODE" == "COUNTDOWN" ]; then
                dunstify -r "$notification_id" -t 0 "Countdown Timer" "Time remaining: $time_formatted"
                if [ "$current_time" -le 0 ]; then
                    dunstify -C "$notification_id" 2>/dev/null
                    break
                fi
                duration=$((duration - 1))
            else
                dunstify -r "$notification_id" -t 0 "Stopwatch" "Elapsed time: $time_formatted"
            fi
        fi

        sleep 1
    done

    if [ "$MODE" == "COUNTDOWN" ]; then
        dunstify -u critical "Countdown Timer" "Time's up!"
    fi
}

timer_stopwatch() {
    local LAUNCHER
    if command -v dmenu &>/dev/null; then
        LAUNCHER="dmenu"
    elif command -v rofi &>/dev/null; then
        LAUNCHER="rofi"
    else
        notify -u critical "Countdown Error" "Neither dmenu nor rofi was found. Exiting."
        return 1
    fi

    get_time_input() {
        local suggestions=$(printf "Back (ESC)\n! Stopwatch\n5\n10:00\n1:00:00\nStop Timer\n")
        local prompt="Time (M:SS) or !SW :"

        if [ "$LAUNCHER" == "dmenu" ]; then
            dmenu -p "$prompt" -l 6 <<<"$suggestions"
        elif [ "$LAUNCHER" == "rofi" ]; then
            rofi -dmenu -lines 5 -p "$prompt" <<<"$suggestions"
        fi
    }

    parse_time_to_seconds() {
        local input_time="$1"
        local total_seconds=0
        local cleaned_time=$(echo "$input_time" | tr -cd '0-9:')
        IFS=':' read -ra time_parts <<<"$cleaned_time"
        local num_parts=${#time_parts[@]}

        if [ -z "$cleaned_time" ]; then
            echo -1
            return
        fi
        if [ "$num_parts" -eq 1 ]; then
            total_seconds=$((10#${time_parts[0]} * 60))
        elif [ "$num_parts" -eq 2 ]; then
            total_seconds=$((10#${time_parts[0]} * 60 + 10#${time_parts[1]}))
        elif [ "$num_parts" -eq 3 ]; then
            total_seconds=$((10#${time_parts[0]} * 3600 + 10#${time_parts[1]} * 60 + 10#${time_parts[2]}))
        else
            echo -1
            return
        fi
        echo "$total_seconds"
    }

    local time_input=$(get_time_input)

    # Check for Cancel/Back
    if [ -z "$time_input" ] || [ "$time_input" == "Back (ESC)" ]; then
        notify "Timer operation cancelled."
        return 0
    fi

    if [ "$time_input" == "Stop Timer" ]; then
        local current_pid=$(cat "$TIMER_PID_FILE" 2>/dev/null)
        local current_notif_id=$(cat "$TIMER_NOTIF_FILE" 2>/dev/null)

        if [ -f "$TIMER_PID_FILE" ] && kill -0 "$current_pid" 2>/dev/null; then
            kill_timer_process
            notify "Timer" "Running timer/stopwatch terminated."
        else
            notify "Timer" "No running timer found to stop."
        fi
        return 0
    fi

    if [ -f "$TIMER_PID_FILE" ]; then
        notify "Timer" "A timer/stopwatch is already running. Use 'Stop Timer' first."
        return 0
    fi

    local MODE duration start_time initial_message

    if [[ "$time_input" =~ ^! ]]; then
        MODE="STOPWATCH"
        duration=0
        start_time=$(date +%s)
        initial_message="Stopwatch started."
    else
        MODE="COUNTDOWN"
        duration=$(parse_time_to_seconds "$time_input")
        initial_message="Countdown Timer started."
    fi

    if [ "$MODE" == "COUNTDOWN" ]; then
        if [ "$duration" -eq -1 ]; then
            notify -u critical "Countdown Error" "Invalid time format: '$time_input'. Use M, MM:SS, or HH:MM:SS."
            return 1
        fi
        if [ "$duration" -le 0 ]; then
            notify -u critical "Countdown Error" "Duration must be greater than zero seconds."
            return 1
        fi
    fi

    if ! command -v dunstify &>/dev/null; then
        notify -u critical "Error" "dunstify is required for the timer/stopwatch functionality. Please install it."
        return 1
    fi

    local cmd="run_timer_loop \"$MODE\" \"$duration\" \"$start_time\" \"$initial_message\""
    bash -c "$cmd" &

    echo $! >"$TIMER_PID_FILE"

    return 0
}

# --- Color Picker ---
color_picker() {
    if command -v /usr/bin/grim &>/dev/null && command -v /usr/bin/slurp &>/dev/null && command -v /usr/bin/convert &>/dev/null; then
        /usr/bin/grim -g "$(/usr/bin/slurp -p)" -t ppm - | /usr/bin/convert - -format '%[pixel:p{0,0}]' txt:- | /usr/bin/awk -F'[(,)]' '/srgb/{printf "#%02x%02x%02x\n", $2, $3, $4}' | /usr/bin/xargs -I{} notify-send "Picked Color" "{}"
        return 0
    else
        notify -u critical "Color Picker Error" "Dependencies (grim, slurp, convert) not found. Cannot run color picker."
        return 1
    fi
}

# --- Main menu ---
main_menu() {
    local SPACES=$(printf '%*s' 20 "")
    # local options="Exit (ESC)\nAudio Switch\nBluetooth Menu\nTimer / Stopwatch\nColor Picker"
    local options="Exit (ESC)\nAudio Switch\nBluetooth Menu\nTimer / Stopwatch$SPACES Bug It never exit (run: \`\`\`pkill -f 'controllers.sh' 2>/dev/null\`\`\` to fix it)\nColor Picker"
    local choice

    # Loop to keep showing the menu after a function completes
    while true; do
        choice=$(echo -e "$options" | menu "System Control     :")
        case "$choice" in
        "Audio Switch") audio_switch ;;
        "Bluetooth Menu") bluetooth_menu ;;
        "Timer / Stopwatch") timer_stopwatch ;;
        "Color Picker") color_picker ;;
        "Exit" | *) exit 0 ;;
        esac
    done
}

# Execute Main Menu
kill_timer_process
main_menu
