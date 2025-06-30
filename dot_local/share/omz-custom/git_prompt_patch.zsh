if [[ $PROMPT_SIMPLE ]]; then
    export ZSH_THEME_GIT_PROMPT_DIRTY="%{[31m%}X%{[00m%}"
else
    # Poop emoji, gets overwritten if it's in zshenv
    export ZSH_THEME_GIT_PROMPT_DIRTY="\xF0\x9F\x92\xA9 "
fi
