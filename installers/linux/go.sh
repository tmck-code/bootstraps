#!/bin/bash

set -euxo pipefail

go_source="go$GOLANG_VERSION.$OS-$ARCH.tar.gz"
temp_dir="/usr/local/src"

mkdir -p ${temp_dir} && sudo chown $USER ${temp_dir}
cd ${temp_dir}

# Fetch the binaries & install into /usr/local/go
wget https://dl.google.com/go/${go_source}
sudo tar -C /usr/local -xzf ${go_source}
rm -rf ${go_source}

# Add the go bin directory to PATH
echo "export PATH=$PATH:/usr/local/go/bin" >> $HOME/.profile

echo "- finished installing ${go_source}"

