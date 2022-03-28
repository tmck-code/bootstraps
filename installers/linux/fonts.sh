#!/bin/bash

set -euxo pipefail

urls=(
  https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Iosevka/Regular/complete/Iosevka%20Nerd%20Font%20Complete%20Mono.ttf
  https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Iosevka/Italic/complete/Iosevka%20Italic%20Nerd%20Font%20Complete%20Mono.ttf
  https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Iosevka/Thin/complete/Iosevka%20Thin%20Nerd%20Font%20Complete%20Mono.ttf
  https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Iosevka/Bold/complete/Iosevka%20Bold%20Nerd%20Font%20Complete%20Mono.ttf
  https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Iosevka/Bold-Italic/complete/Iosevka%20Bold%20Italic%20Nerd%20Font%20Complete%20Mono.ttf
)

mkdir -p $HOME/fonts/
cd $HOME/fonts/

parallel -n 1 -P $(nproc) wget -q ::: "${urls[@]}"

echo "Downloaded fonts to $HOME/fonts:"
ls -1 $HOME/fonts
