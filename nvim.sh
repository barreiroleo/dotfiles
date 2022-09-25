#!/bin/bash

PACKAGES="xclip wl-clipboard"
! pacman --query $PACKAGES && sudo pacman -S $PACKAGES --noconfirm

# Only for winbar. On 0.8 stable i will back.
PACKAGES="neovim-nightly-bin"
! pacman --query $PACKAGES && yay -S $PACKAGES --noconfirm

if [[ ! -d ~/.local/share/nvim/mason ]]; then
    nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'; true
fi
