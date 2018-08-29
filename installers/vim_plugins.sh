#!/bin/bash

set -euxo pipefail

core_repos="
airblade/vim-gitgutter.git
altercation/vim-colors-solarized.git
crusoexia/vim-monokai.git
ctrlp/ctrlp.vim
ervandew/supertab
godlygeek/tabular
honza/vim-snippets.git
joshdick/onedark.vim.git
mechatroner/rainbow_csv.git
nanotech/jellybeans.vim
ngmy/vim-rubocop.git
ryanoasis/vim-devicons
scrooloose/nerdtree.git
rakr/vim-one.git
scrooloose/syntastic.git
thinca/vim-quickrun.git
tpope/vim-fugitive.git
tpope/vim-sensible.git
tpope/vim-surround.git
tyrannicaltoucan/vim-quantum.git
vim-airline/vim-airline-themes.git
vim-airline/vim-airline.git
"

extra_repos="
Shougo/neocomplete.vim.git
"

function install_pathogen() {
  cd $HOME
  mkdir -p .vim/autoload .vim/bundle
  curl -LSso .vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
}

function install_package() {
  git clone git@github.com:${1} || echo "- Vim package already exists:${1}" 
}

export -f install_package

function install_core_packages() {
  cd $HOME/.vim/bundle
  echo ${core_repos} | tr ' ' '\n' | parallel -n 1 -P 15 install_package
  echo "- Installed all core vim packages"
}

function install_extra_packages() {
  echo ${extra_repos} | tr ' ' '\n' | parallel -n 1 -P 2 install_package
  echo "- Installed all extra vim packages"
}

# install_pathogen
# install_core_packages
