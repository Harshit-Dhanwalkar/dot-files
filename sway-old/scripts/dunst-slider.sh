#!/usr/bin/env bash

## Author  : Harshit Prashant Dhanwalkar
## Github  : @Harshit-Dhanwalkar

set -euo pipefail

# --- Configuration ---
VOLUME_STEP=5
BRIGHTNESS_STEP=5
MSG_TAG_VOLUME="volume_control"
MSG_TAG_BRIGHTNESS="brightness_control"
PROGRESS_BAR_LENGTH=8

# Urgency thresholds
VOLUME_WARNING=90
BRIGHTNESS_WARNING=90

# --- Helpers ---
get_volume() {
    pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '[0-9]{1,3}(?=%)' | head -1
}

get_mute() {
    pactl get-sink-mute @DEFAULT_SINK@ | grep -Po '(?<=Mute: )(yes|no)'
}

get_brightness() {
    # Run brightnessctl with sudo if needed, but capture output as current user
    if [ -w /sys/class/backlight/*/brightness ]; then
        brightnessctl g
    else
        sudo brightnessctl g 2>/dev/null
    fi
}

get_max_brightness() {
    # Run brightnessctl with sudo if needed
    if [ -w /sys/class/backlight/*/brightness ]; then
        brightnessctl m
    else
        sudo brightnessctl m 2>/dev/null
    fi
}

# --- Progress Bar Functions ---
create_progress_bar() {
    local percentage=$1
    local filled_blocks=$((percentage * PROGRESS_BAR_LENGTH / 100))
    local empty_blocks=$((PROGRESS_BAR_LENGTH - filled_blocks))

    # Handle edge cases
    if [[ $percentage -eq 0 ]]; then
        filled_blocks=0
        empty_blocks=$PROGRESS_BAR_LENGTH
    elif [[ $percentage -eq 100 ]]; then
        filled_blocks=$PROGRESS_BAR_LENGTH
        empty_blocks=0
    fi

    # Create the progress bar with different styles
    local bar=""

    # Option 1: Simple blocks with different characters
    # for ((i = 0; i < filled_blocks; i++)); do
    #     bar+="■"
    # done
    # for ((i = 0; i < empty_blocks; i++)); do
    #     bar+="─"
    # done

    # Option 3: Segmented bars
    local segments=("▰" "▱") # 
    for ((i = 0; i < filled_blocks; i++)); do
        bar+="${segments[0]}"
    done
    for ((i = 0; i < empty_blocks; i++)); do
        bar+="${segments[1]}"
    done
    echo "$bar"
}

# --- Urgency Detection ---
get_volume_urgency() {
    local volume=$1
    local mute=$2

    if [[ "$mute" == "yes" ]]; then
        echo "low"
    elif [[ $volume -ge $VOLUME_WARNING ]]; then
        echo "critical"
    else
        echo "low"
    fi
}

get_brightness_urgency() {
    local percentage=$1

    if [[ $percentage -ge $BRIGHTNESS_WARNING ]]; then
        echo "critical"
    else
        echo "low"
    fi
}

# --- Notifications ---
notify_volume() {
    local volume mute icon bar urgency
    volume=$(get_volume)
    mute=$(get_mute)
    bar=$(create_progress_bar "$volume")
    urgency=$(get_volume_urgency "$volume" "$mute")

    if [[ "$mute" == "yes" || "$volume" -eq 0 ]]; then
        icon="󰸈 "                                               # muted
        bar=$(printf '%*s' "$PROGRESS_BAR_LENGTH" | tr ' ' '─') # Empty bar when muted
    elif [[ "$volume" -lt 30 ]]; then
        icon="󰕿 " # low
    elif [[ "$volume" -lt 70 ]]; then
        icon="󰖀 " # medium
    elif [[ "$volume" -gt 100 ]]; then
        icon="󱄡 " # boosted
    else
        icon="󰕾 " # high
    fi

    dunstify -a "changeVolume" -u "$urgency" -i none -h string:x-dunst-stack-tag:"$MSG_TAG_VOLUME" \
        -h int:value:"$volume" "$icon Volume: ${volume}%  $bar"
}

notify_brightness() {
    local brightness max_brightness percentage icon bar urgency
    brightness=$(get_brightness)
    max_brightness=$(get_max_brightness)
    percentage=$((brightness * 100 / max_brightness))
    icon="󰃠 "
    bar=$(create_progress_bar "$percentage")
    urgency=$(get_brightness_urgency "$percentage")

    dunstify -a "changeBrightness" -u "$urgency" -i none -h string:x-dunst-stack-tag:"$MSG_TAG_BRIGHTNESS" \
        -h int:value:"$percentage" "$icon Brightness: ${percentage}%  $bar"
}

# --- Volume Controls ---
volume_up() {
    pactl set-sink-mute @DEFAULT_SINK@ 0
    pactl set-sink-volume @DEFAULT_SINK@ +${VOLUME_STEP}%
    notify_volume
}

volume_down() {
    pactl set-sink-volume @DEFAULT_SINK@ -${VOLUME_STEP}%
    notify_volume
}

volume_mute() {
    pactl set-sink-mute @DEFAULT_SINK@ toggle
    notify_volume
}

# --- Brightness Controls ---
brightness_up() {
    # Run brightnessctl with sudo if needed, but notification as user
    if [ -w /sys/class/backlight/*/brightness ]; then
        brightnessctl set +${BRIGHTNESS_STEP}% >/dev/null
    else
        sudo brightnessctl set +${BRIGHTNESS_STEP}% >/dev/null
    fi
    notify_brightness
}

brightness_down() {
    # Run brightnessctl with sudo if needed, but notification as user
    if [ -w /sys/class/backlight/*/brightness ]; then
        brightnessctl set ${BRIGHTNESS_STEP}%- >/dev/null
    else
        sudo brightnessctl set ${BRIGHTNESS_STEP}%- >/dev/null
    fi
    notify_brightness
}

# --- Main Logic ---
case "${1:-}" in
volume_up) volume_up ;;
volume_down) volume_down ;;
volume_mute) volume_mute ;;
brightness_up) brightness_up ;;
brightness_down) brightness_down ;;
*)
    echo "Usage: $0 {volume_up|volume_down|volume_mute|brightness_up|brightness_down}"
    exit 1
    ;;
esac
