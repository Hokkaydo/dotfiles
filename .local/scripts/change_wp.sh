#!/usr/bin/env bash
set -x
# Define all supported image formats
supported_formats=("jpeg" "png" "gif" "pnm" "tga" "tiff" "webp" "bmp" "farbfeld" "jpg")

TMP="$(mktemp)"
filename=$(ls -1 ~/Pictures/Wallpapers/eDP-1 | grep \\.jpg | while read A ; do  echo -en "$A\x00icon\x1f~/Pictures/Wallpapers/eDP-1/$A\n"; done | rofi -dmenu -theme ~/.config/rofi/themes/wallpaper.rasi)

# filename="$(cat $TMP)"

if [[ -z "$filename" ]]; then
  # notify-send "Wallpaper" "Error: No file given"
  exit 1
fi

currentoutput="$(hyprctl activeworkspace| head -1 | awk '{print $NF}' | rev | cut -c 2- | rev)"

# Get the file extension (lowercase)
file_extension="${filename##*.}"
file_extension=$(tr [:upper:] [:lower:] <<< "$file_extension")

if [[ " ${supported_formats[@]} " =~ " $file_extension " ]]; then
  #swww img ~/Pictures/Wallpapers/eDP-1/$filename -o $currentoutput --transition-type fade --transition-fps 60 --transition-bezier 1,.08,.39,.79
  killall swaybg
  
  monitors=$(hyprctl monitors | grep '^Monitor' | awk '{print $2}')
     
  CURRENT_STORE_PATH="${currentoutput//-/_}_WALLPAPER_STORE_PATH"
  echo ~/Pictures/Wallpapers/eDP-1/$filename > ${!CURRENT_STORE_PATH}
  
  for monitor in $monitors; do 
    STORE_PATH="${monitor//-/_}_WALLPAPER_STORE_PATH"
    TRUE_PATH=$(cat "${!STORE_PATH}")
    swaybg -o $monitor -m fill -i $TRUE_PATH &
  done
  #wal -nteq -i ~/Pictures/wallpapers/$filename
  #themecord
else
  notify-send "Wallpaper" "$filename seems to not be a image file."
fi

rm -f $TMP
