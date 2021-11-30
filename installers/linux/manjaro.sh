#!/bin/bash

set -euo pipefail

# Base dependencies
sudo pacman -Syu --noconfirm \
    git vim ffmpeg \
    tmux cowsay lolcat fortune-mod screenfetch \
    pkgconf flatpak \
    python3 python-pip \
    obs-studio alacritty

# Steam
flatpak install flathub com.valvesoftware.Steam
# Need this to be able to access another drive
flatpak override --user --filesystem=/mnt/X/ com.valvesoftware.Steam
# flatpak run com.valvesoftware.Steam

# pokesay-go
bash -c "$(curl https://raw.githubusercontent.com/tmck-code/pokesay-go/master/scripts/install.sh)" bash linux amd64
