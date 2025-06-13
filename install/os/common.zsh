#!/bin/zsh
import::source link
import::source custom_installers/wezterm

function install() {
  if [[ -z "$DOTFILES_DIR" ]]; then
    cat >&2 <<< 'DOTFILES_DIR must be set, consider running the main install script instead'
    exit 1
  fi

  CACHE="${XDG_CACHE_HOME:-$HOME/.cache}"

  FORCE=''
  if [[ $1 == '-f' ]]; then
      FORCE=-f
  fi

  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  fi

  if [[ ! -d "${CACHE?}/tmux-plugins/tpm" ]]; then
    git clone https://github.com/tmux-plugins/tpm "${CACHE?}/tmux-plugins/tpm"
  fi

  link::home zshrc
  link::home zshenv
  link::home zsh
  link::home zprofile
  link::home gitconfig
  link::symlink "tmux/tmux.conf" "${XDG_CONFIG_HOME?}/tmux/tmux.conf" 

  link::symlink --sudo "z/z.sh" "/usr/local/etc/profile.d/z.sh"
  link::symlink --sudo "z/z.1" "/usr/local/man/man1/z.1"

  link::symlink "powerline/themes/tmux/default.json" "${XDG_CONFIG_HOME?}/powerline/themes/tmux/default.json" 

  link::symlink "config/direnv/direnv.toml" "${XDG_CONFIG_HOME?}/direnv/direnv.toml"

  wezterm::install
}
