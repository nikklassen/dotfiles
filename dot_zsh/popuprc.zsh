export ZSH_CUSTOM="$HOME/.local/share/omz-custom"
export DISABLE_AUTO_UPDATE="true"
export ZSH_THEME=

plugins=(git jj)

zstyle :omz:plugins:jj ignore-working-copy yes

source "$ZSH/oh-my-zsh.sh"
source vcs.zsh

PROMPT='> '
RPS1=''
