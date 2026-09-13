#!/usr/bin/env bash
set -uo pipefail

send_notification() {
    volume=$(pamixer --get-volume)
    if [ "${volume}" -gt 70 ]; then icon=notification-audio-volume-high
    elif [ "${volume}" -gt 40 ]; then icon=notification-audio-volume-medium
    elif [ "${volume}" -gt 0 ]; then icon=notification-audio-volume-low
    else icon=notification-audio-volume-muted
    fi
    #dunstify -a "changevolume" -u low -r "9993" -h int:value:"$volume" -i "$icon" "Volume: ${volume}%" -t 2000
    canberra-gtk-play -i audio-volume-change -d "changeVolume" &
}

show_usage() {
    echo "Usage: $(basename "$0") [up|down|mute]" >&2
    echo "  up         Increase volume by 5%"
    echo "  down       Decrease volume by 5%"
    echo "  mute       Toggle mute/unmute"
}

case "${1:-}" in
up)
    # Set the volume on (if it was muted)
    pamixer -u
    pamixer --allow-boost -i 5
    send_notification
    ;;
down)
    pamixer -u
    pamixer --allow-boost -d 5
    send_notification
    ;;
mute)
    pamixer -t
    if [ "$(pamixer --get-mute)" != "true" ]; then
        send_notification
    fi
    ;;
*)
    show_usage
    exit 1
    ;;
esac
