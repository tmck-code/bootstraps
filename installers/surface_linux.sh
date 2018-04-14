#!/bin/bash

set -euxo pipefail

version="4.15.16"
revision="1"
ipts="v78"
i915="skl"

sudo mkdir -p /usr/local/src
cd /usr/local/src

debs=(
  "linux-headers-4.15.16-surface-linux-surface_4.15.16-surface-linux-surface-37_amd64.deb"
  "linux-image-4.15.16-surface-linux-surface_4.15.16-surface-linux-surface-37_amd64.deb"
)

for file in ${files[@]}; do
  [ -f "${file}" ] || wget https://github.com/jakeday/linux-surface/releases/download/4.15.16-1/${file}
done

source="4.15.16-1"
[ -f "${source}.tar.gz" ] || wget https://github.com/jakeday/linux-surface/archive/${source}.tar.gz

rm -rf linux-surface-${source}
tar xvzf ${source}.tar.gz
cd linux-surface-${source}

# 1. Copy the files under root to where they belong:
sudo cp -R root/* /
# 
# 2. Make /lib/systemd/system-sleep/hibernate as executable:
sudo chmod a+x /lib/systemd/system-sleep/hibernate

# 3. Extract ipts_firmware_v78.zip to /lib/firmware/intel/ipts/
sudo mkdir -p /lib/firmware/intel/ipts
sudo unzip firmware/ipts_firmware_${ipts}.zip -d /lib/firmware/intel/ipts/

# 4. Extract i915_firmware_skl_.zip to /lib/firmware/i915/
sudo mkdir -p /lib/firmware/i915
sudo unzip firmware/i915_firmware_${i915}.zip -d /lib/firmware/i915/

# 5. (Ubuntu 17.10) Fix issue with Suspend to Disk:
sudo ln -s /lib/systemd/system/hibernate.target /etc/systemd/system/suspend.target && sudo ln -s /lib/systemd/system/systemd-hibernate.service /etc/systemd/system/systemd-suspend.service
# 5. (all other distros) Fix issue with Suspend to Disk:
# sudo ln -s /usr/lib/systemd/system/hibernate.target /etc/systemd/system/suspend.target && sudo ln -s /usr/lib/systemd/system/systemd-hibernate.service /etc/systemd/system/systemd-suspend.service

# 6. Install the latest marvell firmware
git clone git://git.marvell.com/mwifiex-firmware.git
sudo mkdir -p /lib/firmware/mrvl/
sudo cp -v mwifiex-firmware/mrvl/* /lib/firmware/mrvl/

# 7. Install the custom kernel and headers:
sudo dpkg -i "${debs[@]}" 

