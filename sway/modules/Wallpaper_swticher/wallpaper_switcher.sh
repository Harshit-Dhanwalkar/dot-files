#!/usr/bin/env bash

## Author  : Harshit Prahant Dhanwalkar
## Github  : @harshitpmd

# Directory containing your wallpapers
WALLPAPER_DIR="$HOME/Pictures/wallpapers"

# List all image files in the directory and store both full paths and processed filenames
WALLPAPERS=($(ls "$WALLPAPER_DIR"/*.{jpg,jpeg,png} 2> /dev/null))
FILENAMES=()

for WALLPAPER in "${WALLPAPERS[@]}"; do
    BASENAME=$(basename "$WALLPAPER")
    FILENAME_WITHOUT_EXT="${BASENAME%.*}"
    CAPITALIZED_NAME=$(echo "$FILENAME_WITHOUT_EXT" | sed 's/.*/\u&/')
    FILENAMES+=("$CAPITALIZED_NAME")
done

# If no wallpapers are found, exit the script
if [ ${#FILENAMES[@]} -eq 0 ]; then
    echo "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

# Use rofi with a specific style to select a wallpaper (showing capitalized filenames without extensions)
#SELECTED_NAME=$(printf "%s\n" "${FILENAMES[@]}" | rofi -dmenu -p "Select a wallpaper" -theme ~/.config/rofi/launchers/My_custom_type/wallpaper_switcher_style.rasi)
SELECTED_NAME=$(printf "%s\n" "${FILENAMES[@]}" | rofi -dmenu -p "Select a wallpaper" -theme ~/.config/sway/modules/Wallpaper_swticher/wallpaper_switcher_style.rasi)

# Map the selected name back to the corresponding full path
for i in "${!FILENAMES[@]}"; do
    if [ "${FILENAMES[$i]}" == "$SELECTED_NAME" ]; then
        SELECTED="${WALLPAPERS[$i]}"
        break
    fi
done

# Debugging output
echo "Selected wallpaper: $SELECTED" >> /tmp/wallpaper_switcher.log

# If a wallpaper was selected, update the sway config and reload sway
if [ -n "$SELECTED" ]; then
    # Update the sway configuration file
    sed -i "s|^output \* bg .*|output \* bg $SELECTED fill|" ~/.config/sway/config

    # Reload Sway to apply the changes
    swaymsg reload

    echo "Wallpaper updated and Sway configuration reloaded." >> /tmp/wallpaper_switcher.log
else
    echo "No wallpaper selected." >> /tmp/wallpaper_switcher.log
fi
