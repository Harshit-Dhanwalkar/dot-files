#!/usr/bin/env bash

## Available Styles
#
## style-1     style-2     style-3     style-4     style-5
## style-6     style-7     style-8     style-9     style-10

#dir="$HOME/.config/rofi/launchers/type-3"
dir="$HOME/.config/sway/modules/app_launcher/"
theme='style-3'

## Run
rofi \
    -show drun \
    -theme ${dir}/${theme}.rasi
