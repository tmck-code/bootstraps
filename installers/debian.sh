#!/bin/bash

set -euxo pipefail

# Update & upgrade
sudo apt update
sudo apt upgrade -y

# Basic deps
sudo apt install -y \
  wget curl git \
  tmux htop iotop bmon nethogs \
  cowsay fortune \
  checkinstall locales build-essential yasm \
  docker \
  handbrake redshift

# Clean up
sudo apt autoremove -y

