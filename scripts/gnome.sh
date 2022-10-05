#!/bin/bash

install_packages ()
{
    PACKAGES="gnome dconf-editor ghex gnome-connections gnome-mines gnome-sudoku gnome-tweaks gnome-usage sysprof gnome-browser-connector"
    sh ./scripts/query_install.sh pacman $PACKAGES
}

open_terminal ()
{
    sh ./scripts/query_install.sh yay nautilus-open-any-terminal

    local TERMINAL=kitty
    local TERM_SET=$(gsettings get com.github.stunkymonkey.nautilus-open-any-terminal terminal)

    if [[ $TERM_SET != "'$TERMINAL'" ]]; then
        gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal $TERMINAL
        gsettings set com.github.stunkymonkey.nautilus-open-any-terminal keybindings 'F4'
        gsettings set com.github.stunkymonkey.nautilus-open-any-terminal new-tab
        echo $TERMINAL
    fi
}

locale_dirs ()
{
    local FILE=~/.config/user-dirs.dirs
    if [[ -d "$FILE" ]]; then rm FILE; fi
    local FILE=~/.config/user-dirs.locale
    if [[ -d "$FILE" ]]; then rm FILE; fi
}

install_extensions () { sh ~/dotfiles/private/gnome/extensions.sh; }

dconf_backup_settings ()
{
    local FILE=~/dotfiles/private/gnome/dconf-all.conf.bak
    if [[ ! -d "$FILE" ]]; then dconf dump / > $FILE; fi

    FILE=~/dotfiles/private/gnome/extensions.conf.bak
    if [[ ! -d "$FILE" ]]; then dconf dump /org/gnome/shell/extensions/ > $FILE; fi
}

dconf_restore_settings ()
{
    dconf reset -f /org/gnome/desktop/app-folders/
    dconf load / < ~/dotfiles/private/gnome/app-folders.conf
    gsettings set org.gnome.shell app-picker-layout "[]"
    dconf load / < ~/dotfiles/private/gnome/bindings.conf
    dconf load / < ~/dotfiles/private/gnome/general.conf
    dconf load / < ~/dotfiles/private/gnome/nautilus.conf
    dconf load / < ~/dotfiles/private/gnome/peripherals.conf
    dconf load /org/gnome/shell/ < ~/dotfiles/private/gnome/shell.conf
}

install_packages
open_terminal
locale_dirs
dconf_backup_settings
dconf_restore_settings
