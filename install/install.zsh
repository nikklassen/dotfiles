#!/bin/zsh

if ! command chezmoi > /dev/null 2>&1; then
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/.local/bin
fi
chezmoi init --apply --source "${PWD?}" nikklassen
