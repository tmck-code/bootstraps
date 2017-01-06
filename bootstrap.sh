#!/bin/bash
set -euxo pipefail

# Repositories and sources --------------------------------
echo '> Finding the fastest available mirror'

# Install netselect-apt and run it to find the fastest repo mirror
sudo apt-get install netselect-apt && sudo netselect-apt
# Replace the original sources file with the netselect one
sudo mv sources.list /etc/apt/sources.list

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

# Locale, timezone, utf-8 ---------------------------------
echo '> Setting locale & timezone'
RUN echo -e 'LANG="en_US.UTF-8"\nLANGUAGE="en_US:en"\n' > /etc/default/locale

RUN echo "Australia/Melbourne" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata && \
    echo 'LANG="en_US.UTF-8"' >> /etc/default/locale

echo '> Setting utf-8'
export TERM=uxterm
sudo /usr/sbin/locale-gen en_US.UTF-8

export LANG='en_US.UTF-8'
export LANGUAGE='en_US.UTF-8'

# Install specific tools
echo "> Calling rvm.sh for ruby installation"
./rvm.sh

echo "> Calling vim.sh for vim8 installation"
./vim8.sh

echo "> Calling tools.sh for linux utils installation"
./tools.sh