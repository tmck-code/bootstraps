#!/bin/bash

sudo apt update
sudo apt purge -y docker docker-engine docker.io
sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

release=$(lsb_release -cs)

if [ "${release}" == "bullseye" ]; then
  release="buster"
  echo "- Using debian release 'buster' instead of 'bullseye'!"
else
  echo "- Using debian release '${release}'!"
fi

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   ${release} \
   stable"

sudo apt update
sudo apt install -y docker-ce

