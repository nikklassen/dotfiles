alias sai="sudo apt-get install"
alias ls="ls -dF --color=auto"

# Load nvm if it exists
which nvm > /dev/null
if [[ $? == 0 ]]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    nvm use v > /dev/null
fi

# Load autojump
[[ -s /usr/share/autojump/autojump.sh ]] && . /usr/share/autojump/autojump.sh
