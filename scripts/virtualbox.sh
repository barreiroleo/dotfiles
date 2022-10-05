#!/bin/bash

! pacman --query virtualbox-host-modules-arch && yay -S virtualbox-host-modules-arch  --noconfirm
! pacman --query virtualbox && sudo pacman -S virtualbox --noconfirm

# Load kernel module
# Note: If you do not want the VirtualBox modules to be automatically loaded at
# boot time, you have to mask the default /usr/lib/modules-load.d/virtualbox-host-modules-arch.conf
# (or /usr/lib/modules-load.d/virtualbox-host-dkms.conf) by creating an empty file
# (or symlink to /dev/null) with the same name in /etc/modules-load.d/.
sudo modprobe vboxdrv

# Accessing host USB devices in guest
# To use the USB ports of your host machine in your virtual machines, add users that will be authorized
# to use this feature to the vboxusers user group.

# A security feature in Wayland (i.e. when using GDM) disallows VirtualBox to grab all keyboard input.
# This is annoying when you want to pass window manager shortcuts to your guest OS.
# It can be bypassed by whitelisting VirtualBox:
# gsettings get org.gnome.mutter.wayland xwayland-grab-access-rules
# gsettings set org.gnome.mutter.wayland xwayland-grab-access-rules "['VirtualBox Machine']"
