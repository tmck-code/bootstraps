#!/bin/bash

set -euxo pipefail

# rm -rf $HOME/.pyenv

# Install some dependencies
sudo apt-get install -y \
  libreadline-dev \
  libssl-dev \
  zlib1g-dev libbz2-dev \
  libsqlite3-dev

curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash

echo '# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
' >> ~/.bash_profile

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

pyenv update
pyenv install $PYTHON_VERSION
echo $PYTHON_VERSION > $HOME/.pyenv/version

