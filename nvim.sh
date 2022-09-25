#!/bin/bash

PACKAGES="xclip wl-clipboard npm"
! pacman --query $PACKAGES && sudo pacman -Sy $PACKAGES --noconfirm

# Only for winbar. On 0.8 stable i will back.
PACKAGES="neovim-nightly-bin"
! pacman --query $PACKAGES && yay -Sy $PACKAGES --noconfirm

if [[ ! -d ~/.local/share/nvim/mason ]]; then
    nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'; true
fi
