#!/bin/bash

set -euo pipefail

function debug_echo() {
  test -v DEBUG && echo "→ $*" || return 0
}

function get_os_release_id() {
  grep -i '^ID=' /etc/os-release | cut -d= -f 2
}

function detect_os() {
  method="${1:-os-release}"
  debug_echo "using method ${method} to detect os"

  case $method in
    "os-release" ) get_os_release_id ;;
    * ) echo "unsupported detect method: ${method}" && exit 1 ;;
  esac
}

function detect_debian_version() {
  method="${1:-apt}"
  debug_echo "using method ${method} to detect debian version"

  case $method in
    "apt" ) apt policy | grep -i 'security/main.*amd64' | cut -d' ' -f 4 | cut -d- -f 1 ;;
    * ) echo "unsupported detect method: ${method}" && exit 1 ;;
  esac
}

function wrap_and_exit() {
  if "$@" ; then
    echo "yes"
    exit 0
  else
    echo "no"
    exit 1
  fi
}

function check_os() {
  local os="${1:-}"
  if detect_os "${2:-os-release}" | grep -qi "${os}" ; then
    return 0
  else
    return 1
  fi
}

if ! (return 0 2>/dev/null) ; then
  case "${1:-}" in
    "mint" ) wrap_and_exit check_os mint ;;
    "version" ) detect_debian_version "${2:-apt}" ;;
    "os" ) detect_os "${2:-os-release}" ;;
    * ) echo "usage: $0 mint|version" && exit 1 ;;
  esac
fi
