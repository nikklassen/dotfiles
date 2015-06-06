export PATH="/Users/Nik/.rbenv/shims:/usr/local/bin:/usr/local/sbin:/Users/Nik/.rbenv/versions/2.0.0-p195/bin/gem:/Users/Nik/.rbenv/bin:.:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/usr/local/git/bin:/usr/texbin:/Library/Frameworks/Python.framework/Versions/2.7/bin:/Users/Nik/node_modules/.bin:./node_modules/.bin:/Users/Nik/Library/Haskell/bin:/Users/Nik/.cabal/bin"

# Load and run compinit
autoload -U compinit
compinit -i -d "$HOME/.zcompdump"

autoload -U add-zsh-hook 
autoload -U zmv

eval "$(rbenv init -)"

multisrc() {
    for f in $@;
    do source $f
    done
}

# Souce other scripts
pushd .zsh > /dev/null

multisrc *.zsh

popd > /dev/null

alias ls="ls -FG"
alias lls="ls -lah"
alias xgit="xcrun git"
alias mysql=/usr/local/mysql/bin/mysql
alias mysqladmin=/usr/local/mysql/bin/mysqladmin
alias rsync="rsync -h --progress"
alias ytaudio="youtube-dl -x --audio-format mp3"
alias gvim=mvim

alias plz='sudo $(fc -ln -1)' 

youtube-mp3 () {
    youtube-dl -x --audio-format mp3 $1
}

mkcd() {
    mkdir -p $1
    cd $1
}

export CLASSPATH="$HOME/Programming/Java/classes/"

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

setopt correct
setopt correctall
alias sudo="nocorrect sudo"

setopt globdots
setopt extendedglob
setopt automenu
setopt autoparamslash
setopt completealiases

autoload up-line-or-beginning-search
autoload down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "\e[A" up-line-or-beginning-search
bindkey "\e[B" down-line-or-beginning-search
bindkey "\e[1~" beginning-of-line # ⌘ <-
bindkey "\e[4~" end-of-line # ⌘ ->
bindkey "\e[3~" delete-char # fn delete

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
