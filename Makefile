.PHONY: default
default: develop desktop

.PHONY: all delete
all:
	stow --verbose --target=$$HOME --restow */
	stow --verbose --target=$$HOME --delete z_root/
	stow --verbose --target=/ --restow z_root/
delete:
	stow --verbose --target=$$HOME --delete */
	stow --verbose --target=$$HOME --delete z_root/
	stow --verbose --target=/ --delete z_root/

.PHONY: develop terminal git ssh ide docker
develop: terminal git ssh ide docker
terminal:
	stow --verbose --target=$$HOME --restow kitty shell tmux
git: ssh
	stow --verbose --target=$$HOME --restow git
ssh:
	stow --verbose --target=$$HOME --restow ssh
ide:
	stow --verbose --target=$$HOME --restow vim
docker:
	cd z_root && sudo stow --verbose --target=/ --restow docker hosts


.PHONY: desktop gnome conky ulauncher
desktop: gnome conky ulauncher
gnome:
	stow --verbose --target=$$HOME --restow gnome
conky:
	stow --verbose --target=$$HOME --restow conky
ulauncher:
	stow --verbose --target=$$HOME --restow ulauncher

