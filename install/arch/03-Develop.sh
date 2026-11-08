#!/bin/bash
#set -x
sudo pacman -Syu --noconfirm

if [[ ! $(which man) ]]; then
    sudo pacman -S man-pages man-pages-es --noconfirm
fi
echo "[ OK ] Man pages installed"

if [[ ! $(which clang) ]];then
    sudo pacman -S base-devel ninja clang libc++ cmake gdb cppcheck jq bc --noconfirm
fi
echo "[ OK ] Base-devel (build-essential), clang, libc++, cmake, gdb, cppcheck jq, bc"

if [[ ! $(which uv) ]]; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi
echo "[OK] Python UV manager"

if [[ ! $(which dotnet) ]];then
    sudo pacman -S dotnet-runtime dotnet-sdk --noconfirm
fi
echo "[ OK ] .NET Core"

if [[ ! $(which java) ]];then
    sudo pacman -S jdk-openjdk --noconfirm
fi
echo "[ OK ] Java Development Kit"

if [[ ! $(which node) ]];then
    curl -fsSL https://fnm.vercel.app/install | bash
    mkdir -p ~/.oh-my-zsh/completions/
    fnm completions --shell zsh > ~/.oh-my-zsh/completions/_fnm
    fnm install v25
fi
echo "[ OK ] FNM & NodeJS"

if [[ ! $(which lua) ]];then
    sudo pacman -S lua51 luarocks luajit --noconfirm
fi
echo "[ OK ] lua & luarocks"

if [[ ! $(which go) ]];then
    sudo pacman -S go --noconfirm
fi
echo "[ OK ] Golang"

if [[ ! $(which cargo) ]];then
    sh -c "$(curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs)"
fi
echo "[ OK ] Rust"

if [[ ! $(which docker) ]];then
    sudo pacman -S docker docker-compose
fi
echo "[ OK ] docker"

if [[ ! -f ~/.local/bin/plantuml.jar ]]; then
    sudo pacman -S graphviz --noconfirm
    PLANTUML_VERSION=$(curl -s "https://api.github.com/repos/plantuml/plantuml/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo plantuml.jar "https://github.com/plantuml/plantuml/releases/latest/download/plantuml-${PLANTUML_VERSION}.jar"
    mkdir -p ~/.local/bin/
    mv plantuml.jar ~/.local/bin/
fi
echo "[ OK ] Plantuml downloaded at ~/.local/bin/plantuml.jar"

if [[ ! $(which virt-manager) ]]; then
    https://tanis.codes/posts/virt-manager-qemu-arch-linux/
    # sudo pacman -Syu libvirt virt-manager qemu-full dnsmasq dmidecode
    sudo pacman -Syu libvirt virt-manager qemu-base qemu-desktop dnsmasq dmidecode
    sudo systemctl enable --now libvirtd.service virtlogd.service
    sudo usermod -aG libvirt ${USER}
    sudo virsh net-autostart default && sudo virsh net-start default
    echo "Ensure that any files/folders outside of Virt-managers default pool are owned by the libvirt-qemu group"
    echo "sudo chown ${USER}:libvirt-qemu /path/to/vm/folder"
fi
