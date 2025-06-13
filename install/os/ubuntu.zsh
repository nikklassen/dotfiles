#!/bin/zsh
import::source custom_installers/docker
import::source custom_installers/lua-language-server
import::source custom_installers/wezterm_terminfo
import::source custom_installers/wsl
import::source managers/apt
import::source managers/asdf
import::source managers/github
import::source managers/go
import::source managers/npm
import::source managers/pipx

function install() {
  sudo add-apt-repository ppa:neovim-ppa/unstable
  sudo apt-get update

  mkdir -p "$HOME/.config"
  mkdir -p "$HOME/.local/bin"

  apt::install

  pipx::install
  github::install

  # Normally asdf is configured by oh-my-zsh, but we need to ensure it is set up before installing plugins.
  path=("$HOME/.asdf/shims" $path)
  export ASDF_CRATE_DEFAULT_PACKAGES_FILE="${DOTFILES_DIR}/package_lists/cargo.txt"
  asdf::install

  go::install
  npm::install

  ln -sf /usr/bin/batcat ~/.local/bin/bat
  ln -sf "$(which fdfind)" ~/.local/bin/fd
  mkdir -p $HOME/.config/jj
  ln -sf "${DOTFILES_DIR}/jj/config.toml" $HOME/.config/jj/config.toml

  lua-language-server::install

  if [[ "$(uname -r)" == *"WSL"* ]]; then
    wsl::install
  fi

  docker::install
  wezterm_terminfo::install
}
