#!/bin/bash

username=$(powershell.exe -Command '$env:USERNAME' | tr -d '\r')
appdata_path="/mnt/c/Users/${username}/AppData/Roaming"
alacritty_path="${appdata_path}/alacritty"

mkdir -p ${alacritty_path}
cp -r . ${alacritty_path}
