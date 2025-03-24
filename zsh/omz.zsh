export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$HOME/.zsh/omz-custom"

export ZSH_THEME=dpoggi

plugins=(
  asdf
  common-aliases
  debian
  docker
  docker-compose
  encode64
  extract
  git
  git-ext
  jj
  tmux
  urltools
  you-should-use
  zsh-syntax-highlighting
)
if command -v direnv >/dev/null 2>&1; then
  plugins+=(direnv)
fi

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

zstyle :omz:plugins:jj ignore-working-copy yes

source ~/.oh-my-zsh/oh-my-zsh.sh
