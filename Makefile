DESKTOP_PACKAGES = gnome conky ulauncher flatpak qalc pdf stream
DEVELOP_PACKAGES = terminal git ssh vim docker hosts fonts platformio code cmake virtualbox
SYSTEM_PACKAGES = appimages monitor network

.PHONY: all default dirs develop desktop
install-pac:=sh ./scripts/query_install.sh pacman
install-yay:=sh ./scripts/query_install.sh yay

all: default dirs $(DEVELOP_PACKAGES) $(DESKTOP_PACKAGES)
default:
	sudo pacman -Sy
	$(install-pac) stow
dirs:
	mkdir -p ~/.local/bin/ ~/.ssh/

.PHONY:  $(DEVELOP_PACKAGES)
develop: default $(DEVELOP_PACKAGES)
terminal:
	sh terminal.sh
	stow --verbose --target=$$HOME --restow kitty shell tmux

git: dirs ssh
	$(install-pac) lazygit
	cd private && stow --verbose --target=$$HOME --restow git

ssh: dirs
	[ ! -d ~/.ssh/id_rsa ] && cd private && stow --verbose --target=$$HOME --restow ssh; true

vim:
	stow --verbose --target=$$HOME --restow vim
	sh nvim.sh
code:
	$(install-yay) visual-studio-code-bin

docker: hosts
	sh docker.sh
	cd z_root && stow --verbose --target=$$HOME --restow docker

hosts:
	cd z_root && stow --verbose --target=$$HOME --restow hosts

fonts:
	sh fonts.sh

platformio:
	sh platformio.sh

cmake:
	$(install-pac) cmake

virtualbox:
	sh virtualbox.sh


.PHONY: $(SYSTEM_PACKAGES)
appimages:
	sh appimages.sh
monitor:
	$(install-pac) bottom
network:
	$(install-pac) nethogs bandwhich

.PHONY:  $(DESKTOP_PACKAGES)
desktop: default $(DESKTOP_PACKAGES)
gnome:
	sh gnome.sh
	stow --verbose --target=$$HOME --restow gnome

conky:
	$(install-pac) conky
	stow --verbose --target=$$HOME --restow conky

ulauncher: qalc
	$(install-pac) ulauncher wmctrl
	stow --verbose --target=$$HOME --restow ulauncher
	
flatpak:
	sh flatpak.sh

pdf:
	$(install-yay) sioyek-appimage
qalc:
	$(install-pac) qalculate-gtk

iriunwebcam:
	$(install-pac) iriunwebcam-bin
	sudo rmmod v4l2loopback; sudo modprobe v4l2loopback
obs:
	$(install-pac) obs-studio qt5-wayland qt6-wayland
	cd private && stow --verbose --target=$$HOME --restow obs
zoom:
	$(install-yay) zoom
