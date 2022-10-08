#!/bin/bash

echo "Installing noto fonts"
PACKAGES="noto-fonts noto-fonts-emoji" # noto-fonts-cjk noto-fonts-extra"
sh ./scripts/query_install.sh pacman $PACKAGES

download ()
{
    URL="$1"; DIR="$2"; FILE="$2".zip
    echo "Installing $DIR"
    echo ULR: "$URL"; echo DIR: "$DIR"; echo FILE: "$FILE"; echo ''
    if [[ ! -d ~/.local/share/fonts/"$DIR" ]]; then
        wget -O "$FILE" "$URL"
        mkdir ~/.local/share/fonts/ -p
        unzip -d "$DIR" "$FILE" && mv "$DIR"/ ~/.local/share/fonts/
        rm "$FILE"*
    fi
}

# URL=; DIR=

URL=https://github.com/source-foundry/Hack/releases/download/v3.003/Hack-v3.003-ttf.zip; DIR=Hack
download "$URL" "$DIR"
URL=https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/Hack.zip; DIR="Hack Nerd Font Mono"
download "$URL" "$DIR"

URL=https://download.jetbrains.com/fonts/JetBrainsMono-2.242.zip; DIR="JetBrains Mono"
download "$URL" "$DIR"
URL=https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/JetBrainsMono.zip; DIR="JetBrainsMono Nerd Font Mono"
download "$URL" "$DIR"

URL=https://github.com/vizhub-core/ubuntu-mono-ligaturized/archive/refs/heads/master.zip; DIR="Ubuntu Mono Ligaturized"
download "$URL" "$DIR"
URL=https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/UbuntuMono.zip; DIR="UbuntuMono Nerd Font"
download "$URL" "$DIR"

URL=https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/VictorMono.zip; DIR="VictorMono Nerd Font"
download "$URL" "$DIR"

URL=https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/NerdFontsSymbolsOnly.zip; DIR="Symbols Nerd Font Mono"
download "$URL" "$DIR"

echo "Recaching fonts"
fc-cache -fv

RED='\033[0;31m'; NC='\033[0m'
echo -e "\nYou can check the font name with: ${RED}fc-list | grep --regexp=\"/share/fonts/FONTFOLDER\"${NC}"
lsd ~/.local/share/fonts/
