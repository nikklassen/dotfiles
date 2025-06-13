#!/bin/zsh
import::source link
import::source managers/asdf

function install() {
  link::home macos

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

  ITERM_DIR=$HOME/.iterm
  if [[ ! -d $ITERM_DIR ]]; then
      mkdir $ITERM_DIR
      ln -s $PWD/iterm.plist $ITERM_DIR/com.googlecode.iterm2.plist
  fi

  asdf::update_plugins

  while read -r line; do
    npm install -g "$line"
  done < "${DOTFILES_DIR}/install/package_lists/npm.txt"
}
