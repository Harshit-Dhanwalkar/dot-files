#!/usr/bin/env bash

## Author  : Harshit Prashant Dhanwalkar
## Github  : @Harshit-Dhanwalkar

# Dependencies: dmenu, dunstify, firefox/brave-browser/chromium-browser

# Title
prompt="Quick Links"
message="Attempting to open links in: Firefox → Brave → Chromium"

# Menu entries
options=(
  "  Github"
  "  Whatsapp"
  "  Gmail"
  "󰎄  Youtube Music" #   󰎅 
  "  Reddit"
  "󰙯  Discord"
  "𝕏  X.com ( Twitter)"
  "  LinkedIn"
  # "  Slack"
  "  One Piece"
)

# Function to find available browser
open_link() {
  local url="$1"
  local browser=""

  for b in firefox brave chromium google-chrome; do
    if command -v "$b" &>/dev/null; then
      browser="$b"
      break
    fi
  done

  if [[ -n "$browser" ]]; then
    "$browser" "$url" &
    command -v dunstify &>/dev/null && dunstify -u low "Opening $browser" "$url" || echo -e "Opeing \e[34m$url\e[0m in $browser" >&2
  else
    command -v dunstify &>/dev/null && dunstify -u critical "No browser found!" || echo "No browser found!" >&2
  fi
}

# Build menu
chosen=$(printf "%s\n" "${options[@]}" | dmenu -i -l 9 -p "$prompt")

# Handle cancel
[[ -z "$chosen" ]] && exit 0

# Match choice → URL
case "$chosen" in
*Github*) open_link "https://github.com/Harshit-Dhanwalkar/" ;;
*Whatsapp*) open_link "https://web.whatsapp.com/" ;;
*Gmail*) open_link "https://mail.google.com/" ;;
*Youtube*) open_link "https://music.youtube.com/" ;;
*Reddit*) open_link "https://www.reddit.com/?feed=home/" ;;
*Discord*) open_link "https://canary.discord.com/channels/@me" ;;
*X.com* | *Twitter*) open_link "https://x.com/" ;;
*LinkedIn*) open_link "https://www.linkedin.com/in/harshit-dhanwalkar/" ;;
*One* | *Piece*) open_link "https://mangafire.to/manga/one-piecee.dkw" ;;
esac
