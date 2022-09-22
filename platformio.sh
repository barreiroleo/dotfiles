#!/bin/bash

echo "Download and install platformio"
if [[ ! -d ~/.platformio ]]; then
    python3 -c "$(curl -fsSL https://raw.githubusercontent.com/platformio/platformio/master/scripts/get-platformio.py)"
fi

echo "Export binaries to path"
mkdir ~/.local/bin -p
ln -s ~/.platformio/penv/bin/platformio ~/.local/bin/platformio
ln -s ~/.platformio/penv/bin/pio ~/.local/bin/pio
ln -s ~/.platformio/penv/bin/piodebuggdb ~/.local/bin/piodebuggdb

echo "Enable udev rules"
curl -fsSL https://raw.githubusercontent.com/platformio/platformio-core/master/scripts/99-platformio-udev.rules \
    | sudo tee /etc/udev/rules.d/99-platformio-udev.rules

sudo udevadm control --reload-rules
sudo udevadm trigger

echo "Set permisions for Arch"
sudo usermod -a -G uucp $USER
sudo usermod -a -G lock $USER

# echo "Set permisions for Debian"
# sudo usermod -a -G dialout $USER
# sudo usermod -a -G plugdev $USER

echo "Enable tab completion zsh"
~/.local/bin/pio system completion install zsh
