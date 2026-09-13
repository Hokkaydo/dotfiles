#!/usr/bin/env bash
set -uo pipefail

truncate() {
    local str="$1" n="$2"
    if [[ ${#str} -gt $n ]]; then
        echo "${str:0:$((n-3))}..."
    else
        echo "$str"
    fi
}

find_active_player() {
    local players player
    mapfile -t players < <(playerctl -l 2>/dev/null)
    if [[ ${#players[@]} -eq 0 ]]; then
        return 1
    fi
    for player in "${players[@]}"; do
        if [[ "$(playerctl -p "$player" status 2>/dev/null)" == "Playing" ]]; then
            echo "$player"
            return 0
        fi
    done
    echo "${players[-1]}"
}

PLAYER=$(find_active_player) || { echo " - "; exit 0; }

case "${1:-}" in
show)
    title=$(playerctl -p "$PLAYER" metadata --format '{{title}}' 2>/dev/null || echo "")
    artist=$(playerctl -p "$PLAYER" metadata --format '{{artist}}' 2>/dev/null || echo "")
    echo "$(truncate "$title" 30)   $(truncate "$artist" 30)"
    ;;
next)
    playerctl -p "$PLAYER" next
    ;;
prev)
    playerctl -p "$PLAYER" previous
    ;;
toggle)
    playerctl -p "$PLAYER" play-pause
    ;;
*)
    echo "Usage: $(basename "$0") [show|next|prev|toggle]" >&2
    exit 1
    ;;
esac
