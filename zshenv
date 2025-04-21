# If we're in TMUX all this is already in the path
if [[ -n $TMUX ]]; then
	return
fi

export PAGER=less
export LESS="-FXSR -# 0"

# Node modules
PATH="./node_modules/.bin:$PATH"

# Cargo
if [[ -d "$HOME/.cargo" ]]; then
  PATH="$HOME/.cargo/bin:$PATH"
fi

PATH="/usr/texbin:$PATH"

# Homebrew path
PATH="/opt/homebrew/bin:$PATH"

[[ -z $XDG_CONFIG_HOME ]] && export XDG_CONFIG_HOME="$HOME/.config"

[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"

[[ -d "$HOME/.luarocks" ]] && export PATH="$PATH:$HOME/.luarocks/bin"

# Undocumented feature that stops zsh-syntax-highlight after a certain length
export ZSH_HIGHLIGHT_MAXLENGTH=100

export PATH="$PATH:$HOME/.fzf/bin"
export FZF_DEFAULT_COMMAND="fd --type f"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d"
export FZF_DEFAULT_OPTS="--keep-right --bind=home:first,end:last"
export FZF_TMUX=0

[[ -f /usr/libexec/java_home/ ]] && export JAVA_HOME="$(/usr/libexec/java_home/)"

if which rustc >/dev/null 2>&1; then
    export RUST_SRC_PATH=$(rustc --print sysroot)/lib/rustlib/src/rust/src/
fi

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

export PATH="$PATH":"$HOME/.pub-cache/bin"

[ -f ~/.zshenv.local ] && source ~/.zshenv.local

if which python >/dev/null 2>&1; then 
	export SITE_PACKAGES="$(python -m site --user-site)"
fi

# For security the local directory should be at the end
export PATH="$PATH:."

if command -v nvim >/dev/null 2>&1; then
    export EDITOR=nvim
else
    export EDITOR=vim
fi

export JJ_CONFIG="$HOME/.config/jj"

# Workaround for nvim + tmux issues
export COLORTERM=1

export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
