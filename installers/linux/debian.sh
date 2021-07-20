#!/bin/bash

set -euo pipefail

# Remove the largest, least-used programs. Saves a lot of time when running
# `apt-get upgrade` for the first time
function purge_bloat() {
  echo "> Purging largest programs that aren't often used"
  sudo apt-get update
  sudo apt-get purge -y libreoffice* thunderbird* rhythmbox* shotwell*
  sudo apt-get autoremove -y
}

# Removes bloaty programs and then upgrades the system.
function clean_slate() {
  purge_bloat

  echo "> Upgrading all OS packages"
  sudo apt-get update
  sudo apt-get upgrade -y
}

# Install base dependencies
function install_base() {
  echo "> Installing base OS packages"
  sudo apt-get update
  sudo apt-get install -y --no-install-recommends \
    wget curl git tig tree \
    tmux htop iotop bmon sysstat \
    parallel \
    cowsay fortune fortunes \
    locales build-essential yasm
}


# Install tools used in .bashrc
# - my pokesay lib
# - "high-performance" lolcat
function install_pokesay() {
  echo "> Installing pokesay tools for .bashrc"
  cd /tmp

  sudo apt-get update
  sudo apt-get install -y cowsay fortune

  if [ ! -f $HOME/bin/pokesay ]; then
    git clone --depth 1 http://github.com/tmck-code/pokesay
    (cd pokesay && ./install.sh)
  fi

  if [ ! -f $HOME/bin/lolcat ]; then
    git clone --depth 1 https://github.com/jaseg/lolcat.git
    (cd lolcat && make lolcat && cp ./lolcat $HOME/bin/)
  fi

  rm -rf /tmp/pokesay /tmp/lolcat
}

function install_vscode() {
  curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
  sudo install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/microsoft-archive-keyring.gpg
  sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

  sudo apt install -y apt-transport-https
  sudo apt update
  sudo apt install code # or code-insiders
}

function install_chrome() {
  cd /tmp/
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  sudo apt install -y ./google-chrome-stable_current_amd64.deb
}

function install_opera() {
  sudo sh -c 'echo "deb http://deb.opera.com/opera-stable/ stable non-free" > /etc/apt/sources.list.d/opera.list'
  wget -O - https://deb.opera.com/archive.key | sudo apt-key add -
  sudo apt update
  sudo apt install -y opera-stable
}

function install_ergodox() {
  sudo apt install -y libusb-dev # gtk+3.0 libwebkit2gtk-4.0 libusb-dev
  local config=$(cat <<EOF
# Teensy rules for the Ergodox EZ
ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", ENV{ID_MM_DEVICE_IGNORE}="1"
ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789A]?", ENV{MTP_NO_PROBE}="1"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789ABCD]?", MODE:="0666"
KERNEL=="ttyACM*", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", MODE:="0666"

# STM32 rules for the Moonlander and Planck EZ
SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", \
    MODE:="0666", \
    SYMLINK+="stm32_dfu"
EOF
)
  echo "${config}" | sudo tee /etc/udev/rules.d/50-wally.rules
  cd /tmp/
  wget https://configure.ergodox-ez.com/wally/linux -O wally
  chmod +x wally
  mv wally $HOME/bin
}

function install_rust() {
  if ! command -v rustup; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    source $HOME/.cargo/env
    rustup override set stable
    rustup update stable
  fi
}

function install_alacritty() {
  sudo apt update
  sudo apt install -y \
    cmake pkg-config \
    libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev

  # install rustup/cargo
  install_rust
  [ -d /tmp/alacritty ] && rm -rf /tmp/alacritty

  cd /tmp/
  git clone https://github.com/alacritty/alacritty.git

  cd alacritty
  cargo build --release
    sudo cp -v target/release/alacritty /usr/local/bin/
  cd $HOME
  rm -rf /tmp/alacritty
}

function install_steam() {
  echo "Installing steam"
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

function install_obs() {
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
  make -j "$(nproc)"
  sudo make install -j "$(nproc)"
}

function install_fish() {
  echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/3/Debian_10/ /' \
    | sudo tee /etc/apt/sources.list.d/shells:fish:release:3.list
  curl -fsSL https://download.opensuse.org/repositories/shells:fish:release:3/Debian_10/Release.key \
    | gpg --dearmor \
    | sudo tee /etc/apt/trusted.gpg.d/shells_fish_release_3.gpg \
    > /dev/null
  sudo apt update
  sudo apt install -y fish
}

function install_z() {
  rm -rf "$HOME/bin/z/"
  git clone git@github.com:rupa/z.git "$HOME/bin/z/"
}

function install_spacemacs() {
  sudo apt update
  sudo apt install -y emacs
  git clone https://github.com/syl20bnr/spacemacs "$HOME/.emacs.d"
}

function install_git() {
  sudo apt install -y \
    git gettext \
    libssl-dev libghc-zlib-dev libcurl4-gnutls-dev libexpat1-dev

  [ -d /tmp/git ] || git clone https://github.com/git/git.git /tmp/git
  cd /tmp/git && git pull
  make prefix=/usr/local -j "$(nproc)" all
  sudo make prefix=/usr/local -j "$(nproc)" install
}

function install_sbt() {
  echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" | sudo tee /etc/apt/sources.list.d/sbt.list
  echo "deb https://repo.scala-sbt.org/scalasbt/debian /" | sudo tee /etc/apt/sources.list.d/sbt_old.list
  curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | sudo apt-key add
  sudo apt-get update
  sudo apt-get install sbt
}

function install_cli_tools() {
  install_z
}

function bootstrap() {
  echo "> Bootstrapping debian"
  clean_slate
  install_base
  install_pokesay
  install_vscode
  install_spacemacs
  install_chrome
  install_ergodox
  install_alacritty
  echo "> Bootstrap complete!"
}

function extras() {
  install_fish
  install_cli_tools
}

case ${1:-} in
  "alacritty" )   install_alacritty ;;
  "base" )        install_base ;;
  "chrome" )      install_chrome ;;
  "clean_slate" ) clean_slate ;;
  "cli_tools" )   install_cli_tools ;;
  "ergodox" )     install_ergodox ;;
  "fish" )        install_fish ;;
  "git" )         install_git ;;
  "obs" )         install_obs ;;
  "opera" )       install_opera ;;
  "pokesay" )     install_pokesay ;;
  "rust" )        install_rust ;;
  "sbt" )         install_sbt ;;
  "steam" )       install_steam ;;
  "spacemacs" )   install_spacemacs ;;
  "vscode" )      install_vscode ;;
  "extras" )      extras ;;
  "bootstrap"|* )   bootstrap ;;
esac
