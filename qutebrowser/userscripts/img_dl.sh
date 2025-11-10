#!/bin/bash

## Author  : Harshit Prahant Dhanwalkar
## Github  : @Harshit-Dhanwalkar

URL="$1"
TARGET_DIR="$2"

# FILENAME_BASE=$(echo "$URL" | sed -E 's/https?:\/\/[^\/]+//' | cut -d '?' -f 1)
# FILENAME_BASE=$(basename "$FILENAME_BASE")
# if [ -z "$FILENAME_BASE" ]; then
#     FILENAME_BASE="image_$(date +%s)"
# fi

CONTENT_TYPE=$(curl -s -I -L "$URL" | awk -F': ' '/^Content-Type/ {print $2}' | tr -d '\r')
case "$CONTENT_TYPE" in
*image/jpeg*) EXTENSION=".jpg" ;;
*image/png*) EXTENSION=".png" ;;
*image/gif*) EXTENSION=".gif" ;;
*image/webp*) EXTENSION=".webp" ;;
*image/svg+xml*) EXTENSION=".svg" ;;
*) EXTENSION=".jpg" ;; # Fallback for unknown types
esac

TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
FINAL_NAME="${TIMESTAMP}${EXTENSION}"
# FINAL_NAME="${FILENAME_BASE}${EXTENSION}"
FULL_PATH="${TARGET_DIR}/images"

mkdir -p "$FULL_PATH"

# wget --content-disposition -P "$FULL_PATH" -O "$FULL_PATH/$FINAL_NAME" -c "$URL"
wget -P "$FULL_PATH" -O "$FULL_PATH/$FINAL_NAME" -c "$URL"
