alias ls="ls -FG"
alias tar="tar --disable-copyfile"

bindkey "\e[1~" beginning-of-line # ⌘ <-
bindkey "\e[4~" end-of-line # ⌘ ->
bindkey "\e[3~" delete-char # fn delete

export PS1="%{\$(iterm2_prompt_mark)%}$PS1"

[ -f ~/.iterm2_shell_integration.zsh ] && source ~/.iterm2_shell_integration.zsh
