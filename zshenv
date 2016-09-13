export PAGER=less
export LESS="-SR -# 0"
export EDITOR=/usr/local/bin/nvim

# Python
# Setting PATH for Python 2.7
PATH="${PATH}:/Library/Frameworks/Python.framework/Versions/2.7/bin"

# Setup rbenv
PATH="$HOME/.rbenv/bin:$PATH"

# Node modules
PATH="./node_modules/.bin:$PATH"

# Cargo
PATH="$HOME/.cargo/bin:$PATH"

# Homebrew path
PATH="/usr/local/bin:/usr/local/sbin:$PATH"

PATH="$PATH:$HOME/Library/Haskell/bin:$HOME/.cabal/bin:$HOME/.pandoc/bin"

PATH="/usr/texbin:$PATH"

# Buildozer path
PATH="$PATH:./.buildozer/android/platform/android-sdk-21/platform-tools"

# Homebrew path
PATH="/usr/local/bin:/usr/local/sbin:$PATH"

# rvm
export PATH="$PATH:$HOME/.rvm/bin"

# For security the local directory should be at the end
export PATH="$PATH:."

PYTHONPATH="$PYTHONPATH:~/Programming/Python"
PYTHONSTARTUP=~/.pystartup

XML_CATALOG_FILES="/usr/local/etc/xml/catalog"

export XDG_CONFIG_HOME="$HOME/.config"

# Undocumented feature that stops zsh-syntax-highlight after a certain length
ZSH_HIGHLIGHT_MAXLENGTH=100

export FZF_DEFAULT_COMMAND='ag -g ""'
export FZF_TMUX=0

export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

export JAVA_HOME="$(/usr/libexec/java_home/)"

BOOT_EMIT_TARGET=no

export RUST_SRC_PATH='/usr/local/include/rust/src'
