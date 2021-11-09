#!/bin/bash

set -euxo pipefail

CUDA_VERSION_MAJOR=11.5
CUDA_VERSION=11.5.0
NVIDIA_DRIVER_VERSION=495.29.05
CUDA_OS_VERSION_SLUG=debian11-11-5
NASM_VERSION=2.15.05

export PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig"
export LD_LIBRARY_PATH="/usr/local/cuda-$CUDA_VERSION_MAJOR/lib64:${LD_LIBRARY_PATH:-}"
export PATH="$HOME/bin:/usr/local/cuda-$CUDA_VERSION_MAJOR/bin:$PATH"

function pkg_deps() {
  sudo apt update
  sudo apt -y install \
    autoconf automake build-essential cmake git-core \
    libass-dev libfreetype6-dev libsdl2-dev libtool \
    libssh-dev libssl-dev \
    libva-dev libvdpau-dev libvorbis-dev \
    libxcb1-dev libxcb-shm0-dev libxcb-xfixes0-dev \
    pkg-config texinfo wget yasm zlib1g-dev \
    libvpx-dev libmp3lame-dev libopus-dev
}

function younger_than_a_week() {
  if [ ! -d $1 ]; then
    echo "- $1 does not exist, installing"
    return 1
  fi
  age=$[ $[ $(date +%s) - $(date -r "${1}" +%s) ] / 60 / 60 / 24 ]

  if (( "$age" < 7 )); then
    echo "- $1 is $age days old, skipping"
    return 1
  else
    echo "- $1 is $age days old, updating"
    return 0
  fi
}


function nasm() {
  cd ~/ffmpeg_sources
  [ -d nasm-$NASM_VERSION ] && return

  wget https://www.nasm.us/pub/nasm/releasebuilds/$NASM_VERSION/nasm-$NASM_VERSION.tar.bz2
  tar xjvf nasm-$NASM_VERSION.tar.bz2
  cd nasm-$NASM_VERSION
  ./autogen.sh
  ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin"
  make -j "$(nproc)"
  sudo make -j "$(nproc)" install
}

# NV headers & CUDA
function nv_deps() {
  cd ~/ffmpeg_sources
  younger_than_a_week nv-codec-headers && return

  git -C nv-codec-headers pull 2> /dev/null || git clone --depth 1 https://git.videolan.org/git/ffmpeg/nv-codec-headers.git
  cd nv-codec-headers
  make
  sudo make -j "$(nproc)" install

  # CUDA
  if [ -d /var/cuda-repo-$CUDA_OS_VERSION_SLUG-local/ ]; then
    sudo apt update
    sudo apt upgrade -y
  else
    wget https://developer.download.nvidia.com/compute/cuda/$CUDA_VERSION/local_installers/cuda-repo-$CUDA_OS_VERSION_SLUG-local_$CUDA_VERSION-$NVIDIA_DRIVER_VERSION-1_amd64.deb
    sudo dpkg -i cuda-repo-$CUDA_OS_VERSION_SLUG-local_$CUDA_VERSION-$NVIDIA_DRIVER_VERSION-1_amd64.deb
    sudo apt-key add /var/cuda-repo-$CUDA_OS_VERSION_SLUG-local/7fa2af80.pub
    # sudo add-apt-repository contrib
    sudo apt-get update
    sudo apt-get -y install cuda
  fi
}

function x264() {
  cd ~/ffmpeg_sources
  younger_than_a_week x264 && return

  git -C x264 pull 2> /dev/null || git clone --depth 1 https://code.videolan.org/videolan/x264.git
  cd x264
   ./configure \
    --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --enable-static --enable-pic
  make -j "$(nproc)"
  sudo make -j "$(nproc)" install
}

function x265() {
  cd ~/ffmpeg_sources
  younger_than_a_week x265_git && return

  sudo apt-get install libnuma-dev
  git -C x265_git pull 2> /dev/null || git clone https://bitbucket.org/multicoreware/x265_git
  # if younger_than_a_week x265; then return;  fi
  cd x265_git/build/linux
  cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DENABLE_SHARED=off ../../source
  make -j "$(nproc)"
  sudo make -j "$(nproc)" install
}

function ffmpeg() {
  cd ~/ffmpeg_sources
  younger_than_a_week ffmpeg && return

  wget -O ffmpeg-snapshot.tar.bz2 https://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
  tar xjvf ffmpeg-snapshot.tar.bz2
  cd ffmpeg
  # make distclean
  ./configure \
    --prefix="$HOME/ffmpeg_build" \
    --pkg-config-flags="--static" \
    --extra-cflags="-I$HOME/ffmpeg_build/include -I/usr/include -I/usr/local/include" \
    --extra-ldflags="-L$HOME/ffmpeg_build/lib -L/usr/local/lib" \
    --extra-libs="-lpthread -lm -lz" \
    --bindir="$HOME/bin" \
    --enable-gpl \
    --enable-libass \
    --enable-libfreetype \
    --enable-libmp3lame \
    --enable-libopus \
    --enable-libvorbis \
    --enable-libx264 \
    --enable-libx265 \
    --enable-nonfree \
    --enable-libssh \
    --extra-cflags="-I/usr/local/cuda-11.5/include" \
    --extra-ldflags="-L/usr/local/cuda-11.5/lib64" \
    --nvccflags="-gencode arch=compute_52,code=sm_52 -O2" \
    --enable-cuda-nvcc \
    --enable-cuvid \
    --enable-libnpp \
    --enable-nvenc
  make -j "$(nproc)"
  make -j "$(nproc)" install
  hash -r
}

function remove_compilations() {
  sudo rm -rf ~/ffmpeg_build ~/bin/{ffmpeg,ffprobe,ffplay,x264,x265}
}

function purge() {
  rm -rf ~/ffmpeg_build ~/ffmpeg_sources ~/bin/{ffmpeg,ffprobe,ffplay,x264,x265,nasm,vsyasm,yasm,ytasm}
  hash -r
}

function install() {
  sudo rm -rf ~/ffmpeg_build ~/bin/{ffmpeg,ffprobe,ffplay,x264,x265,nasm,ndisasm}
  mkdir -p ~/ffmpeg_sources ~/ffmpeg_build ~/bin $PKG_CONFIG_PATH
  pkg_deps
  nv_deps
  nasm
  x264
  x265
  ffmpeg
}

function update() {
  remove_compilations
  pkg_deps
  install
}

update
