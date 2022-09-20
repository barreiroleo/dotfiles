#!/bin/bash

sudo pacman -S \
    kitty tmux starship zsh \
    lsd bat \
    --noconfirm

DIR=~/.oh-my-zsh
if [[ ! -d "$DIR" ]]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"   
fi

echo "Installing plugins"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

git clone https://github.com/zsh-users/zsh-autosuggestions \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

echo "Set zsh default as terminal"
chsh -s /bin/zsh
