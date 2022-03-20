#!/bin/bash

set -euo pipefail

function deps() {
  # Just in case, I often use /tmp/ for downloading/unzipping etc
  sudo chown -R $USER:$USER /tmp/
  # Makes the package manager downloads 100x faster
  sudo pacman-mirrors --country Australia

  # Base dependencies
  sudo pacman -Syu --noconfirm \
      git vim ffmpeg mpv docker docker-compose \
      tmux cowsay lolcat fortune-mod redshift nvtop \
      tree screenfetch hyperfine \
      pkgconf flatpak snapd \
      python3 python-pip \
      obs-studio alacritty piper audacious gparted \
      xclip
  python3 -m pip install bpytop ipython

  # pokesay-go
  bash -c "$(curl https://raw.githubusercontent.com/tmck-code/pokesay-go/master/scripts/install.sh)" bash linux amd64

  # docker
  sudo usermod -aG docker $USER
  sudo systemctl enable --now docker
  # snap
  sudo systemctl enable --now snapd.socket
  sudo ln -s /var/lib/snapd/snap /snap
  export PATH="$PATH:/snap"
  # vscode
  sudo snap install code --classic
}


function steam() {
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

function pia() {
  cd /tmp/
  wget https://installers.privateinternetaccess.com/download/pia-linux-3.2-06857.run
  chmod +x ./pia-linux-3.2-06857.run
  sudo ./pia-linux-3.2-06857.run
  rm ./pia-linux-3.2-06857.run
}

for i in "${@}"; do
  ${i}
done

