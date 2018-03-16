#!/bin/bash
set -euxo pipefail

. ${0%/*}/vim_plugins.sh

LOCAL_DIR=$(pwd)
WEEK=604800

current_version="$(apt show -a vim)"

function install_packages() {
  install_pathogen
  install_core_packages
  install_extra_packages
}

if [ -f /usr/local/bin/vim ]; then
  current_version_date=$(stat -c %Y /usr/local/bin/vim)

  if [ -n $current_version_date ]; then
    todays_date=$(date +%s)
    days_since_update="$(( $todays_date - $current_version_date ))"
    if [ $days_since_update -lt $WEEK ]; then
      echo "Installed version is recent enough, skipping compilation"
      install_packages
      exit 0
    fi
  fi
fi

sudo apt purge -y vim vim-common vim-runtime

sudo apt install -y\
    libncurses5-dev \
    libgtk2.0-dev libatk1.0-dev libbonoboui2-dev libcairo2-dev libx11-dev \
    libxpm-dev libxt-dev \
    checkinstall \
    python-dev python3-dev \
    liblua5.3-0 liblua5.3-dev \
    libperl-dev

if [ ! -d /usr/include/lua5.3/include ]; then
    sudo mkdir /usr/include/lua5.3/{include,lib}
    sudo cp /usr/include/lua5.3/*.h /usr/include/lua5.3/include/
    sudo ln -sf /usr/lib/x86_64-linux-gnu/liblua5.3.so /usr/include/lua5.3/lib/liblua.so
    sudo ln -sf /usr/lib/x86_64-linux-gnu/liblua5.3.a /usr/include/lua5.3/lib/liblua.a
fi

# Download & install vim8 ---------------------------------

echo '> Cloning vim8 from git'
sudo chown -R $USER:$USER /usr/local/src && cd /usr/local/src
if [ -d vim ]; then
    cd vim ; git pull ; cd ../
else
  git clone git@github.com:vim/vim.git
fi

echo '> Configure vim8'
cd ./vim 
./configure \
    --with-features=huge \
    --enable-python3interp \
    --enable-luainterp \
    --with-lua-prefix=/usr/include/lua5.3 \
    --enable-gui=no \
    --without-x \
    --enable-cscope \
    --enable-largefile \
    --enable-multibyte \
    --enable-fail-if-missing

echo '> Compiling and installing vim8'
sudo checkinstall -y

sudo ln -s /usr/local/bin/vim /usr/bin/vim

install_packages

chown -R $USER:$USER $HOME/.vim/

