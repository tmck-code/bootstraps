#!/bin/bash

set -euxo pipefail

mkdir -p ~/dev && cd ~/dev

if [ -d dotfiles ]; then
  (cd dotfiles && git pull)
else
  git clone https://github.com/tmck-code/dotfiles.git
fi

cd dotfiles
cp bash_aliases ~/.bash_aliases
cp bashrc       ~/.bashrc
cp vimrc        ~/.vimrc
cp gitconfig    ~/.gitconfig
cp tmux_conf    ~/.tmux.conf

