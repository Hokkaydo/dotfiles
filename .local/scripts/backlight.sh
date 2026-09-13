#!/usr/bin/env bash
set -euo pipefail

modify() {
    local sign="$1" pct="$2"
    local curr max total
    curr=$(brightnessctl g)
    max=$(brightnessctl m)
    total=$(python3 -c "print(int($sign*$max/100*$pct+$curr))")
    brightnessctl s "$total"
}

case "${1:-}" in
up)
    modify 1 "${2:-5}"
    ;;
down)
    modify -1 "${2:-5}"
    ;;
*)
    echo "Usage: $(basename "$0") [up|down] [percent]" >&2
    exit 1
    ;;
esac
