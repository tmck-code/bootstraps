#!/bin/bash

set -euxo pipefail

def teardown() {
  sudo apt purge -y vim vim-common vim-runtime
  sudo rm -rf $HOME/.vim $HOME/.vimrc
}

def install() {
  sudo apt-get install -y vim
  
  # Install pathogen, a vim plugin manager
  cd $HOME
  mkdir -p .vim/autoload .vim/bundle
  curl -LSso .vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
}

# Plugins -------------------------------------------------
cd $HOME/.vim/bundle

git clone https://github.com/Shougo/neocomplete.vim.git &
git clone https://github.com/scrooloose/nerdtree.git &
git clone https://github.com/mechatroner/rainbow_csv.git &
git clone https://github.com/scrooloose/syntastic.git &
git clone https://github.com/vim-airline/vim-airline.git &
git clone https://github.com/vim-airline/vim-airline-themes.git &
git clone https://github.com/altercation/vim-colors-solarized.git &
git clone https://github.com/ryanoasis/vim-devicons &
git clone https://github.com/tpope/vim-fugitive.git &
git clone https://github.com/airblade/vim-gitgutter.git &
git clone https://github.com/crusoexia/vim-monokai.git &
git clone https://github.com/tyrannicaltoucan/vim-quantum.git &
git clone https://github.com/thinca/vim-quickrun.git &
git clone https://github.com/ngmy/vim-rubocop.git &
git clone https://github.com/tpope/vim-sensible.git &
git clone https://github.com/tpope/vim-surround.git &
git clone https://github.com/ctrlpvim/ctrlp.vim &
git clone https://github.com/godlygeek/tabular &
git clone https://github.com/ervandew/supertab &
git clone https://github.com/honza/vim-snippets.git &
git clone https://github.com/junegunn/vim-easy-align.git &
wait

chown -R $USER:$USER $HOME/.vim/

