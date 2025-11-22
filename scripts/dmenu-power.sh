#!/usr/bin/env bash

## Author  : Harshit Prashant Dhanwalkar
## Github  : @Harshit-Dhanwalkar

DMENU="/usr/local/bin/dmenu"

case "$(echo -e " \
  Shutdown\n \
  Restart\n \
  Lock\n \
󰗽  Logout\n \
  Suspend " | $DMENU \
    -i -p \
    "Power: ")" in
    " Shutdown") exec systemctl poweroff;;
    " Restart") exec systemctl reboot;;
    " Lock") exec systemctl --user start lock.target;;
    "󰗽 Logout") kill -HUP $XDG_SESSION_PID;;
    " Suspend") exec systemctl suspend;;
esac

# case "$(echo -e " \
#   Shutdown\n \
#   Restart\n \
#   Lock\n \
# 󰗽  Logout\n \
#   Suspend " | $DMENU \
#     -nb "${COLOR_BACKGROUND:-#1e1e2e}" \
#     -nf "${COLOR_DEFAULT:-#cdd6f4}" \
#     -sf "${COLOR_HIGHLIGHT:-#1e1e2e}" \
#     -sb "#89b4fa" \
#     -b -i -p \
#     "Power: -l 5")" in
#     " Shutdown") exec systemctl poweroff;;
#     " Restart") exec systemctl reboot;;
#     " Lock") exec systemctl --user start lock.target;;
#     "󰗽 Logout") kill -HUP $XDG_SESSION_PID;;
#     " Suspend") exec systemctl suspend;;
# esac
