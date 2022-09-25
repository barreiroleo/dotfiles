#!/bin/bash

PACKAGES="kitty tmux starship zsh lsd bat fzf"
! pacman --query $PACKAGES && sudo pacman -Sy $PACKAGES --noconfirm

if [[ ! -d ~/.oh-my-zsh/ ]]; then
    # sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"   
    git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
fi

echo "Installing ZSH plugins"
DIR=~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
if [[ ! -d "$DIR" ]]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
        ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

echo "Installing ZSH plugins"
DIR=~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
if [[ ! -d "$DIR" ]]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions \
        ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

echo "Set zsh default as terminal"
if [[ ! $SHELL == /usr/bin/zsh && ! $SHELL == /bin/zsh ]]; then
    chsh -s /bin/zsh
fi
