export CLASSPATH="$HOME/Programming/Java/classes/"

alias ls="ls -FG"
alias tar="tar --disable-copyfile"

bindkey "\e[1~" beginning-of-line # ⌘ <-
bindkey "\e[4~" end-of-line # ⌘ ->
bindkey "\e[3~" delete-char # fn delete

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

toggle_proxy() {
    proxy_info="$(sudo networksetup -getsocksfirewallproxy Wi-Fi)"

    if [[ $proxy_info =~ "Enabled: No" ]]; then
        echo "Turning on"
        sudo networksetup -setsocksfirewallproxystate Wi-Fi on
        ssh -ND 9999 nik@nikklassen.ca 2> /dev/null
    else
        echo "Turning off"
        sudo networksetup -setsocksfirewallproxystate Wi-Fi off
    fi
}

start_calibre_server() {
    /Applications/calibre.app/Contents/MacOS/calibre-server --port 7777&
    ssh -NR 5555:localhost:7777 nik@nikklassen.ca
    /usr/bin/read -n 1
}

linux_headless() {
    VBoxManage list runningvms | grep "Ubuntu 15.10" > /dev/null
    if [[ $? == 1 ]]; then
        VBoxManage startvm Ubuntu\ 15.10 --type headless
    fi
    ssh -p 2222 nik@localhost
}

# Load z
. /usr/local/etc/profile.d/z.sh

# Load nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

. ./remotepair.zsh

test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh
