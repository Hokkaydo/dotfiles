cmd=$1

PLAYER=0

[ "$(playerctl -l 2>&1)" = "No players found" ] && echo " - " && exit 0;
for player in $(playerctl -l 2>&1)
do
    if [ "$(playerctl -p "$player" status 2>&1)" = "Playing" ];
    then 
        PLAYER=$player 
    fi
done
if [ $PLAYER = 0 ];
then
    PLAYER="$(playerctl -l 2>&1 | tail -n 1)";
fi

truncate() {
    local str="$1"
    local n=$2
    if [ ${#str} -gt ${n} ]; then
        echo "${str:0:$n-3}..."
    else
        echo "$str"
    fi
}

case $1 in
show)
    [ $PLAYER = -1 ] && echo " - " && exit 0;
    title=$(playerctl -p $PLAYER metadata --format '{{title}}')
    artist=$(playerctl -p $PLAYER metadata --format '{{artist}}')
    echo "$(truncate "${title}" 30)   $(truncate "${artist}" 30)" 
    exit 0
    ;;
next)
    playerctl -p $PLAYER next
    exit 0;
    ;;
prev)
    playerctl -p $PLAYER previous
    exit 0;
    ;;
toggle)
    playerctl -p $PLAYER play-pause
    exit 0;
esac
