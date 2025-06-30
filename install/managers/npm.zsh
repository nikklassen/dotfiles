#!/bin/zsh

(( _DOTFILES_INSTALL_MANAGERS_NPM_SH++ != 0 )) && return

function npm::install() {
  pkgs=(
    @anthropic-ai/claude-code
    bash-language-server
    typescript-language-server
    vim-language-server
    vscode-langservers-extracted
  )
  npm install -g "${pkgs[@]}"
}
