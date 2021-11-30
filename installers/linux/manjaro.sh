#!/bin/bash

sudo pacman -Syu --noconfirm \
    git \
    obs-studio \
    vim \
    python3 python-pip \
    alacritty \
    tmux cowsay fortune-mod screenfetch \
    ffmpeg flatpak

flatpak install flathub com.valvesoftware.Steam
flatpak run com.valvesoftware.Steam
