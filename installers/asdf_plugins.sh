#!/bin/zsh
function asdf::update_plugins() {
  local existing_plugins=($(asdf plugin list))

  typeset -A plugins=(
    ["nodejs"]="https://github.com/asdf-vm/asdf-nodejs.git"
    ["golang"]="https://github.com/asdf-community/asdf-golang.git"
    ["rust"]="https://github.com/asdf-community/asdf-rust.git"
  )
  for plugin url in "${(@kv)plugins}"; do
    if [[ ${existing_plugins[(ie)${plugin}]} > ${#existing_plugins} ]]; then
      asdf plugin add "$plugin" "$url"
      asdf install "$plugin" latest
      asdf set -u "$plugin" latest
    fi
  done
}
