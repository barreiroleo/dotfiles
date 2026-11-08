#!/bin/bash
#set -x
sudo pacman -Syu --noconfirm

if [[ ! $(which lazygit) ]]; then
    sudo pacman -S lazygit --noconfirm
fi
echo "[ OK ] Lazygit"

if [[ ! $(which ranger) ]]; then
    sudo pacman -S ranger --noconfirm
fi
echo "[ OK ] Ranger"
