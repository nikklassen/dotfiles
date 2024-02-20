#!/bin/zsh

FORCE=''
if [[ $1 == '-f' ]]; then
    FORCE=-f
fi

symlink() {
    ln -s $FORCE $@
}
export symlink

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

git clone https://github.com/tmux-plugins/tpm ~/.tmux-plugins/tpm

link_home() {
    if [[ ! -L $HOME/.$1 || -n $FORCE ]]; then
        symlink $PWD/$1 $HOME/.$1
    fi
}

link_home zshrc
link_home zshenv
link_home zsh
link_home tmux.conf
link_home tmux
link_home gitconfig

sudo mkdir -p /usr/local/etc/profile.d/
sudo ln -s $FORCE $PWD/z/z.sh /usr/local/etc/profile.d/z.sh
sudo mkdir -p /usr/local/man/man1/
sudo ln -s $FORCE $PWD/z/z.1 /usr/local/man/man1/z.1

mkdir -p ~/.config/powerline/themes/tmux
symlink $PWD/powerline/themes/tmux/default.json ~/.config/powerline/themes/tmux/default.json

symlink $PWD/scripts/node-lazy ~/.local/bin/node-lazy

source zsh/wezterm.zsh
