#!/bin/bash

set -euxo pipefail

FONT_DIR="$HOME/fonts"
mkdir $FONT_DIR && cd $FONT_DIR

wget https://github.com/tonsky/FiraCode/releases/download/1.206/FiraCode_1.206.zip

