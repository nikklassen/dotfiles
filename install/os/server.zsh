#!/bin/zsh

(( _DOTFILES_INSTALL_OS_SERVER_SH++ != 0 )) && return

function server::install() {
  mkdir -p $HOME/.vim/
  sudo curl https://raw.githubusercontent.com/tpope/vim-sensible/master/plugin/sensible.vim -o $HOME/.vim/vimrc
}
