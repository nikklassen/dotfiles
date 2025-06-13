#!/bin/zsh

function install() {
  pkgs=(
    vscode-langservers-extracted
    bash-language-server
    @anthropic-ai/claude-code
  )
  for pkg in $pkgs; do
    npm install -g "$pkg"
  done
}
