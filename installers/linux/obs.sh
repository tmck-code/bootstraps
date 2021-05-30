#!/bin/bash

set -euo pipefail

function detect_os() {
  for os in ubuntu debian; do
    grep -qi "$os" /etc/lsb-release && echo "$os" && return 0
  done
}

function install_ubuntu() {
  sudo apt purge -y obs* libobs*
  sudo apt autoremove --purge -y

  sudo apt install -y v4l2loopback-dkms

  sudo add-apt-repository -y ppa:obsproject/obs-studio
  sudo apt update
  sudo apt install -y obs-studio
}

function install_debian() {
  sudo apt install -y \
    build-essential checkinstall cmake git libasound2-dev libavcodec-dev libavdevice-dev \
    libavfilter-dev libavformat-dev libavutil-dev libcurl4-openssl-dev libfdk-aac-dev \
    libfontconfig-dev libfreetype6-dev libglvnd-dev libjack-jackd2-dev libjansson-dev \
    libluajit-5.1-dev libmbedtls-dev libnss3-dev libpipewire-0.3-dev libpulse-dev \
    libqt5svg5-dev libqt5x11extras5-dev libspeexdsp-dev libswresample-dev libswscale-dev \
    libudev-dev libv4l-dev libvlc-dev libwayland-dev libx11-dev libx11-xcb-dev libx264-dev \
    libxcb-randr0-dev libxcb-shm0-dev libxcb-xfixes0-dev libxcb-xinerama0-dev libxcb1-dev \
    libxcomposite-dev libxinerama-dev libxss-dev pkg-config python3-dev qtbase5-dev \
    qtbase5-private-dev qtwayland5 swig

  wget https://cdn-fastly.obsproject.com/downloads/cef_binary_4280_linux64.tar.bz2
  tar -xjf ./cef_binary_4280_linux64.tar.bz2
  git clone --recursive https://github.com/obsproject/obs-studio.git
  cd obs-studio
  mkdir build && cd build
  cmake -DUNIX_STRUCTURE=1 -DCMAKE_INSTALL_PREFIX=/usr -DBUILD_BROWSER=ON -DCEF_ROOT_DIR="../../cef_binary_4280_linux64" ..
  make -j $(nproc)
  sudo make install -j $(nproc)
}

OS=$(detect_os)

case ${OS:-} in
  "ubuntu") install_ubuntu ;;
  "debian") install_debian ;;
  *)        echo "Unsupported OS: '$OS'" && exit 1;;
esac