#!/bin/zsh

(( _DOTFILES_INSTALL_OS_OSX_SH++ != 0 )) && return

source ${DOTFILES_DIR}/install/link.zsh
source ${DOTFILES_DIR}/install/managers/asdf.zsh

function osx::install() {
  which -s brew 2>&1 > /dev/null
  if [[ $? == 1 ]]; then
      bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
      export PATH="/opt/homebrew/bin:$PATH"
  fi
  brew update
  while read -r line; do
      brew install "$line"
  done < "${DOTFILES_DIR}/install/package_lists/brew.txt"
  while read -r line; do
      brew install --cask "$line"
  done < "${DOTFILES_DIR}/install/package_lists/brew_casks.txt"

  which -s nvim 2>&1 > /dev/null
  if [[ $? == 1 ]]; then
      brew install neovim
      mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
      sudo pip3 install neovim
  fi

  # Normally asdf is configured by oh-my-zsh, but we need to ensure it is set up before installing plugins.
  path=("$HOME/.asdf/shims" $path)
  asdf::install

  go::install
}
