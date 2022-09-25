#!/bin/bash

FLATPACK_STATUS=$(pacman --query flatpak)
if [[ ! $FLATPACK_STATUS ]]; then
    sudo mkdir -p /opt/flatpak/
    sudo ln -s /opt/flatpak/ /var/lib/
    sudo pacman -S flatpak --noconfirm
fi
