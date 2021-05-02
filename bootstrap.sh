#!/bin/bash

sudo apt update && \
  sudo apt install -y git && \
  cd && \
  mkdir -p dev && \
  cd dev && \
  git clone https://github.com/tmck-code/bootstraps.git && \
  cd bootstraps

./installers/dotfiles.sh
