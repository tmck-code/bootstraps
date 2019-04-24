#!/bin/bash

set -euxo pipefail

mkdir -p $HOME/dev

cd $HOME/dev
git clone git@github.com:Invoicebus/html-invoice-generator.git

gem install sass
gem install compass
npm install -g grunt-cli

cd html-invoice-generator
npm install

grunt prod

