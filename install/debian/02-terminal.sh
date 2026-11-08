#!/bin/bash
#set -x

sudo apt update -y

if [[ ! $(which tmux) ]]; then
    echo "tmux"
    sudo apt install tmux -y
fi
echo "[ OK ] tmux"

if [[ ! $(which lsd) ]]; then
    echo "lsd"
    sudo apt install lsd -y
fi
echo "[ OK ] lsd"

if [[ ! $(which batcat) ]]; then
    echo "batcat"
    sudo apt install bat -y
    # Ubuntu bat' name is batcat due to a name clash with another package
    mkdir -p ~/.local/bin
    ln -s /usr/bin/batcat ~/.local/bin/bat
fi
echo "[ OK ] batcat"

if [[ ! $(which fzf) ]]; then
    echo "fzf"
    # sudo apt install fzf -y # Fzf is super out of date in ubuntu
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
    git clone --depth 1 https://github.com/junegunn/fzf-git.sh.git ${HOME}/.fzf-git.sh
fi
echo "[ OK ] fzf"

if [[ ! $(which rg) ]]; then
    echo "rg"
    sudo apt install ripgrep -y
fi
echo "[ OK ] ripgrep"
