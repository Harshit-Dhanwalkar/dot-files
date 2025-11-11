#!/usr/bin/env bash

## Author  : Harshit Prahant Dhanwalkar
## Github  : @Harshit-Dhanwalkar

PACTL="/usr/bin/pactl"
JQ="/usr/bin/jq"
DUNST="dunst"
MAKO="mako"
NOTIFY_SEND="notify-send"

notify() {
  if pgrep -x "$DUNST" >/dev/null 2>&1; then
    notify-send "$@"
  elif pgrep -x "$MAKO" >/dev/null 2>&1; then
    notify-send "$@"
  elif command -v "$NOTIFY_SEND" >/dev/null 2>&1; then
    notify-send "$@"
  else
    echo "Notification: $*" >&2
  fi
}

# --- Menu launcher ---
if command -v dmenu >/dev/null 2>&1; then
  menu() { dmenu -i -l 10 -p "$1"; }
elif command -v rofi >/dev/null 2>&1; then
  menu() { rofi -dmenu -i -p "$1"; }
else
  echo "Error: neither dmenu nor rofi found!" >&2
  notify-send "Error: neither dmenu nor rofi found!"
  exit 1
fi

# --- Audio switcher ---
audio_switch() {
  sinks=$($PACTL -f json list sinks | $JQ -r '.[] | .description')
  [ -z "$sinks" ] && notify "No audio outputs found!" && return

  selection=$(echo "$sinks" | menu "Select Audio Output:")
  [ -z "$selection" ] && {
    notify "Audio switch cancelled"
    return
  }

  sink_name=$($PACTL -f json list sinks | $JQ -r --arg s "$selection" '.[] | select(.description == $s) | .name')
  if [ -n "$sink_name" ]; then
    $PACTL set-default-sink "$sink_name" && notify "Audio switched to: $selection"
  else
    notify "Audio Switch Failed"
  fi
}

# --- Bluetooth ---
bluetooth_menu() {
  bluetoothctl show >/dev/null 2>&1 || {
    notify "Bluetooth not found"
    return
  }

  power_state=$(bluetoothctl show | grep "Powered:" | awk '{print $2}')
  devices=$(bluetoothctl devices | sed 's/^Device //' | cut -d ' ' -f2-)
  options="Power: $power_state\nScan\nPairable\nDiscoverable\nDevices\nExit"

  choice=$(echo -e "$options" | menu "Bluetooth:")

  case "$choice" in
  "Power: yes")
    bluetoothctl power off
    notify "Bluetooth turned OFF"
    ;;
  "Power: no")
    bluetoothctl power on
    notify "Bluetooth turned ON"
    ;;
  "Scan")
    bluetoothctl --timeout 5 scan on
    notify "Bluetooth scanning..."
    ;;
  "Pairable")
    bluetoothctl pairable on
    notify "Bluetooth set to pairable mode"
    ;;
  "Discoverable")
    bluetoothctl discoverable on
    notify "Bluetooth is now discoverable"
    ;;
  "Devices")
    device=$(echo "$devices" | menu "Select Device:")
    if [ -n "$device" ]; then
      mac=$(bluetoothctl devices | grep "$device" | awk '{print $2}')
      bluetoothctl connect "$mac" && notify "Connected to $device" || notify "Failed to connect $device"
    else
      notify "No device selected"
    fi
    ;;
  "Exit" | *) ;;
  esac
}

# --- Main menu ---
main_menu() {
  options="Audio Switch\nBluetooth Menu\nExit"
  choice=$(echo -e "$options" | menu "System Control:")

  case "$choice" in
  "Audio Switch") audio_switch ;;
  "Bluetooth Menu") bluetooth_menu ;;
  *) exit 0 ;;
  esac
}

main_menu
