#!/bin/bash

PACKAGES="neovim xclip wl-clipboard"
! pacman --query $PACKAGES && sudo pacman -S $PACKAGES --noconfirm

if [[ ! -d ~/.local/share/nvim/mason ]]; then
    nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'; true
fi
