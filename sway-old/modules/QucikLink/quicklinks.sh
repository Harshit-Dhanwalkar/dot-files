#!/usr/bin/env bash

## Author  : Harshit Prashant Dhanwalkar
## Github  : @Harshit-Dhanwalkar

## Applets : Quick Links

type="$HOME/.config/sway/modules/QucikLink/My-type"
style='mystyle.rasi'
# style='style-1.rasi'
theme="$type/$style"

# Theme Elements
prompt='Quick Links'
mesg="Attempting to open links in the following order: Firefox, Brave(Brave-broswer), Chromium"

# if [[ "$theme" == *'type-1'* || "$theme" == *'type-3'* || "$theme" == *'type-5'* ]]; then
#     list_col='1'
#     list_row='8'
# elif [[ "$theme" == *'type-2'* || "$theme" == *'type-4'* ]]; then
#     list_col='8'
#     list_row='1'
# fi

# if [[ "$theme" == *'type-1'* || "$theme" == *'type-5'* ]]; then
#     efonts="JetBrains Mono Nerd Font 10"
# else
#     efonts="JetBrains Mono Nerd Font 28"
# fi

if [[ "$theme" == *'My-type'* ]]; then
    list_col='1'
    list_row='7'
fi

if [[ "$theme" == *'My-type'* ]]; then
    efonts="JetBrains Mono Nerd Font 12"
fi

# Options
layout=$(grep 'USE_ICON' "$theme" | cut -d'=' -f2)
if [[ "$layout" == 'NO' ]]; then
    # for more glyphs https://fontawesome.com/v6/search?o=r&m=free
    option_1=" Whatsapp  "
    option_2=" Gmail     "
    option_3=" Github    "
    option_4=" Reddit    "
    option_5="󰙯 Discord   "
    option_6="󰎄 Youtube Music" #  󰎅
    option_7="𝕏 X.com( Twitter)"
#    option_8= "slack"
fi

# Rofi CMD
rofi_cmd() {
    rofi -theme-str "listview {columns: $list_col; lines: $list_row;}" \
        -theme-str 'textbox-prompt-colon {str: "";}' \
        -theme-str "element-text {font: \"$efonts\";}" \
        -dmenu \
        -p "$prompt" \
        -mesg "$mesg" \
        -markup-rows \
        -theme "$theme"
}

# Pass variables to rofi dmenu
run_rofi() {
    echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5\n$option_6\n$option_7" | rofi_cmd
}

# Function to find and use the available browser
open_link() {
    url="$1"
    # browser=$(which chromium 2>/dev/null || which brave 2>/dev/null || which firefox 2>/dev/null)
    browser=$(which firefox 2>/dev/null || which brave 2>/dev/null || which firefox 2>/dev/null)

    if [[ -n "$browser" ]]; then
        "$browser" "$url"
    else
        dunstify -u critical "No compatible browser found!"
    fi
}

# Execute Command
run_cmd() {
    if [[ "$1" == '--opt1' ]]; then
        open_link 'https://web.whatsapp.com/'
    elif [[ "$1" == '--opt2' ]]; then
        open_link 'https://mail.google.com/'
    elif [[ "$1" == '--opt3' ]]; then
        open_link 'https://github.com/Harshit-Dhanwalkar/'
    elif [[ "$1" == '--opt4' ]]; then
        open_link 'https://www.reddit.com/?feed=home/'
    elif [[ "$1" == '--opt5' ]]; then
        open_link 'https://canary.discord.com/channels/@me'
    elif [[ "$1" == '--opt6' ]]; then
        open_link 'https://music.youtube.com/'
    elif [[ "$1" == '--opt7' ]]; then
        open_link 'https://x.com/'
        #    elif [[ "$1" == '--opt8' ]]; then
        #        open_link 'https://www.youtube.com/'
    fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
$option_1)
    run_cmd --opt1
    ;;
$option_2)
    run_cmd --opt2
    ;;
$option_3)
    run_cmd --opt3
    ;;
$option_4)
    run_cmd --opt4
    ;;
$option_5)
    run_cmd --opt5
    ;;
$option_6)
    run_cmd --opt6
    ;;
$option_7)
    run_cmd --opt7
    ;;
#    $option_8)
#        run_cmd --opt8
#        ;;
esac
