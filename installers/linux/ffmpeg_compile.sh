#!/bin/bash

# set -euxo pipefail

function pkg_deps() {
  sudo apt update
  sudo apt -y install \
    autoconf \
    automake \
    build-essential \
    cmake \
    git-core \
    libass-dev \
    libbluray-dev \
    libfreetype6-dev \
    libsdl2-dev \
    libtool \
    libva-dev \
    libvdpau-dev \
    libvorbis-dev \
    libxcb1-dev \
    libxcb-shm0-dev \
    libxcb-xfixes0-dev \
    pkg-config \
    texinfo \
    wget \
    zlib1g-dev
}

function younger_than_a_week() {
  echo $[ $[ $(date +%s) - $(date -r "${1}" +%s) ] < 604800 ]
}

function nasm() {
  cd ~/ffmpeg_sources
  # if younger_than_a_week nasm-2.14.02; then return;  fi

  wget https://www.nasm.us/pub/nasm/releasebuilds/2.14.02/nasm-2.14.02.tar.bz2
  tar xjvf nasm-2.14.02.tar.bz2
  cd nasm-2.14.02
  ./autogen.sh
  PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin"
  make -j 4
  make -j 4 install
}

function yasm() {
  # need >= 1.2, debian provides 1.3 as of 2018/07/26
  sudo apt install -y yasm
}

function x264() {
  cd ~/ffmpeg_sources
  # if younger_than_a_week x264; then return;  fi

  git -C x264 pull 2> /dev/null || git clone --depth 1 https://git.videolan.org/git/x264
  cd x264
  PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --enable-static --enable-pic
  PATH="$HOME/bin:$PATH" make -j 4
  make -j 4 install
}

function x265() {
  sudo apt install -y mercurial libnuma-dev
  cd ~/ffmpeg_sources
  # if younger_than_a_week x265; then return;  fi

  if [ -d x265 ]; then
    (cd x265 && hg pull && hg update)
  else
    hg clone --config ui.clonebundles=false https://bitbucket.org/multicoreware/x265
  fi
  cd x265/build/linux
  PATH="$HOME/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DENABLE_SHARED=off ../../source
  PATH="$HOME/bin:$PATH" make -j 4
  make -j 4 install
}

function libbluray() {
  sudo apt-get install -y --no-install-recommends libxml2-dev ant
  cd ~/ffmpeg_sources

  if [ -d libbluray ]; then
    (cd libbluray && git pull && make uninstall && make clean)
  else
    git clone https://code.videolan.org/videolan/libbluray.git
    cd libbluray
    git submodule update --init
    autoreconf -fiv
  fi

  PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --disable-shared --enable-static --disable-examples --disable-bdjava-jar --disable-doxygen-doc --disable-doxygen-dot --without-fontconfig --without-freetype
  PATH="$HOME/bin:$PATH" make -j 4
  make -j 4 install
}

function others() {
  sudo apt install -y \
    libvpx-dev \
    libmp3lame-dev \
    libopus-dev
}

function ffmpeg() {
  mkdir -p ~/ffmpeg_sources ~/bin
  cd ~/ffmpeg_sources
  # if younger_than_a_week ffmpeg; then return; fi
    
  wget -O ffmpeg-snapshot.tar.bz2 https://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
  tar xjvf ffmpeg-snapshot.tar.bz2
  cd ffmpeg
  # make clean
  PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
    --prefix="$HOME/ffmpeg_build" \
    --pkg-config-flags="--static" \
    --extra-cflags="-I$HOME/ffmpeg_build/include -I/usr/include" \
    --extra-ldflags="-L$HOME/ffmpeg_build/lib" \
    --extra-libs="-lpthread -lm" \
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
    --enable-libbluray
  make
  make -j 4 install
  hash -r
}

function remove_compilations() {
  rm -rf ~/ffmpeg_build ~/bin/{ffmpeg,ffprobe,ffplay,x264,x265}
}

function purge() {
  rm -rf ~/ffmpeg_build ~/ffmpeg_sources ~/bin/{ffmpeg,ffprobe,ffplay,x264,x265,nasm,vsyasm,yasm,ytasm}
  # sed -i '/ffmpeg_build/d' ~/.manpath
  hash -r
}

function install() {
  mkdir -p ~/ffmpeg_sources ~/bin
  pkg_deps
  nasm
  yasm
  x264
  x265
  others
  libbluray
  ffmpeg
}

function update() {
  remove_compilations
  pkg_deps
  install
}

update
