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

.PHONY: develop terminal git ssh ide docker fonts
develop: terminal git ssh ide docker hosts fonts
terminal:
	sh terminal.sh
	stow --verbose --target=$$HOME --restow kitty shell tmux
git: ssh
	cd private && stow --verbose --target=$$HOME --restow git
ssh:
	[ ! -d ~/.ssh ] && cd private && stow --verbose --target=$$HOME --restow ssh; true
ide:
	! pacman --query neovim && sudo pacman -S neovim; true
	! pacman --query xclip	&& sudo pacman -S xclip wl-clipboard; true
	stow --verbose --target=$$HOME --restow vim
	[ ! -d ~/.local/share/nvim/mason ] && \
		nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'; true
docker: hosts
	cd z_root && stow --verbose --target=$$HOME --restow docker
hosts:
	cd z_root && stow --verbose --target=$$HOME --restow hosts
fonts:
	sh fonts.sh

.PHONY: develop-apps nvim platformio
develop-apps: nvim platformio
nvim:
	sudo pacman -S neovim
platformio:
	sh platformio.sh

.PHONY: desktop gnome conky ulauncher
desktop: gnome conky ulauncher
gnome:
	stow --verbose --target=$$HOME --restow gnome
conky:
	stow --verbose --target=$$HOME --restow conky
ulauncher:
	stow --verbose --target=$$HOME --restow ulauncher

