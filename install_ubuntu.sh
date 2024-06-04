#!/bin/zsh

DOTFILES_DIR="$(dirname "$(readlink -f "$0")")"

sudo add-apt-repository ppa:neovim-ppa/unstable

mkdir -p "$HOME/.config"

while read -r line; do
  npm install -g "$line"
done < npm_packages.txt

sudo apt-get update

while read -r line; do
    sudo apt-get install -yq "$line"
done < ubuntu_packages.txt

mkdir -p ~/.local/bin
ln -sf /usr/bin/batcat ~/.local/bin/bat
ln -sf "$(which fdfind)" ~/.local/bin/fd
mkdir -p $HOME/.config/jj
ln -sf "${DOTFILES_DIR}/jj/config.toml" $HOME/.config/jj/config.toml
