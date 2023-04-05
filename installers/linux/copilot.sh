#!/bin/bash

set -euo pipefail

echo "- installing for vim"
git clone https://github.com/github/copilot.vim.git \
  ~/.vim/pack/github/start/copilot.vim

echo "- installing for neovim"
git clone https://github.com/github/copilot.vim.git \
  ~/.config/nvim/pack/github/start/copilot.vim

echo "- installing for vscode"
code --install-extension GitHub.copilot

echo "! run :Copilot setup & :Copilot enable when in vim/nvim"

echo "- installing nodejs"
sudo apt install -y nodejs
