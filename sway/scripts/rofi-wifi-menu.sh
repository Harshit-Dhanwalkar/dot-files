#!/usr/bin/env bash

## Author  : Harshit Prahant Dhanwalkar
## Github  : @Harshit-Dhanwalkar

# Import Current Theme
source "$HOME"/.config/rofi/applets/shared/theme.bash
theme="$type/$style"

# Theme Elements
prompt='Wi-Fi'
mesg='Select a network or toggle Wi-Fi'

# Theme-specific Rofi geometry
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
	win_width='620px'
elif [[ ("$theme" == *'type-2'*) || ("$theme" == *'type-4'*) ]]; then
	list_col='6'
	list_row='1'
	win_width='670px'
fi

# The themed Rofi command function
rofi_cmd() {
	rofi -theme-str "window {width: $win_width;}" \
		-theme-str "listview {columns: $list_col; lines: $list_row;}" \
		-theme-str 'textbox-prompt-colon {str: "";}' \
		-dmenu \
		-i \
		-p "$prompt" \
		-mesg "$mesg" \
		-markup-rows \
		-theme ${theme}
}

notify-send "Getting list of available Wi-Fi networks..."
# Get a list of available wifi connections and morph it into a nice-looking list
wifi_list=$(nmcli --fields "SECURITY,SSID" device wifi list | sed 1d | sed 's/  */ /g' | sed -E "s/WPA*.?\S/ /g" | sed "s/^--/ /g" | sed "s/  //g" | sed "/--/d")

connected=$(nmcli -fields WIFI g)
if [[ "$connected" =~ "enabled" ]]; then
	toggle="󰖪  Disable Wi-Fi"
elif [[ "$connected" =~ "disabled" ]]; then
	toggle="󰖩  Enable Wi-Fi"
fi

# Use rofi to select wifi network, using the themed function
chosen_network=$(echo -e "$toggle\n$wifi_list" | uniq -u | rofi_cmd -selected-row 1)

# Get name of connection
read -r chosen_id <<<"${chosen_network:3}"

if [ "$chosen_network" = "" ]; then
	exit
elif [ "$chosen_network" = "󰖩  Enable Wi-Fi" ]; then
	nmcli radio wifi on
elif [ "$chosen_network" = "󰖪  Disable Wi-Fi" ]; then
	nmcli radio wifi off
else
	# Message to show when connection is activated successfully
	success_message="You are now connected to the Wi-Fi network \"$chosen_id\"."
	# Get saved connections
	saved_connections=$(nmcli -g NAME connection)
	if [[ $(echo "$saved_connections" | grep -w "$chosen_id") = "$chosen_id" ]]; then
		nmcli connection up id "$chosen_id" | grep "successfully" && notify-send "Connection Established" "$success_message"
	else
		if [[ "$chosen_network" =~ "" ]]; then
			wifi_password=$(rofi -dmenu -p "Password: " -theme ${theme})
		fi
		nmcli device wifi connect "$chosen_id" password "$wifi_password" | grep "successfully" && notify-send "Connection Established" "$success_message"
	fi
fi
