#!/usr/bin/env bash

## Author  : Harshit Prashant Dhanwalkar
## Github  : @Harshit-Dhanwalkar

# bold=$(tput bold) # Print text bold with echo, for visual clarity
# normal=$(tput sgr0) # Reset text to normal
# echo "${bold}Definition of $word"
# echo "${normal}$def"

word=$(echo "" | dmenu -p "Enter word to define:")
[[ -z "$word" ]] && exit 0

[[ "$word" =~ [\/] ]] && dunstify -u critical -t 3000 "Invalid input" "Word contains invalid characters" && exit 0

# API request
query=$(curl -s --connect-timeout 5 --max-time 10 "https://api.dictionaryapi.dev/api/v2/entries/en_US/$word")

# Check for connection error
if [ $? -ne 0 ]; then
    dunstify -u critical -t 3000 "Connection error" "Failed to connect to dictionary API"
    exit 1
fi

# Invalid word response
if [[ "$query" == *"No Definitions Found"* ]] || [[ "$query" == *"title"*"No Definitions Found"* ]]; then
    dunstify -u normal -t 3000 "Word not found" "No definition found for: $word"
    exit 0
fi

# Extract definitions with part of speech
# def=$(echo "$query" | jq -r '
#   .[0].meanings[0:2] | 
#   map("\(.partOfSpeech):\n  \(.definitions[0:2] | map("• \(.definition)") | join("\n  "))") |
#   join("\n\n")
# ')

# Show first definition for each part of speech
def=$(echo "$query" | jq -r '.[0].meanings[] | "\(.partOfSpeech): \(.definitions[0].definition)\n"')

# Show all definitions
# def=$(echo "$query" | jq -r '.[].meanings[] | "\n\(.partOfSpeech). \(.definitions[].definition)"')

# Regex + grep for just definition, if prefers that to jq
# def=$(grep -Po '"definition":"\K(.*?)(?=")' <<< "$query")


# Check if jq succeeded
if [[ -z "$def" ]] || [[ "$def" == "null" ]]; then
    dunstify -u critical -t 3000 "Error" "Failed to parse definition for: $word"
    exit 1
fi

# Use dunstify (if available, otherwise fallback to notify-send)
if command -v dunstify >/dev/null 2>&1; then
    dunstify -t 60000 "$word" "$def"
else
    notify-send -t 60000 "$word" "$def"
fi
