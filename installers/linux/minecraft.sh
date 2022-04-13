#!/bin/bash

set -euo pipefail


function install_launcher() {
  wget "https://launcher.mojang.com/download/Minecraft.deb"
  sudo apt update
  sudo apt install -y openjdk-11-jre openjdk-11-jre-headless

  sudo dpkg -i Minecraft.deb
  sudo apt install -f
  rm Minecraft.deb
}

# function install_optifine() { }

function install_fabric() {
  wget https://maven.fabricmc.net/net/fabricmc/fabric-installer/0.10.2/fabric-installer-0.10.2.jar
  java -jar fabric-installer-0.10.2.jar
}

for i in "${@}"; do
  install_${i}
done
