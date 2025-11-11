#!/usr/bin/env bash

## Author  : Harshit Prashant Dhanwalkar
## Github  : @Harshit-Dhanwalkar

## Applets : Quick Links Opener (Dmenu Primary, Rofi Secondary)

# --- Configuration & Commands ---
DMENU_CMD="/usr/bin/local/dmenu"
ROFI_CMD="/usr/bin/rofi"
NOTIFY="/usr/bin/notify-send"
PROMPT='Quick Links'

# --- Link Data Array ---
# Format: "Menu_Text:URL"
links=(
  " Whatsapp:https://web.whatsapp.com/"
  " Gmail:https://mail.google.com/"
  " Github:https://github.com/Harshit-Dhanwalkar/"
  " Reddit:https://www.reddit.com/?feed=home/"
  "󰙯 Discord:https://canary.discord.com/channels/@me"
  "󰎄 Youtube Music:https://music.youtube.com/"
  "𝕏 X.com( Twitter):https://x.com/"
)

# --- Browser Logic (Unchanged) ---

open_link() {
  local url="$1"
  local browser=$(which firefox 2>/dev/null || which brave 2>/dev/null || which chromium 2>/dev/null)

  if [[ -n "$browser" ]]; then
    "$browser" "$url"
  else
    $NOTIFY -u critical "No Browser" "No compatible browser found (Firefox/Brave/Chromium)!"
  fi
}

# --- Menu Command Execution ---

menu_exec() {
  local menu_input="$1"
  local chosen_menu_tool=""
  local -a chosen_args=() # Array to hold arguments safely

  if command -v $DMENU_CMD &>/dev/null; then
    # 1. Dmenu execution (Priority)
    chosen_menu_tool=$DMENU_CMD
    # Arguments stored in an array to ensure '-p' and 'Quick Links' are separate args
    chosen_args=(-l ${#links[@]} -p "$PROMPT")
    # Note: -i flag removed as it caused previous issues

  elif command -v $ROFI_CMD &>/dev/null; then
    # 2. Rofi fallback execution
    chosen_menu_tool=$ROFI_CMD
    # Rofi arguments, also stored in an array
    chosen_args=(-dmenu -p "$PROMPT" -mesg 'Opening link...' -markup-rows)

    # Add Rofi theming arguments (optional)
    local -a ROFI_THEME_OPTS=()
    ROFI_THEME_OPTS+=("-theme-str" "listview {columns: 1; lines: ${#links[@]};}")
    ROFI_THEME_OPTS+=("-theme-str" "textbox-prompt-colon {str: \"\";}")
    ROFI_THEME_OPTS+=("-theme-str" "element-text {font: \"JetBrains Mono Nerd Font 12\";}")
    ROFI_THEME_OPTS+=("-theme-str" "element-text {horizontal-align: 0.0;}")

    chosen_args+=("${ROFI_THEME_OPTS[@]}")
  else
    # 3. No menu tool found
    $NOTIFY -u critical "Error" "Neither dmenu nor rofi found. Cannot open menu."
    exit 1
  fi

  # Execute the menu safely using array expansion ("${chosen_args[@]}")
  echo -e "$menu_input" | "$chosen_menu_tool" "${chosen_args[@]}"
}

# --- Main Logic ---

# 1. Generate Menu Input (only the visible names)
menu_options=$(printf "%s\n" "${links[@]%%:*}")

# 2. Run Menu and Capture Selection
chosen_option=$(menu_exec "$menu_options")

# 3. Handle Exit/Cancel
if [ -z "$chosen_option" ]; then
  $NOTIFY "Quick Links" "Menu cancelled."
  exit 0
fi

# 4. Search for the URL corresponding to the selected name
selected_url=""

for link_pair in "${links[@]}"; do
  # Check if the pair starts with the chosen option name
  if [[ "$link_pair" == "$chosen_option":* ]]; then
    selected_url="${link_pair#*:}" # Extract the part after the colon (the URL)
    break
  fi
done

# 5. Execute Action
if [ -n "$selected_url" ]; then
  open_link "$selected_url"
else
  $NOTIFY -u critical "Error" "Could not find URL for '$chosen_option'."
fi
