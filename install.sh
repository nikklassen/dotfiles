#!/bin/zsh

source common_install.sh

link_home vim

XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
[[ ! -f $XDG_CONFIG_HOME ]] && mkdir -p $XDG_CONFIG_HOME
symlink $PWD/vim $XDG_CONFIG_HOME/nvim

if [[ $(uname) == 'Darwin' ]]; then
    link_home macos
    source install_osx.sh
else
    source install_ubuntu.sh
fi

# If this is a login shell source the changes immediately
if [[ $- == *i* ]]; then
    source ~/.zshrc
fi
