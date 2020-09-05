# initialization completions
fpath=(/usr/local/share/zsh-completions $fpath)

# Load and run compinit
autoload -U compinit
compinit -C -d "$HOME/.zcompdump"

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
    source ./macos.zsh
else
    source ./ubuntu.zsh
fi

popd > /dev/null

if [[ PROMPT_SIMPLE ]]; then
    export ZSH_THEME_GIT_PROMPT_DIRTY="%{[31m%}X%{[00m%}"
else
    # Poop emoji, gets overwritten if it's in zshenv
    export ZSH_THEME_GIT_PROMPT_DIRTY="\xF0\x9F\x92\xA9 "
fi

OMITTED_WORDCHARS="/="
function _backward_kill_default_word() {
  WORDCHARS="$WORDCHARS$OMITTED_WORDCHARS" zle backward-kill-word
}
zle -N backward-kill-default-word _backward_kill_default_word
bindkey '\ew' backward-kill-default-word
function _kill_default_word() {
  WORDCHARS="$WORDCHARS$OMITTED_WORDCHARS" zle kill-word
}
zle -N kill-default-word _kill_default_word
bindkey '\ed' kill-default-word

bindkey '^U' backward-kill-line

vim-none-command-line () {
  local EDITOR="$EDITOR -u NONE"
  edit-command-line
}
zle -N vim-none-command-line
bindkey '^X^E' vim-none-command-line

bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line

alias lls="ls -lAh"
alias rsync="rsync -h --progress"
alias stf="sudo tail -f"
alias pyg='pygmentize -f 256 -O style=monokai'
alias rc='$EDITOR $HOME/.zshrc'
alias plz='sudo $(fc -ln -1)'
# 256 color
alias tmux='tmux -2'
alias ta='tmux attach'

alias dc='docker-compose'
alias dcu='docker-compose up -d'
alias dcd='docker-compose down'
alias dclg='docker-compose logs -f'
alias dctf='docker-compose logs -f --tail="100"'
alias dcr='docker-compose restart'
alias dcru='docker-compose run'
alias dcri='docker-compose run --rm -it'
alias d='docker'
alias dri='docker run --rm -it'

function docker-upload () {
    local repo="$1"
    local last_image=$(docker images --format '{{ .Repository }}:{{ .Tag }}' | head -1)
    echo "Uploading $last_image"
    docker tag "$last_image" "$repo/$last_image"
    docker push "$repo/$last_image"
}

alias dup="docker-upload"

function dccs() {
    docker-compose create "$1" && \
        docker-compose start "$1"
}

command -v nvim >/dev/null 2>&1 && alias vim=nvim && alias vi=nvim

alias gdl='git clone --depth 1'

alias -g NV='--no-verify'
alias -g LO='$(eval `fc -ln -1`)'
alias -g NE='2> /dev/null'
alias -g NUL='> /dev/null 2>&1'

alias youtube-mp3='youtube-dl -x --audio-format mp3'

mkcd () {
    mkdir -p "$*"
    cd "$*"
}

function gbc () {
    git branch $1 && git checkout $1
}

function gbdd () {
    git branch -D $1
    git push origin :$1 --no-verify
}

function grc () {
    git reset HEAD $1 > /dev/null && git checkout $1
}

function gpnew() {
    git push --set-upstream origin "$(git rev-parse --abbrev-ref HEAD)"
}

function testport () {
    nc -v "$1" "$2" < /dev/null
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

# setopt correct

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
    if [[ -z "$VIRTUAL_ENV" ]]; then
        return
    fi
    echo "($(basename ${VIRTUAL_ENV##*/})) "
}

export VIRTUAL_ENV_DISABLE_PROMPT=1

local VENV="\$(virtualenv_info)";
PS1="${VENV}$PS1"

# Exclude slashes from the default definition of WORDCHARS omz sets this to
# empty, so we can't just remove the one character. Also omits = for flags.
export WORDCHARS='*?_-.[]~&;!#$%^(){}<>'

# Load z
[ -f /usr/local/bin/z.sh ] && source /usr/local/bin/z.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

[ -f ~/.zshrc.local ] && source ~/.zshrc.local

test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
