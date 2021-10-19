# bootstraps

A home for all my linux bootstrapping scripts, somewhat mirrors the contents of my Docker repo.

## Use thusly

* is _slightly_more annoying/more effort to set up, but is worth it in the future

### One-liner

```bash
bash -c "$(curl https://raw.githubusercontent.com/tmck-code/bootstraps/master/bootstrap.sh)"
```

### Pull repo via ssh

```bash
ssh-keygen -t ed25519
cat ~/.ssh/id_ed25519.pub

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

### Manjaro

```bash
sudo pacman -Syu --noconfirm && \
  sudo pacman -S --noconfirm git && \
  git clone git@github.com:tmck-code/bootstraps.git && \
  cd bootstraps
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
