#!/bin/zsh

(( _DOTFILES_INSTALL_CUSTOM_INSTALLERS_LUA_LANGUAGE_SERVER_SH++ != 0 )) && return

source ${DOTFILES_DIR}/install/managers/github.zsh

function lua-language-server::install() {
  local install_dir="${HOME}/.local/share/lua-language-server"
  mkdir -p "${install_dir?}"
  rm -rf "${install_dir?}/*"
  local repo="https://github.com/LuaLS/lua-language-server"
  local tag
  tag="$(github::latest_tag "${repo}")" || return 1
  curl -L "${repo}/releases/download/${tag}/lua-language-server-${tag}-linux-x64.tar.gz" | \
    tar -xz -C "${install_dir?}" \
    || return 1
}
