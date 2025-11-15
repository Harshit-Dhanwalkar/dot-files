#!/usr/bin/env bash

## Author  : Harshit Prashant Dhanwalkar
## Github  : @Harshit-Dhanwalkar

# Dependencies: dmenu, dunstify, firefox/brave/chromium

# Title
prompt="Quick Links"
message="Attempting to open links in: Firefox → Brave → Chromium"

# Menu entries
options=(
  "  Whatsapp"
  "  Gmail"
  "  Github"
  "  Reddit"
  "󰙯  Discord"
  "󰎄  Youtube Music" #   󰎅 
  "𝕏  X.com ( Twitter)"
  "  Slack"
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
  else
    command -v dunstify &>/dev/null && dunstify -u critical "No browser found!" || echo "No browser found!" >&2
  fi
}

# Build menu
chosen=$(printf "%s\n" "${options[@]}" | dmenu -i -l 10 -p "$prompt")
# chosen=$(printf "%s\n" "${options[@]}" | dmenu -i -p "$prompt")

# Handle cancel
[[ -z "$chosen" ]] && exit 0

# Match choice → URL
case "$chosen" in
*Whatsapp*) open_link "https://web.whatsapp.com/" ;;
*Gmail*) open_link "https://mail.google.com/" ;;
*Github*) open_link "https://github.com/Harshit-Dhanwalkar/" ;;
*Reddit*) open_link "https://www.reddit.com/?feed=home/" ;;
*Discord*) open_link "https://canary.discord.com/channels/@me" ;;
*Youtube*) open_link "https://music.youtube.com/" ;;
*X.com* | *Twitter*) open_link "https://x.com/" ;;
*OncePiece) open_link "https://mangafire.to/manga/one-piecee.dkw" ;;
esac
