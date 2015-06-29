EDITOR=/usr/local/bin/vim

PATH=".:$PATH"

# Python
# Setting PATH for Python 2.7
PATH="${PATH}:/Library/Frameworks/Python.framework/Versions/2.7/bin"
PYTHONSTARTUP=~/.pystartup

# Setup rbenv
PATH="$HOME/.rbenv/bin:$PATH"

# Gems path
PATH="$HOME/.rbenv/versions/2.0.0-p195/bin/gem:$PATH"

# Node modules
PATH="$PATH:$HOME/node_modules/.bin:./node_modules/.bin"

PATH="$PATH:$HOME/Library/Haskell/bin:$HOME/.cabal/bin"

PATH="/usr/texbin:$PATH"

# Homebrew path
PATH="/usr/local/bin:/usr/local/sbin:$PATH"

# Buildozer path
PATH="$PATH:./.buildozer/android/platform/android-sdk-21/platform-tools"

PYTHONPATH="${PYTHONPATH}:~/Programming/Python"

XML_CATALOG_FILES="/usr/local/etc/xml/catalog"
