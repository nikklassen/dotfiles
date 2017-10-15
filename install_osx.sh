#!/bin/zsh

which -s brew 2>&1 > /dev/null
if [[ $? == 1 ]]; then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi
brew update
while read -r line; do
    brew install "$line"
done < mac_packages.txt

which -s nvim 2>&1 > /dev/null
if [[ $? == 1 ]]; then
    brew install neovim/neovim/neovim
    mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
    ln -s ~/.vim $XDG_CONFIG_HOME/nvim
    sudo pip3 install neovim
fi

ITERM_DIR=$HOME/.iterm
if [[ ! -d $ITERM_DIR ]]; then
    mkdir $ITERM_DIR
    ln -s $PWD/iterm.plist $ITERM_DIR/com.googlecode.iterm2.plist
fi
