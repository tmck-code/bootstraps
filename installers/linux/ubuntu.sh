#!/bin/bash

set -euxo pipefail

# Update, remove crap & upgrade
sudo apt update
sudo apt purge -y libreoffice* thunderbird* rhythmbox* shotwell*
sudo apt autoremove -y
sudo apt upgrade -y --no-install-recommends

# Basic deps
sudo apt install -y --no-install-recommends \
  wget curl git \
  tmux htop iotop bmon nethogs \
  cowsay fortune \
  checkinstall locales build-essential yasm \
  handbrake redshift

# Clean up
sudo apt autoremove -y

# TODO: verify if this still works
#
# Update to newest version of distro (if available)
# sudo sed -i 's/^Prompt=lts/Prompt=normal/g' /etc/update-manager/release-upgrades
# sudo do-release-upgrade -f DistUpgradeTextView || echo "no new releases"

# Bypass DVD copy protection
# sudo DEBIAN_FRONTEND=noninteractive apt -yq install libdvd-pkg
