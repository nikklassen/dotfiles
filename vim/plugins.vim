call plug#begin('~/.vim/plugged')

Plug 'Lokaltog/vim-easymotion'
Plug 'Raimondi/delimitMate'
Plug 'Shougo/vimproc.vim', {'do': 'make'}
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

let completers = '--tern-completer'
if has('mac')
    let completers .= ' --clang-completer --racer-completer'
endif
Plug 'Valloric/YouCompleteMe', { 'do': './install.py ' . completers }

Plug 'altercation/vim-colors-solarized'
Plug 'dag/vim2hs', {'for': 'haskell'}
Plug 'eagletmt/ghcmod-vim', {'for': 'haskell'}
Plug 'elzr/vim-json', {'for': 'json'}
Plug 'embear/vim-localvimrc'
Plug 'fs111/pydoc.vim', {'for': 'python'}
Plug 'groenewege/vim-less', {'for': 'less'}
Plug 'leafgarland/typescript-vim', {'for': 'typescript'}
Plug 'mattn/emmet-vim', {'for': ['html', 'htmldjango']}
Plug 'othree/xml.vim'
Plug 'tpope/vim-abolish'
Plug 'pangloss/vim-javascript' | Plug 'mxw/vim-jsx'
Plug 'scrooloose/nerdtree', {'on': ['NERDTreeToggle', 'NERDTreeFind']}
Plug 'tomasr/molokai'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround' | Plug 'tpope/vim-repeat'
Plug 'tpope/vim-abolish'
Plug 'LaTeX-Box-Team/LaTeX-Box', {'for': 'tex'}
Plug 'vim-pandoc/vim-pandoc', {'for': ['markdown', 'pandoc']} | Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'chase/vim-ansible-yaml', {'for': 'ansible'}
Plug 'dhruvasagar/vim-table-mode', {'for': ['pandoc', 'markdown']}
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } | Plug 'junegunn/fzf.vim'

Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-rails'

" Load ag.vim after fzf so that fzf's Ag command is overridden
Plug 'rking/ag.vim'

if has('nvim')
    Plug 'benekastah/neomake'
    Plug 'brettanomyces/nvim-editcommand'
    Plug 'neovim/node-host' | Plug 'snoe/nvim-parinfer.js', {
        \ 'for': 'clojure',
        \ 'do': 'ln -s rplugin/node/nvim-parinfer.js ../../rplugin/node/nvim-parinfer.js'}
else
    Plug 'scrooloose/syntastic'
    Plug 'vim-scripts/fakeclip'
endif
if !has('win32')
    Plug 'tpope/vim-eunuch'
endif
if has('mac')
    Plug 'Floobits/floobits-vim', {'on': ['FlooJoinWorkspace', 'FlooShareDirPublic', 'FlooShareDirPrivate']}
    Plug 'rizzatti/dash.vim', {'on': 'Dash'}
    Plug 'rust-lang/rust.vim'
endif

call plug#end()
