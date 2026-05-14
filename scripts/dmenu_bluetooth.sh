#!/usr/bin/env bash

## Author  : Harshit Prashant Dhanwalkar
## Github  : @Harshit-Dhanwalkar

# --- Notification Helper ---
notify() {
    local title="$1"
    local message="$2"
    local urgency="${3:-normal}"

    if pgrep -x dunst >/dev/null 2>&1; then
        # Use -u for urgency
        notify-send -u "$urgency" "$title" "$message"
    elif pgrep -x mako >/dev/null 2>&1; then
        notify-send "$title" "$message"
    elif command -v notify-send >/dev/null 2>&1; then
        notify-send "$title" "$message"
    else
        echo "Notification ($urgency): $title - $message" >&2
    fi
}

# --- Dmenu Launcher ---
if ! command -v dmenu >/dev/null 2>&1; then
    echo "Error: dmenu not found!" >&2
    notify "Error: dmenu not found!" "Please install dmenu." "critical"
    exit 1
fi

menu() {
    dmenu -i -l 10 -p "$1"
}

# --- Bluetooth Functions ---
## Checks if bluetooth controller is powered on
power_on() {
    bluetoothctl show | grep -F -q "Powered: yes"
}

## Toggles power state
toggle_power() {
    if power_on; then
        bluetoothctl power off
        notify "Bluetooth Disabled" "Power is OFF"
    else
        # Unblock if hardware is soft-blocked
        if rfkill list bluetooth | grep -F -q 'blocked: yes'; then
            rfkill unblock bluetooth && sleep 3
        fi
        bluetoothctl power on
        notify "Bluetooth Enabled" "Power is ON"
    fi
}

## Checks if a device is connected
device_connected() {
    if [[ ${#1} -eq 17 ]]; then
        bluetoothctl info "$1" | grep -F -q "Connected: yes"
    fi
}

## Toggles device connection (Connect/Disconnect)
toggle_connection() {
    mac="$1"
    device_name="$2"

    if device_connected "$mac"; then
        notify "Disconnecting..." "from $device_name"
        bluetoothctl disconnect "$mac"
        notify "Disconnected" "from $device_name"
    else
        notify "Connecting..." "to $device_name"
        bluetoothctl connect "$mac"
        # Wait a moment for connection to establish before checking status
        sleep 1
        if device_connected "$mac"; then
            notify "Connection Successful" "Connected to $device_name"
        else
            notify "Connection Failed" "Could not connect to $device_name" "critical"
            # Attempt to pair if connection failed, assuming it's an un-paired device
            if ! bluetoothctl info "$mac" | grep -F -q "Paired: yes"; then
                 notify "Pairing Attempt" "Attempting to pair with $device_name"
                 bluetoothctl pair "$mac"
            fi
        fi
    fi
}

# --- Main Menu Logic ---
show_menu() {
    # Check if bluetooth daemon is running
    if command -v systemctl >/dev/null 2>&1; then
        if ! systemctl is-active --quiet bluetooth; then
            notify "Bluetooth Daemon" "Attempting to start bluetooth service..." "normal"
            systemctl start bluetooth || { notify "Error" "Failed to start bluetooth daemon" "critical"; exit 1; }
        fi
    fi

    if power_on; then
        toggle_option="[OFF] Disable Bluetooth"
        notify "Scanning for devices..." "Listing paired and discovered devices."

        # Get list of devices (Paired and Discovered)
        device_list=$(bluetoothctl devices | grep -F Device | while read -r line; do
            mac=$(echo "$line" | cut -d ' ' -f 2)
            alias=$(echo "$line" | cut -d ' ' -f 3-)
            status_tag="[ ]" # Default for Disconnected device

            if device_connected "$mac"; then
                status_tag="[C]" # [C] for Connected
            fi

            # TODO:
            # show if it is Paired [P] or not Paired [ ]
            # Discoverable devices require a 'scan on' to be listed.

            # Format: [STATUS] MAC_ADDRESS Alias
            echo "$status_tag $mac $alias"
        done | uniq -u)

    else
        toggle_option="[ON] Enable Bluetooth"
        device_list=""
    fi

    # Display menu
    chosen_item=$(echo -e "$toggle_option\n$device_list" | menu "Bluetooth:")

    # Handle menu selection
    if [ -z "$chosen_item" ]; then
        notify "Bluetooth operation cancelled"
        exit 0
    elif [ "$chosen_item" = "$toggle_option" ]; then
        toggle_power
    else
        fields=($chosen_item)
        mac="${fields[1]}"

        # Validate MAC: must be 17 chars and follow the MAC address pattern
        if [[ ${#mac} -eq 17 && "$mac" =~ ^([0-9A-Fa-f]{2}[:]){5}([0-9A-Fa-f]{2})$ ]]; then
            alias="${chosen_item#* $mac }"
            toggle_connection "$mac" "$alias"
        else
            notify "Error" "Invalid device selection: MAC address not found." "critical"
        fi
    fi
}

# Execute the main function
show_menu
