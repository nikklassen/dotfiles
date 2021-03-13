export PAGER=less
export LESS="-SR -# 0"
if command -v nvim >/dev/null 2>&1; then
    export EDITOR=nvim
else
    export EDITOR=vim
fi

# Node modules
PATH="./node_modules/.bin:$PATH"

# Cargo
[[ -f "$HOME/.cargo" ]] && PATH="$HOME/.cargo/bin:$PATH"

PATH="/usr/texbin:$PATH"

# Homebrew path
PATH="/usr/local/bin:/usr/local/sbin:$PATH"

# rvm
[[ -f "$HOME/.rvm" ]] && PATH="$PATH:$HOME/.rvm/bin"

# For security the local directory should be at the end
export PATH="$PATH:."

export PYTHONSTARTUP=~/.pystartup

[[ -z $XDG_CONFIG_HOME ]] && export XDG_CONFIG_HOME="$HOME/.config"

[[ -d "$HOME/.local/bin" ]] && export PATH="$PATH:$HOME/.local/bin"

[[ -d "/usr/local/go/bin" ]] && export PATH="$PATH:/usr/local/go/bin"

# Undocumented feature that stops zsh-syntax-highlight after a certain length
export ZSH_HIGHLIGHT_MAXLENGTH=100

export FZF_DEFAULT_COMMAND="fd --type f"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d"
export FZF_DEFAULT_OPTS="--keep-right"
export FZF_TMUX=0

[[ -f /usr/libexec/java_home/ ]] && export JAVA_HOME="$(/usr/libexec/java_home/)"

BOOT_EMIT_TARGET=no

if command -v rustc >/dev/null 2>&1; then
    export RUST_SRC_PATH=$(rustc --print sysroot)/lib/rustlib/src/rust/src/
fi

export NVIM_LISTEN_ADDRESS=/tmp/nvimsocket

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

[ -f ~/.zshenv.local ] && source ~/.zshenv.local
source "$HOME/.cargo/env"

export POWERLINE_CONFIG_COMMAND="$HOME/.local/bin/powerline-config"
