autoload -U promptinit compinit
compinit -u

promptinit
prompt suse

eval "$(rbenv init -)"

alias ls="ls -FG"
alias xgit="xcrun git"
alias mysql=/usr/local/mysql/bin/mysql
alias mysqladmin=/usr/local/mysql/bin/mysqladmin

# Git
alias gst="git status"
alias gdiff="git diff --cached"

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
alias sudo="nocorrect sudo"

setopt globdots
setopt automenu
setopt autoparamslash
setopt completealiases

autoload up-line-or-beginning-search
autoload down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "\e[A" up-line-or-beginning-search
bindkey "\e[B" down-line-or-beginning-search
bindkey "\e[1~" beginning-of-line # ⌘ <-
bindkey "\e[4~" end-of-line # ⌘ ->
bindkey "\e[3~" delete-char # fn delete

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

function proxy_toggle() {
    proxy_info="$(sudo networksetup -getsocksfirewallproxy Wi-Fi)"

    if [[ $proxy_info =~ "Enabled: No" ]]; then
        echo "Turning on"
        sudo networksetup -setsocksfirewallproxystate Wi-Fi on
    else
        echo "Turning off"
        sudo networksetup -setsocksfirewallproxystate Wi-Fi off
    fi
}

osascript ~/dotfiles/scripts/itermcolours.applescript 2> /dev/null
