#!/bin/bash

set -euo pipefail

core_repos=$(cat <<EOF
AndrewRadev/splitjoin.vim
airblade/vim-gitgutter
ctrlpvim/ctrlp.vim
dyng/ctrlsf.vim.git
lifepillar/vim-mucomplete
mechatroner/rainbow_csv
ngmy/vim-rubocop
ntpeters/vim-better-whitespace
tpope/vim-fugitive
tpope/vim-sensible
tpope/vim-surround
EOF
)

aesthetic_repos=$(cat <<EOF
fenetikm/falcon
morhetz/gruvbox
rakr/vim-one
ryanoasis/vim-devicons
scrooloose/nerdtree
scrooloose/syntastic
tiagofumo/vim-nerdtree-syntax-highlight
vim-airline/vim-airline
vim-airline/vim-airline-themes
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
    git clone --depth 1 git@github.com:${1} || echo "- vim plugin already exists: ${1}"
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

function install_aesthetic_packages() {
  echo "- Installing aesthetic vim plugins"
  cd $HOME/.vim/bundle
  echo "${aesthetic_repos}" | parallel -n 1 -P ${N_CONCURRENT_DOWNLOADS} install_package
  echo "- Installed all aesthetic vim plugins"
}

# Don't run if we're just sourcing the file
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
  echo "- Sourced vim plugin functions"
else
  install_pathogen
  install_core_packages
  install_aesthetic_packages
fi

