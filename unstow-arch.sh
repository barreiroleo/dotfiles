#!/bin/bash
#set -x

GREEN='\033[0;32m'
NC='\033[0m'

if [[ ! $(which stow) ]]; then
    sudo pacman -S stow
fi
echo "[ OK ] Stow"

function apply(){
    pack=$1
    msg=$2
    stow --adopt -v $pack
    git restore .
    stow --restow -v $pack
    echo $msg
    echo
}

git stash
apply shell "[ OK ] zsh, bash, profile"
apply git "[ OK ] git"
apply nvim "[ OK ] nvim"
apply tmux "[ OK ] tmux"
apply wezterm "[ OK ] wezterm"
apply ghostty "[ OK ] ghostty"
apply opencode "[ OK ] opencode"
apply i3 "[ OK ] i3"
apply niri "[ OK ] niri"
apply hypr "[ OK ] hypr"
apply sway "[ OK ] sway"
apply zed "[ OK ] zed"
git stash apply
git stash clear

echo
echo -e "${GREEN}Remember to manually install the following packages:${NC}"
echo
echo "https://localsend.org/es"
echo "https://wayscriber.com/#install"
