#!/bin/bash

FLATPACK_STATUS=$(pacman --query flatpak)
if [[ ! $FLATPACK_STATUS ]]; then
    sudo mkdir -p /opt/flatpak/
    sudo ln -s /opt/flatpak/ /var/lib/
    sudo pacman -Sy flatpak --noconfirm
fi
