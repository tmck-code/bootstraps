#!/bin/bash

set -euxo pipefail

# Update, remove crap & upgrade
sudo apt update
sudo apt remove -y libreoffice* thunderbird* rhythmbox*
sudo apt upgrade -y

# Update to newest version of distro (if available)
sudo do-release-upgrade -f DistUpgradeViewNonInteractive

# Basic deps
sudo apt install -y \
    cowsay fortune tmux \
    docker docker-compose \
    wget git checkinstall locales build-essential yasm \
    htop iotop bmon nethogs \
    ilc handbrake guake redshift

# Bypass DVD copy protection
sudo DEBIAN_FRONTEND=noninteractive apt -yq install libdvd-pkg

# ffmpeg
sudo apt install -y libass-dev libfreetype6-dev \
  libsdl2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev \
  libxcb-xfixes0-dev pkg-config texinfo zlib1g-dev \
  libmp3lame-dev libfdk-aac-dev libx264-dev libx265-dev
sudo apt install -y ffmpeg

# Clean up
sudo apt autoremove -y

