#!/bin/bash

set -euxo pipefail

sudo apt-get -y install git curl wget sed

git clone https://github.com/jakeday/linux-surface.git $HOME/linux-surface
cd $HOME/linux-surface

sudo sh setup.sh
