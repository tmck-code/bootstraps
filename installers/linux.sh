#!/bin/bash
set -euxo pipefail

# Updates and dependency installation ---------------------
echo '> Running OS updates and upgrades'
sudo apt update && sudo apt upgrade -y

echo '> Installing basic dependencies'
sudo apt install -y \
    curl \
    cowsay fortune \
    tmux \
    docker docker-compose \
    git checkinstall locales

cd $HOME
git clone http://github.com/possatti/pokemonsay
cd pokemonsay
./install.sh

# Locale, timezone, utf-8 ---------------------------------
echo '> Setting locale & timezone'

echo "Australia/Melbourne" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata
