.PHONY: default develop all delete
default:
	! pacman --query stow && sudo pacman -S stow --noconfirm; true

DEVELOP = terminal git ssh vim docker hosts fonts platformio
develop: $(DEVELOP)
.PHONY:  $(DEVELOP)

terminal:
	sh terminal.sh
	stow --verbose --target=$$HOME --restow kitty shell tmux

git: ssh
	! pacman --query lazygit && sudo pacman -S lazygit --noconfirm; true
	cd private && stow --verbose --target=$$HOME --restow git

ssh:
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


.PHONY: gnome conky ulauncher flatpak
gnome:
	sh gnome.sh
	stow --verbose --target=$$HOME --restow gnome

conky:
	! pacman --query conky && sudo pacman -S conky --noconfirm; true
	stow --verbose --target=$$HOME --restow conky

ulauncher:
	! pacman --query ulauncher && yay -S ulauncher --noconfirm; true
	stow --verbose --target=$$HOME --restow ulauncher
	
flatpak:
	sh flatpack.sh
