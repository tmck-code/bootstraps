#!/bin/bash

set -euxo pipefail

# Dependencies
sudo apt install -y \
  network-manager-openvpn* \
  openvpn \
  uuid-runtime

# Download all ovpn files from PIA
sudo mkdir -p /tmp/openvpn && cd /tmp/openvpn
sudo wget https://www.privateinternetaccess.com/installer/pia-nm.sh

sudo bash pia-nm.sh
