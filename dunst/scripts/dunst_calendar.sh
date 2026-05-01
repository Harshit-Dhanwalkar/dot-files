#!/usr/bin/env bash

## Author  : Harshit Prahant Dhanwalkar
## Github  : @Harshit-Dhanwalkar

# Dependency:  ncal

TIME="$(date +'%I:%M %p')"
DAY_OF_YEAR=$(date +'%j')
TODAY=$(date +'%e' | tr -d ' ')
MONTH=$(date +'%B %Y')

CAL_OUTPUT=$(ncal -h -M | sed -e "s/\b$TODAY\b/<u><b>$TODAY<\/b><\/u>/g")

dunstify -r 999999999 \
    "${TIME} :: Day ${DAY_OF_YEAR}" \
    "${CAL_OUTPUT}"

exit 0
