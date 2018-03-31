#!/bin/bash

set -euxo pipefail

dvd_drive=false
multimedia=false

# Update, remove crap & upgrade
sudo apt update
sudo apt remove -y libreoffice* thunderbird* rhythmbox* shotwell* && sudo apt autoremove -y
sudo apt upgrade -y

# Basic deps
sudo apt install -y \
  wget curl git \
  tmux htop iotop bmon nethogs \
  cowsay fortune \
  checkinstall locales build-essential yasm \
  docker \
  handbrake guake redshift

# Update to newest version of distro (if available)
sudo sed -i 's/^Prompt=lts/Prompt=normal/g' /etc/update-manager/release-upgrades
sudo do-release-upgrade  -f DistUpgradeViewNonInteractive

# Bypass DVD copy protection
if $dvd_drive; then
  sudo DEBIAN_FRONTEND=noninteractive apt -yq install libdvd-pkg
fi

# ffmpeg
if $multimedia; then
  sudo apt install -y \
    libass-dev libfreetype6-dev \
    libsdl2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev \
    libxcb-xfixes0-dev pkg-config texinfo zlib1g-dev \
    libmp3lame-dev libfdk-aac-dev libx264-dev libx265-dev
  sudo apt install -y ffmpeg
fi

# Clean up
sudo apt autoremove -y

