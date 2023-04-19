#!/bin/bash

set -euo pipefail

fonts="${*:-FiraCode FiraCode NotoS}"

function install_font() {
  local font="$1"
  echo "⌛installing $font"
  cd "$HOME/.fonts/nerd-fonts"
  git sparse-checkout add "patched-fonts/$font"

  ./install.sh "$font"
  echo "✔ $font installed"
}

function create_or_update_fonts_repository() {
  if ! test -d "$HOME/.fonts/nerd-fonts"; then
    echo "⌛creating fonts directory"
    mkdir -p "$HOME/.fonts/"
    git clone \
      --filter=blob:none \
      --sparse git@github.com:ryanoasis/nerd-fonts \
      "$HOME/.fonts/nerd-fonts"

    cd "$HOME/.fonts/nerd-fonts"
    echo "✔ fonts repository cloned"
  else
    echo "⌛updating fonts repository"
    cd "$HOME/.fonts/nerd-fonts"
    git pull

    echo "✔ fonts repository updated"
  fi
}

echo "⌛installing fonts: $fonts"
for font in $fonts; do
  install_font "$font"
done
