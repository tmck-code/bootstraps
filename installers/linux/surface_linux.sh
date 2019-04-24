#!/bin/bash

set -euxo pipefail

sudo apt-get -y install git curl wget sed

git clone --depth 1 https://github.com/jakeday/linux-surface.git ~/linux-surface

cd $HOME/linux-surface

sudo sh setup.sh
