#!/bin/bash

set -euxo pipefail

version=3.6.5

mkdir -p /usr/local/src
cd /usr/local/src
sudo apt install -y libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev
wget "https://www.python.org/ftp/python/${version}/Python-${version}.tgz"

tar xvzf "Python-${version}.tgz"

cd Python-${version}
./configure --enable-optimizations --with-ensurepip=install
make -j 4
sudo make altinstall

