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

start_calibre_server() {
    /Applications/calibre.app/Contents/MacOS/calibre-server --port 7777 --daemonize
    ssh -NR \*:5555:localhost:7777 nik &
    PID=$!
    /usr/bin/read -n 1
    pkill calibre-server
    kill $PID
}

linux_headless() {
    VBoxManage list runningvms | grep "Ubuntu 15.10" > /dev/null
    if [[ $? == 1 ]]; then
        VBoxManage startvm Ubuntu\ 15.10 --type headless
    fi
    ssh -p 2222 nik@localhost
}

. ./remotepair.zsh

export PS1="%{\$(iterm2_prompt_mark)%}$PS1"

[ -f ~/.iterm2_shell_integration.zsh ] && source ~/.iterm2_shell_integration.zsh
