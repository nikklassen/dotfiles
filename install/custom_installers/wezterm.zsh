#!/bin/zsh

(( _DOTFILES_INSTALL_CUSTOM_INSTALLERS_WEZTERM_SH != 0 )) && return

function wezterm::install() {
  tempfile=$(mktemp)
  curl -o $tempfile https://raw.githubusercontent.com/wezterm/wezterm/main/termwiz/data/wezterm.terminfo
  tic -x -o ~/.terminfo $tempfile
  rm $tempfile
}
