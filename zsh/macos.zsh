export CLASSPATH="$HOME/Programming/Java/classes/"

bindkey "\e[1~" beginning-of-line # ⌘ <-
bindkey "\e[4~" end-of-line # ⌘ ->
bindkey "\e[3~" delete-char # fn delete

# Load autojump
[[ -s /usr/local/etc/profile.d/autojump.sh ]] && . /usr/local/etc/profile.d/autojump.sh
