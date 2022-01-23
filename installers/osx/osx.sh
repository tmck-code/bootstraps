#!/bin/bash

set -uxo pipefail

cd $HOME

if [ -f $HOME/.ssh/id_ed25519.pub ]; then
  echo "- SSH public key already exists, skipping"
else
  echo "- Generating a new ssh public key for GitHub"
  ssh-keygen -t ed25519
  cat ~/.ssh/id_ed25519.pub
fi

if [ $(which homebrew) ]; then
  echo "- homebrew already installed, skipping"
else
  echo "- Installing homebrew"
  xcode-select --install
  cd /tmp/ && mkdir homebrew && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C homebrew
fi

brew update

# Install the essential GNU utilities
brew reinstall openssl
brew install \
  tmux fortune cowsay htop bmon tig parallel gnupg2 \
  coreutils diffutils gnutls gzip watch wget findutils gnu-sed grep

export PATH="$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:$PATH"

if [ -f $HOME/bin/pokesay ]; then
  echo "- pokesay already installed, skipping"
else
  echo "- Installing pokesay"
  cd /tmp/
  git clone --depth 1 http://github.com/tmck-code/pokesay
  (cd pokesay && ./install.sh)
  rm -rf /tmp/pokesay
fi

if [ -f $HOME/bin/lolcat ]; then
  echo "- lolcat already installed, skipping"
else
  echo "- Installing lolcat"
  cd /tmp/
  # Install the "high-performance" lolcat
  git clone --depth 1 https://github.com/jaseg/lolcat.git
  (cd lolcat && make lolcat && cp ./lolcat $HOME/bin/)
  rm -rf /tmp/lolcat
fi

if [ $(which gh) ]; then
  echo "- gh already installed, skipping"
else
  echo "- Installing gh"
  brew install github/gh/gh
  brew update && brew upgrade gh
fi
