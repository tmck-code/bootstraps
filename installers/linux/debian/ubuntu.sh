#!/bin/bash

set -euxo pipefail

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
  handbrake guake redshift

# Update to newest version of distro (if available)
# sudo sed -i 's/^Prompt=lts/Prompt=normal/g' /etc/update-manager/release-upgrades
# sudo do-release-upgrade -f DistUpgradeTextView || echo "no new releases"

# Bypass DVD copy protection
sudo DEBIAN_FRONTEND=noninteractive apt -yq install libdvd-pkg

# Clean up
sudo apt autoremove -y

