#!/bin/zsh

which -s brew 2>&1 > /dev/null
if [[ $? == 1 ]]; then
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi
brew update
while read -r line; do
    brew install "$line"
done < osx_packages.txt
while read -r line; do
    brew install --cask "$line"
done < osx_casks.txt

which -s nvim 2>&1 > /dev/null
if [[ $? == 1 ]]; then
    brew install neovim
    mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
    sudo pip3 install neovim
fi

ITERM_DIR=$HOME/.iterm
if [[ ! -d $ITERM_DIR ]]; then
    mkdir $ITERM_DIR
    ln -s $PWD/iterm.plist $ITERM_DIR/com.googlecode.iterm2.plist
fi
