#!/usr/bin/env bash

## Author  : Harshit Prahant Dhanwalkar
## Github  : @harshitpmd

# Import Current Theme
source "$HOME"/.config/rofi/applets/shared/theme.bash
theme="$type/$style"

# Theme Elements
prompt='Screenshot'
mesg="Saved in DIR: $(xdg-user-dir PICTURES)/Screenshots/"

if [[ "$theme" == *'type-1'* ]]; then
	list_col='1'
	list_row='6'
	win_width='400px'
elif [[ "$theme" == *'type-3'* ]]; then
	list_col='1'
	list_row='6'
	win_width='120px'
elif [[ "$theme" == *'type-5'* ]]; then
	list_col='1'
	list_row='6'
	win_width='520px'
elif [[ ("$theme" == *'type-2'*) || ("$theme" == *'type-4'*) ]]; then
	list_col='6'
	list_row='1'
	win_width='670px'
fi

# Options
layout=$(cat ${theme} | grep 'USE_ICON' | cut -d'=' -f2)
if [[ "$layout" == 'NO' ]]; then
	option_1=" Capture Desktop"
	option_2="󰹑 Capture Area"
	option_3=" Capture Window"
	option_4="󱎫 Capture in 5s"
	option_5="󱎫 Capture in 10s"
else
	option_1=" "
	option_2="󰹑 "
	option_3=" "
	option_4="󱎫 "
	option_5="󱎫 "
fi

# Rofi CMD
rofi_cmd() {
	rofi -theme-str "window {width: $win_width;}" \
		-theme-str "listview {columns: $list_col; lines: $list_row;}" \
		-theme-str 'textbox-prompt-colon {str: "";}' \
		-dmenu \
		-p "$prompt" \
		-mesg "$mesg" \
		-markup-rows \
		-theme ${theme}
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5" | rofi_cmd
}

# Screenshot
time=$(date +%Y-%m-%d-%H-%M-%S)
#geometry=$(swaymsg -t get_outputs | jq -r '[.[] | select(.focused).current_mode.width, .[] | select(.focused).current_mode.height] | "\(.[0])x\(.[1])"')
dir="$(xdg-user-dir PICTURES)/Screenshots"
#file="Screenshot_${time}_${geometry}.png"
file="Screenshot_${time}.png"

if [[ ! -d "$dir" ]]; then
	mkdir -p "$dir"
fi

# notify and view screenshot
notify_view() {
	notify_cmd_shot='dunstify -u low -t 3000 --replace=699'
	${notify_cmd_shot} "Copied to clipboard."
	sxiv ${dir}/"$file"
	if [[ -e "$dir/$file" ]]; then
		${notify_cmd_shot} "Screenshot Saved."
	else
		${notify_cmd_shot} "Screenshot Deleted."
	fi
}

# Copy screenshot to clipboard
copy_shot() {
	cat "$file" | grim - | wl-copy
}

# countdown
countdown() {
	for sec in $(seq $1 -1 1); do
		dunstify -t 1000 --replace=699 "Taking shot in : $sec"
		sleep 1
	done
}

# take shots
shotnow() {
	cd ${dir} && grim ${file}
	notify_view
}

shot5() {
	countdown '5'
	sleep 1 && cd ${dir} && grim ${file}
	notify_view
}

shot10() {
	countdown '10'
	sleep 1 && cd ${dir} && grim ${file}
	notify_view
}

shotwin() {
	cd ${dir} && grim -g "$(swaymsg -t get_tree | jq -r '.. | select(.focused? == true).rect | "\(.x),\(.y) \(.width)x\(.height)"')" ${file}
	notify_view
}

shotarea() {
	cd ${dir} && grim -g "$(slurp)" ${file}
	notify_view
}

# Execute Command
run_cmd() {
	if [[ "$1" == '--opt1' ]]; then
		shotnow
	elif [[ "$1" == '--opt2' ]]; then
		shotarea
	elif [[ "$1" == '--opt3' ]]; then
		shotwin
	elif [[ "$1" == '--opt4' ]]; then
		shot5
	elif [[ "$1" == '--opt5' ]]; then
		shot10
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
esac
