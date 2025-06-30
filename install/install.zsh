#!/bin/zsh

DOTFILES_DIR="${${(%):-%x}:h}/.."

source ${DOTFILES_DIR}/install/os/common.zsh
source ${DOTFILES_DIR}/install/os/osx.zsh
source ${DOTFILES_DIR}/install/os/server.zsh
source ${DOTFILES_DIR}/install/os/ubuntu.zsh

if [[ "$1" == "--server" ]]; then
  server::install
  exit 0
fi

if [[ $(uname) == 'Darwin' ]]; then
  osx::install
else
  ubuntu::install
fi

# If this is a login shell source the changes immediately
if [[ $- == *i* ]]; then
    . ~/.zshrc
fi
