#!/bin/sh
completers=''

function prompt_for() {
    printf "Install $1 completer [yN]: "
    read install
    echo ""
    [[ install == 'y' ]] && completers="$completers --${1}-completer"
}

prompt_for tern
prompt_for clang
prompt_for racer

eval ./install.py $completers
