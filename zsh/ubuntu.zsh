alias sai="sudo apt-get install"
alias ls="ls -F --color=auto"

# Load nvm if it exists
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
if [[ $? == 0 ]]; then
    nvm use v > /dev/null
fi

# Load autojump
[[ -s /usr/share/autojump/autojump.sh ]] && . /usr/share/autojump/autojump.sh
