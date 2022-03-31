#!/bin/bash

set -euo pipefail

urls=(
  # Iosevka
  https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Iosevka/Regular/complete/Iosevka%20Nerd%20Font%20Complete%20Mono.ttf
  https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Iosevka/Regular/complete/Iosevka%20Term%20Nerd%20Font%20Complete%20Mono.ttf
  https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Iosevka/Italic/complete/Iosevka%20Italic%20Nerd%20Font%20Complete%20Mono.ttf
  https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Iosevka/Italic/complete/Iosevka%20Term%20Italic%20Nerd%20Font%20Complete%20Mono.ttf
  https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Iosevka/Thin/complete/Iosevka%20Thin%20Nerd%20Font%20Complete%20Mono.ttf
  https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Iosevka/Thin/complete/Iosevka%20Term%20Thin%20Nerd%20Font%20Complete%20Mono.ttf
  https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Iosevka/Bold/complete/Iosevka%20Bold%20Nerd%20Font%20Complete%20Mono.ttf
  https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Iosevka/Bold/complete/Iosevka%20Term%20Bold%20Nerd%20Font%20Complete%20Mono.ttf
  https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Iosevka/Bold-Italic/complete/Iosevka%20Bold%20Italic%20Nerd%20Font%20Complete%20Mono.ttf
  https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Iosevka/Bold-Italic/complete/Iosevka%20Term%20Bold%20Italic%20Nerd%20Font%20Complete%20Mono.ttf

  # Hasklig, good for ligatures
  https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Hasklig/Regular/complete/Hasklug%20Nerd%20Font%20Complete.otf
  https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Hasklig/Bold/complete/Hasklug%20Bold%20Nerd%20Font%20Complete.otf
  https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Hasklig/Italic/complete/Hasklug%20Italic%20Nerd%20Font%20Complete.otf
  https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Hasklig/Bold-Italic/complete/Hasklug%20Bold%20Italic%20Nerd%20Font%20Complete.otf

  # Victor Mono - nice curly italic mode
  https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/VictorMono/Light/complete/Victor%20Mono%20Light%20Nerd%20Font%20Complete.ttf
)

mkdir -p $HOME/fonts/
rm -f $HOME/fonts/*
cd $HOME/fonts/

parallel wget -q ::: ${urls[@]}

echo "Downloaded fonts to $HOME/fonts:"
ls -1 $HOME/fonts
