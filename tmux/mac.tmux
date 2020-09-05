set-option -g default-command "which reattach-to-user-namespace > /dev/null && reattach-to-user-namespace -l $SHELL || $SHELL"

bind ] run "reattach-to-user-namespace pbpaste | tmux load-buffer - && tmux paste-buffer"

set -g status-interval 1

set -g status-right '#[fg=colour81]♪ #(~/dotfiles/scripts/now_playing.sh)#[fg=colour165]#[bg=default] #H'
set -g status-right-length 100
