#!/usr/bin/env bash

## Author  : Harshit Prashant Dhanwalkar
## Github  : @Harshit-Dhanwalkar

## IMPORTANT: This script is now integrated along with bluetooh.sh into controllers.sh

# Ensure dunstify is installed:
# sudo apt install dunstify libnotify-bin

if command -v dmenu &>/dev/null; then
    LAUNCHER="dmenu"
elif command -v rofi &>/dev/null; then
    LAUNCHER="rofi"
else
    dunstify -u critical "Countdown Error" "Neither dmenu nor rofi was found. Exiting."
    exit 1
fi

get_time_input() {
    local suggestions=$(printf "5\n10:00\n1:00:00\n! Stopwatch\n")
    local prompt="Time (M:SS) or !Stopwatch:"

    if [ "$LAUNCHER" == "dmenu" ]; then
        dmenu -p "$prompt" -l 4 <<<"$suggestions"
    elif [ "$LAUNCHER" == "rofi" ]; then
        rofi -dmenu -lines 4 -p "$prompt" <<<"$suggestions"
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
        total_seconds=$((time_parts[0] * 60)) # M (Minutes)
    elif [ "$num_parts" -eq 2 ]; then
        total_seconds=$((time_parts[0] * 60 + time_parts[1])) # MM:SS
    elif [ "$num_parts" -eq 3 ]; then
        total_seconds=$((time_parts[0] * 3600 + time_parts[1] * 60 + time_parts[2])) # HH:MM:SS
    else
        echo -1
        return
    fi

    echo "$total_seconds"
}

time_input=$(get_time_input)

if [ -z "$time_input" ]; then
    dunstify "Timer" "Timer cancelled or no input provided."
    exit 1
fi

# Check for Stopwatch Mode activation using '!' prefix
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

# --- Countdown Mode ---
if [ "$MODE" == "COUNTDOWN" ]; then
    if [ "$duration" -eq -1 ]; then
        dunstify -u critical "Countdown Error" "Invalid time format: '$time_input'. Use M, MM:SS, or HH:MM:SS."
        exit 1
    fi

    if [ "$duration" -le 0 ]; then
        dunstify -u critical "Countdown Error" "Duration must be greater than zero seconds."
        exit 1
    fi
fi

notification_id=0
current_time=0

while true; do
    if [ "$MODE" == "COUNTDOWN" ]; then
        current_time=$((duration))
    else # STOPWATCH mode
        current_time=$(($(date +%s) - start_time))
    fi

    # Calculate H, M, S for display
    hours=$((current_time / 3600))
    minutes=$(((current_time % 3600) / 60))
    seconds=$((current_time % 60))

    # Display format
    if [ "$hours" -gt 0 ]; then
        time_formatted=$(printf "%02d:%02d:%02d" "$hours" "$minutes" "$seconds")
    else
        time_formatted=$(printf "%02d:%02d" "$minutes" "$seconds")
    fi

    if [ "$notification_id" -eq 0 ]; then
        notification_id=$(dunstify -p -t 0 "Timer ($MODE)" "$initial_message $time_formatted")
    else
        if [ "$MODE" == "COUNTDOWN" ]; then
            dunstify -r "$notification_id" -t 0 "Countdown Timer" "Time remaining: $time_formatted"
            if [ "$current_time" -le 0 ]; then
                break
            fi
            duration=$((duration - 1))
        else # STOPWATCH
            dunstify -r "$notification_id" -t 0 "Stopwatch" "Elapsed time: $time_formatted"
        fi
    fi

    sleep 1
done

if [ "$MODE" == "COUNTDOWN" ]; then
    dunstify -u critical "Countdown Timer" "Time's up!"
fi
