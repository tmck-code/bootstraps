#!/bin/bash

set -euo pipefail

# Remove the largest, least-used programs. Saves a lot of time when running 
# `apt-get upgrade` for the first time
function purge_bloat() {
  echo "> Purging largest programs that aren't often used"
  sudo apt-get update
  sudo apt-get purge -y libreoffice* thunderbird* rhythmbox* shotwell*
  sudo apt-get autoremove -y
}

# Removes bloaty programs and then upgrades the system.
function clean_slate() {
  purge_bloat

  echo "> Upgrading all OS packages"
  sudo apt-get update
  sudo apt-get upgrade -y
}

# Install base dependencies
function install_base() {
  echo "> Installing base OS packages"
  sudo apt-get update
  sudo apt-get install -y --no-install-recommends \
    wget curl git tig tree \
    tmux htop iotop bmon sysstat \
    parallel \
    cowsay fortune \
    locales build-essential yasm \
    brasero \
    redshift \
    software-properties-common
}


# Install tools used in .bashrc
# - my pokesay lib
# - "high-performance" lolcat
function install_pokesay() {
  echo "> Installing pokesay tools for .bashrc"
  cd /tmp

  sudo apt-get update
  sudo apt-get install -y cowsay fortune

  if [ ! -f $HOME/bin/pokesay ]; then
    git clone --depth 1 http://github.com/tmck-code/pokesay
    (cd pokesay && ./install.sh)
  fi

  if [ ! -f $HOME/bin/lolcat ]; then
    git clone --depth 1 https://github.com/jaseg/lolcat.git
    (cd lolcat && make lolcat && cp ./lolcat $HOME/bin/)
  fi

  rm -rf /tmp/pokesay /tmp/lolcat
}

function bootstrap() {
  echo "> Bootstrapping debian"
  clean_slate
  install_base
  install_pokesay
  echo "> Bootstrap complete!"
}


case ${1:-} in
  "base" )        install_base ;;
  "pokesay" )     install_pokesay ;;
  "clean_slate" ) clean_slate ;;
  "bootstrap"|* )   bootstrap ;;
esac
