install-pac:=sh ./scripts/query_install.sh pacman
install-yay:=sh ./scripts/query_install.sh yay

.PHONY: all default dirs
all: default dirs $(DEVELOP_PACKAGES) $(DESKTOP_PACKAGES)
default:
	sudo pacman -Sy
	$(install-pac) stow
dirs:
	mkdir -p ~/.local/bin/ ~/.ssh/

.PHONY: desktop develop office stream system 
desktop: default $(DESKTOP_PACKAGES)
develop: default $(DEVELOP_PACKAGES)
office:  default $(OFFICE_PACKAGES)
stream:  default $(STREAM_PACKAGES)
system:  default $(SYSTEM_PACKAGES)
	

DESKTOP_PACKAGES = conky fonts gnome ulauncher web
.PHONY: $(DESKTOP_PACKAGES)
conky:
	$(install-pac) conky
	stow --verbose --target=$$HOME --restow conky
fonts:
	sh fonts.sh
gnome:
	sh gnome.sh
	stow --verbose --target=$$HOME --restow gnome
ulauncher: qalc
	$(install-pac) ulauncher wmctrl
	stow --verbose --target=$$HOME --restow ulauncher
web:
	$(install-yay) firefox-pwa-bin brave-bin


DEVELOP_PACKAGES = terminal git ssh vim code docker virtualbox platformio cmake draw
.PHONY: $(DEVELOP_PACKAGES)
terminal: fonts
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
virtualbox:
	sh virtualbox.sh
platformio:
	sh platformio.sh
cmake:
	$(install-pac) cmake
draw:
	$(install-yay) drawio-desktop-bin
	$(install-pac) inkscape


OFFICE_PACKAGES  = pdf qalc
.PHONY: $(OFFICE_PACKAGES)
pdf:
	$(install-yay) sioyek-appimage
qalc:
	$(install-pac) qalculate-gtk


STREAM_PACKAGES  = iriunwebcam obs zoom
.PHONY: $(STREAM_PACKAGES)
iriunwebcam:
	$(install-pac) iriunwebcam-bin
	sudo rmmod v4l2loopback; sudo modprobe v4l2loopback
obs:
	$(install-pac) obs-studio qt5-wayland qt6-wayland
	cd private && stow --verbose --target=$$HOME --restow obs
zoom:
	$(install-yay) zoom


SYSTEM_PACKAGES  = appimages flatpak hosts monitor network
.PHONY: $(SYSTEM_PACKAGES)
appimages:
	sh appimages.sh
flatpak:
	sh flatpak.sh
hosts:
	cd z_root && stow --verbose --target=$$HOME --restow hosts
monitor:
	$(install-pac) bottom
network:
	$(install-pac) nethogs bandwhich
