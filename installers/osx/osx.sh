#!/bin/bash

set -uxo pipefail

cd $HOME
export PATH="$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:$PATH"

echo "- Generating a new ssh public key for GitHub"
ssh-keygen -t ed25519
cat ~/.ssh/id_ed25519.pub

echo "- Installing homebrew"
xcode-select --install
which homebrew || cd /usr/local && mkdir homebrew && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C homebrew

brew update

# Install the essentials
brew install \
  tmux \
  fortune cowsay \
  htop bmon \
  tig \
  parallel \
  gnupg2

brew reinstall openssl

# Core GNU file/shell/text utilities
brew install coreutils diffutils gnutls gzip watch wget
# GNU find, xargs & locate
brew install findutils --with-default-names
brew install gnu-sed --with-default-names
brew install grep --with-default-names

if [ ! -f $HOME/bin/pokemonsay ]; then
  echo "- Installing pokemonsay"
  cd /usr/local/src
  git clone --depth 1 http://github.com/possatti/pokemonsay
  (cd pokemonsay && ./install.sh)
else
  echo "- Pokemonsay already installed, skipping"
fi

if [ ! -f $HOME/bin/lolcat ]; then
  echo "- Installing lolcat"
  cd /usr/local/src
  # Install the "high-performance" lolcat
  git clone --depth 1 https://github.com/jaseg/lolcat.git
  (cd lolcat && make lolcat && cp ./lolcat $HOME/bin/)
fi
