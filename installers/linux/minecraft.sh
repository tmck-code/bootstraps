#!/bin/bash

set -euo pipefail

wget "https://launcher.mojang.com/download/Minecraft.deb"

sudo apt update
sudo apt install -y openjdk-11-jre openjdk-11-jre-headless

sudo dpkg -i Minecraft.deb
sudo apt install -f
