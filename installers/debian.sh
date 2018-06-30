#!/bin/bash

set -euxo pipefail

function install_firefox() {
  sudo mkdir -p /usr/local/src && sudo chown $USER /usr/local/src && cd /usr/local/src
  wget -O FirefoxSetup.tar.bz2 "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US"
  sudo mkdir -p /opt/firefox
  sudo tar xjf FirefoxSetup.tar.bz2 -C /opt/firefox/
  rm FirefoxSetup.tar.bz2
  
  if [ -f /usr/lib/firefox-esr/firefox-esr ]; then
    sudo mv /usr/lib/firefox-esr/firefox-esr /usr/lib/firefox-esr/firefox-esr.bak
  fi
  
  sudo ln -s /opt/firefox/firefox/firefox /usr/lib/firefox-esr/firefox-esr
}

# Update & upgrade
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
  handbrake redshift

# Clean up
sudo apt autoremove -y

install_firefox

echo "
[device]
wifi.scan-rand-mac-address=no
" >> /etc/NetworkManager/NetworkManager.conf 

