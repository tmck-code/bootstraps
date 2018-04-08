#!/bin/bash

set -euxo pipefail

# 1. Copy the files under root to where they belong:

sudo cp -R root/* /

# 2. 
sudo chmod a+x /lib/systemd/system-sleep/hibernate

sudo mkdir -p /lib/firmware/intel/ipts
sudo unzip firmware/ipts_firmware_[VERSION].zip -d /lib/firmware/intel/ipts/
sudo mkdir -p /lib/firmware/i915
sudo unzip firmware/i915_firmware_[VERSION].zip -d /lib/firmware/i915/

sudo ln -s /lib/systemd/system/hibernate.target /etc/systemd/system/suspend.target && sudo ln -s /lib/systemd/system/systemd-hibernate.service /etc/systemd/system/systemd-suspend.service
sudo ln -s /usr/lib/systemd/system/hibernate.target /etc/systemd/system/suspend.target && sudo ln -s /usr/lib/systemd/system/systemd-hibernate.service /etc/systemd/system/systemd-suspend.service

git clone git://git.marvell.com/mwifiex-firmware.git
sudo mkdir -p /lib/firmware/mrvl/
sudo cp mwifiex-firmware/mrvl/* /lib/firmware/mrvl/

sudo dpkg -i linux-headers-[VERSION].deb linux-image-[VERSION].deb


## Compile from scratch

sudo apt-get install build-essential binutils-dev libncurses5-dev libssl-dev ccache bison flex
cd ~
git clone git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
cd linux-stable
git checkout v4.y.z
for i in ~/linux-surface/patches/[VERSION]/*.patch; do patch -p1 < $i; done
cp ~/linux-surface/config .config
make -j \`getconf _NPROCESSORS_ONLN\` deb-pkg LOCALVERSION=-linux-surface
sudo dpkg -i linux-headers-[VERSION].deb linux-image-[VERSION].deb
