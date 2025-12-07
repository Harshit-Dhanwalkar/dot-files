#!/usr/bin/env bash

## Author  : Harshit Prashant Dhanwalkar
## Github  : @Harshit-Dhanwalkar

bar="▁▂▃▄▅▆▇█"

# Define colors for each bar (10 bars max)
colors=(
    "'#f7768e'" #   "'#ff0000'"  # Red
    "'#ff9e64'" #   "'#ff6600'"  # Orange
    "'#e0af68'" #   "'#ffcc00'"  # Yellow
    "'#9ece6a'" #   "'#66ff00'"  # Lime
    "'#73daca'" #   "'#00ff66'"  # Green
    "'#b4f9f8'" #   "'#00ccff'"  # LightBlue
    "'#2ac3de'" #   "'#0066ff'"  # Blue
    "'#7dcfff'" #   "'#6600ff'"  # Purple
    "'#7aa2f7'" #   "'#cc00ff'"  # Pink
    "'#bb9af7'" #   "'#ff00cc'"  # Magenta
)

# CAVA config
config_file="/tmp/bar_cava_config"
cat >"$config_file" <<EOF
[general]
bars = 10

[input]
method = pulse
source = auto

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
EOF

# Kill previous cava instance
pkill -f "cava -p $config_file"

# Process cava output
cava -p "$config_file" | while read -r line; do
    # Split the line into individual bar values
    IFS=';' read -ra values <<<"$line"

    output=""
    for i in "${!values[@]}"; do
        # Get the bar character (0-7 maps to ▁▂▃▄▅▆▇█)
        bar_index="${values[$i]}"
        if [[ "$bar_index" =~ ^[0-7]$ ]]; then
            char="${bar:$bar_index:1}"
            # Apply color
            color="${colors[$i % ${#colors[@]}]}"
            output+="<span color=${color}>${char}</span>"
        fi
    done

    # Print the formatted output (for Waybar)
    echo "$output"
done
