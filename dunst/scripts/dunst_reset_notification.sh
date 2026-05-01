#!/usr/bin/env bash

## Author  : Harshit Prahant Dhanwalkar
## Github  : @Harshit-Dhanwalkar

pkill dunst
dunst -print &
notify-send "Test" "Debug mode test"
