.PHONY: default dirs develop
default:
	! pacman --query stow && sudo pacman -Sy stow --noconfirm; true
dirs:
	mkdir -p ~/.local/bin/ ~/.ssh/
all: default dirs $(DEVELOP) $(DESKTOP)

DEVELOP = terminal git ssh vim docker hosts fonts platformio
develop: default $(DEVELOP)
.PHONY:  $(DEVELOP)

terminal:
	sh terminal.sh
	stow --verbose --target=$$HOME --restow kitty shell tmux

git: dirs ssh
	! pacman --query lazygit && sudo pacman -Sy lazygit --noconfirm; true
	cd private && stow --verbose --target=$$HOME --restow git

ssh: dirs
	[ ! -d ~/.ssh ] && cd private && stow --verbose --target=$$HOME --restow ssh; true

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


DESKTOP = gnome conky ulauncher flatpak
desktop: default $(DESKTOP)
.PHONY:  $(DESKTOP)
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
