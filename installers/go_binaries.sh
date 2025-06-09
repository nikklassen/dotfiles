#!/bin/zsh

function go_binaries::install() {
  for pkg in $(
    "golang.org/x/tools/gopls"
    "github.com/sqls-server/sqls"
  ); do
    go install "${pkg}@latest"
  done

  curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/HEAD/install.sh | sh -s -- -b $(go env GOPATH)/bin
}
