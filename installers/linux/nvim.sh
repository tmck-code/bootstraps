#!/bin/bash

set -euxo pipefail

sudo apt update
sudo apt purge -y neovim
sudo apt install -y libtool automake cmake pkg-config gettext

cd $HOME/dev

if [ -d neovim ]; then
  cd neovim
  make clean -j $(nproc)
  git pull
else
  git clone git@github.com:neovim/neovim.git
  cd neovim
fi

make distclean

make CMAKE_BUILD_TYPE=Release -j $(nproc)
sudo make install -j $(nproc)
