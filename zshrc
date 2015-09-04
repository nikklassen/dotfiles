. "$HOME/.zpath"

# Load and run compinit
autoload -U compinit
compinit -i -d "$HOME/.zcompdump"

autoload -U add-zsh-hook 
autoload -U zmv

multisrc() {
    for f in $@;
    do source $f
    done
}

return_code="%?"

# Souce other scripts
pushd "$HOME/.zsh" > /dev/null

multisrc omz.zsh syntax-highlighting/zsh-syntax-highlighting.zsh

if [[ $(uname) == 'Darwin' ]]; then
    . ./macos.zsh
else
    . ./ubuntu.zsh
fi

popd > /dev/null

function _backward_kill_default_word() {
  WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>' zle backward-kill-word
}
zle -N backward-kill-default-word _backward_kill_default_word
bindkey '\ew' backward-kill-default-word

alias lls="ls -lAh"
alias xgit="xcrun git"
alias mysql=/usr/local/mysql/bin/mysql
alias mysqladmin=/usr/local/mysql/bin/mysqladmin
alias rsync="rsync -h --progress"
alias ytaudio="youtube-dl -x --audio-format mp3"
alias stf="sudo tail -f"

alias gpnew='git push --set-upstream origin $(current_branch)'
alias -g NV='--no-verify'

alias plz='sudo $(fc -ln -1)' 

youtube-mp3 () {
    youtube-dl -x --audio-format mp3 $1
}

mkcd () {
    mkdir -p "$*"
    cd "$*"
}

gbc () {
    git branch $1 &&
    git checkout $1
}

gbd () {
    git branch -D $1 &&
    git push origin :$1
}

HISTFILE=$HOME/.zhistory
HISTSIZE=SAVEHIST=10000
setopt APPEND_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY
setopt AUTO_CD
setopt EXTENDED_GLOB

setopt correct
setopt correctall

# Nocorrect
alias sudo="nocorrect sudo"
alias gulp="nocorrect gulp"
alias make="nocorrect make"
alias cargo="nocorrect cargo"

setopt globdots
setopt extendedglob
setopt automenu
setopt autoparamslash

auto-ls-after-cd() {
    emulate -L zsh
    ls
}
add-zsh-hook chpwd auto-ls-after-cd
