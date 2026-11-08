#!/bin/bash

USER="leonardo"

# Create local user
useradd -m -G wheel ${USER} &&
passwd ${USER} &&
echo "${USER} ALL=(ALL) ALL" >> /etc/sudoers

# Install basics
pacman -Syu
pacman -S sudo git

# Install Xorg + I3
sudo pacman -S --needed --noconfirm dbus i3-wm i3status dmenu xterm xorg-xrandr gtk3
