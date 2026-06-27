#!/usr/bin/env bash

## Author  : Harshit Prashant Dhanwalkar
## Github  : @Harshit-Dhanwalkar

FLAGS="-noi -l 5 -p Power:"           # for vertical layout

# case "$(echo -e "Shutdown\nRestart\nLogout\nSuspend\nLock" | dmenu \
#     # -nb "${COLOR_BACKGROUND:-#151515}" \
#     # -nf "${COLOR_DEFAULT:-#aaaaaa}" \
#     # -sf "${COLOR_HIGHLIGHT:-#589cc5}" \
#     # -sb "#1a1a1a" \
#     # -b \
#     # -i \
#     $FLAGS)" in
#         Shutdown) exec systemctl poweroff;;
#         Restart) exec systemctl reboot;;
#         Logout) kill -HUP $XDG_SESSION_PID;;
#         Suspend) exec systemctl suspend;;
#         Lock) exec systemctl --user start lock.target;;
# esac

case "$(echo -e "Shutdown\nRestart\nLogout\nSuspend\nLock" | dmenu $FLAGS)" in
        Shutdown) exec systemctl poweroff;;
        Restart) exec systemctl reboot;;
        Logout) kill -HUP $XDG_SESSION_PID;;
        Suspend) exec systemctl suspend;;
        Lock) exec systemctl --user start lock.target;;
esac
