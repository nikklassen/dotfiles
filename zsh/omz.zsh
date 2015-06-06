# Include only my relevant stuff from oh-my-zsh
OMZ_DIR=oh-my-zsh-sparse

multisrc $OMZ_DIR/lib/*.zsh
multisrc $OMZ_DIR/plugins/**/*.zsh

source $OMZ_DIR/themes/dpoggi.zsh-theme
