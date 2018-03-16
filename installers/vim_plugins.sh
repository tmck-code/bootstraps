#!/bin/bash

set -euxo pipefail

core_repos=(
  scrooloose/nerdtree.git
  mechatroner/rainbow_csv.git
  scrooloose/syntastic.git
  vim-airline/vim-airline.git
  vim-airline/vim-airline-themes.git
  altercation/vim-colors-solarized.git
  ryanoasis/vim-devicons
  tpope/vim-fugitive.git
  airblade/vim-gitgutter.git
  crusoexia/vim-monokai.git
  tyrannicaltoucan/vim-quantum.git
  thinca/vim-quickrun.git
  ngmy/vim-rubocop.git
  tpope/vim-sensible.git
  tpope/vim-surround.git
  ctrlp/ctrlp.vim
  nanotech/jellybeans.vim
  godlygeek/tabular
  ervandew/supertab
  honza/vim-snippets.git
)

extra_repos=(
  Shougo/neocomplete.vim.git
)

function install_pathogen() {
  mkdir -p .vim/autoload .vim/bundle
  curl -LSso .vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
}

function install_package() {
  git clone https://github.com/$1 || echo "$1 is already installed"
}

function install_core_packages() {
  cd $HOME/.vim/bundle
  echo $core_repos | xargs -n 1 -P 10 install_package
}

function install_extra_packages() {
  echo $extra_repos | xargs -n 1 -P 10 install_package
}

