DESKTOP_PACKAGES = gnome conky ulauncher flatpak qalc pdf stream
DEVELOP_PACKAGES = terminal git ssh vim docker hosts fonts platformio code cmake virtualbox
SYSTEM_PACKAGES = appimages monitor network

.PHONY: all default dirs develop desktop
all: default dirs $(DEVELOP_PACKAGES) $(DESKTOP_PACKAGES)
default:
	sudo pacman -Sy
	! pacman --query stow && sudo pacman -S stow --noconfirm; true
dirs:
	mkdir -p ~/.local/bin/ ~/.ssh/

.PHONY:  $(DEVELOP_PACKAGES)
develop: default $(DEVELOP_PACKAGES)
terminal:
	sh terminal.sh
	stow --verbose --target=$$HOME --restow kitty shell tmux

git: dirs ssh
	! pacman --query lazygit && sudo pacman -S lazygit --noconfirm; true
	cd private && stow --verbose --target=$$HOME --restow git

ssh: dirs
	[ ! -d ~/.ssh/id_rsa ] && cd private && stow --verbose --target=$$HOME --restow ssh; true

vim:
	stow --verbose --target=$$HOME --restow vim
	sh nvim.sh

docker: hosts
	sh docker.sh
	cd z_root && stow --verbose --target=$$HOME --restow docker

hosts:
	cd z_root && stow --verbose --target=$$HOME --restow hosts

fonts:
	sh fonts.sh

platformio:
	sh platformio.sh

code:
	! pacman --query visual-studio-code-bin && yay -S visual-studio-code-bin  --noconfirm; true

virtualbox:
	sh virtualbox.sh

cmake:
	! pacman --query cmake && yay -S cmake --noconfirm; true

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
	! pacman --query conky && sudo pacman -S conky --noconfirm; true
	stow --verbose --target=$$HOME --restow conky

ulauncher: qalc
	! pacman --query ulauncher wmctrl && yay -S ulauncher wmctrl --noconfirm; true
	stow --verbose --target=$$HOME --restow ulauncher
	
flatpak:
	sh flatpak.sh

qalc:
	! pacman --query qalculate-gtk && yay -S qalculate-gtk --noconfirm; true

pdf:
	! pacman --query sioyek-appimage && yay -S sioyek-appimage --noconfirm; true

stream:
	! pacman --query iriunwebcam-bin && yay -S iriunwebcam-bin --noconfirm; true
	sudo rmmod v4l2loopback; sudo modprobe v4l2loopback
	! pacman --query obs-studio qt5-wayland qt6-wayland && sudo pacman -S obs-studio qt5-wayland qt6-wayland --noconfirm; true
	! pacman --query zoom && yay -S zoom --noconfirm; true
	cd private && stow --verbose --target=$$HOME --restow obs
