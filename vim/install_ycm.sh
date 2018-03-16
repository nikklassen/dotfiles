#!/bin/bash
completers=''

function has_exe() {
    if [[ -n "$(which "$1" 2> /dev/null)" ]]; then
        completers="$completers --${2}-completer"
    fi
}

has_exe node tern
# has_exe clang++ clang
has_exe rustc racer

eval python3 ./install.py $completers
