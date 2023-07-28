#!/bin/bash

set -euxo pipefail

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
  dnf check-update || echo 'updated'
  sudo dnf remove -y libreoffice* thunderbird*
  sudo dnf upgrade -y

  sudo dnf install -y \
    ncurses ncurses-devel redshift wl-clipboard \
    fish tmux fortune-mod bash-completion the_silver_searcher \
    python3-pip python3-devel \
    bmon htop nvtop sysstat vim git curl wget \
    steam

  # install pokesay
  bash -c "$(curl https://raw.githubusercontent.com/tmck-code/pokesay/master/build/scripts/install.sh)" bash linux amd64
  # install rhythmbox
  install_rhythmbox
}

function install_rhythmbox() {
  # Install rhythmbox and the dark theme

  sudo dnf install -y rhythmbox yaru-gtk4-theme
  # Copy the regular .desktop file to the user's local dir
  cp /usr/share/applications/org.gnome.Rhythmbox3.desktop ~/.local/share/applications/
  # Wrap the usual rhythmbox in a bash -c to be able to se the theme - `GTK_THEME=Yaru:dark rhythmbox`
  sed -i \
    's/Exec=rhythmbox %U/Exec=bash -c "GTK_THEME=Yaru:dark rhythmbox %U"/g' \
    ~/.local/share/applications/org.gnome.Rhythmbox3.desktop
}

function install_browsers() {
  sudo dnf install -y google-chrome-stable brave-browser
}

function install_vscode() {
  dnf list code && return

  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
  sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
  dnf check-update
  sudo dnf install code -y
}

function install_docker() {
  sudo dnf remove -y docker* containerd.io

  sudo dnf -y install dnf-plugins-core
  sudo dnf config-manager \
      --add-repo \
      https://download.docker.com/linux/fedora/docker-ce.repo

  sudo dnf install -y \
    docker-ce docker-ce-cli \
    containerd.io docker-buildx-plugin \
    docker-compose-plugin

  sudo usermod -aG docker $USER
  sudo systemctl start docker
}

function bootstrap() {
  echo -e "> bootstrapping fedora...\n"
  for i in base browsers vscode; do install install_$i; done
  print_success "bootstrap complete!"
}

function install() {
  print_installing "$1"
  install_$1
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
