#!/bin/zsh
import::source managers/github

function install() {
  mkdir /tmp/lua-language-server
  pushd /tmp/lua-language-server
  local repo="https://github.com/LuaLS/lua-language-server"
  local tag="$(github::latest_tag "${repo}")"
  curl "${repo}/releases/download/${tag}/lua-language-server-${tag}-linux-x64.tar.gz" | tar -x
  mv /tmp/lua-language-server ~/.local/bin/
  popd
}
