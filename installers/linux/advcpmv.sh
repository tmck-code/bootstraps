#!/bin/bash

cd /tmp/

wget http://ftp.gnu.org/gnu/coreutils/coreutils-8.32.tar.xz
tar xvJf coreutils-8.32.tar.xz
cd coreutils-8.32/
wget https://raw.githubusercontent.com/jarun/advcpmv/master/advcpmv-0.8-8.32.patch
patch -p1 -i advcpmv-0.8-8.32.patch
./configure
make -j $(nproc)

sudo mv ./src/cp $HOME/bin/cpv
sudo mv ./src/mv $HOME/bin/mvv

cd && rm -rf /tmp/coreutils-8.32/
