#!/bin/bash

FLATPACK_STATUS=$(pacman --query flatpak)
if [[ ! $FLATPACK_STATUS ]]; then
    sudo mkdir -p /opt/flatpak/
    sudo mv /var/lib/flatpak /opt
    sudo ln -s /opt/flatpak/ /var/lib/
    sudo pacman -Sy flatpak --noconfirm
fi

flatpak install flathub com.github.tchx84.Flatseal -y
