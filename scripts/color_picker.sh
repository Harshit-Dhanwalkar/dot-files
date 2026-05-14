#!/usr/bin/env bash

## Author  : Harshit Prashant Dhanwalkar
## Github  : @Harshit-Dhanwalkar

## IMPORTANT: This script is now integrated into controllers.sh

/usr/bin/grim -g "$(/usr/bin/slurp -p)" -t ppm - | /usr/bin/convert - -format '%[pixel:p{0,0}]' txt:- | /usr/bin/awk -F'[(,)]' '/srgb/{printf "#%02x%02x%02x\n", $2, $3, $4}' | /usr/bin/xargs -I{} /usr/bin/notify-send "Picked Color" "{}"
