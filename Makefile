DESKTOP_PACKAGES = gnome conky ulauncher flatpak
DEVELOP_PACKAGES = terminal git ssh vim docker hosts fonts platformio

.PHONY: all default dirs develop desktop
all: default dirs $(DEVELOP_PACKAGES) $(DESKTOP_PACKAGES)
default:
	! pacman --query stow && sudo pacman -Sy stow --noconfirm; true
dirs:
	mkdir -p ~/.local/bin/ ~/.ssh/

.PHONY:  $(DEVELOP_PACKAGES)
develop: default $(DEVELOP_PACKAGES)
terminal:
	sh terminal.sh
	stow --verbose --target=$$HOME --restow kitty shell tmux

git: dirs ssh
	! pacman --query lazygit && sudo pacman -Sy lazygit --noconfirm; true
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


.PHONY:  $(DESKTOP_PACKAGES)
desktop: default $(DESKTOP_PACKAGES)
gnome:
	sh gnome.sh
	stow --verbose --target=$$HOME --restow gnome

conky:
	! pacman --query conky && sudo pacman -Sy conky --noconfirm; true
	stow --verbose --target=$$HOME --restow conky

ulauncher:
	! pacman --query ulauncher && yay -Sy ulauncher --noconfirm; true
	stow --verbose --target=$$HOME --restow ulauncher
	
flatpak:
	sh flatpak.sh
