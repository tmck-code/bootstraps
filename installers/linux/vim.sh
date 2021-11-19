#!/bin/bash

set -euxo pipefail

. ${0%/*}/vim_plugins.sh

# Teardown any old vim
sudo apt purge -y vim vim-*
sudo rm -rf $HOME/.vim $HOME/.vimrc

# Install new vim
# -gtk3 enables OS clipboard integration
sudo apt-get install -y vim-gtk3

# Install vim packages
install_pathogen
install_packages "core_repos"
install_packages "aesthetic_repos"

chown -R $USER:$USER $HOME/.vim/

