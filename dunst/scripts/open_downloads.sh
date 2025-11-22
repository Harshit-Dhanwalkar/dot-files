#!/usr/bin/env bash

# FILE=$(echo "$DUNST_BODY" | tail -n 1 | xargs)
FILE=$(echo "$DUNST_BODY" | xargs)

if [ -z "$FILE" ]; then
    exit 0
fi

DOWNLOADS_DIR="$HOME/Downloads"
FULL_PATH="$DOWNLOADS_DIR/$FILE"

if [ ! -f "$FULL_PATH" ]; then
    notify-send -t 3000 "Download Error" "File not found at $FULL_PATH"
    exit 1
fi

if [[ "$FILE" =~ \.(pdf|png|jpe?g)$ ]]; then
    ACTION=$(notify-send \
        --replace-id="$DUNST_ID" \
        -a "Download Action" \
        -i "firefox" \
        "$FILE" \
        --action="open,Open with firefox" \
        --action="ignore,Ignore")

    case "$ACTION" in
        "open")
            # firefox "$FULL_PATH" &
            xdg-open "$FULL_PATH" &
            ;;
        *)
            ;;
    esac

elif [[ "$FILE" =~ \.(xlsx|csv)$ ]]; then
    ACTION=$(notify-send \
        --replace-id="$DUNST_ID" \
        -a "Download Action" \
        -i libreoffice-calc \
        "$FILE" \
        --action="open,Open with Calc" \
        --action="ignore,Ignore")

    case "$ACTION" in
        "open")
            libreoffice --calc "$FULL_PATH" &
            ;;
        *)
            ;;
    esac
fi
