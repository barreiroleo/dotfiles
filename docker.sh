#!/bin/bash

! pacman --query docker && sudo pacman -Sy docker --noconfirm

sudo systemctl start docker.service
sudo systemctl enable docker.service
sudo usermod -aG docker $USER
