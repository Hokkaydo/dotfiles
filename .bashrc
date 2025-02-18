#
# ~/.bashrc
#
source .zshenv
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias python='python3.11'
alias py='python'
alias rate="upower -d | grep "energy-rate" | head -n 1 | cut -d: -f2 | cut -d ' ' -f10-"
alias battery="upower -d | grep -E 'energy-|capacity' | grep -vE 'empty|rate' | head -3"
alias ssh="kitty +kitten ssh"

PS1='[\u@\h \W]\$ '

function gcce() {
  gcc "$1"
  ./a.out
}
function mkcd() {
    mkdir "$1"
    cd "$1"
}
function mvcd() {
    mv "$1" "$2"
    cd "$2"
}
function mkmv() {
    mkdir "$2"
    mv "$1" "$2"
}
function mkmvcd() {
    mkdir -p "$2"
    mv "$1" "$2"
    cd "$2"
}

startx
