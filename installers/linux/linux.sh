#!/bin/bash

set -euxo pipefail

cd $HOME

echo '> Running OS updates and upgrades'
sudo apt update

echo '> Installing basic dependencies'
sudo apt install -y \
    curl tmux parallel \
    cowsay fortune \
    git locales \
    bc htop bmon iotop sysstat net-tools

if [ ! -f $HOME/bin/pokemonsay ]; then
    git clone --depth 1 http://github.com/possatti/pokemonsay
    (cd pokemonsay && ./install.sh)
fi

if [ ! -f $HOME/bin/lolcat ]; then
  cd /usr/local/src
  # Install the "high-performance" lolcat
  git clone --depth 1 https://github.com/jaseg/lolcat.git
  (cd lolcat && make lolcat && cp ./lolcat $HOME/bin/)
fi
