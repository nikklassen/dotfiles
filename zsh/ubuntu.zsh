alias sai="sudo apt-get install"
alias ls="ls -F --color=auto"

ssa() {
    service "$1" start
}

sso() {
    service "$1" stop
}

sr() {
    service "$1" restart
}
