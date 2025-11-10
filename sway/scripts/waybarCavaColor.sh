#!/bin/bash

# Define the bar characters
bar="▁▂▃▄▅▆▇█"

# Define colors for each bar (10 bars max)
# colors=(
#     "'#ff0000'"  # Red
#     "'#ff6600'"  # Orange
#     "'#ffcc00'"  # Yellow
#     "'#66ff00'"  # Lime
#     "'#00ff66'"  # Green
#     "'#00ccff'"  # Light Blue
#     "'#0066ff'"  # Blue
#     "'#6600ff'"  # Purple
#     "'#cc00ff'"  # Pink
#     "'#ff00cc'"  # Magenta
# )
colors=(
    "'#f7768e'"
    "'#ff9e64'"
    "'#e0af68'"
    "'#9ece6a'"
    "'#73daca'"
    "'#b4f9f8'"
    "'#2ac3de'"
    "'#7dcfff'"
    "'#7aa2f7'"
    "'#bb9af7'"
)

# CAVA config
config_file="/tmp/bar_cava_config"
cat > "$config_file" <<EOF
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
    IFS=';' read -ra values <<< "$line"
    
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
