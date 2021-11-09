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
    autoconf automake build-essential cmake git-core python3-pip ninja-build meson \
    libass-dev libfreetype6-dev libsdl2-dev libtool \
    libssh-dev libssl-dev \
    libva-dev libvdpau-dev libvorbis-dev \
    libxcb1-dev libxcb-shm0-dev libxcb-xfixes0-dev \
    pkg-config texinfo wget yasm zlib1g-dev \
    libgnutls28-dev libvpx-dev libmp3lame-dev libopus-dev \
    libunistring-dev
}

function younger_than_a_week() {
  return 1
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
  younger_than_a_week nasm-$NASM_VERSION && return

  wget https://www.nasm.us/pub/nasm/releasebuilds/$NASM_VERSION/nasm-$NASM_VERSION.tar.bz2
  tar xjvf nasm-$NASM_VERSION.tar.bz2
  cd nasm-$NASM_VERSION
  ./autogen.sh
  ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin"
  make -j "$(nproc)"
  make -j "$(nproc)" install
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
  make -j "$(nproc)" install
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
  make -j "$(nproc)" install
}

function libfdk_aac() {
  cd ~/ffmpeg_sources
  younger_than_a_week fdk-aac && return

  git -C fdk-aac pull 2> /dev/null || git clone --depth 1 https://github.com/mstorsjo/fdk-aac
  cd fdk-aac
  autoreconf -fiv
  ./configure --prefix="$HOME/ffmpeg_build" --disable-shared
  make -j "$(nproc)"
  make -j "$(nproc)" install
}

function libopus() {
  cd ~/ffmpeg_sources
  younger_than_a_week opus && return

  git -C opus pull 2> /dev/null || git clone --depth 1 https://github.com/xiph/opus.git
  cd opus
  ./autogen.sh
  ./configure --prefix="$HOME/ffmpeg_build" --disable-shared
  make -j "$(nproc)"
  make -j "$(nproc)" install
}

function libaom() {
  cd ~/ffmpeg_sources
  younger_than_a_week aom_build && return

  git -C aom pull 2> /dev/null || git clone --depth 1 https://aomedia.googlesource.com/aom
  mkdir -p aom_build
  cd aom_build
  cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DENABLE_TESTS=OFF -DENABLE_NASM=on ../aom
  make -j "$(nproc)"
  make -j "$(nproc)" install
}

function libsvtav1() {
  cd ~/ffmpeg_sources
  younger_than_a_week SVT-AV1 && return

  git -C SVT-AV1 pull 2> /dev/null || git clone https://gitlab.com/AOMediaCodec/SVT-AV1.git
  mkdir -p SVT-AV1/build
  cd SVT-AV1/build
  cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DCMAKE_BUILD_TYPE=Release -DBUILD_DEC=OFF -DBUILD_SHARED_LIBS=OFF ..
  make -j "$(nproc)"
  make -j "$(nproc)" install
}

function libdav1d() {
  pip3 install --user meson

  cd ~/ffmpeg_sources
  younger_than_a_week dav1d && return


  git -C dav1d pull 2> /dev/null || git clone --depth 1 https://code.videolan.org/videolan/dav1d.git
  mkdir -p dav1d/build
  cd dav1d/build
  meson setup -Denable_tools=false -Denable_tests=false --default-library=static .. --prefix "$HOME/ffmpeg_build" --libdir="$HOME/ffmpeg_build/lib"
  ninja
  ninja install
}

function libvmaf() {
  cd ~/ffmpeg_sources
  younger_than_a_week vmaf-2.1.1 && return

  wget https://github.com/Netflix/vmaf/archive/v2.1.1.tar.gz
  tar xvf v2.1.1.tar.gz
  mkdir -p vmaf-2.1.1/libvmaf/build
  cd vmaf-2.1.1/libvmaf/build
  meson setup -Denable_tests=false -Denable_docs=false --buildtype=release --default-library=static .. --prefix "$HOME/ffmpeg_build" --bindir="$HOME/ffmpeg_build/bin" --libdir="$HOME/ffmpeg_build/lib"
  ninja
  ninja install
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
    --extra-cflags="-I$HOME/ffmpeg_build/include -I/usr/include -I/usr/local/include -I/usr/local/cuda-11.5/include" \
    --extra-ldflags="-L$HOME/ffmpeg_build/lib -L/usr/local/lib -L/usr/local/cuda-11.5/lib64" \
    --nvccflags="-gencode arch=compute_52,code=sm_52 -O2" \
    --extra-libs="-lpthread -lm -lz" \
    --ld="g++" \
    --bindir="$HOME/bin" \
    --enable-nonfree \
    --enable-libssh \
    --enable-gpl \
    --enable-gnutls \
    --enable-libaom \
    --enable-libass \
    --enable-libfdk-aac \
    --enable-libfreetype \
    --enable-libmp3lame \
    --enable-libopus \
    --enable-libsvtav1 \
    --enable-libvmaf \
    --enable-libvorbis \
    --enable-libvpx \
    --enable-libx264 \
    --enable-libx265 \
    --enable-cuda-nvcc \
    --enable-cuvid \
    --enable-libnpp \
    --enable-nvenc
    # --enable-libdav1d \
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
  # sudo rm -rf ~/ffmpeg_build ~/bin/{ffmpeg,ffprobe,ffplay,x264,x265,nasm,ndisasm}
  mkdir -p ~/ffmpeg_sources ~/ffmpeg_build ~/bin $PKG_CONFIG_PATH
  pkg_deps
  nv_deps
  nasm
  x264
  x265
  libfdk_aac
  libopus
  libaom
  libsvtav1
  # libdav1d
  libvmaf
  ffmpeg
}

function update() {
  pkg_deps
  install
}

update
