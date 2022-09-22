.PHONY: default stow
default: stow develop desktop
stow:
	! pacman --query stow && sudo pacman -S stow; true

.PHONY: all delete
all:
	stow --verbose --target=$$HOME --restow */ 
	stow --verbose --target=$$HOME --delete private z_root
	cd private	&& stow --verbose --target=$$HOME --restow */ && cd ..
	cd z_root	&& stow --verbose --target=/ 	  --restow */ && cd ..
delete:
	stow --verbose --target=$$HOME --delete */ 
	cd private	&& stow --verbose --target=$$HOME --delete */ && cd ..
	cd z_root	&& stow --verbose --target=/ 	  --delete */ && cd ..


.PHONY: develop terminal git ssh vim docker fonts platformio
develop: terminal git ssh vim docker hosts fonts platformio
terminal:
	sh terminal.sh
	stow --verbose --target=$$HOME --restow kitty shell tmux
git: ssh
	cd private && stow --verbose --target=$$HOME --restow git bin
ssh:
	[ ! -d ~/.ssh ] && cd private && stow --verbose --target=$$HOME --restow ssh; true
vim:
	! pacman --query neovim && sudo pacman -S neovim; true
	! pacman --query xclip	&& sudo pacman -S xclip wl-clipboard; true
	stow --verbose --target=$$HOME --restow vim
	[ ! -d ~/.local/share/nvim/mason ] && \
		nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'; true
docker: hosts
	! pacman --query docker && sudo pacman -S docker; true
	cd z_root && stow --verbose --target=$$HOME --restow docker
	sudo systemctl start docker.service
	sudo systemctl enable docker.service
	sudo usermod -aG docker $$USER
hosts:
	cd z_root && stow --verbose --target=$$HOME --restow hosts
fonts:
	sh fonts.sh
platformio:
	sh platformio.sh

.PHONY: desktop gnome conky ulauncher
desktop: gnome conky ulauncher
gnome:
	rm ~/.config/user-dirs.dirs ~/.config/user-dirs.locale
	stow --verbose --target=$$HOME --restow gnome
conky:
	! pacman --query conky && sudo pacman -S conky; true
	stow --verbose --target=$$HOME --restow conky bin
ulauncher:
	! pacman --query ulauncher && yay -S ulauncher --noconfirm; true
	stow --verbose --target=$$HOME --restow ulauncher

