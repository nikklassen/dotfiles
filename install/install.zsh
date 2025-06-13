#!/bin/zsh

DOTFILES_DIR="${${(%):-%x}:h}/.."

source "${DOTFILES_DIR}/zsh/import.zsh"
import::init

import::source link
import::source os/common
import::source os/osx
import::source os/server
import::source os/ubuntu

common::install

if [[ "$1" == "--server" ]]; then
  server::install
  exit 0
fi

XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
[[ ! -f $XDG_CONFIG_HOME ]] && mkdir -p $XDG_CONFIG_HOME
common::symlink $PWD/vim $XDG_CONFIG_HOME/nvim

if [[ $(uname) == 'Darwin' ]]; then
  osx::install
else
  ubuntu::install
fi

# If this is a login shell source the changes immediately
if [[ $- == *i* ]]; then
    . ~/.zshrc
fi
