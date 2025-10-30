#!/usr/bin/env sh
killall waybar # Kill all instances of waybar
waybar & # Launch statusbar

killall swaybg

monitors=$(hyprctl monitors | grep '^Monitor' | awk '{print $2}')

for monitor in $monitors; do 
    STORE_PATH="${monitor//-/_}_WALLPAPER_STORE_PATH"
    if [[ -f "${!STORE_PATH}" ]]; then    
        TRUE_PATH=$(cat "${!STORE_PATH}")
        swaybg -o $monitor -m fill -i $TRUE_PATH & 
    else
        touch "${!STORE_PATH}"
    fi
done
