#!/bin/bash

set -euo pipefail

function detect_os() {
  for os in ubuntu debian; do
    grep -qi "$os" /etc/lsb-release && echo "$os" && return 0
  done
}

function install_debian() {
  line_n=$(grep -n 'deb http://deb.debian.org/debian/ buster main$' /etc/apt/sources.list) || line_n=''
  if [ ! -z "${line_n:-}" ]; then
    sudo sed -i \
      "${line_n}s,deb http://deb.debian.org/debian/ buster main$,deb http://deb.debian.org/debian/ buster main contrib non-free,g" \
      /etc/apt/sources.list
  fi

  sudo dpkg --add-architecture i386
  sudo apt update
  sudo apt install -y \
    steam \
    mesa-vulkan-drivers \
    libglx-mesa0:i386 \
    mesa-vulkan-drivers:i386 \
    libgl1-mesa-dri:i386

  sudo apt install -y -t buster-backports nvidia-driver-libs:i386
}

function install_ubuntu() {
  sudo add-apt-repository -y multiverse
  sudo apt update
  sudo apt install -y libnvidia-gl-460:i386
  sudo apt install -y steam
}

OS=$(detect_os)

case ${OS:-} in
  "ubuntu") install_ubuntu ;;
  "debian") install_debian ;;
  *)        echo "Unsupported OS: '$OS'" && exit 1;;
esac
