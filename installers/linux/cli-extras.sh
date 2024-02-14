#!/bin/bash

set -euo pipefail

the_best=(
  'Spliff.flf'
  'doh.flf'
  'Doh.flf'
  'DOS Rebel.flf'
  'larry3d.flf'
  '3d.flf'
  'Georgia11.flf'
  'rusto.flf'
  'Small.flf'
  'Crawford2.flf'
  'miniwi.flf'
  'Roman.flf'
  'miniwi.flf'
  'slant.flf'
  'ANSI Shadow.flf'
  'Bloody.flf'
  'NScript.flf'
)

cd /tmp
rm -rf figlet-fonts
git clone git@github.com:xero/figlet-fonts.git

sudo chown -R $USER:$USER /usr/share/figlet/
mkdir -p /usr/share/figlet/fonts

cp -v figlet-fonts/* /usr/share/figlet/fonts/
rm -rf figlet-fonts

mkdir -p "$HOME/bin/streaming/figlet/"
for i in ${the_best[@]}; do
  ln -svf "/usr/share/figlet/fonts/$i" "$HOME/bin/streaming/figlet/"
done
