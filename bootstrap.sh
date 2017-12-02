#!/bin/bash
set -euxo pipefail

# Updates and dependency installation ---------------------
echo '> Running OS updates and upgrades'
sudo apt-get update && sudo apt-get upgrade -y

echo '> Installing basic dependencies'
sudo apt-get install -y \
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

# Install specific tools
# echo "> Calling rvm.sh for ruby installation"
# ./langs/rvm.sh

# echo "> Calling vim.sh for vim8 installation"
# ./vim/vim_regular.sh

echo "> Calling tools.sh for linux utils installation"
./tools.sh
