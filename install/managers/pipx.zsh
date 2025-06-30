#!/bin/zsh

(( _DOTFILES_INSTALL_MANAGERS_PIPX_SH++ != 0 )) && return

function pipx::install() {
  pkgs=(
    httpie
    install-release
    powerline-status
  )
  for pkg in $pkgs; do
    pipx install "$pkg"
  done

  pipx inject powerline-status --editable -r <(cat <<EOF
${DOTFILES_DIR?}/powerline_ext
requests
EOF
  )
}
