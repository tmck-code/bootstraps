#!/bin/bash

set -euxo pipefail

# rm -rf $HOME/.pyenv

# Install some dependencies
sudo apt-get install -y \
  libreadline-dev \
  libssl-dev \
  zlib1g-dev libbz2-dev \
  libsqlite3-dev

# curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
# 
# cat <<EOF >> ~/.bash_profile
# # pyenv
# export PYENV_ROOT="$HOME/.pyenv"
# export PATH="$PYENV_ROOT/bin:$PATH"
# if command -v pyenv 1>/dev/null 2>&1; then
#   eval "$(pyenv init -)"
# fi
# EOF
# 
# pyenv update
pyenv install $PYTHON_VERSION
echo $PYTHON_VERSION > $HOME/.pyenv/version

