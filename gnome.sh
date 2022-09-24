#!/bin/bash

TERMINAL=kitty

PACKAGES="gnome-software nautilus"
! pacman --query $PACKAGES                  && sudo pacman -S $PACKAGES --noconfirm
! pacman --query nautilus-open-any-terminal && yay -S nautilus-open-any-terminal --noconfirm

TERM_SET=$(gsettings get com.github.stunkymonkey.nautilus-open-any-terminal terminal)
if [[ $TERM_SET != "'$TERMINAL'" ]]; then
    gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal $TERMINAL
    gsettings set com.github.stunkymonkey.nautilus-open-any-terminal keybindings 'F4'
    gsettings set com.github.stunkymonkey.nautilus-open-any-terminal new-tab
    echo $TERMINAL
fi

rm ~/.config/user-dirs.dirs ~/.config/user-dirs.locale
