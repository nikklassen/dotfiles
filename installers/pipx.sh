#!/bin/zsh

DOTFILES_DIR="$(dirname "$(readlink -f "$0")")"

while read -r line; do
  pipx install "$line"
done < package_lists/pipx.txt

pipx inject powerline-status "${DOTFILES_DIR}/powerline_ext"
