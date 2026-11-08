#!/bin/bash
#set -x

sudo apt update -y

if [[ ! $(which gcc) ]]; then
    echo "Build essential - GCC"
    sudo apt-get install build-essential gcc make ninja-build python3-pip python3-venv graphviz gdb jq bc openjdk-21-jdk -y

    sudo apt install gcc-14 g++-14 libgcc-14-dev libstdc++-14-dev
    sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-14 60
    sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-14 60
fi
echo "[ OK ] Build essential - GCC"

if [[ ! $(which clang) ]]; then
    echo "LLVM and Clang"
    echo "deb http://apt.llvm.org/noble/ llvm-toolchain-noble main" | sudo tee -a /etc/apt/sources.list.d/llvm.list
    echo "deb-src http://apt.llvm.org/noble/ llvm-toolchain-noble main" | sudo tee -a /etc/apt/sources.list.d/llvm.list
    wget -qO- https://apt.llvm.org/llvm-snapshot.gpg.key | sudo tee /etc/apt/trusted.gpg.d/apt.llvm.org.asc
    sudo apt update -y
    sudo apt install clang clang-tools clangd clang-tidy clang-format lld libc++-dev -y
    sudo update-alternatives --set cc $(which clang)
    sudo update-alternatives --set c++ $(which clang++)
fi
echo "[ OK ] LLVM Clang"

if [[ ! $(which cmake) ]]; then
    echo "Cmake"
    sudo snap install cmake --classic
fi
echo "[ OK ] Cmake"

if [[ ! $(which npm) ]]; then
    # If there's already a NVM_DIR configured in ~/.zshenv, then the path should be exist.
    if [[ -n ${NVM_DIR} ]];
        then mkdir -p ${NVM_DIR}
    fi
    # From nodejs' doc
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash
    # in lieu of restarting the shell
    \. "$HOME/.nvm/nvm.sh"
    # Download and install Node.js:
    nvm install 22
    node -v && nvm current && npm -v
fi
echo "[ OK ] Nodejs - npm"

if [[ ! $(which pipx) ]]; then
    sudo apt install pipx
    pipx ensurepath
fi
echo "[ OK ] Pipx"

if [[ ! $(which docker) ]]; then
    # From docker's doc
    # Add Docker's official GPG key:
    sudo apt-get update
    sudo apt-get install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

    # Post install
    sudo groupadd docker
    sudo usermod -aG docker $USER
    newgrp docker
fi
echo "[ OK ] Docker"

if [[ ! $(which openconnect) ]]; then
   echo 'deb http://download.opensuse.org/repositories/home:/bluca:/openconnect/Ubuntu_24.04/ /' | sudo tee /etc/apt/sources.list.d/home:bluca:openconnect.list
   curl -fsSL https://download.opensuse.org/repositories/home:bluca:openconnect/Ubuntu_24.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_bluca_openconnect.gpg > /dev/null
   sudo apt update
   sudo apt install openconnect network-manager-openconnect-gnome -y
fi

echo "[ OK ] Openconnect"
if [[ ! $(which dotnet) ]]; then
    # Official script: https://learn.microsoft.com/en-us/dotnet/core/install/linux-ubuntu#register-the-microsoft-package-repository
    # Get Ubuntu version
    declare repo_version=$(if command -v lsb_release &> /dev/null; then lsb_release -r -s; else grep -oP '(?<=^VERSION_ID=).+' /etc/os-release | tr -d '"'; fi)
    # Download Microsoft signing key and repository
    wget https://packages.microsoft.com/config/ubuntu/$repo_version/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
    sudo dpkg -i packages-microsoft-prod.deb
    rm packages-microsoft-prod.deb
    sudo apt update
    sudo apt install dotnet-sdk-7.0 -y
fi
echo "[ OK ] .NET Core 7"

if [[ ! $(which lua) || ! $(which luarocks) ]]; then
    sudo apt-get --no-install-recommends install lua5.1 luarocks -y
fi
echo "[ OK ] lua & luarocks (needed for mason tools, null-ls)"

if [[ ! -f ~/.local/bin/plantuml.jar ]]; then
    sudo apt-get install --no-install-recommends graphviz -y
    PLANTUML_VERSION=$(curl -s "https://api.github.com/repos/plantuml/plantuml/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo plantuml.jar "https://github.com/plantuml/plantuml/releases/latest/download/plantuml-${PLANTUML_VERSION}.jar"
    mv plantuml.jar ~/.local/bin/
fi
echo "[ OK ] Plantuml downloaded at ~/.local/bin/plantuml.jar"
