#!/bin/zsh

(( _DOTFILES_INSTALL_MANAGERS_APT_SH++ != 0 )) && return

function apt::install() {
  pkgs=(
    bat
    build-essential
    clang
    cmake
    curl
    direnv
    fd-find
    fzf
    git
    htop
    jq
    neovim
    pipx
    python3-dev
    python3-pip
    python3-neovim
    ripgrep
    terminator
    tmux
    tree
    fd-find
  )
  for pkg in $pkgs; do
    sudo apt-get install -yq "$pkg"
  done

  if [[ $INSTALL_UBUNTU_DESKTOP == 1 ]]; then
    desktop_pkgs=(
      compizconfig-settings-manager
      fonts-inconsolata
      gnome-tweak-tool
    )
    for pkg in $desktop_pkgs; do
      sudo apt-get install -yq "$pkg"
    done
  fi
}
