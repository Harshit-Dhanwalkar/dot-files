#!/usr/bin/env bash

BRIGHTNESS=$(cat /sys/devices/platform/dell-laptop/leds/dell\:\:kbd_backlight/brightness)

if [ "$BRIGHTNESS" = "0" ]; then
    # Off state
    echo "{\"text\": \" off\", \"class\": \"off\"}"
elif [ "$BRIGHTNESS" = "1" ]; then
    # Low state
    echo "{\"text\": \"󰌌 low\", \"class\": \"low\"}"
elif [ "$BRIGHTNESS" = "2" ]; then
    # High state
    echo "{\"text\": \"󰌏 High\", \"class\": \"high\"}"
else
    # Unknown state
    echo "{\"text\": \"unknown\", \"class\": \"unknown\"}"
fi
