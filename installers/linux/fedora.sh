#!/bin/bash

set -euo pipefail

PS1_bold='\e[1m'
PS1_green='\e[1;32m'
PS1_reset='\e[0m'

function print_installing() {
  echo -e "${PS1_bold}> installing ${1}...${PS1_reset}"
}

function print_success() {
  echo -e "${PS1_green}> ${1} complete!${PS1_reset}"
}

function base() {
  dnf check-update
  sudo dnf remove -y libreoffice* thunderbird*
  sudo dnf upgrade -y

  sudo dnf install -y \
    ncurses ncurses-devel redshift \
    fish tmux fortune-mod \
    python3-pip python3-devel \
    bmon htop nvtop sysstat vim git curl wget \
    steam

  # install pokesay
  bash -c "$(curl https://raw.githubusercontent.com/tmck-code/pokesay/master/build/scripts/install.sh)" bash linux amd64
}

function browsers() {
  sudo dnf install -y google-chrome-stable brave-browser
}

function vscode() {
  dnf list code && return

  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
  sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
  dnf check-update
  sudo dnf install code -y
}

function bootstrap() {
  echo -e "> bootstrapping fedora...\n"
  for i in base browsers vscode; do install $i; done
  print_success "bootstrap complete!"
}

function install() {
  print_installing "$1"
  $1
  print_success "$1"
}

if [ -z "${1:-}" ]; then
  bootstrap
else
  case ${1:-} in
    "bootstrap" )   bootstrap ;;
    *)              for i in "${@}"; do install $i ; done ;;
  esac
fi
