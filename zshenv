export PAGER=less
export LESS="-SR -# 0"
if [[ -z $(which nvim 2> /dev/null) ]]; then
    export EDITOR=vim
else
    export EDITOR=nvim
fi

# Node modules
PATH="./node_modules/.bin:$PATH"

# Cargo
PATH="$HOME/.cargo/bin:$PATH"

# Homebrew path
PATH="/usr/local/bin:/usr/local/sbin:$PATH"

PATH="$PATH:$HOME/Library/Haskell/bin:$HOME/.cabal/bin:$HOME/.pandoc/bin"

PATH="/usr/texbin:$PATH"

# Homebrew path
PATH="/usr/local/bin:/usr/local/sbin:$PATH"

# rvm
export PATH="$PATH:$HOME/.rvm/bin"

# For security the local directory should be at the end
export PATH="$PATH:."

PYTHONPATH="$PYTHONPATH:~/Programming/Python"
PYTHONSTARTUP=~/.pystartup

[[ -z $XDG_CONFIG_HOME ]] && export XDG_CONFIG_HOME="$HOME/.config"

# Undocumented feature that stops zsh-syntax-highlight after a certain length
ZSH_HIGHLIGHT_MAXLENGTH=100

export FZF_DEFAULT_COMMAND='ag -g ""'
export FZF_TMUX=0

[[ -f /usr/libexec/java_home/ ]] && export JAVA_HOME="$(/usr/libexec/java_home/)"

BOOT_EMIT_TARGET=no

if [[ $(which rustc > /dev/null 2>&1) == 0 ]]; then
    export RUST_SRC_PATH=$(rustc --print sysroot)/lib/rustlib/src/rust/src/
fi

export NVIM_LISTEN_ADDRESS=/tmp/nvimsocket

[ -f ~/.zshenv.local ] && source ~/.zshenv.local
