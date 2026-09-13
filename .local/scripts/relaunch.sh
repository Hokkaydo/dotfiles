#!/usr/bin/env bash
set -uo pipefail

killall waybar 2>/dev/null || true
waybar &

killall swaybg 2>/dev/null || true

mapfile -t monitors < <(hyprctl monitors | awk '/^Monitor/{print $2}')

for monitor in "${monitors[@]}"; do
    store_var="${monitor//-/_}_WALLPAPER_STORE_PATH"
    store_path="${!store_var:-}"
    if [[ -z "$store_path" ]]; then
        continue
    fi
    if [[ -f "$store_path" ]]; then
        true_path=$(cat "$store_path")
        swaybg -o "$monitor" -m fill -i "$true_path" &
    else
        touch "$store_path"
    fi
done
