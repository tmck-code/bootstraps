#!/bin/bash

set -euxo pipefail

# rm -rf $HOME/.pyenv

PYTHON_VERSION=3.6.4

# Install some dependencies
sudo apt-get install -y \
  libreadline-dev \
  libssl-dev \
  zlib1g-dev libbz2-dev \
  libsqlite3-dev

curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

pyenv update
pyenv install $PYTHON_VERSION
echo $PYTHON_VERSION > $HOME/.pyenv/version

