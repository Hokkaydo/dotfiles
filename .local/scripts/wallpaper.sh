#!/usr/bin/env bash
set -uo pipefail

killall swaybg 2>/dev/null || true

mapfile -t monitors < <(hyprctl monitors | awk '/^Monitor/{print $2}')

for monitor in "${monitors[@]}"; do
    random="$(find ~/Pictures/Wallpapers/eDP-1/ -type f | shuf -n 1)"
    store_var="${monitor//-/_}_WALLPAPER_STORE_PATH"
    store_path="${!store_var:-}"
    if [[ -z "$store_path" ]]; then
        continue
    fi
    echo "$random" > "$store_path"
    swaybg -o "$monitor" -m fill -i "$random" &
done
