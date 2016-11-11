# initialization completions
fpath=(/usr/local/share/zsh-completions $fpath)

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

# Poop emoji, gets overwritten if it's in zshenv
export ZSH_THEME_GIT_PROMPT_DIRTY="\xF0\x9F\x92\xA9 "

function _backward_kill_default_word() {
  WORDCHARS="*?_-.[]~=&;!#$%^(){}<>/" zle backward-kill-word
}
zle -N backward-kill-default-word _backward_kill_default_word
bindkey '\ew' backward-kill-default-word

bindkey '^U' backward-kill-line

vim-none-command-line () {
  local EDITOR="$EDITOR -u NONE"
  edit-command-line
}
zle -N vim-none-command-line
bindkey '^X^E' vim-none-command-line

alias lls="ls -lAh"
alias rsync="rsync -h --progress"
alias ytaudio="youtube-dl -x --audio-format mp3"
alias stf="sudo tail -f"
alias pyg='pygmentize -f 256 -O style=monokai'
alias rc='$EDITOR $HOME/.zshrc'
alias plz='sudo $(fc -ln -1)'

alias gdl='git clone --depth 1'
alias gpnew='git push --set-upstream origin $(current_branch)'

alias -g NV='--no-verify'
alias -g LO='$(eval `fc -ln -1`)'
alias -g NE='2> /dev/null'
alias -g NUL='> /dev/null 2>&1'

youtube-mp3 () {
    youtube-dl -x --audio-format mp3 $1
}

mkcd () {
    mkdir -p "$*"
    cd "$*"
}

gbc () {
    git branch $1 && git checkout $1
}

gbd () {
    git branch -D $1 && git push origin :$1
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

setopt globdots
setopt extendedglob
setopt automenu
setopt autoparamslash

auto-ls-after-cd() {
    emulate -L zsh
    ls
}
add-zsh-hook chpwd auto-ls-after-cd

function virtualenv_info(){
    if [[ -n "$VIRTUAL_ENV" ]]; then
        venv=$(basename ${VIRTUAL_ENV##*/})
    else
        venv=''
    fi
    [[ -n "$venv" ]] && echo "($venv) "
}

export VIRTUAL_ENV_DISABLE_PROMPT=1

local VENV="\$(virtualenv_info)";
PS1="${VENV}$PS1"

# Load z
[[ -e /usr/local/etc/profile.d/z.sh ]] && . /usr/local/etc/profile.d/z.sh

# Load nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

[ -f ~/.zshrc.local ] && source ~/.zshrc.local
