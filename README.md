# bootstraps

A home for all my linux bootstrapping scripts, somewhat mirrors the contents of my Docker repo.

## Use thusly

### Repo via https

```bash
sudo apt update && \
  sudo apt install -y git && \
  git clone https://github.com/tmck-code/bootstraps.git && \
  cd bootstraps
```

### Repo via ssh

```bash
sudo apt update && \
  sudo apt install -y git && \
  git clone git@github.com:tmck-code/bootstraps.git && \
  cd bootstraps
```
 
 ### Run bootstraps
 
```bash
./ubuntu/bootstrap.sh \
  && ./langs/ruby.sh \
  && ./langs/python.sh \
  && ./langs/go.sh
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
