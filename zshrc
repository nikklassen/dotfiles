autoload -U promptinit compinit
compinit -u

promptinit
prompt suse

EDITOR=/opt/local/bin/vim

# Setting PATH for Python 2.7
PATH="${PATH}:/Library/Frameworks/Python.framework/Versions/2.7/bin"

# Setup rbenv
PATH="$HOME/.rbenv/bin:$PATH"

# Node modules
PATH="$PATH:$HOME/node_modules/.bin"

eval "$(rbenv init -)"

# MacPorts Installer addition on 2012-11-19_at_19:38:15: adding an appropriate PATH variable for use with MacPorts.
PATH="/opt/local/bin:/opt/local/sbin:$PATH"

PATH="$PATH:$HOME/Library/Haskell/bin:$HOME/.cabal/bin"

alias ls="ls -FG"
alias xgit="xcrun git"

export CLASSPATH="$HOME/Programming/Java/classes/"

HISTFILE=$HOME/.zhistory
HISTSIZE=SAVEHIST=10000
setopt APPEND_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY

setopt correct
setopt correctall
setopt globdots
setopt automenu
setopt autoparamslash
setopt completealiases
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search 

autoload -U edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

trash () {
    if [ -f $1 ]
    then
        mv $1 ~/.Trash
    else
        mv -r $1 ~/.Trash
    fi
}

function auto-ls-after-cd() {
    emulate -L zsh
    ls
}
add-zsh-hook chpwd auto-ls-after-cd
