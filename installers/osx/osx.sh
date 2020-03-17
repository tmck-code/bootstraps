#!/bin/bash

set -uxo pipefail

cd $HOME

if [ -f $HOME/.ssh/id_ed25519.pub ]; then
  echo "- Generating a new ssh public key for GitHub"
  ssh-keygen -t ed25519
  cat ~/.ssh/id_ed25519.pub
fi

if [ $(which homebrew) ]; then
  echo "- gh already installed, skipping"
else
  echo "- Installing homebrew"
  xcode-select --install
  cd /usr/local/src && mkdir homebrew && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C homebrew
fi

brew update

# Install the essentials
brew install \
  tmux fortune cowsay htop bmon tig parallel gnupg2

brew reinstall openssl
# Core GNU file/shell/text utilities
brew install coreutils diffutils gnutls gzip watch wget
# GNU find, xargs & locate
brew install findutils --with-default-names
brew install gnu-sed --with-default-names
brew install grep --with-default-names

export PATH="$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:$PATH"

if [ -f $HOME/bin/pokesay ]; then
  echo "- pokesay already installed, skipping"
else
  echo "- Installing pokesay"
  cd /usr/local/src
  git clone --depth 1 http://github.com/tmck-code/pokesay
  (cd pokesay && ./install.sh)
fi

if [ -f $HOME/bin/lolcat ]; then
  echo "- lolcat already installed, skipping"
else
  echo "- Installing lolcat"
  cd /usr/local/src
  # Install the "high-performance" lolcat
  git clone --depth 1 https://github.com/jaseg/lolcat.git
  (cd lolcat && make lolcat && cp ./lolcat $HOME/bin/)
fi

if [ $(which gh) ]; then
  echo "- gh already installed, skipping"
else
  echo "- Installing gh"
  brew install github/gh/gh
  brew update && brew upgrade gh
fi
