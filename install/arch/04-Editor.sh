#!/bin/bash
#set -x
sudo pacman -Syu --noconfirm

if [[ ! $(which nvim) ]];then
    echo "Neovim"
    yay -S neovim-nightly-bin --noconfirm
    sudo pacman -S tree-sitter-cli xclip wl-clipboard --noconfirm
    echo "[ WARN ] Update editor in ~/.profile"
fi
echo "[ OK ] Neovim"
