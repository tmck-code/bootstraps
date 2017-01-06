#!/bin/bash
set -euxo pipefail

sudo apt-get install -y\
    libncurses5-dev \
    libgtk2.0-dev libatk1.0-dev libbonoboui2-dev libcairo2-dev libx11-dev \
    libxpm-dev libxt-dev \
    python-dev python3-dev \
    lua5.1 lua5.1-dev \
    libperl-dev

# Download & install vim8 ---------------------------------

echo '> Cloning vim8 from git'
rm -rf ./vim/ ; tar xvzf /usr/local/src/vim.tar.gz

# chown -R vagrant:vagrant /usr/local/src && \
  # cd /usr/local/src && \
  # git clone https://github.com:vim/vim.git

echo '> Configure vim8'
cd ./vim && make clean
./configure \
    --enable-rubyinterp=yes \
    --with-ruby-command=/home/vagrant/.rvm/rubies/ruby-2.3.3/bin/ruby \
    --enable-pythoninterp=yes \
    --enable-luainterp=yes \
    --enable-gui=no \
    --without-x \
    --enable-multibyte \
    --prefix=/usr

echo '> Compile vim8'
sudo checkinstall -y

# Install pathogen, a vim plugin manager
cd /home/vagrant && mkdir -p .vim/autoload .vim/bundle && \
curl -LSso .vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

# Plugins -------------------------------------------------
cd /home/vagrant/.vim/bundle

# git clone https://github.com/Shougo/neocomplete.vim.git
# git clone https://github.com/scrooloose/nerdtree.git
# git clone https://github.com/mechatroner/rainbow_csv.git
# git clone https://github.com/scrooloose/syntastic.git
# git clone https://github.com/vim-airline/vim-airline.git
# git clone https://github.com/vim-airline/vim-airline-themes.git
# git clone https://github.com/altercation/vim-colors-solarized.git
# git clone https://github.com/ryanoasis/vim-devicons
# git clone https://github.com/tpope/vim-fugitive.git
# git clone https://github.com/airblade/vim-gitgutter.git
# git clone https://github.com/crusoexia/vim-monokai.git
# git clone https://github.com/tyrannicaltoucan/vim-quantum.git
# git clone https://github.com/thinca/vim-quickrun.git
# git clone https://github.com/ngmy/vim-rubocop.git
# git clone https://github.com/tpope/vim-sensible.git
# git clone https://github.com/tpope/vim-surround.git

chown -R vagrant:vagrant /home/vagrant/.vim/
