.PHONY: default
default: develop desktop

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
	stow --verbose --target=$$HOME --restow kitty shell tmux
	sudo pacman -S kitty zsh zsh-completions starship tmux lsd bat
	sudo pacman -S zsh-syntax-highlighting zsh-autosuggestions
	chsh -s /bin/zsh
	sh -c "$$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git: ssh
	cd private && stow --verbose --target=$$HOME --restow git
ssh:
	cd private && stow --verbose --target=$$HOME --restow ssh
ide:
	stow --verbose --target=$$HOME --restow vim
docker: hosts
	cd z_root && stow --verbose --target=$$HOME --restow docker
hosts:
	cd z_root && stow --verbose --target=$$HOME --restow hosts
fonts:
	sudo pacman -S noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra
	wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/UbuntuMono.zip
	unzip -d UbuntuMono UbuntuMono.zip && mv UbuntuMono/ ~/.local/share/fonts/ && rm Ubuntu*.zip
	fc-cache -fv
	
.PHONY: desktop gnome conky ulauncher
desktop: gnome conky ulauncher
gnome:
	stow --verbose --target=$$HOME --restow gnome
conky:
	stow --verbose --target=$$HOME --restow conky
ulauncher:
	stow --verbose --target=$$HOME --restow ulauncher

