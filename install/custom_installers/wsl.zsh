#!/bin/zsh

(( _DOTFILES_INSTALL_CUSTOM_INSTALLERS_WSL_SH++ != 0 )) && return

function wsl::install() {
  sudo add-apt-repository ppa:wslutilities/wslu
  sudo apt update
  sudo apt upgrade
}
