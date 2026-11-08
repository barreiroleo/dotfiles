#!/data/data/com.termux/files/usr/bin/bash

JETBRAINS_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip"
wget -q --show-progress ${JETBRAINS_URL} -O JetBrainsMono.zip
unzip -q JetBrainsMono.zip -d JetBrainsMono/

mkdir -p ~/.termux
cp JetBrainsMono/JetBrainsMonoNerdFontMono-Regular.ttf ~/.termux/font.ttf

termux-reload-settings
rm JetBrainsMono JetBrainsMono.zip -rf
