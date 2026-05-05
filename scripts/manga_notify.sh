#!/bin/env bash

## Author  : Harshit Prashant Dhanwalkar
## Github  : @Harshit-Dhanwalkar

# Configuration
URL="https://mangafire.to/manga/one-piecee.dkw"
CACHE_FILE="$HOME/.cache/one_piece_chapter"
USER_AGENT="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
NOTIFY="/usr/bin/dunstify"

check_manga() {
    # Fetch raw HTML
    RAW_HTML=$(curl -s -L -A "$USER_AGENT" "$URL")

    # Extract latest chapter number
    LATEST_CH=$(echo "$RAW_HTML" | grep -oP 'chapter-\K[0-9.]+' | head -n 1)

    # Extract the release date
    LATEST_DATE=$(echo "$RAW_HTML" | grep -oP '(?<=<span>)[A-Z][a-z]{2} [0-9]{1,2}, [0-9]{4}' | head -n 1)

    # Fallback if the date format is different
    if [[ -z "$LATEST_DATE" ]]; then
        LATEST_DATE=$(echo "$RAW_HTML" | grep -oP '(?<=<span>)[0-9]+ (days|hours|mins) ago' | head -n 1)
    fi

    if [[ -n "$LATEST_CH" ]]; then
        # cache if it doesn't exist
        [[ ! -f "$CACHE_FILE" ]] && echo "0" > "$CACHE_FILE"
        LAST_SAVED=$(cat "$CACHE_FILE")

        if [[ "$LATEST_CH" != "$LAST_SAVED" ]]; then
            TITLE="One Piece Update"
            MESSAGE="New Chapter: $LATEST_CH\nReleased: ${LATEST_DATE:-Unknown Date}"
            $NOTIFY -u normal -a "MangaFire" "$TITLE" "$MESSAGE"
            # Update cache
            echo "$LATEST_CH" > "$CACHE_FILE"
        fi
    fi
}

while true; do
    check_manga
    sleep 1800
done
