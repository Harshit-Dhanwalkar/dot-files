#!/usr/bin/env bash

## Author  : Harshit Prahant Dhanwalkar
## Github  : @Harshit-Dhanwalkar

: <<'END_COMMENT'
How to use sxiv selection:
    Run the script / Bing key in Sway config 
    - `sxiv` will open in thumbnail mode showing all wallpapers
    - Press `m` to mark the images you want to select (marked images will have a red border)
    - Press `q` to quit - sxiv will output the paths of marked images
    The script will use the first marked image as your wallpaper

Alternative sxiv keybindings:
    - `Enter` - Open image in full view (press `q` to return to thumbnails)
    - `m` - Mark/unmark image for selection
    - `q` - Quit and output marked files
    - `Ctrl+m` - Mark all images
    - `Ctrl+u` - Unmark all images
END_COMMENT

# Directory containing your wallpapers
WALLPAPER_DIR="$HOME/Pictures/wallpapers"

# Initialize arrays
WALLPAPERS=()
FILENAMES=()

# Find wallpapers safely
while IFS= read -r -d $'\0' file; do
    WALLPAPERS+=("$file")
    BASENAME=$(basename "$file")
    FILENAME_WITHOUT_EXT="${BASENAME%.*}"
    # Capitalize first letter of each word
    CAPITALIZED_NAME=$(echo "$FILENAME_WITHOUT_EXT" | sed 's/\b\(.\)/\u\1/g')
    FILENAMES+=("$CAPITALIZED_NAME")
done < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) -print0 2>/dev/null)

# If no wallpapers are found, exit the script
if [ ${#FILENAMES[@]} -eq 0 ]; then
    echo "No wallpapers found in $WALLPAPER_DIR" >>/tmp/wallpaper_switcher.log
    exit 1
fi

# Select wallpaper using sxiv, dmenu, or rofi
SELECTED_NAME=""
SELECTED=""

if command -v sxiv >/dev/null 2>&1; then
    # Use sxiv in selection mode - press 'q' to quit and output selected files
    SELECTED=$(printf "%s\n" "${WALLPAPERS[@]}" | sxiv -tio - 2>/dev/null | head -n1)

    if [ -n "$SELECTED" ]; then
        # Extract the base name for logging
        BASENAME=$(basename "$SELECTED")
        FILENAME_WITHOUT_EXT="${BASENAME%.*}"
        SELECTED_NAME=$(echo "$FILENAME_WITHOUT_EXT" | sed 's/\b\(.\)/\u\1/g')
        echo "Selected via sxiv: $SELECTED" >>/tmp/wallpaper_switcher.log
    else
        echo "No selection made in sxiv" >>/tmp/wallpaper_switcher.log
    fi
elif command -v dmenu >/dev/null 2>&1; then
    SELECTED_NAME=$(printf "%s\n" "${FILENAMES[@]}" | dmenu -l 15 -i -p "Select a wallpaper")

    # Map the selected name back to the corresponding full path
    for i in "${!FILENAMES[@]}"; do
        if [ "${FILENAMES[$i]}" == "$SELECTED_NAME" ]; then
            SELECTED="${WALLPAPERS[$i]}"
            break
        fi
    done
elif command -v rofi >/dev/null 2>&1; then
    SELECTED_NAME=$(printf "%s\n" "${FILENAMES[@]}" | rofi -dmenu -p "Select a wallpaper" -theme ~/.config/sway/modules/Wallpaper_swticher/wallpaper_switcher_style.rasi)

    # Map the selected name back to the corresponding full path
    for i in "${!FILENAMES[@]}"; do
        if [ "${FILENAMES[$i]}" == "$SELECTED_NAME" ]; then
            SELECTED="${WALLPAPERS[$i]}"
            break
        fi
    done
else
    echo "Error: Neither sxiv, rofi nor dmenu could be found." >>/tmp/wallpaper_switcher.log
    exit 1
fi

# If user cancelled selection, exit
if [ -z "$SELECTED" ]; then
    echo "No wallpaper selected." >>/tmp/wallpaper_switcher.log
    exit 0
fi

# Debugging output
echo "Selected wallpaper: $SELECTED" >>/tmp/wallpaper_switcher.log

# If a wallpaper was selected, update the sway config and reload sway
if [ -n "$SELECTED" ]; then
    # Update the sway configuration file
    sed -i "s|^output \* bg .*|output \* bg $SELECTED fill|" ~/.config/sway/config
    # Reload Sway to apply the changes
    swaymsg reload

    echo "Wallpaper updated and Sway configuration reloaded." >>/tmp/wallpaper_switcher.log
else
    echo "Selected wallpaper not found: $SELECTED_NAME" >>/tmp/wallpaper_switcher.log
fi
