#!/bin/zsh

function install() {
  pkgs=(
    @anthropic-ai/claude-code
    bash-language-server
    typescript-language-server
    vscode-langservers-extracted
  )
  npm install -g "${pkgs[@]}"
}
