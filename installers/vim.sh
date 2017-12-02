#!/bin/bash
set -euxo pipefail

LOCAL_DIR=$(pwd)

current_version="$(apt show -a vim)"

if [[ $(echo $current_version | grep 'Version: 20') ]]; then
  current_version_date=$(echo $current_version | sed 's/.*Version: 20/20/g' | awk '{ print $1 }' | cut -d- -f1)
  if [ -n $current_version_date ]; then
    todays_date=$(date +%Y%m%d)
    days_since_update="$(( $todays_date - $current_version_date ))"
    if [ $days_since_update -lt 7 ]; then
      echo "Installed version is recent enough, skipping compilation"
      exit 0
    fi
  fi
fi

sudo apt purge -y vim vim-common vim-runtime

sudo apt install -y\
    libncurses5-dev \
    libgtk2.0-dev libatk1.0-dev libbonoboui2-dev libcairo2-dev libx11-dev \
    libxpm-dev libxt-dev \
    checkinstall \
    python-dev python3-dev \
    liblua5.3-0 liblua5.3-dev \
    libperl-dev

if [ ! -d /usr/include/lua5.3/include ]; then
    sudo mkdir /usr/include/lua5.3/{include,lib}
    sudo cp /usr/include/lua5.3/*.h /usr/include/lua5.3/include/
    sudo ln -sf /usr/lib/x86_64-linux-gnu/liblua5.3.so /usr/include/lua5.3/lib/liblua.so
    sudo ln -sf /usr/lib/x86_64-linux-gnu/liblua5.3.a /usr/include/lua5.3/lib/liblua.a
fi

# Download & install vim8 ---------------------------------

echo '> Cloning vim8 from git'
sudo chown -R $USER:$USER /usr/local/src && cd /usr/local/src
if [ -d vim ]; then
    cd vim ; git pull ; cd ../
else
  git clone git@github.com:vim/vim.git
fi

echo '> Configure vim8'
cd ./vim 
./configure \
    --with-features=huge \
    --enable-rubyinterp \
    --with-ruby-command=$HOME/.rvm/rubies/ruby-2.4.2/bin/ruby \
    --enable-python3interp \
    --enable-luainterp \
    --with-lua-prefix=/usr/include/lua5.3 \
    --enable-gui=no \
    --without-x \
    --enable-cscope \
    --enable-largefile \
    --enable-multibyte \
    --enable-fail-if-missing

echo '> Compiling and installing vim8'
sudo checkinstall -y

# Install pathogen, a vim plugin manager
cd $HOME
if [ ! -f .vim/autoload/pathogen.vim ]; then
    mkdir -p .vim/autoload .vim/bundle
    curl -LSso .vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
fi

# Plugins -------------------------------------------------
cd $HOME/.vim/bundle

function install_package() {
    git clone https://github.com/$1 || echo "$1 is already installed"
}

repos="Shougo/neocomplete.vim.git
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
kien/ctrlp.vim
nanotech/jellybeans.vim
godlygeek/tabular
ervandew/supertab
nathanaelkane/vim-indent-guides
honza/vim-snippets.git"

for repo in $repos; do install_package $repo ; done

chown -R $USER:$USER $HOME/.vim/
cp $LOCAL_DIR/installers/vimrc $HOME/.vimrc
