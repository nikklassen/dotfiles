start_remotepair () {
    ssh -R 0.0.0.0:7000:localhost:22 -N nik@nikklassen.ca&
    ssh_pid=$!

    tmux -S /tmp/pair has-session -t workenv
    if [[ $? == 1 ]] ; then
        tmux -S /tmp/pair new-session -d -s workenv -n Vim
        tmux -S /tmp/pair select-window -t workenv:Vim
    fi

    chmod 777 /tmp/pair
    sudo dscl . -create /Users/remotepair UserShell /bin/bash

    tmux -S /tmp/pair -2 attach -t workenv

    chmod 770 /tmp/pair
    sudo dscl . -create /Users/remotepair UserShell /usr/bin/false

    if [ "-k" != "$1" ]; then
        kill $!
    fi
}
