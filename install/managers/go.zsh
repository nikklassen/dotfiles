#!/bin/zsh

(( _DOTFILES_INSTALL_MANAGERS_GO_SH++ != 0 )) && return

function go::install() {
  pkgs=(
    "golang.org/x/tools/gopls"
    "github.com/sqls-server/sqls"
    "github.com/go-task/task/v3/cmd/task"
  )
  for pkg in $pkgs; do
    go install "${pkg}@latest"
  done

  asdf reshim
}
