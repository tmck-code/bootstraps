#!/bin/bash

set -euo pipefail

if [ -n "${1}" ] && ! [[ "${1}" =~ ^(linux|windows|darwin)$ ]]; then
  echo "$1 must be one of linux/windows/darwin"
  exit 1
fi

OS=${1}
ARCH=amd64

# Get the latest download URL by parsing the download website
url=$(curl -s https://golang.org/dl/ | grep -oE "https://dl.google.com/go/go([0-9]+.)+${OS}-${ARCH}.tar.gz" | head -n 1)

# Get the latest version number from the latest URL found
VERSION=$(grep -oE "([0-9]+\.)+([0-9])+" <<< ${url})

cat <<EOF
Downloading Go!
- VERSION  : ${VERSION}
- download : ${url}

EOF

cd /tmp/
wget --quiet --continue --show-progress ${url}
sudo tar -C /usr/local -xzf go$VERSION.$OS-$ARCH.tar.gz

echo "export PATH=$PATH:/usr/local/go/bin" >> $HOME/.bash_profile

mkdir -p $HOME/go # Create default Go project dir
