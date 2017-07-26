#!/bin/bash

set -euxo pipefail

sudo apt-get install -y curl

# Get the RVM gpg key ("Michal Papis (RVM signing) <mpapis@gmail.com>")
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
# Get the stable version of RVM
\curl -sSL https://get.rvm.io | bash -s stable --auto-dotfiles

# Add RVM to PATH for scripting
export PATH="$PATH:$HOME/.rvm/bin"
echo 'export PATH="$PATH:$HOME/.rvm/bin"' >> $HOME/.bash_profile

# Install latest (stable) ruby & jruby
rvm install 2.4.1

