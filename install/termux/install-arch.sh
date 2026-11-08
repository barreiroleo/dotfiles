#!/data/data/com.termux/files/usr/bin/bash

USER="leonardo"

echo "Tip: Run termux-reset for clean install"
pkg update
pkg upgrade
pkg install tur-repo curl wget git x11-repo termux-x11-nightly pulseaudio proot-distro

echo "Downloading starting script"
curl -O https://raw.githubusercontent.com/LinuxDroidMaster/Termux-Desktops/main/scripts/proot_arch/startxfce4_arch.sh
sed -i -e "s/droidmaster/${USER}/g" startxfce4_arch.sh

echo "Installing archlinux distro"
proot-distro install archlinux

echo "Setup host storage"
termux-setup-storage

echo "Post install script"
proot-distro copy ./post-install.sh archlinux:/tmp/post-install.sh
proot-distro login archlinux -- /tmp/post-install.sh
DOTFILES_CMD="git clone https://github.com/barreiroleo/dotfiles.git ~/dotfiles && ~/dotfiles/stow.sh apply"
proot-distro login archlinux --user ${USER} -- /bin/bash -c "${DOTFILES_CMD}"

echo "Login as ${USER}"
proot-distro login --shared-tmp --no-arch-warning --user ${USER} archlinux
