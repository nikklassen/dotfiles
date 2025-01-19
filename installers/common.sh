#!/bin/zsh

FORCE=''
if [[ $1 == '-f' ]]; then
    FORCE=-f
fi

symlink() {
    ln -s $FORCE $@
}
export symlink

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

if [[ ! -d "${XDG_CACHE_HOME?}/tmux-plugins/tpm" ]]; then
  git clone https://github.com/tmux-plugins/tpm "${XDG_CACHE_HOME?}/tmux-plugins/tpm"
fi

link_home() {
    if [[ ! -L $HOME/.$1 || -n $FORCE ]]; then
        symlink $PWD/$1 $HOME/.$1
    fi
}

link_home zshrc
link_home zshenv
link_home zsh
link_home gitconfig
symlink "${XDG_CONFIG_HOME}/tmux/tmux.conf" tmux/tmux.conf

sudo mkdir -p /usr/local/etc/profile.d/
sudo ln -s $FORCE $PWD/z/z.sh /usr/local/etc/profile.d/z.sh
sudo mkdir -p /usr/local/man/man1/
sudo ln -s $FORCE $PWD/z/z.1 /usr/local/man/man1/z.1

mkdir -p "${XDG_CONFIG_HOME?}/powerline/themes/tmux"
symlink "${DOTFILES_DIR?}/powerline/themes/tmux/default.json" "${XDG_CONFIG_HOME?}/powerline/themes/tmux/default.json"

"${DOTFILES_DIR?}/update_asdf.sh"

typeset -A plugins=(
  ["nodejs"]="https://github.com/asdf-vm/asdf-nodejs.git"
  ["golang"]="https://github.com/asdf-community/asdf-golang.git"
  ["rust"]="https://github.com/asdf-community/asdf-rust.git"
)
for plugin url in "${(@kv)plugins}"; do
  asdf plugin add "$plugin" "$url"
  asdf install "$plugin" latest
  asdf global "$plugin" latest
done

mkdir -p ~/.config/direnv
ln -s $PWD/config/direnv/direnv.toml ~/.config/direnv/direnv.toml

source zsh/wezterm.zsh
