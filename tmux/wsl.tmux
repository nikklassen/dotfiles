bind ] run 'tmux set-buffer "$(paste.exe | tr -d \"\\r\\n\")"; tmux paste-buffer'
