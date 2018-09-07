#!/bin/bash

sudo apt purge docker docker-engine docker.io
sudo apt update
sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

curl -fsSL https://download.docker.com/linux/$(lsb_release -is)/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/$(lsb_release -is) \
   $(lsb_release -cs) \
   stable"

sudo apt update
sudo apt install -y docker-ce

