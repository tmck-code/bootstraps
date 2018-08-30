#!/bin/bash

set -euxo pipefail

# Install Gnome Network Manager dependencies
sudo apt install -y network-manager-openvpn* openvpn

# Download all ovpn files from PIA
sudo mkdir -p /tmp/openvpn && cd /tmp/openvpn
sudo wget https://www.privateinternetaccess.com/openvpn/openvpn.zip
sudo unzip openvpn.zip

# Install ovpn configurations
sudo nmcli connection import type openvpn file /tmp/openvpn/Singapore.ovpn
