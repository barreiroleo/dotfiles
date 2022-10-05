#!/bin/bash
sh ./scripts/query_install.sh pacman docker

sudo systemctl start docker.service
sudo systemctl enable docker.service
sudo usermod -aG docker $USER
