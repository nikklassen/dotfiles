export ZSH_CUSTOM="$HOME/.zsh/omz-custom"

export ZSH_THEME=dpoggi

export NVM_DIR="$HOME/.config/nvm"
zstyle ':omz:plugins:nvm' lazy yes

plugins=(
  common-aliases
  debian
  docker
  docker-compose
  encode64
  extract
  git
  git-ext
  nvm
  tmux
  you-should-use
  zsh-syntax-highlighting
)

export YSU_IGNORED_ALIASES=("vi" "vim")

# tmux config
export ZSH_TMUX_FIXTERM=1

# Disable bracketed paste
export DISABLE_MAGIC_FUNCTIONS=true

# Remove information unnecessary when using the Neovim terminal
if [[ $NVIM == 1 ]]; then
     PROMPT="${PROMPT/$\(git_prompt_info\)/}"
     RPS1=''
fi

source ~/.oh-my-zsh/oh-my-zsh.sh
