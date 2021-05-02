#!/bin/bash

set -euo pipefail

sudo apt update
sudo apt install -y git

cd
mkdir -p dev
cd dev
git clone https://github.com/tmck-code/bootstraps.git
cd bootstraps

./installers/dotfiles.sh
./installers/linux/debian.sh
./installers/linux/docker.sh
./installers/linux/vim_full.sh
./installers/linux/ffmpeg_compile.sh
