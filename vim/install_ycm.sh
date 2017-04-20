#!/bin/bash
completers=''

function prompt_for() {
    if [[ $- == *i* ]]; then
        printf "Install $1 completer [yN]: "
        read install
        echo ""
        [[ install == 'y' ]] && completers="$completers --${1}-completer"
    else
        completers="$completers --${1}-completer"
    fi
}

prompt_for tern
prompt_for clang
prompt_for racer

eval ./install.py $completers
