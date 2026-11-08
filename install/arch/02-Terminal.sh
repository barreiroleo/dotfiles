#!/bin/bash
#set -x
sudo pacman -Syu --noconfirm

if [[ ! $(which starship) ]];then
    echo "starship"
    curl -sS https://starship.rs/install.sh | sh
fi
echo "[ OK ] starship"

if [[ ! $(which tmux) ]]; then
    echo "tmux"
    sudo pacman -S tmux --noconfirm
fi
echo "[ OK ] tmux"

if [[ ! $(which lsd) ]]; then
    echo "lsd"
    sudo pacman -S lsd --noconfirm
fi
echo "[ OK ] lsd"

if [[ ! $(which bat) ]]; then
    echo "batcat"
    sudo pacman -S bat --noconfirm
fi
echo "[ OK ] batcat"

if [[ ! $(which fzf) ]]; then
    echo "fzf"
    sudo pacman -S fzf --noconfirm
    git clone --depth 1 https://github.com/junegunn/fzf-git.sh.git ${HOME}/.fzf-git.sh
fi
echo "[ OK ] fzf"

if [[ ! $(which rg) ]]; then
    echo "rg"
    sudo pacman -S ripgrep-all --noconfirm
fi
echo "[ OK ] ripgrep"

if [[ ! $(which fd) ]]; then
    sudo pacman -S fd --noconfirm
fi
echo "[ OK ] fd"

if command -v delta &> /dev/null; then
    sudo pacman -S git-delta --noconfirm
fi
