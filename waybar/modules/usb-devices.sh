#!/usr/bin/env bash

# File to store the process ID (PID) for signal handling
path_pid="/tmp/waybar-usb-udev.pid"

# --- JSON Output Function for Waybar ---
usb_print() {
    # 1. Get the full, nested JSON structure from lsblk
    DEVICES_JSON=$(lsblk -J)

    # 2. Filter for removable DISKS (type=disk, rm=true) that have children (partitions)
    # The output is condensed to a single object per disk using -c, ready for wc -l counting.
    REMOVABLE_DISKS=$(echo "$DEVICES_JSON" | jq -c '
        .blockdevices[] 
        | select(.type == "disk") 
        | select(.rm == true) 
        | select(.children != null)
        | select(.name | startswith("loop") | not) # EXCLUDE loop devices
    ')
    
    # 3. Count disks that are fully unmounted (all partitions are null/empty mountpoint)
    unmounted_count=$(echo "$REMOVABLE_DISKS" | jq -r '
        select(.children | all(.mountpoint == null or .mountpoint == "")) 
        | .name
    ' | wc -l)
    
    # 4. Count disks that are at least partially mounted (any partition is mounted)
    mounted_count=$(echo "$REMOVABLE_DISKS" | jq -r '
        select(.children | any(.mountpoint != null and .mountpoint != "")) 
        | .name
    ' | wc -l)

    # Total unique removable disks detected
    total_count=$((mounted_count + unmounted_count)) # Note: This can be > actual count if a disk has mixed mounted/unmounted partitions.

    # We determine the output based on the presence of unmounted partitions
    if [ "$unmounted_count" -gt 0 ]; then
        # Use the unmounted count for the low state text
        display_count="$unmounted_count"
        state_text="unmounted"
        class="low"
    elif [ "$mounted_count" -gt 0 ]; then
        # Use the mounted count for the high state text
        display_count="$mounted_count"
        state_text="mounted"
        class="high"
    else
        # No removable disks found
        display_count="No"
        state_text="devices"
        class="off"
    fi

    # Generate Tooltip content
    tooltip_content="Total Removable: $total_count\nMounted: $mounted_count\nUnmounted (Needs Mount): $unmounted_count"
    
    # Set icon
    icon="" # USB icon

    # Output JSON for Waybar
    echo "{\"text\": \"$icon $display_count $state_text\", \"class\": \"$class\", \"tooltip\": \"$tooltip_content\"}"
}

# --- Signal Update Function ---
usb_update() {
    pid=$(cat "$path_pid" 2>/dev/null)
    if [ "$pid" != "" ]; then
        kill -USR1 "$pid"
    fi
}

# --- Mount/Unmount/Default Logic ---
case "$1" in
    --update)
        usb_update
        ;;
    --mount)
        devices=$(lsblk -Jplno NAME,TYPE,RM,MOUNTPOINT | jq -r '.blockdevices[] | select(.type == "part") | select(.rm == true) | select(.mountpoint == null) | .name')
        
        for mount_part in $devices; do
            udisksctl mount --no-user-interaction -b "$mount_part"
        done

        usb_update
        ;;
    --unmount)
        devices=$(lsblk -Jplno NAME,TYPE,RM,MOUNTPOINT | jq -r '.blockdevices[] | select(.type == "part") | select(.rm == true) | select(.mountpoint != null) | .name')

        for unmount_part in $devices; do
            udisksctl unmount --no-user-interaction -b "$unmount_part"
        done

        usb_update
        ;;
    *)
        echo $$ > "$path_pid"
        trap usb_print USR1
        trap exit INT

        while true; do
            usb_print 

            sleep 60 &
            wait $!
        done
        ;;
esac
