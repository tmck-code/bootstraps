#!/bin/bash

set -euxo pipefail

version=3.6.4

mkdir -p /usr/local/src
cd /usr/local/src
wget "https://www.python.org/ftp/python/${version}/Python-${version}.tgz"

tar xvzf "Python-${version}.tgz"

cd Python-${version}
./configure
make
sudo make altinstall

