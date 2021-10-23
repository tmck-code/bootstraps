#!/bin/bash

set -euxo pipefail

sudo apt update
sudo apt purge -y neovim

cd $HOME/dev

if [ -d neovim ]; then
  cd neovim
  make clean -j $(nproc)
  git pull
else
  git clone git@github.com:neovim/neovim.git
  cd neovim
fi

make CMAKE_BUILD_TYPE=Release -j $(nproc)
sudo make CMAKE_INSTALL_PREFIX=$HOME/bin/nvim install -j $(nproc)

