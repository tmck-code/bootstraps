#!/bin/bash

set -euxo pipefail

# Install cargo
curl https://sh.rustup.rs -sSf | sh

echo 'export CARGO_HOME=$HOME/.cargo' >> $HOME/.bash_profile
export CARGO_HOME=$HOME/.cargo

# Add cargo-installed binaries to the path
echo 'export PATH="$PATH:$CARGO_HOME/bin"' >> $HOME/.bash_profile
export PATH="$PATH:$CARGO_HOME/bin"

source $HOME/.cargo/env

# Install silicon
cargo install silicon

