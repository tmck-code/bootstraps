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

mkdir -p "$HOME/bin/streaming/figlet/"
for i in ${the_best[@]}; do
  ln -svf "/usr/share/figlet/fonts/$i" "$HOME/bin/streaming/figlet/"
done
