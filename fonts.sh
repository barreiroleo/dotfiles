#!/bin/bash

echo "Installing noto fonts"
sudo pacman -S \
    noto-fonts noto-fonts-cjk noto-fonts-emoji \ #noto-fonts-extra \
    --noconfirm

echo "Installing Ubuntu Nerd Font"
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/UbuntuMono.zip
unzip -d UbuntuMono UbuntuMono.zip && mv UbuntuMono/ ~/.local/share/fonts/ && rm Ubuntu*.zip

echo "Recaching fonts"
fc-cache -fv
