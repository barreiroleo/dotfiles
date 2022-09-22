#!/bin/bash

echo "Installing noto fonts"
sudo pacman -S \
    noto-fonts noto-fonts-cjk noto-fonts-emoji \ #noto-fonts-extra \
    --noconfirm

echo "Installing Ubuntu Nerd Font"
if [[ -d ~/.local/share/fonts/UbuntuMono ]]; then
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/UbuntuMono.zip
    mkdir ~/.local/share/fonts/UbuntuMono/ -p
    unzip -d UbuntuMono UbuntuMono.zip && mv UbuntuMono/ ~/.local/share/fonts/UbuntuMono
    rm UbuntuMono.zip*
fi

echo "Recaching fonts"
fc-cache -fv
