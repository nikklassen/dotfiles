#!/bin/sh
tmux rename-window -t "$TMUX_PANE" "$(basename "$(dirname "$PWD")")"
