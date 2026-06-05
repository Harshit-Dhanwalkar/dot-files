#!/usr/bin/env bash

## Author  : Harshit Prashant Dhanwalkar
## Github  : @Harshit-Dhanwalkar

# History file location
HISTORY_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/define-word-history"

# helpers
notify() {
    local urgency="${1:-normal}" title="$2" body="$3" timeout="${4:-60000}"
    if command -v dunstify >/dev/null 2>&1; then
        dunstify -u "$urgency" -t "$timeout" "$title" "$body"
    else
        notify-send -u "$urgency" -t "$timeout" "$title" "$body"
    fi
}

err() { notify critical "$1" "$2" 3000; exit 1; }

# Add word to history (append, keep last 100 entries)
add_to_history() {
    local w="$1"
    echo "$w" >> "$HISTORY_FILE"
    if [[ -f "$HISTORY_FILE" ]]; then
        tail -n 100 "$HISTORY_FILE" > "$HISTORY_FILE.tmp" && mv "$HISTORY_FILE.tmp" "$HISTORY_FILE"
    fi
}

# Prompt for word
word=$(echo "" | dmenu -p "Enter word to define:")
[[ -z "$word" ]] && exit 0
[[ "$word" =~ [\/] ]] && err "Invalid input" "Word contains invalid characters"

# Add to history after validation
add_to_history "$word"

# URL encode function helper
encode() {
    python3 -c "import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1]))" "$1"
}

# Fetch dictionary data with encoded word
encoded_word=$(encode "$word")
query=$(curl -s --connect-timeout 5 --max-time 10 \
    "https://api.dictionaryapi.dev/api/v2/entries/en_US/$encoded_word")
[[ $? -ne 0 ]] && err "Connection error" "Failed to connect to dictionary API"

word_found=true
if [[ "$query" == *"No Definitions Found"* ]]; then
    word_found=false
fi

# Build synonym list
synonyms=""
if $word_found; then
    synonyms=$(echo "$query" | jq -r '
        [ .[0].meanings[].synonyms[] ] | unique | .[]
    ' 2>/dev/null)
fi

# Build acronym list via abbreviations.com
acronym_raw=$(curl -s --connect-timeout 5 --max-time 8 \
    "https://www.abbreviations.com/$word" 2>/dev/null)
acronyms=""
if [[ -n "$acronym_raw" ]]; then
    acronyms=$(echo "$acronym_raw" | \
        grep -oP '(?<=<td class="td3l">)[^<]+' | \
        head -10 | \
        sed 's/^[[:space:]]*//' | \
        grep -v '^$')
fi

# Build dmenu action list
menu_items="[def]  Define: $word"
menu_items+="\n[wiki] Wikipedia: $word"
menu_items+="\n[hist] History"

if [[ -n "$synonyms" ]]; then
    while IFS= read -r syn; do
        [[ -n "$syn" ]] && menu_items+="\n[syn]  Synonym: $syn"
    done <<< "$synonyms"
fi

if [[ -n "$acronyms" ]]; then
    while IFS= read -r acr; do
        [[ -n "$acr" ]] && menu_items+="\n[acr]  Acronym: $acr"
    done <<< "$acronyms"
fi

# Show selection menu
choice=$(echo -e "$menu_items" | dmenu -l 15 -p "Action for \"$word\":")
[[ -z "$choice" ]] && exit 0

# Handle choice
## a. Wikipedia lookup
handle_wikipedia() {
    local search_word="$1"
    local wiki_query
    wiki_query=$(curl -s --connect-timeout 5 --max-time 10 \
        "https://en.wikipedia.org/api/rest_v1/page/summary/$(encode "$search_word")")
    [[ $? -ne 0 ]] && err "Connection error" "Failed to connect to Wikipedia"

    local wiki_title wiki_extract
    wiki_title=$(echo "$wiki_query" | jq -r '.title // empty')
    wiki_extract=$(echo "$wiki_query" | jq -r '.extract // empty')

    if [[ -z "$wiki_extract" ]] || echo "$wiki_query" | grep -q '"type":"disambiguation"'; then
        local dis_query
        dis_query=$(curl -s --connect-timeout 5 --max-time 10 \
            "https://en.wikipedia.org/w/api.php?action=opensearch&search=$(encode "$search_word")&limit=10&format=json")
        local dis_options
        dis_options=$(echo "$dis_query" | jq -r '.[1][]' 2>/dev/null)
        if [[ -z "$dis_options" ]]; then
            notify normal "Wikipedia" "No results found for: $search_word" 4000
            return
        fi
        local dis_choice
        dis_choice=$(echo "$dis_options" | dmenu -l 10 -p "Wikipedia - pick article:")
        [[ -z "$dis_choice" ]] && return
        handle_wikipedia "$dis_choice"
        return
    fi

    local display="${wiki_extract:0:1200}"
    [[ ${#wiki_extract} -gt 1200 ]] && display+="..."
    notify normal "Wikipedia: $wiki_title" "$display"
}

## b. Dictionary definition (with URL encoding)
handle_define() {
    local lookup_word="$1"
    local encoded_lookup=$(encode "$lookup_word")
    local q
    if [[ "$lookup_word" == "$word" ]]; then
        q="$query"
    else
        q=$(curl -s --connect-timeout 5 --max-time 10 \
            "https://api.dictionaryapi.dev/api/v2/entries/en_US/$encoded_lookup")
        [[ $? -ne 0 ]] && err "Connection error" "Failed to connect to dictionary API"
    fi

    if [[ "$q" == *"No Definitions Found"* ]]; then
        notify normal "Word not found" "No definition found for: $lookup_word" 4000
        return
    fi

    local def
    def=$(echo "$q" | jq -r '.[0].meanings[] | "\(.partOfSpeech): \(.definitions[0].definition)\n"')
    if [[ -z "$def" ]] || [[ "$def" == "null" ]]; then
        err "Parse error" "Failed to parse definition for: $lookup_word"
    fi

    notify normal "$lookup_word" "$def"
}

## c. History handler
handle_history() {
    if [[ ! -f "$HISTORY_FILE" ]] || [[ ! -s "$HISTORY_FILE" ]]; then
        notify normal "History" "No search history found" 3000
        return
    fi

    # Build unique recent list (most recent first, no duplicates)
    local history_list
    history_list=$(tac "$HISTORY_FILE" | awk '!seen[$0]++' | head -100)
    local menu="Clear History\n$history_list"
    local hist_choice
    hist_choice=$(echo -e "$menu" | dmenu -l 15 -p "Select word (or Clear History):")
    [[ -z "$hist_choice" ]] && return

    if [[ "$hist_choice" == "Clear History" ]]; then
        rm -f "$HISTORY_FILE"
        notify normal "History" "Search history cleared"
    else
        handle_define "$hist_choice"
    fi
}

# Route the choice
if [[ "$choice" == "[wiki]"* ]]; then
    search="${choice#\[wiki\] Wikipedia: }"
    handle_wikipedia "$search"

elif [[ "$choice" == "[syn]"* ]]; then
    syn_word="${choice#\[syn\]  Synonym: }"
    handle_define "$syn_word"

elif [[ "$choice" == "[acr]"* ]]; then
    acr_text="${choice#\[acr\]  Acronym: }"
    notify normal "Acronym - $word" "$acr_text"

elif [[ "$choice" == "[def]"* ]]; then
    handle_define "$word"

elif [[ "$choice" == "[hist]"* ]]; then
    handle_history
fi
