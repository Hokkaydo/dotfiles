killall swaybg

monitors=$(hyprctl monitors | grep '^Monitor' | awk '{print $2}')

for monitor in $monitors; do 
    random="$(find ~/Pictures/Wallpapers/eDP-1/ -type f | shuf -n 1)"
    STORE_PATH="${monitor//-/_}_WALLPAPER_STORE_PATH"
    TRUE_PATH=$(cat "${!STORE_PATH}")
    echo $random > ${!STORE_PATH}
    swaybg -o $monitor -m fill -i $random & 
done
