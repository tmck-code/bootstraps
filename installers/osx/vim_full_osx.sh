#!/bin/bash

set -euxo pipefail

. ${0%/*}/vim_plugins.sh

LOCAL_DIR=$(pwd)
WEEK=604800

function install_packages() {
  install_pathogen
  install_core_packages
  install_extra_packages
}

if [ -f /usr/local/bin/vim ]; then
  echo '- Overwriting current vim installation'
else
  echo '- No vim custom install found'
fi

# Download & install vim8 ---------------------------------

echo '> Cloning vim8 from git'
sudo chown -R $USER /usr/local/src
cd /usr/local/src
if [ -d vim ]; then
  (cd vim && git pull)
else
  git clone git@github.com:vim/vim.git
fi

echo '> Configure vim8'
cd ./vim
./configure \
    --with-features=huge \
    --enable-python3interp \
    --enable-gui=no \
    --without-x \
    --enable-cscope \
    --enable-largefile \
    --enable-multibyte \
    --enable-fail-if-missing

make
sudo make install

# install_packages

