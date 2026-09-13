#!/usr/bin/env bash
set -euo pipefail

port="${1:?Usage: $(basename "$0") <port>}"
addr=$(ip addr | grep 192.168. | cut -d" " -f6 | cut -d/ -f1 | head -n1)
notify-send "Remote control on port $addr:$port"
python3 ~/dev/own/web/remote-control/server.py "$port"
