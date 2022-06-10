export ZSH="$HOME/.zsh/omz"
export ZSH_CUSTOM="$HOME/.zsh/omz-custom"

export ZSH_THEME=dpoggi

plugins=(
  git
  git-ext
  docker
  docker-compose
  debian
  tmux
  zsh-syntax-highlighting
  common-aliases
)

# tmux config
export ZSH_TMUX_FIXTERM=1

# Remove information unnecessary when using the Neovim terminal
if [[ $NVIM == 1 ]]; then
     PROMPT="${PROMPT/$\(git_prompt_info\)/}"
     RPS1=''
fi

source $ZSH/oh-my-zsh.sh
