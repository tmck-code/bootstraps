#!/bin/bash

set -euxo pipefail

. ${0%/*}/vim_plugins.sh

# Teardown any old vim
sudo apt purge -y vim vim-common vim-runtime
sudo rm -rf $HOME/.vim $HOME/.vimrc

# Install new vim
sudo apt-get install -y vim

# Install vim packages
install_pathogen
install_core_packages

chown -R $USER:$USER $HOME/.vim/

