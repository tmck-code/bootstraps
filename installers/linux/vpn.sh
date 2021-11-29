#!/bin/bash

set -euxo pipefail

# Dependencies
sudo apt install -y \
  network-manager-openvpn* \
  openvpn \
  uuid-runtime

curl https://www.privateinternetaccess.com/installer/pia-nm.sh | sudo bash

