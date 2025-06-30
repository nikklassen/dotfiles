#!/bin/zsh

DOTFILES_DIR="${${(%):-%x}:h}/.."

source ${DOTFILES_DIR}/install/link.zsh
source ${DOTFILES_DIR}/install/os/common.zsh
source ${DOTFILES_DIR}/install/os/osx.zsh
source ${DOTFILES_DIR}/install/os/server.zsh
source ${DOTFILES_DIR}/install/os/ubuntu.zsh

if [[ "$1" == "--server" ]]; then
  server::install
  exit 0
fi

XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
[[ ! -f $XDG_CONFIG_HOME ]] && mkdir -p $XDG_CONFIG_HOME
link::symlink $PWD/vim $XDG_CONFIG_HOME/nvim

if [[ $(uname) == 'Darwin' ]]; then
  osx::install
else
  ubuntu::install
fi

# If this is a login shell source the changes immediately
if [[ $- == *i* ]]; then
    . ~/.zshrc
fi
