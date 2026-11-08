#!/bin/bash
#set -x
sudo pacman -Syu --noconfirm

if [[ ! $(which xdg-open) ]];then
    sudo pacman -S xdg-utils --noconfirm
fi
if [[ ! $(which wslview) ]]; then
    echo "[WARN] wslu missing for arch"
fi

echo "[WARN] Skipping locale config"
# if [[ ! "$LANG" == "es_AR.UTF8" ]]; then
#     echo "Actual locale: $LANG"
#     sudo locale-gen "es_AR.UTF-8"
#     sudo dpkg-reconfigure locales
# fi
# echo "[ OK ] Locale configured es_AR.UTF-8"

if [[ ! $(which zsh) ]]; then
    echo "ZSH"
    sudo pacman -S zsh --noconfirm
fi
echo "[ OK ] ZSH"

if [[ ! -d ~/.oh-my-zsh/ ]]; then
    echo "ZSH Oh my zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    # git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
fi
echo "[ OK ] ZSH Oh my zsh"

DIR=~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
if [[ ! -d "$DIR" ]]; then
    echo "ZSH Syntax highlighting"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
        ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi
echo "[ OK ] ZSH Syntax highlighting"

DIR=~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
if [[ ! -d "$DIR" ]]; then
    echo "ZSH Autosuggestion"
    git clone https://github.com/zsh-users/zsh-autosuggestions \
        ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi
echo "[ OK ] ZSH Autosuggestion"

if [[ ! $SHELL == /usr/bin/zsh && ! $SHELL == /bin/zsh ]]; then
    echo "ZSH by default"
    chsh -s /bin/zsh
fi
echo "[ OK ] ZSH by default"

# if [[ ! -d "/usr/bin/gnome-terminal.bak" ]]; then
#     sudo mv /usr/bin/gnome-terminal /usr/bin/gnome-terminal.bak
#     sudo ln -s /usr/bin/kitty /usr/bin/gnome-terminal
# fi
