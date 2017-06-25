#!/bin/zsh

source common_install.sh

mkdir -p $HOME/.vim/
sudo curl https://raw.githubusercontent.com/tpope/vim-sensible/master/plugin/sensible.vim -o $HOME/.vim/vimrc
