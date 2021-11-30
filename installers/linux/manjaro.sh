#!/bin/bash

set -euo pipefail

# Makes the package manager downloads 100x faster
sudo pacman-mirrors --country Australia

# Base dependencies
sudo pacman -Syu --noconfirm \
    git vim ffmpeg code docker docker-compose \
    tmux cowsay lolcat fortune-mod screenfetch redshift \
    pkgconf flatpak \
    python3 python-pip \
    obs-studio alacritty piper

# Add user to the docker group
sudo usermod -aG docker $USER

# pokesay-go
bash -c "$(curl https://raw.githubusercontent.com/tmck-code/pokesay-go/master/scripts/install.sh)" bash linux amd64

# Steam
# run with: flatpak run com.valvesoftware.Steam
flatpak install flathub com.valvesoftware.Steam
# Need this to be able to access another drive
flatpak override --user --filesystem=/mnt/X/ com.valvesoftware.Steam
