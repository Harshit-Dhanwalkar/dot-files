#!/usr/bin/env bash

# Current Theme
dir="$HOME/.config/sway/modules/powermenu/"
style='my_style.rasi'

# CMDs
lastlogin="$(last $USER | head -n1 | tr -s ' ' | cut -d' ' -f5,6,7)"
uptime="$(uptime -p | sed -e 's/up //g')"
host=$(hostname)

# Options
# $lock\n$suspend\n$logout\n$reboot\n$shutdown
lock=''
suspend='󰤄'
logout='󰍃'
reboot='↻'
shutdown='⏻'
hibernate='⏼'
yes='✔'
no='✘'

# Rofi CMD
rofi_cmd() {
	rofi -dmenu \
		-p " $USER@$host" \
		-mesg "󱑇 Uptime: $uptime" \
		-theme ${dir}/${style}
}

# Confirmation CMD
confirm_cmd() {
	rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 350px;}' \
		-theme-str 'mainbox {orientation: vertical; children: [ "message", "listview" ];}' \
		-theme-str 'listview {columns: 2; lines: 1;}' \
		-theme-str 'element-text {horizontal-align: 0.5;}' \
		-theme-str 'textbox {horizontal-align: 0.5;}' \
		-dmenu \
		-p 'Confirmation' \
		-mesg 'Are you Sure?' \
		-theme ${dir}/${theme}.rasi
}

# Ask for confirmation
confirm_exit() {
	echo -e "$yes\n$no" | confirm_cmd
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | rofi_cmd
}

# Execute Command
run_cmd() {
	selected="$(confirm_exit)"
	if [[ "$selected" == "$yes" ]]; then
		if [[ $1 == '--shutdown' ]]; then
			systemctl poweroff
		elif [[ $1 == '--reboot' ]]; then
			systemctl reboot
		elif [[ $1 == '--suspend' ]]; then
			mpc -q pause
			amixer set Master mute
			systemctl suspend
		elif [[ $1 == '--logout' ]]; then
			if [[ "$DESKTOP_SESSION" == 'openbox' ]]; then
				openbox --exit
			elif [[ "$DESKTOP_SESSION" == 'bspwm' ]]; then
				bspc quit
			elif [[ "$DESKTOP_SESSION" == 'i3' ]]; then
				i3-msg exit
			elif [[ "$DESKTOP_SESSION" == 'plasma' ]]; then
				qdbus org.kde.ksmserver /KSMServer logout 0 0 0
			elif [[ "$DESKTOP_SESSION" == 'sway' ]]; then
				# Use swaynag for logout confirmation in sway
				swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -B 'Yes, exit sway' 'swaymsg exit'
			fi
		fi
	else
		exit 0
	fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
$shutdown)
	run_cmd --shutdown
	;;
$reboot)
	run_cmd --reboot
	;;
$lock)
	if [[ -x '/usr/bin/swaylock' ]]; then
		swaylock -C ~/.config/sway/swaylock/config
	else
		notify-send "Swaylock not found!" "Please install swaylock to use the lock feature."
	fi
	;;
$suspend)
	run_cmd --suspend
	;;
$logout)
	run_cmd --logout
	;;
esac
