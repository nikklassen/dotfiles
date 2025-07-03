#!/bin/zsh

(( _DOTFILES_INSTALL_OS_COMMON_SH++ != 0 )) && return

function common::install() {
  if [[ -z "$DOTFILES_DIR" ]]; then
    cat >&2 <<< 'DOTFILES_DIR must be set, consider running the main install script instead'
    exit 1
  fi

  if ! command chezmoi > /dev/null 2>&1; then
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/.local/bin
  fi
  chezmoi init --apply --source "${DOTFILES_DIR?}" nikklassen

  CACHE="${XDG_CACHE_HOME:-$HOME/.cache}"

  FORCE=''
  if [[ $1 == '-f' ]]; then
      FORCE=-f
  fi
}
