#!/bin/bash

set -euxo pipefail

if [ -z "${PYTHON_INSTALL_VERSION}" ]; then
  echo "Must set 'PYTHON_INSTALL_VERSION' env var, e.g. 3.7.2"
  exit 1
fi

mkdir -p /usr/local/src
cd /usr/local/src
sudo apt install -y libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev
wget "https://www.python.org/ftp/python/${version}/Python-${version}.tgz"

tar xvzf "Python-${version}.tgz"

cd Python-${version}
./configure --enable-optimizations --with-ensurepip=install
make -j 4
sudo make altinstall

