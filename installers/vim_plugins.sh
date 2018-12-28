#!/bin/bash

set -euo pipefail

core_repos=$(cat <<EOF
airblade/vim-gitgutter.git
ctrlpvim/ctrlp.vim
ervandew/supertab
godlygeek/tabular
honza/vim-snippets.git
mechatroner/rainbow_csv.git
ngmy/vim-rubocop.git
ryanoasis/vim-devicons
scrooloose/nerdtree.git
rakr/vim-one.git
scrooloose/syntastic.git
thinca/vim-quickrun.git
tpope/vim-fugitive.git
tpope/vim-sensible.git
tpope/vim-surround.git
vim-airline/vim-airline-themes.git
vim-airline/vim-airline.git
EOF
)

N_CONCURRENT_DOWNLOADS=8

function install_pathogen() {
  echo "- Installing Pathogen (plugin/package manager)"
  cd $HOME
  mkdir -p .vim/autoload .vim/bundle
  curl -LSso .vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
}

function install_package() {
  echo "- Installing vim plugin: ${1}"
  git clone git@github.com:${1} || echo "- vim plugin already exists: ${1}"
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

