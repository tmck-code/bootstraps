#!/bin/bash

set -euxo pipefail

function install_base_packages() {
  # Update & upgrade
  sudo apt update
  sudo apt upgrade -y

  # Basic deps
  sudo apt install -y \
    wget curl git \
    tmux htop iotop bmon nethogs \
    cowsay fortune \
    checkinstall locales build-essential yasm \

  # Clean up
  sudo apt-get autoremove
}

function install_media_packages() {
  sudo apt-get update
  sudo apt-get upgrade -y

  sudo apt-get install -y \
    brasero

  sudo add-apt-repository http://download.videolan.org/pub/debian/stable/
  wget -O - http://download.videolan.org/pub/debian/videolan-apt.asc | sudo apt-key add -

  sudo apt-get update
  sudo apt-get install libdvdcss2
}

function run() {
  install_base_packages
  install_media_packages
}

case ${1} in
  "icons" )    install_icons ;;
  "firefox" )  install_firefox ;;
  "packages" ) install_packages ;;
  "wifi" )     wifi ;;
  "run" )      run ;;
esac

