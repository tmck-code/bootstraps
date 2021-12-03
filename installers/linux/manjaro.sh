#!/bin/bash

set -euo pipefail

function deps() {
  # Makes the package manager downloads 100x faster
  sudo pacman-mirrors --country Australia

  # Base dependencies
  sudo pacman -Syu --noconfirm \
      git vim ffmpeg code docker docker-compose \
      tmux cowsay lolcat fortune-mod screenfetch redshift nvtop \
      pkgconf flatpak snapd \
      python3 python-pip \
      obs-studio alacritty piper

  sudo chown -R $USER:$USER /tmp/

  # pokesay-go
  bash -c "$(curl https://raw.githubusercontent.com/tmck-code/pokesay-go/master/scripts/install.sh)" bash linux amd64

  python3 -m pip install bpytop

  # Add user to the docker group
  sudo usermod -aG docker $USER
  sudo systemctl enable --now docker
  sudo systemctl enable --now snapd.socket
  sudo ln -s /var/lib/snapd/snap /snap
  export PATH="$PATH:/snap"
  sudo snap install code --classic
}


function steam() {
  # Steam
  # run with: flatpak run com.valvesoftware.Steam
  flatpak install flathub com.valvesoftware.Steam
  # Need this to be able to access another drive
  flatpak override --user --filesystem=/mnt/X/ com.valvesoftware.Steam
}


function google_chrome() {
  sudo pacman -S --needed base-devel git
  cd /tmp/
  git clone https://aur.archlinux.org/yay-git.git
  cd yay-git
  makepkg -si
  cd && rm -rf /tmp/yay-git
  yay -S google-chrome
}

for i in "${@}"; do
  ${i}
done

