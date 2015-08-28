#!/bin/zsh
git submodule init

# Setup oh-my-zsh
OMZ_MODULE=.git/modules/zsh/oh-my-zsh-sparse
ln -s $PWD/.omz.sparse-checkout $OMZ_MODULE/info/sparse-checkout
git config -f $OMZ_MODULE/config core.sparsecheckout true

git submodule update --recursive

link_home() {
    if [ ! -L $HOME/.$1 ]; then
        ln -s $1 $HOME/.$1
    fi
}

link_home zpath
link_home zshrc
link_home zshenv
link_home zsh
link_home vim
link_home osx
link_home irbrc

ln -s scripts/vim_diffconflicts /usr/local/bin/diffconflicts
git config --global merge.tool diffconflicts
git config --global mergetool.diffconflicts.cmd 'diffconflicts vim $BASE $LOCAL $REMOTE $MERGED'
git config --global mergetool.diffconflictstrustExitCode true
git config --global mergetool.keepBackup false

source ~/.zshrc
