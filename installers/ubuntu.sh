#!/bin/bash

set -euxo pipefail

# Update, remove crap & upgrade
sudo apt-get update
sudo apt-get remove -y libreoffice* thunderbird* firefox* rhythmbox*
sudo apt-get upgrade -y

# Basic deps
sudo apt-get install -y \
    cowsay fortune tmux \
    docker docker-compose \
    wget git checkinstall locales build-essential yasm \
    htop iotop bmon nethogs \
    vlc handbrake guake terminator redshift

sudo DEBIAN_FRONTEND=noninteractive apt-get -yq install libdvd-pkg

# Kodi
# sudo apt-get install -y software-properties-common
# sudo add-apt-repository -y ppa:team-xbmc/ppa
# sudo apt-get update
# sudo apt-get install -y kodi

# Plex media server
# echo deb https://downloads.plex.tv/repo/deb ./public main | sudo tee /etc/apt/sources.list.d/plexmediaserver.list
# curl https://downloads.plex.tv/plex-keys/PlexSign.key | sudo apt-key add -
# sudo apt-get update && sudo apt-get install -y plexmediaserver


# ffmpeg
sudo apt-get install -y libass-dev libfreetype6-dev \
  libsdl2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev \
  libxcb-xfixes0-dev pkg-config texinfo zlib1g-dev \
  libmp3lame-dev libfdk-aac-dev libx264-dev libx265-dev
sudo apt-get install -y ffmpeg

sudo apt-get autoremove -y
