#!/bin/bash

set -uxo pipefail

cd $HOME
export PATH="$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:$PATH"

echo "- Generating a new ssh public key for GitHub"
ssh-keygen -t ed25519
cat ~/.ssh/id_ed25519.pub

echo "- Installing homebrew"
xcode-select --install
mkdir homebrew && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C homebrew

brew update

# Install the essentials
brew install \
  tmux \
  fortune cowsay \
  htop bmon \
  tig \
  parallel \
  gnupg2

# Core GNU file/shell/text utilities
brew install coreutils diffutils gnutls gzip watch wget
# GNU find, xargs & locate
brew install findutils --with-default-names
brew install gnu-sed --with-default-names
brew install grep --with-default-names

if [ ! -f $HOME/bin/pokemonsay ]; then
  echo "- Installing pokemonsay"
  git clone http://github.com/possatti/pokemonsay
  (cd pokemonsay && ./install.sh)
else
  echo "- Pokemonsay already installed, skipping"
fi

