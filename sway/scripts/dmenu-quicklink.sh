#!/usr/bin/env bash

## Author  : Harshit Prashant Dhanwalkar
## Github  : @Harshit-Dhanwalkar

# Dependencies: dmenu, dunstify, firefox/brave-browser/chromium-browser

# Title
prompt="Quick Links"
message="Attempting to open links in: Firefox -> Brave -> Chromium"

# Menu entries
options=(
  "  Github"
  "  Gmail"
  " Sourcehut"
  "  Whatsapp"
  "󰎄  Youtube Music" #   󰎅 
  "  Youtube"
  "  LeetCode"
  "  Reddit"
  "󰈢  Notion" # 󰇱  󰗀 󰈙 
  "󰙯  Discord"
  "𝕏  X.com ( Twitter)"
  "  LinkedIn"
  # "  Slack"
  # " Telegram"
  "  One Piece"
)

# Function to find available browser
open_link() {
  local url="$1"
  local browser=""
  local notification_id=$RANDOM

  for b in firefox brave chromium google-chrome; do
    if command -v "$b" &>/dev/null; then
      browser="$b"
      break
    fi
  done

  if [[ -n "$browser" ]]; then
    "$browser" "$url" &
    if command -v dunstify &>/dev/null; then
      dunstify -u low -t 3000 -r "$notification_id" "Opening $browser" "$url"
    else
      echo -e "Opening \e[34m$url\e[0m in $browser" >&2
    fi
  else
    if command -v dunstify &>/dev/null; then
      dunstify -u critical -t 3000 -r "$notification_id" "No browser found!"
    else
      echo "No browser found!" >&2
    fi
  fi
}

# Build menu
chosen=$(printf "%s\n" "${options[@]}" | dmenu -l 13 -p "$prompt")

# Handle cancel
[[ -z "$chosen" ]] && exit 0

case "$chosen" in
*"Github"*) open_link "https://github.com/Harshit-Dhanwalkar/" ;;
*"Gmail"*) open_link "https://mail.google.com/" ;;
*"Sourcehut"*) open_link "https://git.sr.ht/" ;;
*"Whatsapp"*) open_link "https://web.whatsapp.com/" ;;
*"Youtube Music"*) open_link "https://music.youtube.com/" ;;
*"Youtube"*) open_link "https://youtube.com/" ;;
*"LeetCode"*) open_link "https://leetcode.com/problems/" ;;
*"Reddit"*) open_link "https://www.reddit.com/?feed=home/" ;;
*"Notion"*) open_link "https://www.notion.so/" ;;
*"Discord"*) open_link "https://canary.discord.com/channels/@me" ;;
*"X.com"* | *Twitter*) open_link "https://x.com/" ;;
*"LinkedIn"*) open_link "https://www.linkedin.com/in/harshit-dhanwalkar/" ;;
*One* | *Piece*) open_link "https://mangafire.to/manga/one-piecee.dkw" ;;
esac
