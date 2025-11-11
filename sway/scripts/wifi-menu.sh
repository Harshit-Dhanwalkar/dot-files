#!/usr/bin/env bash

## Author  : Harshit Prahant Dhanwalkar
## Github  : @Harshit-Dhanwalkar

# --- Theme Setup (only used if rofi, which is fallback) ---
source "$HOME"/.config/rofi/applets/shared/theme.bash
theme="$type/$style"

# --- Notification Helper ---
notify() {
	if pgrep -x dunst >/dev/null 2>&1; then
		notify-send "$@"
	elif pgrep -x mako >/dev/null 2>&1; then
		notify-send "$@"
	elif command -v notify-send >/dev/null 2>&1; then
		notify-send "$@"
	else
		echo "Notification: $*" >&2
	fi
}

# --- Menu Launcher ---
if command -v dmenu >/dev/null 2>&1; then
	menu() { dmenu -i -l 10 -p "$1"; }
elif command -v rofi >/dev/null 2>&1; then
	menu() {
		rofi -theme-str "window {width: 400px;}" \
			-theme-str "listview {columns: 1; lines: 10;}" \
			-theme-str 'textbox-prompt-colon {str: "";}' \
			-dmenu -i -p "$1" -mesg "Select a network or toggle Wi-Fi" \
			-theme "${theme}"
	}
else
	echo "Error: neither dmenu nor rofi found!" >&2
	notify "Error: neither dmenu nor rofi found!"
	exit 1
fi

# --- Wi-Fi Switcher ---
notify "Scanning for available Wi-Fi networks..."

wifi_list=$(nmcli --fields "SECURITY,SSID" device wifi list | sed 1d |
	sed 's/  */ /g' |
	sed -E "s/WPA*.?\S/ /g" |
	sed "s/^--/ /g" |
	sed "s/  //g" |
	sed "/--/d")

connected=$(nmcli -fields WIFI g)
if [[ "$connected" =~ "enabled" ]]; then
	toggle="󰖪  Disable Wi-Fi"
elif [[ "$connected" =~ "disabled" ]]; then
	toggle="󰖩  Enable Wi-Fi"
fi

chosen_network=$(echo -e "$toggle\n$wifi_list" | uniq -u | menu "Wi-Fi:")
read -r chosen_id <<<"${chosen_network:3}"

if [ -z "$chosen_network" ]; then
	notify "Wi-Fi action cancelled"
	exit 0
elif [ "$chosen_network" = "󰖩  Enable Wi-Fi" ]; then
	nmcli radio wifi on && notify "Wi-Fi enabled"
elif [ "$chosen_network" = "󰖪  Disable Wi-Fi" ]; then
	nmcli radio wifi off && notify "Wi-Fi disabled"
else
	success_message="Connected to \"$chosen_id\"."
	saved_connections=$(nmcli -g NAME connection)

	if echo "$saved_connections" | grep -qw "$chosen_id"; then
		if nmcli connection up id "$chosen_id" | grep -q "successfully"; then
			notify "Connection Established" "$success_message"
		else
			notify "Failed to connect to $chosen_id"
		fi
	else
		if [[ "$chosen_network" =~ "" ]]; then
			wifi_password=$(menu "Password for $chosen_id:")
		fi
		if nmcli device wifi connect "$chosen_id" password "$wifi_password" | grep -q "successfully"; then
			notify "Connection Established" "$success_message"
		else
			notify "Failed to connect to $chosen_id"
		fi
	fi
fi
