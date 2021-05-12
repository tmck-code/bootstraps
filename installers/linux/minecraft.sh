#!/bin/bash

set -euo pipefail

wget "https://launcher.mojang.com/download/Minecraft.deb"

sudo dpkg -i Minecraft.deb
sudo apt install -f
