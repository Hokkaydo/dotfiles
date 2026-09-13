#!/usr/bin/env bash
set -euo pipefail

# Persists the active monitor layout for hypr/monitor.lua.
# Usage:
#   toggle_projection.sh                 cycle extend -> clone room -> extend
#   toggle_projection.sh clone room      mirror at 1920x1080 (dual screen room)
#   toggle_projection.sh clone tv        mirror at 1366x768 (TV salon)
#   toggle_projection.sh extend          dual-monitor extend mode

state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/hypr"
statefile="$state_dir/monitor_mode"
mkdir -p "$state_dir"

current="extend"
[ -f "$statefile" ] && current="$(cat "$statefile")"

if [ "$#" -gt 0 ]; then
    new_mode="$*"
else
    case "$current" in
    extend) new_mode="clone room" ;;
    *) new_mode="extend" ;;
    esac
fi

printf '%s\n' "$new_mode" >"$statefile"
echo "Monitor mode: $new_mode"

hyprctl reload
