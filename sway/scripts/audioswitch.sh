#!/usr/bin/env bash

## Author  : Harshit Prashant Dhanwalkar
## Github  : @Harshit-Dhanwalkar

## IMPORTANT: This script is now integrated along with bluetooh.sh into audio-output-controller.sh

PACTL="/usr/bin/pactl"
JQ="/usr/bin/jq"
DMENU="/usr/local/bin/dmenu"
NOTIFY="/usr/bin/dunst"

options=$($PACTL -f json list sinks | $JQ -r '.[] | .description')
selection=$(echo "$options" | $DMENU -i -l 5 -p "Output:")

# Check if the user cancelled dmenu
if [ -z "$selection" ]; then
  $NOTIFY "Audio switch cancelled"
  exit 0
# else
#   echo "$selection"  # DEBUG
fi

# Extract the corresponding sink name
sink_name=$($PACTL -f json list sinks | $JQ -r --arg sink_pretty_name "$selection" '.[] | select(.description == $sink_pretty_name) | .name')

# Set the selected sink as default and notify
if [ -n "$sink_name" ]; then
  $PACTL set-default-sink "$sink_name" && $NOTIFY "Audio switched to: $selection"
else
  $NOTIFY "Audio Switch Failed: Could not match description to sink name."
fi
