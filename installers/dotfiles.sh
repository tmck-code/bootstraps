#!/bin/bash

set -euxo pipefail

if [ -z "${1:-}" ]; then
  echo "Must provide an OS as \$1"
  exit 1
fi

OS="${1}"

mkdir -p ~/dev && cd ~/dev

if [ -d dotfiles ]; then
  (cd dotfiles && git pull)
else
  git clone https://github.com/tmck-code/dotfiles.git
fi

(cd dotfiles && ./deploy.sh "${OS}")

