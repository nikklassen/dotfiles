#!/bin/zsh

(( _DOTFILES_INSTALL_OS_UBUNTU_SH++ != 0 )) && return

source ${DOTFILES_DIR}/install/custom_installers/lua-language-server.zsh
source ${DOTFILES_DIR}/install/custom_installers/wsl.zsh
source ${DOTFILES_DIR}/install/managers/apt.zsh
source ${DOTFILES_DIR}/install/managers/asdf.zsh
source ${DOTFILES_DIR}/install/managers/github.zsh
source ${DOTFILES_DIR}/install/managers/go.zsh

function ubuntu::install() {
  sudo add-apt-repository ppa:neovim-ppa/unstable
  sudo apt-get update

  mkdir -p "$HOME/.config"
  mkdir -p "$HOME/.local/bin"

  apt::install

  github::install

  # Normally asdf is configured by oh-my-zsh, but we need to ensure it is set up before installing plugins.
  path=("$HOME/.asdf/shims" $path)
  asdf::install

  go::install

  ln -sf /usr/bin/batcat ~/.local/bin/bat
  ln -sf "$(which fdfind)" ~/.local/bin/fd

  lua-language-server::install

  if [[ "$(uname -r)" == *"WSL"* ]]; then
    wsl::install
  fi
}
