#!/usr/bin/env bash

## Author  : Harshit Prashant Dhanwalkar
## Github  : @Harshit-Dhanwalkar

# TODO: add keyboad backlight info (see waybar)

myfetch () {
# ╭╮╰╯ ─│┫┣┳┻
# ┏┓┗┛ ━┃┤├┬┴╋
cat << 'EOF'
         .:i$$Sp,         ."°-.  
       .:i?S$$$Z$$L      : '. .} 
      .::iISS$$$$$$b._    `°` ;° 
      ..::iiI?."`?$S$$$     j;   
       ..::?i:?o,j$j$$?   ,d'    
     u-°*  .::iS?:iI$Si  :?'     
    :S'  '.  .:i:iIS$S?, J$      
    ;$:       .,`-?I$b?$b:?      
     $;.     ;  `b`:?I$.?$b `.   
     °:b,._ '   j7 -:?I$."`4k,-j  
       `°°?i:-,d? -:;i?$$,`°4L.  
             d°?    `:$?(   `?b' 
            j$°:     i$I:   j°?  
          , S^?-    j$I?_'  ;_?  
         ,: )$°$,_.$I?_'   `4b   
        j?'  `?iSI?"?(       :i  
        i:     `^°o°`         `  
        ':.                      
EOF
    echo "    -------------------------------------------------------------------------------"
    echo "    $(whoami)@$(hostname)                                           $(date '+%Y-%m-%d %H:%M')"
    echo "    -------------------------------------------------------------------------------"
    echo "    $(tput setaf 29)OS$(tput sgr0)             :       $(grep -oP 'PRETTY_NAME="\K[^"]+' /etc/os-release)"
    echo "    $(tput setaf 28)Host$(tput sgr0)           :       $(cat /sys/devices/virtual/dmi/id/product_name 2>/dev/null || echo "Unknown") $(cat /sys/devices/virtual/dmi/id/product_version 2>/dev/null)"
    echo "    $(tput setaf 27)Kernel$(tput sgr0)         :       $(uname -r)"
    echo "    $(tput setaf 26)DE$(tput sgr0)             :       ${XDG_CURRENT_DESKTOP:-${DESKTOP_SESSION:-Unknown}}"
    # echo "    WM      :           $(ps -e | grep -E -m1 'awesome|bspwm|dwm|i3|swaywm|qtile|xmonad|openbox|fluxbox' | awk '{print $4}')"
    echo "    $(tput setaf 25)Uptime$(tput sgr0)         :       $(uptime -p | sed 's/up //')"
    echo "    $(tput setaf 24)Shell$(tput sgr0)          :       $($SHELL --version | head -1)"
    if [ -n "$ZSH_THEME" ]; then
        echo "    $(tput setaf 24)ZSH Theme$(tput sgr0)       :      $ZSH_THEME"
    fi
    echo "    $(tput setaf 23)Terminal$(tput sgr0)       :      ${TERM}"
    echo "    $(tput setaf 22)CPU$(tput sgr0)            :      $(grep 'model name' /proc/cpuinfo | head -1 | cut -d':' -f2 | sed 's/^[ \t]*//')"
    echo "    $(tput setaf 21)GPU$(tput sgr0)            :      $(lspci | grep -i 'vga\|3d\|2d' | cut -d' ' -f5-)"
    echo "    $(tput setaf 14)Memory$(tput sgr0)         :      $(free -h | grep Mem | awk '{print $3 " / " $2}')"
    # echo "    Disks      :"
    # # Get root partition
    # if df -h / >/dev/null 2>&1; then
    #     root_info=$(df -h / | awk 'NR==2 {print $3 "/" $2 " (" $5 ")"}')
    #     echo "        /: $root_info"
    # fi
    # # Get home partition if separate
    # if [ "$(df -h /home 2>/dev/null | wc -l)" -gt 1 ] && [ "/home" != "/" ]; then
    #     home_info=$(df -h /home | awk 'NR==2 {print $3 "/" $2 " (" $5 ")"}')
    #     echo "        /home: $home_info"
    # fi
    # # Get other mounted partitions (excluding system ones)
    # df -h | grep -E "^/dev/(sd|nvme|mmc)" 2>/dev/null | grep -vE "(/boot|/efi|/dev/loop)" | while read line; do
    #     mount_point=$(echo "$line" | awk '{print $6}')
    #     if [ "$mount_point" != "/" ] && [ "$mount_point" != "/home" ] && [ "$mount_point" != "/tmp" ] && [ -n "$mount_point" ]; then
    #         info=$(echo "$line" | awk '{print $3 "/" $2 " (" $5 ")"}')
    #         echo "        $mount_point: $info"
    #     fi
    # done
    disk_info=$(df -h / --output=used,size,pcent 2>/dev/null | awk 'NR==2 {print $1 " / " $2 " (" $3 ")"}' | tr -d '\n')
    echo "    $(tput setaf 13)Disks$(tput sgr0)          :      ${disk_info:-Unknown}"
    echo "    $(tput setaf 12)Swap$(tput sgr0)           :      $(free -h | grep Swap | awk '{print $3 " / " $2}')"
    echo "    $(tput setaf 11)Packages$(tput sgr0)       :      $(dpkg --get-selections 2>/dev/null | grep -w "install" | wc -l) (dpkg)"
    if command -v xrandr >/dev/null 2>&1; then
        echo "    $(tput setaf 10)Resolution$(tput sgr0)     :      $(xrandr 2>/dev/null | grep '*' | awk '{print $1}' | head -1)"
    else
        echo "    $(tput setaf 10)Resolution$(tput sgr0)     :      $(xdpyinfo 2>/dev/null | grep dimensions | awk '{print $2}')"
    fi
    if [ -f /sys/class/power_supply/BAT0/capacity ]; then
    battery=$(cat /sys/class/power_supply/BAT0/capacity)
    echo "    $(tput setaf 9)Battery$(tput sgr0)        :      ${battery}%"
    fi
    if pactl info 2>/dev/null | grep -q "Server Name"; then
        echo "    $(tput setaf 8)Audio$(tput sgr0)          :      $(pactl info 2>/dev/null | grep "Server Name" | cut -d: -f2 | tr -d ' ')"
    fi
    # echo "    CPU Usage:    $(top -bn1 | grep "Cpu(s)" | awk '{print $2 "%"}')"
    if command -v sensors >/dev/null 2>&1; then
        echo "    $(tput setaf 6)CPU Temp$(tput sgr0)       :      $(sensors 2>/dev/null | grep -E 'Core 0|Package id 0' | awk '{print $3}' | head -1)"
    fi
    # Public IP (external)
    # echo "    Public IP:    $(curl -s ifconfig.me 2>/dev/null || echo "Unknown")"
    # Local IP
    echo "    $(tput setaf 5)Local IP$(tput sgr0)       :      $(hostname -I 2>/dev/null | awk '{print $1}' || echo "Unknown")"
    # echo "    Storage:"
    # df -h 2>/dev/null | grep -E "^/dev/(sd|nvme|mmc)" | grep -v "boot" | while read line; do
    #     device=$(echo "$line" | awk '{print $1}' | sed 's|/dev/||')
    #     size=$(echo "$line" | awk '{print $2}')
    #     used=$(echo "$line" | awk '{print $3}')
    #     avail=$(echo "$line" | awk '{print $4}')
    #     use_percent=$(echo "$line" | awk '{print $5}')
    #     mount=$(echo "$line" | awk '{print $6}')
    #     if [[ "$mount" != "/boot" && "$mount" != "/boot/efi" ]]; then
    #         echo "                 $device: $used/$size ($use_percent) on $mount"
    #     fi
    # done
    echo "    $(tput setaf 4)Storage                     :      $(tput sgr0)"
    disks=$(lsblk -d -o NAME,SIZE,TYPE 2>/dev/null | grep "disk" | awk '{print $1}')
    for disk in $disks; do
        disk_size=$(lsblk -d -o NAME,SIZE 2>/dev/null | grep "^$disk " | awk '{print $2}')
        echo "                 $disk: $disk_size"
        lsblk -o NAME,SIZE,MOUNTPOINT 2>/dev/null | grep "^├─${disk}[0-9]" | while read part_line; do
            part_name=$(echo "$part_line" | awk '{print $1}' | sed 's/^├─//')
            part_size=$(echo "$part_line" | awk '{print $2}')
            part_mount=$(echo "$part_line" | awk '{print $3}')
            if [ -n "$part_mount" ] && [ "$part_mount" != "" ]; then
                usage=$(df -h 2>/dev/null | grep "/dev/$part_name" | awk '{print $3 "/" $2 " (" $5 ")"}')
                echo "                            └─ $part_name: $usage ($part_mount)"
            else
                echo "                            └─ $part_name: $part_size (unmounted)"
            fi
        done
    done
    echo "    $(tput setaf 3)Load       $(tput sgr0)    :      $(uptime | awk -F'load average:' '{print $2}' | sed 's/^[ \t]*//')"
    echo "    $(tput setaf 2)GTK Theme  $(tput sgr0)    :      $(gsettings get org.gnome.desktop.interface gtk-theme 2>/dev/null | sed "s/'//g")"
    echo "    $(tput setaf 1)Icon Theme $(tput sgr0)    :      $(gsettings get org.gnome.desktop.interface icon-theme 2>/dev/null | sed "s/'//g")"
    # Keyboard Backlight Info
    KBD_PATH="/sys/devices/platform/dell-laptop/leds/dell::kbd_backlight"
    if [ -d "$KBD_PATH" ]; then
        KBD_BRIGHT=$(cat "$KBD_PATH/brightness")
        KBD_MAX=$(cat "$KBD_PATH/max_brightness")
        # Calculate Percentage (using scale=0 for integer)
        KBD_PERC=$(( KBD_BRIGHT * 100 / KBD_MAX ))
        # Determine Label
        if [ "$KBD_BRIGHT" -eq 0 ]; then
            KBD_STATUS="Off"
        else
            KBD_STATUS="$KBD_PERC% ($KBD_BRIGHT/$KBD_MAX)"
        fi
        echo "    $(tput setaf 45)Kbd Backlight$(tput sgr0)  :      $KBD_STATUS"
    fi
    echo "    -------------------------------------------------------------------------------"
    # echo "    Colors:      $(tput setaf 1)██$(tput setaf 2)██$(tput setaf 3)██$(tput setaf 4)██$(tput setaf 5)██$(tput setaf 6)██$(tput setaf 7)██$(tput sgr0)"
    # echo "    -------------------------------------------------------------------------------"
}

myfetch
