#!/bin/zsh

DOTFILES_DIR="$(dirname "$(readlink -f "$0")")"

source installers/common.sh

if [[ "$1" == "--server" ]]; then
  sources installers/server.sh
  exit 0
fi

link_home vim

XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
[[ ! -f $XDG_CONFIG_HOME ]] && mkdir -p $XDG_CONFIG_HOME
symlink $PWD/vim $XDG_CONFIG_HOME/nvim

if [[ $(uname) == 'Darwin' ]]; then
    link_home macos
    source installers/osx.sh
else
    source installers/ubuntu.sh
fi

# If this is a login shell source the changes immediately
if [[ $- == *i* ]]; then
    source ~/.zshrc
fi
