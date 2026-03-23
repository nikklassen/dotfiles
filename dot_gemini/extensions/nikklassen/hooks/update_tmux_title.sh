#!/bin/bash
input="$(cat)"
data="$(echo "$input" | jq '.notification_type // empty')"
if [[ -n "${data}" ]]; then
  tmux rename-window -t "$TMUX_PANE" "$(basename "$(dirname "$PWD")") 󱜸"
fi
echo "{}"
