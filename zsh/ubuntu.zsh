alias sai="sudo apt-get install"

# Load nvm
export NVM_DIR="/home/nicholas/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
nvm use v > /dev/null

# Load autojump
[[ -s /usr/share/autojump/autojump.sh ]] && . /usr/share/autojump/autojump.sh
