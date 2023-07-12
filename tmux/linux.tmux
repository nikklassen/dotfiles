run-shell "powerline-daemon -q --replace; tmux set-environment -g SITE_PACKAGES \"$(python3 -m site --user-site)\""
source-file "$HOME/.tmux/powerline.tmux"
