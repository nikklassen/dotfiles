#!/bin/zsh

which -s brew 2>&1 > /dev/null
if [[ $? == 1 ]]; then
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  export PATH="/opt/homebrew/bin:$PATH"
fi
