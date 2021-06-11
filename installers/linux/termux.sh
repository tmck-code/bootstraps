#!/bin/bash

set -euo pipefail

[ -n "${DEBUG:-}" ] && set -x

function update() {
  echo "- Updating package lists and upgrading"
  pkg update
  pkg upgrade -y
}

function install_dependencies() {
  echo "- Installing basic dependencies"
  pkg install -y \
    openssh curl \
    man git \
    parallel
}

function install_essentials() {
  echo "- Installing essential tools"
  pkg install -y \
    tree coreutils openssh build-essential \
    git tig vim man shellcheck \
    python3 golang \
    htop tmux bmon \
    termux-api termux-tools
}

function install_lolcat() {
  echo "- Installing lolcat"
  cd "${PREFIX}/tmp"
  git clone git@github.com:jaseg/lolcat.git
  (cd lolcat && make lolcat)
  cp lolcat/lolcat "$HOME/bin"
  rm -rf lolcat
}

# Install minimum dependencies for dotfiles and bootstrapping to work
function bootstrap() {
  update
  install_dependencies
  install_essentials
}

case ${1:-} in
  "lolcat" )      install_lolcat ;;
  "bootstrap"|* ) bootstrap ;;
esac

[ -n "${DEBUG:-}" ] && set +x
