#!/bin/sh

PACTL="/usr/bin/pactl"
JQ="/usr/bin/jq"
DMENU="/usr/local/bin/dmenu"
NOTIFY="/usr/bin/notify-send"

options=$($PACTL -f json list sinks | $JQ -r '.[] | .description')
# echo "$options"  # DEBUG
selection=$(echo "$options" | /usr/bin/dmenu -i -l 5 -p "Output:")
# echo $selection  # DEBUG

# Check if the user cancelled dmenu
if [ -z "$selection" ]; then
  $NOTIFY "Audio switch cancelled"
  exit 0
# else
#   echo "$selection"  # DEBUG
fi

# Extract the corresponding sink name
sink_name=$($PACTL -f json list sinks | $JQ -r --arg sink_pretty_name "$selection" '.[] | select(.description == $sink_pretty_name) | .name')
# echo "$sink_name"  # DEBUG

# Set the selected sink as default and notify
if [ -n "$sink_name" ]; then
  $PACTL set-default-sink "$sink_name" && $NOTIFY "Audio switched to: $selection"
else
  $NOTIFY "Audio Switch Failed: Could not match description to sink name."
fi
