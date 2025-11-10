#!/usr/bin/env bash

## Author  : Harshit Prahant Dhanwalkar
## Github  : @harshitpmd

# Import Current Theme from the shared location
source "$HOME"/.config/rofi/applets/shared/theme.bash
theme="$type/$style"

# Constants
divider=" "
goback="Back"

# Theme Elements
prompt='Bluetooth'
mesg='Manage Connections and Devices'

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
    win_width='520px'
elif [[ ("$theme" == *'type-2'*) || ("$theme" == *'type-4'*) ]]; then
    list_col='6'
    list_row='1'
    win_width='670px'
fi

rofi_cmd() {
    rofi -theme-str "window {width: $win_width;}" \
        -theme-str "listview {columns: $list_col; lines: $list_row;}" \
        -theme-str 'textbox-prompt-colon {str: "";}' \
        -dmenu \
        -p "$prompt" \
        -mesg "$mesg" \
        -markup-rows \
        -theme ${theme}
}

rofi_command="rofi_cmd"

# Checks if bluetooth controller is powered on
power_on() {
    if bluetoothctl show | grep -q "Powered: yes"; then
        return 0
    else
        return 1
    fi
}

# Toggles power state
toggle_power() {
    if power_on; then
        bluetoothctl power off
        show_menu
    else
        if rfkill list bluetooth | grep -q 'blocked: yes'; then
            rfkill unblock bluetooth && sleep 3
        fi
        bluetoothctl power on
        show_menu
    fi
}

# Checks if controller is scanning for new devices
scan_on() {
    if bluetoothctl show | grep -q "Discovering: yes"; then
        echo "Scan: on"
        return 0
    else
        echo "Scan: off"
        return 1
    fi
}

# Toggles scanning state
toggle_scan() {
    if scan_on; then
        kill $(pgrep -f "bluetoothctl --timeout 5 scan on")
        bluetoothctl scan off
        show_menu
    else
        bluetoothctl --timeout 5 scan on
        echo "Scanning..."
        show_menu
    fi
}

# Checks if controller is able to pair to devices
pairable_on() {
    if bluetoothctl show | grep -q "Pairable: yes"; then
        echo "Pairable: on"
        return 0
    else
        echo "Pairable: off"
        return 1
    fi
}

# Toggles pairable state
toggle_pairable() {
    if pairable_on; then
        bluetoothctl pairable off
        show_menu
    else
        bluetoothctl pairable on
        show_menu
    fi
}

# Checks if controller is discoverable by other devices
discoverable_on() {
    if bluetoothctl show | grep -q "Discoverable: yes"; then
        echo "Discoverable: on"
        return 0
    else
        echo "Discoverable: off"
        return 1
    fi
}

# Toggles discoverable state
toggle_discoverable() {
    if discoverable_on; then
        bluetoothctl discoverable off
        show_menu
    else
        bluetoothctl discoverable on
        show_menu
    fi
}

# Checks if a device is connected
device_connected() {
    device_info=$(bluetoothctl info "$1")
    if echo "$device_info" | grep -q "Connected: yes"; then
        return 0
    else
        return 1
    fi
}

# Toggles device connection
toggle_connection() {
    if device_connected "$1"; then
        bluetoothctl disconnect "$1"
        device_menu "$device"
    else
        bluetoothctl connect "$1"
        device_menu "$device"
    fi
}

# Checks if a device is paired
device_paired() {
    device_info=$(bluetoothctl info "$1")
    if echo "$device_info" | grep -q "Paired: yes"; then
        echo "Paired: yes"
        return 0
    else
        echo "Paired: no"
        return 1
    fi
}

# Toggles device paired state
toggle_paired() {
    if device_paired "$1"; then
        bluetoothctl remove "$1"
        device_menu "$device"
    else
        bluetoothctl pair "$1"
        device_menu "$device"
    fi
}

# Checks if a device is trusted
device_trusted() {
    device_info=$(bluetoothctl info "$1")
    if echo "$device_info" | grep -q "Trusted: yes"; then
        echo "Trusted: yes"
        return 0
    else
        echo "Trusted: no"
        return 1
    fi
}

# Toggles device connection
toggle_trust() {
    if device_trusted "$1"; then
        bluetoothctl untrust "$1"
        device_menu "$device"
    else
        bluetoothctl trust "$1"
        device_menu "$device"
    fi
}

# Prints a short string with the current bluetooth status
print_status() {
    if power_on; then
        printf ''

        paired_devices_cmd="devices Paired"
        # Check if an outdated version of bluetoothctl is used to preserve backwards compatibility
        if (($(echo "$(bluetoothctl version | cut -d ' ' -f 2) < 5.65" | bc -l))); then
            paired_devices_cmd="paired-devices"
        fi

        mapfile -t paired_devices < <(bluetoothctl $paired_devices_cmd | grep Device | cut -d ' ' -f 2)
        counter=0

        for device in "${paired_devices[@]}"; do
            if device_connected "$device"; then
                device_alias=$(bluetoothctl info "$device" | grep "Alias" | cut -d ' ' -f 2-)

                if [ $counter -gt 0 ]; then
                    printf ", %s" "$device_alias"
                else
                    printf " %s" "$device_alias"
                fi

                ((counter++))
            fi
        done
        printf "\n"
    else
        echo ""
    fi
}

# A submenu for a specific device that allows connecting, pairing, and trusting
device_menu() {
    device=$1

    # Get device name and mac address
    device_name=$(echo "$device" | cut -d ' ' -f 3-)
    mac=$(echo "$device" | cut -d ' ' -f 2)

    # Build options
    if device_connected "$mac"; then
        connected="Connected: yes"
    else
        connected="Connected: no"
    fi
    paired=$(device_paired "$mac")
    trusted=$(device_trusted "$mac")
    options="$connected\n$paired\n$trusted\n$divider\n$goback\nExit"

    # Open rofi menu, read chosen option
    chosen="$(echo -e "$options" | $rofi_command "$device_name")"

    # Match chosen option to command
    case "$chosen" in
    "" | "$divider")
        echo "No option chosen."
        ;;
    "$connected")
        toggle_connection "$mac"
        ;;
    "$paired")
        toggle_paired "$mac"
        ;;
    "$trusted")
        toggle_trust "$mac"
        ;;
    "$goback")
        show_menu
        ;;
    esac
}

# Opens a rofi menu with current bluetooth status and options to connect
show_menu() {
    # Get menu options
    if power_on; then
        power="Power: on"

        # Human-readable names of devices, one per line
        # If scan is off, will only list paired devices
        devices=$(bluetoothctl devices | grep Device | cut -d ' ' -f 3-)

        # Get controller flags
        scan=$(scan_on)
        pairable=$(pairable_on)
        discoverable=$(discoverable_on)

        # Options passed to rofi
        options="$devices\n$divider\n$power\n$scan\n$pairable\n$discoverable\nExit"
        # echo -e "$devices\n$divider\n$power\n$scan\n$pairable\n$discoverable\nExit"
    else
        power="Power: off"
        options="$power\nExit"
        # echo -e "power\nExit"
    fi

    # Open rofi menu, read chosen option
    chosen="$(echo -e "$options" | $rofi_command " Bluetooth")"

    # Match chosen option to command
    case "$chosen" in
    "" | "$divider")
        echo "No option chosen."
        ;;
    "$power")
        toggle_power
        ;;
    "$scan")
        toggle_scan
        ;;
    "$discoverable")
        toggle_discoverable
        ;;
    "$pairable")
        toggle_pairable
        ;;
    *)
        device=$(bluetoothctl devices | grep "$chosen")
        # Open a submenu if a device is selected
        if [[ $device ]]; then device_menu "$device"; fi
        ;;
    esac
}

# The execution block
case "$1" in
--status)
    print_status
    ;;
*)
    show_menu
    ;;
esac
