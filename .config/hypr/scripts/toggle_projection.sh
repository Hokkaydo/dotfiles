#!/usr/bin/env bash

# The file holding persistent variable value
statefile='/var/hyprland_monitor_conf_state'

# Declare our variable as holding an integer
STATE="extend"
# If the persistence file exists, read the variable value from it
source $statefile
echo $monitor_state
# Save value to file
if [ "$STATE" = "extend" ]; then
    STATE="clone"
elif [ "$STATE" = "clone" ]; then
    STATE="extend"
fi

printf 'STATE=%s\n' "$STATE" >"$statefile"
echo $STATE
rm ~/.config/hypr/monitor.conf
echo "~/.config/hypr/monitor_$STATE.conf"
ln -s ~/.config/hypr/monitor_$STATE.conf ~/.config/hypr/monitor.conf  

hyprctl reload
