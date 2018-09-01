# bootstraps

A home for all my linux bootstrapping scripts, somewhat mirrors the contents of my Docker repo.

## Use thusly

* is _slightly_more annoying/more effort to set up, but is worth it in the future
### Pull repo via ssh

```bash
sudo apt update && \
  sudo apt install -y git && \
  git clone git@github.com:tmck-code/bootstraps.git && \
  cd bootstraps
```

### Pull repo via https

```bash
sudo apt update && \
  sudo apt install -y git && \
  git clone https://github.com/tmck-code/bootstraps.git && \
  cd bootstraps
```
 
 ## Example boostraps
 
 ### Ubuntu
 
```bash
sudo apt update && \
  sudo apt install -y git && \
  git clone git@github.com:tmck-code/bootstraps.git && \
  cd bootstraps && \
  ./installers/ubuntu.sh &&
  ./installers/linux && \
  ./installers/tools && \
  ./installers/dotfile
```

## Windows preparation

1. Install distro of choice through the Windows Store (Ubuntu, Debian etc.)

First, launch Powershell in Administrator mode

```
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
```

## Snippets

### Windows

#### Hyper terminal

```
# In admin powershell:
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco install yarn
yarn global add windows-build-tools
choco install hyper
```
