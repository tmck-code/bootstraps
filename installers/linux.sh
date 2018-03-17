#!/bin/bash

set -euxo pipefail

cd $HOME

echo '> Running OS updates and upgrades'
sudo apt update

echo '> Installing basic dependencies'
sudo apt install -y \
    curl \
    cowsay fortune \
    tmux parallel \
    docker \
    git checkinstall locales

if [ ! -f $HOME/bin/pokemonsay ]; then
    git clone http://github.com/possatti/pokemonsay
    (cd pokemonsay && ./install.sh)
fi

