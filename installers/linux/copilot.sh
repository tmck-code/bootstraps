#!/bin/bash

set -euo pipefail

if [ ! -d ~/.vim/pack/github/start/copilot.vim ]; then
  echo "- installing for vim"
  git clone https://github.com/github/copilot.vim.git \
    ~/.vim/pack/github/start/copilot.vim
fi

if [ ! -d ~/.config/nvim/pack/github/start/copilot.vim ]; then
  echo "- installing for neovim"
  git clone https://github.com/github/copilot.vim.git \
    ~/.config/nvim/pack/github/start/copilot.vim
fi

echo "- installing for vscode"
code --install-extension GitHub.copilot

echo "- installing nodejs"
# nodejs needs to be version v16+, debian bullseye only ships with v12
curl -fsSL https://deb.nodesource.com/setup_19.x | sudo -E bash - && \
  sudo apt install -y nodejs

echo "! run :Copilot setup & :Copilot enable when in vim/nvim"
