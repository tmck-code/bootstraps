#!/bin/bash

set -euo pipefail

export core_repos="\
airblade/vim-gitgutter
andrewradev/splitjoin.vim
chrisbra/csv.vim
ctrlpvim/ctrlp.vim
dyng/ctrlsf.vim
lifepillar/vim-mucomplete
mechatroner/rainbow_csv
ngmy/vim-rubocop
ntpeters/vim-better-whitespace
tpope/vim-fugitive
tpope/vim-sensible
tpope/vim-surround
vim-scripts/Align"

export aesthetic_repos="\
ekalinin/Dockerfile.vim
fenetikm/falcon
ftsamoyed/PinkCatBoo
morhetz/gruvbox
mxw/vim-jsx.git
ntk148v/vim-horizon
pangloss/vim-javascript
rakr/vim-one
rigellute/shades-of-purple.vim
ryanoasis/vim-devicons
scrooloose/nerdtree
scrooloose/syntastic
sickill/vim-monokai
tiagofumo/vim-nerdtree-syntax-highlight
vim-airline/vim-airline
vim-airline/vim-airline-themes"

N_CONCURRENT_DOWNLOADS=2

function install_pathogen() {
  echo "- Installing Pathogen (plugin/plugin manager)"

  [ ! -f "${HOME}/.vim/bundle" ] && mkdir -p "${HOME}/.vim/bundle"

  if [ ! -f "${HOME}"/.vim/autoload/pathogen.vim ]; then
    mkdir -p "${HOME}"/.vim/autoload
    curl -LSso "${HOME}"/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
  else
    echo "-- Pathogen already installed, skipping"
  fi
}

function install_plugin() {
  echo "- Installing vim plugin: ${1}"
  repo=$(echo "${1}" | cut -d '/' -f 2)
  if [ ! -d "${repo}" ]; then
    git clone --depth 1 "git@github.com:${1}" || echo "- vim plugin already exists: ${1}"
  else
    echo "-- Plugin already installed: ${1}, skipping"
  fi
}
export -f install_plugin

function install_plugin_category() {
  cd "${HOME}/.vim/bundle"
  echo "${!1}" | parallel -n 1 -P ${N_CONCURRENT_DOWNLOADS} install_plugin
}

function install_all_plugins() {
  echo "- Installing all plugins"
  install_pathogen
  install_plugin_category "core_repos"
  install_plugin_category "aesthetic_repos"
}
export -f install_all_plugins

# Don't run if we're just sourcing the file
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
  echo "- Sourced vim plugin functions"
else
  install_all_plugins
fi

