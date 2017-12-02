#!/bin/bash

set -euxo pipefail

echo '> Running OS updates and upgrades'
sudo apt update
sudo apt upgrade -y

echo '> Installing basic dependencies'
sudo apt install -y \
    curl \
    cowsay fortune \
    tmux \
    docker docker-compose \
    git checkinstall locales

if [ ! -d $HOME/pokemonsay ]; then
    cd $HOME
    git clone http://github.com/possatti/pokemonsay
    cd pokemonsay
    ./install.sh
    cd
fi

# echo '> Setting locale & timezone'
# # echo "Australia/Melbourne" > /etc/timezone
# sudo dpkg-reconfigure -f noninteractive tzdata
