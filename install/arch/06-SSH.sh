#!/bin/bash
#set -x
GREEN="\e[32m"
NC="\e[0m"

sudo pacman -Syu --noconfirm

if [[ ! $(pacman -Qn openssh) ]];then
    sudo pacman -S openssh --noconfirm
    sudo systemctl start sshd
fi
echo "[ OK ] OpenSSH"

# Generate SSH key if not exists
SSH_KEY_PATH="$HOME/.ssh/id_ed25519"
if [[ ! -f "$SSH_KEY_PATH" ]]; then
    local ssh_comment=""
    read -p "No SSH key found. Enter a comment for the new SSH key (e.g., <user>-<machine>): " ssh_comment
    ssh-keygen -t ed25519 -C "$ssh_comment" -f "$SSH_KEY_PATH"
fi
echo "[ OK ] SSH key generated at $SSH_KEY_PATH"

# Disable root login
sudo sed -i 's/^#*PermitRootLogin .*/PermitRootLogin no/' "/etc/ssh/sshd_config"
sudo sed -i 's/^#*PasswordAuthentication .*/PasswordAuthentication no/' "/etc/ssh/sshd_config"
sudo systemctl restart sshd
echo -e "Add authorized keys to ${GREEN}~/.ssh/authorized_keys${NC}"
echo "[ OK ] Root login and password authentication disabled"

# Configure UFW firewall
if command -v ufw &> /dev/null; then
    sudo ufw allow ssh
    sudo ufw allow 22/tcp
    sudo ufw --force enable
    echo "[ OK ] UFW configured to allow SSH"
fi
