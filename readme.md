# Dotfiles

`home/` mirrors `$HOME` and is linked with GNU Stow.

```bash
git clone https://github.com/barreiroleo/dotfiles.git ~/dotfiles
cd ~/dotfiles
./stow.sh apply                    # link home/ into $HOME
./stow.sh adopt ~/.config/<app>    # move an existing config into the repo and link it
```

## Install scripts

Run them in order from `install/<platform>/`:

- `install/arch/`
- `install/debian/`
- `install/termux/` (see its readme)

Install these manually:

- https://localsend.org/es
- https://wayscriber.com/#install
