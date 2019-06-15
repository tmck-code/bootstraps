#!/bin/bash

set -euo pipefail

if [ -z "${1:-}" ]; then
  echo "Defaulting OS to linux"
  OS=linux
else
  OS="${1}"
fi

mkdir -p ~/dev && cd ~/dev

if [ -d dotfiles ]; then
  (cd dotfiles && git pull)
else
  git clone https://github.com/tmck-code/dotfiles.git
fi

(cd dotfiles && ./deploy.sh "${OS}")

