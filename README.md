# bootstraps

A home for all my linux bootstrapping scripts, somewhat mirrors the contents of my Docker repo.

## Use thusly

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
