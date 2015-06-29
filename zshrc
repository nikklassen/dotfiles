export PATH="/usr/local/bin:/usr/local/sbin:.:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/usr/local/git/bin:/usr/texbin:./node_modules/.bin:"

# Load and run compinit
autoload -U compinit
compinit -i -d "$HOME/.zcompdump"

autoload -U add-zsh-hook 
autoload -U zmv

multisrc() {
    for f in $@;
    do source $f
    done
}

return_code="%?"

# Souce other scripts
pushd "$HOME/.zsh" > /dev/null

multisrc *.zsh

popd > /dev/null

source $HOME/.zsh/syntax-highlighting/zsh-syntax-highlighting.zsh

alias ls="ls -FG --color=auto"
alias lls="ls -lAh"
alias xgit="xcrun git"
alias mysql=/usr/local/mysql/bin/mysql
alias mysqladmin=/usr/local/mysql/bin/mysqladmin
alias rsync="rsync -h --progress"
alias ytaudio="youtube-dl -x --audio-format mp3"
alias stf="sudo tail -f"
alias gpnew='git push --set-upstream origin $(current_branch)'

alias plz='sudo $(fc -ln -1)' 

youtube-mp3 () {
    youtube-dl -x --audio-format mp3 $1
}

mkcd () {
    mkdir -p "$*"
    cd "$*"
}

gbc () {
    git branch $1 &&
    git checkout $1
}

HISTFILE=$HOME/.zhistory
HISTSIZE=SAVEHIST=10000
setopt APPEND_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY
setopt AUTO_CD
setopt EXTENDED_GLOB

setopt correct
setopt correctall
alias sudo="nocorrect sudo"

setopt globdots
setopt extendedglob
setopt automenu
setopt autoparamslash

auto-ls-after-cd() {
    emulate -L zsh
    ls
}
add-zsh-hook chpwd auto-ls-after-cd

proxy_toggle() {
    proxy_info="$(sudo networksetup -getsocksfirewallproxy Wi-Fi)"

    if [[ $proxy_info =~ "Enabled: No" ]]; then
        echo "Turning on"
        sudo networksetup -setsocksfirewallproxystate Wi-Fi on
    else
        echo "Turning off"
        sudo networksetup -setsocksfirewallproxystate Wi-Fi off
    fi
}

firewall_toggle() {

    firewall_state="$(sudo defaults read /Library/Preferences/com.apple.alf globalstate)"

    new_state=1
    if [[ $firewall_state == 0 ]]; then
        echo "Turning on"
    else
        echo "Turning off"
        new_state=0
    fi

    sudo defaults write /Library/Preferences/com.apple.alf globalstate -int $new_state

    sudo launchctl unload /System/Library/LaunchDaemons/com.apple.alf.agent.plist
    sudo launchctl load /System/Library/LaunchDaemons/com.apple.alf.agent.plist
}

# Load automjump
if [[ $(uname) == 'Darwin' ]]; then
    . $HOME/.zsh/macos.zsh
else
    . $HOME/.zsh/ubuntu.zsh
fi
