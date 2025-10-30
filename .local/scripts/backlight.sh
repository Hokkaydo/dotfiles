modify() {
    curr=$(brightnessctl g)
    max=$(brightnessctl m)
    let total=$(python3 -c "print(int($1*$max/100*$2+$curr))")
    brightnessctl s $total
}

case $1 in
up)
    modify 1 $2
    exit 0
    ;;
down)
    modify -1 $2
    
esac
