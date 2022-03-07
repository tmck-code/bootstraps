#!/bin/bash

set -euxo pipefail

# Dependencies
sudo apt install -y \
  network-manager-openvpn* \
  openvpn \
  uuid-runtime

cd /tmp/
FNAME="pia-linux-3.1.2-06767.run"
wget https://installers.privateinternetaccess.com/download/$FNAME
chmod +x $FNAME
sudo ls
./$FNAME
rm $FNAME

