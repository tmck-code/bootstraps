#!/bin/bash

set -euo pipefail

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
    git tig vim man \
    htop tmux bmon
}

# Install minimum dependencies for dotfiles and bootstrapping to work
update
install_dependencies
install_essentials
