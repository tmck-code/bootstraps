#!/bin/bash

set -euo pipefail

function install_launcher_arch() {
  rm -rf /tmp/minecraft-launcher
  sudo pacman -S jre-openjdk jre-openjdk-headless

  git clone https://aur.archlinux.org/minecraft-launcher.git /tmp/minecraft-launcher
  cd /tmp/minecraft-launcher

  makepkg
  sudo pacman -U minecraft-launcher-*x86_64.pkg.tar.zst

  rm -rf /tmp/minecraft-launcher
}

function install_launcher_debian() {
  wget "https://launcher.mojang.com/download/Minecraft.deb"
  sudo apt update
  sudo apt install -y openjdk-11-jre openjdk-11-jre-headless

  sudo dpkg -i Minecraft.deb
  sudo apt install -f
  rm Minecraft.deb
}

# function install_optifine() { }

function install_fabric() {
  cd /tmp
  rm -rf fabric-installer*
  wget https://maven.fabricmc.net/net/fabricmc/fabric-installer/0.10.2/fabric-installer-0.10.2.jar
  java -jar fabric-installer-0.10.2.jar
  rm -rf fabric-installer*
}

for i in "${@}"; do
  install_${i}
done
