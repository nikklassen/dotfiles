EDITOR=/usr/local/bin/vim

# Python
# Setting PATH for Python 2.7
PATH="${PATH}:/Library/Frameworks/Python.framework/Versions/2.7/bin"

# Setup rbenv
PATH="$HOME/.rbenv/bin:$PATH"

# Gems path
PATH="$HOME/.rbenv/versions/2.0.0-p195/bin/gem:$PATH"

# Node modules
PATH="$HOME/node_modules/.bin:./node_modules/.bin:$PATH"

PATH="$PATH:$HOME/Library/Haskell/bin:$HOME/.cabal/bin:$HOME/.pandoc/bin"

PATH="/usr/texbin:$PATH"

# Buildozer path
PATH="$PATH:./.buildozer/android/platform/android-sdk-21/platform-tools"

# Homebrew path
PATH="/usr/local/bin:/usr/local/sbin:$PATH"

# For security the local directory should be at the end
PATH="$PATH:."

PYTHONPATH="$PYTHONPATH:~/Programming/Python"
PYTHONSTARTUP=~/.pystartup

XML_CATALOG_FILES="/usr/local/etc/xml/catalog"
