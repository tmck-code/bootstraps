#!/bin/bash

set -euo pipefail

function base() {
  echo "> installing base packages"
  dnf check-update
  sudo dnf remove -y libreoffice* thunderbird*
  sudo dnf upgrade -y

  sudo dnf install -y \
    ncurses ncurses-devel redshift \
    fish tmux fortune-mod \
    python3-pip python3-devel \
    bmon htop nvtop iostat vim git curl wget

  # install pokesay
  bash -c "$(curl https://raw.githubusercontent.com/tmck-code/pokesay/master/build/scripts/install.sh)" bash linux amd64
}

function browsers() {
  echo "> installing browsers"
  sudo dnf install -y google-chrome-stable steam brave-browser
}

function vscode() {
  echo "> installing vscode"
  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
  sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
  dnf check-update
  sudo dnf install code -y
}

function bootstrap() {
  echo "> bootstrapping fedora"
  base
  browsers
  vscode
  echo "> bootstrap complete!"
}

if [ -z "${1:-}" ]; then
  bootstrap
else
  case ${1:-} in
    "bootstrap" )   bootstrap ;;
    *)              for i in "${@}"; do $i ; done ;;
  esac
fi
