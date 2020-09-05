#!/bin/zsh

FORCE=''
if [[ $1 == '-f' ]]; then
    FORCE=-f
fi

symlink() {
    ln -s $FORCE $@
}
export symlink

git submodule update --recursive --init

# Setup oh-my-zsh
OMZ_MODULE=.git/modules/zsh/oh-my-zsh-sparse
symlink $PWD/.omz.sparse-checkout $OMZ_MODULE/info/sparse-checkout
git config -f $OMZ_MODULE/config core.sparsecheckout true

# Clean up each subdirectory's working tree to only use the sparse checkout
git submodule foreach 'git read-tree -m -u HEAD'

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
