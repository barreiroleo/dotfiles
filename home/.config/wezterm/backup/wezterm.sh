#!/bin/bash

username=$(powershell.exe -Command '$env:USERNAME' | tr -d '\r')
home_path="/mnt/c/Users/${username}"
wezterm_cfg_path="${home_path}/.wezterm"

rm -rf ${wezterm_cfg_path} ${home_path}/.wezterm.lua
mkdir -p ${wezterm_cfg_path}
cp wezterm.lua ${home_path}/.wezterm.lua
cp -r . ${wezterm_cfg_path}
