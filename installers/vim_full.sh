#!/bin/bash

set -euxo pipefail

. ${0%/*}/vim_plugins.sh

LOCAL_DIR=$(pwd)
WEEK=604800

current_version="$(apt show -a vim)"

function install_packages() {
  echo "- Installing packages"
  install_pathogen
  install_core_packages
}

<<<<<<< HEAD
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

sudo apt install -y \
    libncurses5-dev \
    libgtk2.0-dev libatk1.0-dev libbonoboui2-dev libcairo2-dev libx11-dev \
    libxpm-dev libxt-dev \
    checkinstall \
    libperl-dev \
    python3-dev
=======
# if [ -f /usr/local/bin/vim ]; then
#   current_version_date=$(stat -c %Y /usr/local/bin/vim)
#
#   if [ -n $current_version_date ]; then
#     todays_date=$(date +%s)
#     days_since_update="$(( $todays_date - $current_version_date ))"
#     if [ $days_since_update -lt $WEEK ]; then
#       echo "- Installed version is recent enough, skipping compilation"
#       install_packages
#       exit 0
#     fi
#   fi
# fi
>>>>>>> Update vim bootstrapper

# Download & install vim8 ---------------------------------

echo '> Cloning vim8 from git'
sudo chown -R $USER:$USER /usr/local/src
cd /usr/local/src
if [ -d vim ]; then
    cd vim ; git pull ; cd ../
else
  git clone --depth 1 git@github.com:vim/vim.git
fi

echo '> Configure vim8'
cd ./vim
./configure \
    --with-features=huge \
    --enable-python3interp \
<<<<<<< HEAD
    --with-python3-config-dir=/usr/lib/python3.6/config-3.6m-x86_64-linux-gnu/ \
=======
    --enable-rubyinterp \
>>>>>>> Update vim bootstrapper
    --enable-gui=no \
    --without-x \
    --enable-cscope \
    --enable-largefile \
    --enable-multibyte \
    --enable-fail-if-missing

make
sudo make install

sudo ln -s /usr/local/bin/vim /usr/bin/vim

install_packages

chown -R $USER:$USER $HOME/.vim/

