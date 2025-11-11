#!/usr/bin/env bash
# ~/.config/dunst/test-notification.sh
# vim: ft=cfg

## Author  : Harshit Prahant Dhanwalkar
## Github  : @Harshit-Dhanwalkar
pkill dunst
dunst -print &
notify-send "Test" "Debug mode test"
