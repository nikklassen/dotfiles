#!/bin/zsh

(( _DOTFILES_INSTALL_LINK_SH++ != 0 )) && return

function link::symlink() {
  local admin=''
  if [[ "$1" == "--sudo" ]]; then
    admin='sudo'
    shift
  fi
  local from="${DOTFILES_DIR?}/$1"
  local to="$2"
  if [[ "$(readlink "$to")" == "$(realpath "$from")" ]]; then
    return
  fi
  if [[ -z "$FORCE" && -L "$to" ]]; then
    echo "Cannot link $to exists, but refers to $(readlink "$to")"
    return
  elif [[ -z "$FORCE" && -f "$to" ]]; then
    echo "Cannot link $to because it already exists"
    return
  fi
  local dir="$(dirname "$to")"
  if [[ ! -d "$dir" ]]; then
    sudo mkdir -p "$dir"
  fi
  sudo ln -s $FORCE "$from" "$to"
}

function link::home() {
  if [[ ! -L $HOME/.$1 || -n $FORCE ]]; then
    symlink $1 $HOME/.$1
  fi
}
