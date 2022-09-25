#!/bin/bash

TERMINAL=kitty

PACKAGES="gnome-software nautilus gnome-shell-extensions"
! pacman --query $PACKAGES                  && sudo pacman -Sy $PACKAGES --noconfirm
! pacman --query nautilus-open-any-terminal && yay -Sy nautilus-open-any-terminal --noconfirm

TERM_SET=$(gsettings get com.github.stunkymonkey.nautilus-open-any-terminal terminal)
if [[ $TERM_SET != "'$TERMINAL'" ]]; then
    gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal $TERMINAL
    gsettings set com.github.stunkymonkey.nautilus-open-any-terminal keybindings 'F4'
    gsettings set com.github.stunkymonkey.nautilus-open-any-terminal new-tab
    echo $TERMINAL
fi

rm ~/.config/user-dirs.dirs ~/.config/user-dirs.locale

sh ~/dotfiles/private/gnome/extensions.sh

if [[ ! -d ~/dotfiles/private/gnome/dconf-all.conf.bak ]]; then
    dconf dump / > dconf-all.conf.bak
fi

if [[ ! -d ~/dotfiles/private/gnome/extensions.conf.bak ]]; then
    dconf dump /org/gnome/shell/extensions/ > extensions.conf.bak
fi

dconf load /org/gnome/shell/extensions/ < ~/dotfiles/private/gnome/extensions.conf
