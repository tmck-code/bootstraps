#!/bin/bash

set -euxo pipefail


LOCAL_DIR=$(pwd)
WEEK=604800

current_version="$(apt show -a vim)"

if [ -f /usr/local/bin/vim ]; then
  current_version_date=$(stat -c %Y /usr/local/bin/vim)

  if [ -n $current_version_date ]; then
    todays_date=$(date +%s)
    days_since_update="$(( $todays_date - $current_version_date ))"
    if [ $days_since_update -lt $WEEK ]; then
      echo "Installed version is recent enough, skipping compilation"
      ./${0%/*}/vim_plugins.sh
      exit 0
    fi
  fi
fi

sudo apt purge -y vim vim-common vim-runtime

sudo apt install -y \
    libncurses5-dev \
    libgtk2.0-dev libatk1.0-dev libcairo2-dev libx11-dev \
    libxpm-dev libxt-dev \
    checkinstall \
    libperl-dev \
    python3-dev

# Download & install vim8 ---------------------------------

echo '> Cloning vim8 from git'
sudo chown -R "$USER:$USER"/usr/local/src
cd /usr/local/src
if [ -d vim ]; then
    cd vim ; git pull ; cd ../
else
  git clone --depth 1 git@github.com:vim/vim.git
fi

echo '> Configure vim8'
cd ./vim
LD_FLAGS="-Wl,-rpath=${HOME}/.pyenv/versions/3.4.0/lib" \
  ./configure \
    --enable-cscope \
    --enable-fail-if-missing \
    --enable-fontset \
    --enable-gui=no \
    --enable-largefile \
    --enable-multibyte \
    --enable-python3interp=dynamic \
    --enable-tclinterp \
    --with-features=huge


n_proc=$(nproc --all)
make -j "${n_proc}"
sudo make -j "${n_proc}" install

sudo ln -s /usr/local/bin/vim /usr/bin/vim

${0%/*}/vim_plugins.sh

chown -R "${USER}:${USER}" "${HOME}/.vim/"
