#!/bin/bash

set -euo pipefail

core_repos=$(cat <<EOF
airblade/vim-gitgutter
ctrlpvim/ctrlp.vim
ervandew/supertab
godlygeek/tabular
honza/vim-snippets
mechatroner/rainbow_csv
ngmy/vim-rubocop
ntpeters/vim-better-whitespace
rakr/vim-one
ryanoasis/vim-devicons
scrooloose/nerdtree
scrooloose/syntastic
thinca/vim-quickrun
tiagofumo/vim-nerdtree-syntax-highlight
tpope/vim-fugitive
tpope/vim-sensible
tpope/vim-surround
tyrannicaltoucan/vim-quantum.git
vim-airline/vim-airline-themes
vim-airline/vim-airline
EOF
)

N_CONCURRENT_DOWNLOADS=8

function install_pathogen() {
  echo "- Installing Pathogen (plugin/package manager)"
  if [ ! -f $HOME/.vim/autoload/pathogen.vim ]; then
    mkdir -p $HOME/.vim/autoload $HOME/.vim/bundle
    curl -LSso $HOME/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
  else
    echo "-- Pathogen already installed, skipping"
  fi
}

function install_package() {
  echo "- Installing vim plugin: ${1}"
  repo=$(echo "${1}" | cut -d '/' -f 2)
  if [ ! -d "${repo}" ]; then
    git clone git@github.com:${1} || echo "- vim plugin already exists: ${1}"
  else
    echo "-- Plugin already installed: ${1}, skipping"
  fi
}
export -f install_package

function install_core_packages() {
  echo "- Installing core vim plugins"
  cd $HOME/.vim/bundle
  echo "${core_repos}" | parallel -n 1 -P ${N_CONCURRENT_DOWNLOADS} install_package
  echo "- Installed all core vim plugins"
}

# Don't run if we're just sourcing the file
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
  echo "- Sourced vim plugin functions"
else
  install_pathogen
  install_core_packages
fi

