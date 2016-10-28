# Include only my relevant stuff from oh-my-zsh
OMZ_DIR=oh-my-zsh-sparse

multisrc $OMZ_DIR/lib/*.zsh
multisrc $OMZ_DIR/plugins/git/*.zsh

source $OMZ_DIR/themes/dpoggi.zsh-theme

# Remove information unnecessary when using the Neovim terminal
if [[ $NVIM == 1 ]]; then
     PROMPT="${PROMPT/$\(git_prompt_info\)/}"
     RPS1=''
fi
