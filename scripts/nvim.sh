#!/bin/bash

PACKAGES="neovim xclip wl-clipboard npm"
sh ./scripts/query_install.sh pacman $PACKAGES

if [[ ! -d ~/.local/share/nvim/mason ]]; then
    nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'; true
fi
