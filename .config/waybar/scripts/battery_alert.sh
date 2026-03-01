#!/bin/bash

percentage=$(upower -i $(upower -e | grep BAT) | grep -E "percentage" | cut -d: -f2 | awk '{$1=$1;print}' | cut -d% -f1)
state=$(upower -d | grep 'state' -m 1 | cut -d: -f2 | cut -d' ' -f16)

if [[ $percentage -le 15 ]] && [[ $state != charging ]] && [[ $((percentage % 5)) == 0 ]]
then
    notify-send -i ~/Pictures/utils/red_blob.png "Battery low : $percentage%" -t 40000000
fi
