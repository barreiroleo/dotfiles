#!/bin/bash

echo "Installing noto fonts"
PACKAGES="noto-fonts noto-fonts-emoji" # noto-fonts-cjk noto-fonts-extra"
! pacman --query $PACKAGES && sudo pacman -S $PACKAGES --noconfirm

echo "Installing Ubuntu Nerd Font"
if [[ ! -d ~/.local/share/fonts/UbuntuMono ]]; then
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/UbuntuMono.zip
    mkdir ~/.local/share/fonts/UbuntuMono/ -p
    unzip -d UbuntuMono UbuntuMono.zip && mv UbuntuMono/ ~/.local/share/fonts/UbuntuMono
    rm UbuntuMono.zip*
fi

echo "Recaching fonts"
fc-cache -fv
