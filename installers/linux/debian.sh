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
    wget curl git tig tree net-tools \
    tmux htop iotop bmon sysstat \
    parallel \
    cowsay fortune fortunes \
    locales build-essential yasm \
    bash-completion \
    pulseeffects lsp-plugins \
    jq silversearcher-ag shellcheck
}


# Install tools used in .bashrc
# - my pokesay lib
# - "high-performance" lolcat
function install_pokesay() {
  echo "> Installing pokesay tools for .bashrc"

  bash -c "$(curl https://raw.githubusercontent.com/tmck-code/pokesay/master/build/scripts/install.sh)" bash linux amd64
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
  local config
  config=$(cat <<EOF
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
  mv wally "$HOME/bin"
}

function install_rust() {
  if ! command -v rustup; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    source "$HOME/.cargo/env"
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

  # Add Desktop Entry
  sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
  sudo desktop-file-install extra/linux/Alacritty.desktop
  sudo update-desktop-database

  # Install man pages
  sudo mkdir -p /usr/local/share/man/man1
  gzip -c extra/alacritty.man | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null
  gzip -c extra/alacritty-msg.man | sudo tee /usr/local/share/man/man1/alacritty-msg.1.gz > /dev/null

  # Install completions
  mkdir -p ~/.bash_completion
  cp extra/completions/alacritty.bash ~/.bash_completion/alacritty

  cd "$HOME"
  rm -rf /tmp/alacritty
}

function install_steam() {
  echo "Installing steam"
  line_n=$(grep -n 'deb http://deb.debian.org/debian/ buster main$' /etc/apt/sources.list) || line_n=''
  if [ -n "${line_n:-}" ]; then
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

  cd $HOME/dev
  wget https://cdn-fastly.obsproject.com/downloads/cef_binary_4280_linux64.tar.bz2
  tar -xjf ./cef_binary_4280_linux64.tar.bz2

  [ -f obs-studio ] && rm -rf obs-studio
  git clone --recursive https://github.com/obsproject/obs-studio.git

  cd obs-studio
  mkdir -p build && cd build
  cmake -DUNIX_STRUCTURE=1 -DCMAKE_INSTALL_PREFIX=/usr -DBUILD_BROWSER=ON -DCEF_ROOT_DIR="../../cef_binary_4280_linux64" ..
  make -j "$(nproc)"
  sudo make install -j "$(nproc)"
}

function install_brave() {
  sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
  sudo apt update
  sudo apt install -y brave-browser
}

function install_zoom() {
  cd /tmp/
  wget https://zoom.us/client/latest/zoom_amd64.deb
  sudo dpkg -i zoom_amd64.deb
  rm zoom_amd64.deb
}

# My favourite shell... I think?
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

# A cli tool for benchmarking things, like an improved /usr/bin/time
function install_hyperfine() {
  cd /tmp/
  HYPERFINE_DEB=hyperfine-musl_1.12.0_amd64.deb
  wget https://github.com/sharkdp/hyperfine/releases/download/v1.12.0/$HYPERFINE_DEB
  sudo dpkg -i $HYPERFINE_DEB
  rm $HYPERFINE_DEB
}

function nerd_font_paths() {
  family="${1}"
  family_html="${2}"
  urls=(
    "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/${family}/Regular/complete/${family_html}%20Nerd%20Font%20Complete.ttf"
    "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/${family}/Bold/complete/${family_html}%20Bold%20Nerd%20Font%20Complete.ttf"
    "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/${family}/Bold-Italic/complete/${family_html}%20Bold%20Italic%20Nerd%20Font%20Complete.ttf"
    "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/${family}/Italic/complete/${family_html}%20Italic%20Nerd%20Font%20Complete.ttf"
  )
  echo ${urls[@]}
}

# These 4 are required by alacritty (regular/bold/bold-italic/italic)
function install_nerd_fonts() {
  for font in "Iosevka Iosevka" "VictorMono Victor%20Mono"; do
    mkdir -p "$HOME/dev/fonts/${font}"
    nerd_font_paths $(echo "${font}") | xargs -n1 wget -P "$HOME/dev/fonts/${font}"
    ln -s "/usr/share/fonts/truetype/${font}" "$HOME/dev/fonts/${font}"
  done
  fc-cache
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

function install_balena_etcher() {
  curl -1sLf \
     'https://dl.cloudsmith.io/public/balena/etcher/setup.deb.sh' \
     | sudo -E bash
  sudo apt-get update
  sudo apt-get install balena-etcher-electron
}

function install_obsidian() {
  cd /tmp/
  wget https://github.com/obsidianmd/obsidian-releases/releases/download/v1.1.16/obsidian_1.1.16_amd64.deb
  sudo dpkg -i obsidian_1.1.16_amd64.deb
  rm obsidian_1.1.16_amd64.deb
}

function install_z() {
  mkdir -p $HOME/dev
  cd $HOME/dev
  git clone https://github.com/rupa/z.git

  echo "source $HOME/dev/z/z.sh" >> $HOME/.bash_profile
}

function install_python() {
  local version
  version=${PYTHON_VERSION:-3.11.1}
  sudo apt install -y \
    build-essential libbz2-dev libc6-dev libffi-dev libgdbm-dev libncurses5-dev \
    libncursesw5-dev libnss3-dev libreadline-dev libsqlite3-dev libssl-dev \
    tk-dev zlib1g-dev

  cd $HOME/dev
  wget https://www.python.org/ftp/python/${version}/Python-${version}.tgz
  tar xzf Python-${version}.tgz
  rm Python-${version}.tgz

  cd Python-${version}

  ./configure --enable-optimizations
  make -j $(nproc)
  make -j $(nproc) test
  sudo make install
}

function install_gh() {
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
  sudo apt update
  sudo apt install gh
}

function install_cli_tools() {
  install_nerd_fonts
  install_fish
  install_hyperfine
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
  install_gh
  install_alacritty
  install_brave
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
