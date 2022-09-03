#!/bin/bash

set -euxo pipefail

sudo su -c "bash <(wget -qO- https://cutt.ly/PjNkrzq)" root
sudo gopro --help
