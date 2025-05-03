#!/bin/zsh

if [[ -z "$DOTFILES_DIR" ]]; then
  cat >&2 <<< 'DOTFILES_DIR must be set, consider running the main install script instead'
  exit 1
fi

CACHE="${XDG_CACHE_HOME:-$HOME/.cache}"

FORCE=''
if [[ $1 == '-f' ]]; then
    FORCE=-f
fi

symlink() {
    local admin=''
    if [[ "$1" == "--sudo" ]]; then
      admin='sudo'
      shift
    fi
    local from="${DOTFILES_DIR?}/$1"
    local to="$2"
    if [[ "$(readlink "$to")" == "$(realpath "$from")" ]]; then
      return
    fi
    if [[ -z "$FORCE" && -L "$to" ]]; then
      echo "Cannot link $to exists, but refers to $(readlink "$to")"
      return
    elif [[ -z "$FORCE" && -f "$to" ]]; then
      echo "Cannot link $to because it already exists"
      return
    fi
    local dir="$(dirname "$to")"
    if [[ ! -d "$dir" ]]; then
      sudo mkdir -p "$dir"
    fi
    sudo ln -s $FORCE "$from" "$to"
}
export symlink

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

if [[ ! -d "${CACHE?}/tmux-plugins/tpm" ]]; then
  git clone https://github.com/tmux-plugins/tpm "${CACHE?}/tmux-plugins/tpm"
fi

link_home() {
    if [[ ! -L $HOME/.$1 || -n $FORCE ]]; then
        symlink $1 $HOME/.$1
    fi
}

link_home zshrc
link_home zshenv
link_home zsh
link_home zprofile
link_home gitconfig
symlink "tmux/tmux.conf" "${XDG_CONFIG_HOME?}/tmux/tmux.conf" 

symlink --sudo "z/z.sh" "/usr/local/etc/profile.d/z.sh"
symlink --sudo "z/z.1" "/usr/local/man/man1/z.1"

symlink "powerline/themes/tmux/default.json" "${XDG_CONFIG_HOME?}/powerline/themes/tmux/default.json" 

"${DOTFILES_DIR?}/update_asdf.sh"

existing_plugins=($(asdf plugin list))

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

symlink "config/direnv/direnv.toml" "${XDG_CONFIG_HOME?}/direnv/direnv.toml"

source zsh/wezterm.zsh
