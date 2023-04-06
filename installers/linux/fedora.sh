#!/bin/bash

function base() {
  sudo dnf remove -y libreoffice*
  sudo dnf upgrade -y

  sudo dnf install -y ncurses ncurses-devel
}

function browsers() {
  sudo dnf install -y google-chrome-stable steam brave-browser
}

function vscode() {
  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
  sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
  dnf check-update
  sudo dnf install code -y
}

function bootstrap() {
  echo "> Bootstrapping fedora"
  base
  browsers
  vscode
  echo "> Bootstrap complete!"
}

if [ -z "${1:-}" ]; then
  bootstrap
else
  case ${1:-} in
    "extras" )      extras ;;
    "bootstrap" )   bootstrap ;;
    *)              for i in "${@}"; do install_${i} ; done ;;
  esac
fi
