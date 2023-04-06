#!/bin/bash

sudo dnf remove libreoffice*
sudo dnf upgrade

sudo dnf install ncurses ncurses-devel \
  google-chrome-stable steam brave-browser

