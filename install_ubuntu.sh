#!/bin/zsh

sudo add-apt-repository ppa:neovim-ppa/unstable

mkdir -p "$HOME/.config"
export NVM_DIR="$HOME/.config/nvm" && (
  git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
  cd "$NVM_DIR"
  git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
) && \. "$NVM_DIR/nvm.sh"
nvm install node

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
