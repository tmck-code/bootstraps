#!/bin/bash

set -euxo pipefail

mkdir -p ~/dev && cd ~/dev
git clone https://github.com/tmck-code/dotfiles.git

cd dotfiles
cp bash_aliases ~/.bash_aliases
cp bashrc       ~/.bashrc
cp vimrc        ~/.vimrc
cp gitconfig    ~/.gitconfig

