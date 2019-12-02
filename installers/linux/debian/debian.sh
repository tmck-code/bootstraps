#!/bin/bash

set -euxo pipefail

function install_packages() {
  # Update & upgrade
  sudo apt update
  sudo apt remove -y libreoffice* thunderbird* rhythmbox* shotwell*
  sudo apt-get autoremove -y
  sudo apt upgrade -y --no-install-recommends

  # Basic deps
  sudo apt install -y --no-install-recommends \
    wget curl git tig tree \
    tmux htop iotop bmon nethogs sysstat \
    cowsay fortune \
    locales build-essential yasm \
    redshift \
    software-properties-common

  # Clean up
  sudo apt-get autoremove -y
}


case ${1:-} in
  "packages" ) install_packages ;;
  *)           install_packages ;;
esac

