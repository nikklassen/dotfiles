# initialization completions
fpath=(/usr/local/share/zsh-completions $fpath)

if [[ ! -d ~/.oh-my-zsh ]]; then
  autoload -Uz compinit
  if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
    compinit
  else
    compinit -C
  fi
fi

autoload -U add-zsh-hook
autoload -U zmv

return_code="%?"

# Souce other scripts
pushd "$HOME/.zsh" > /dev/null

source omz.zsh

if [[ $(uname) == 'Darwin' ]]; then
    source ./macos.zsh
fi

source vcs.zsh

popd > /dev/null

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
  if [[ -f ~/.vim/vimrc.command-line ]]; then
    local VIMRC="~/.vim/vimrc.command-line"
  else
    local VIMRC="NONE"
  fi
  local EDITOR="$EDITOR -u $VIMRC"
  edit-command-line
}
zle -N vim-none-command-line
bindkey '^X^E' vim-none-command-line

bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line
bindkey '\e[1;3D' vi-backward-blank-word-end
bindkey '\e[1;3C' vi-forward-blank-word-end

alias rsync="rsync -h --progress"
alias pyg='pygmentize -f 256 -O style=monokai'
alias plz='sudo $(fc -ln -1)'
alias py-server="python3 -m http.server 3000"
alias python=python3
alias pip=pip3

alias cat="bat -p"
# undo oh-my-zsh
unalias rm cp \G
alias -g G="| rg"

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

alias -g NV='--no-verify'
alias -g LO='$(eval `fc -ln -1`)'

alias youtube-mp3='youtube-dl -x --audio-format mp3'
command -v wslview >/dev/null 2>&1 && alias v=wslview

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
# Installed by apt
if [[ -d /usr/share/doc/fzf ]]; then
  source /usr/share/doc/fzf/examples/key-bindings.zsh
  source /usr/share/doc/fzf/examples/completion.zsh
fi

[ -f ~/.zshrc.local ] && source ~/.zshrc.local

if [[ -x dircolors ]]; then
  if [[ -r ~/.dircolors ]]; then
    eval "$(dircolors -b ~/.dircolors)"
  else
    eval "$(dircolors -b)"
  fi
fi

zle -C complete-files complete-word _generic
bindkey '^X^F' complete-files
bindkey '^X?' _complete_debug
zstyle ':completion:*' accept-exact-dirs true

if command direnv > /dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

if command jj > /dev/null 2>&1; then
  source <(jj util completion zsh)
fi
