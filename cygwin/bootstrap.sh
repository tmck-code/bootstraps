#!/bin/bash

set -euxo pipefail

# Updates and dependency installation
# echo '> Running OS updates and upgrades'
# apt-cyg update && apt-cyg upgrade -y

echo '> Installing basic dependencies'
apt-cyg install tmux curl

# Install vim packages
# ./vim/vim_cygwin.sh

# Deploy dotfiles
[ -d $HOME/dev/ ] || mkdir $HOME/dev/
cd $HOME/dev/
# git clone https://github.com/tmck-code/dotfiles.git
cd dotfiles

cp bashrc $HOME/.bashrc
cp bash_aliases $HOME/.bash_aliases
cp gitconfig $HOME/.gitconfig
cp vimrc $HOME/.vimrc

# Get a "Nerd Font" version of FiraCode so vim file icons can display
[ -d $HOME/fonts/ ] || mkdir $HOME/fonts/
cd $HOME/fonts/

wget "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Regular/complete/Fura%20Code%20Regular%20Nerd%20Font%20Complete%20Mono%20Windows%20Compatible.otf"


