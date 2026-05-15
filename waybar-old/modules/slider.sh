#!/usr/bin/env bash

SLIDER_WINDOW_ID=""
VOLUME_SLIDER_ID=""
BRIGHTNESS_SLIDER_ID=""

find_slider_window() {
    SLIDER_WINDOW_ID=$(xdotool search --name "Waybar-Slider-Control" | head -1)
}

set_volume() {
    local value=$1
    pactl set-sink-volume @DEFAULT_SINK@ "${value}%"
    notify-send -t 1000 "Volume: ${value}%"
}

set_brightness() {
    local value=$1
    light -S "$value"
    notify-send -t 1000 "Brightness: ${value}%"
}

listen_for_changes() {
    tail -f /tmp/waybar-slider-value 2>/dev/null | while read line; do
        case "$line" in
            volume:*)
                set_volume "${line#volume:}"
                ;;
            brightness:*)
                set_brightness "${line#brightness:}"
                ;;
        esac
    done
}

case "$1" in
    "listen")
        listen_for_changes
        ;;
    "volume")
        ;;
    "brightness")
        ;;
    *)
        echo "Usage: $0 {listen|volume|brightness}"
        ;;
esac
