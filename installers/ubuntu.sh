#!/bin/zsh
. "${DOTFILES_DIR}/installers/asdf.sh"
. "${DOTFILES_DIR}/installers/asdf_plugins.sh"

sudo add-apt-repository ppa:neovim-ppa/unstable

mkdir -p "$HOME/.config"

while read -r line; do
  npm install -g "$line"
done < package_lists/npm.txt

sudo apt-get update

while read -r line; do
    sudo apt-get install -yq "$line"
done < package_lists/ubuntu.txt

mkdir -p ~/.local/bin
ln -sf /usr/bin/batcat ~/.local/bin/bat
ln -sf "$(which fdfind)" ~/.local/bin/fd
mkdir -p $HOME/.config/jj
ln -sf "${DOTFILES_DIR}/jj/config.toml" $HOME/.config/jj/config.toml

source installers/pipx.sh
asdf::update
asdf::update_plugins

# Expand ${DOTFILES_DIR} now because it won't be available when this script is run
cat <<EOF > ~/.local/bin/update_asdf
#!/bin/zsh
. ${DOTFILES_DIR}/installers/asdf.sh

asdf::update
EOF
chmod a+x ~/.local/bin/update_asdf
