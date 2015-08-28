call plug#begin('~/.vim/plugged')

Plug 'Lokaltog/vim-easymotion'
Plug 'Raimondi/delimitMate'
Plug 'Shougo/vimproc.vim', {'do': 'make'}
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'Valloric/YouCompleteMe', { 'do': './install.sh --clang-completer' }
Plug 'altercation/vim-colors-solarized'
Plug 'dag/vim2hs'
Plug 'eagletmt/ghcmod-vim'
Plug 'eagletmt/neco-ghc'
Plug 'elzr/vim-json'
Plug 'embear/vim-localvimrc'
Plug 'fs111/pydoc.vim'
Plug 'groenewege/vim-less'
Plug 'leafgarland/typescript-vim'
Plug 'marijnh/tern_for_vim', {'do': 'npm install', 'for': 'javascript'}
Plug 'mattn/emmet-vim'
Plug 'othree/xml.vim'
Plug 'pangloss/vim-javascript'
Plug 'rking/ag.vim', {'on': 'Ag'}
Plug 'scrooloose/nerdtree', {'on': ['NERDTreeToggle', 'NERDTreeFind']}
Plug 'scrooloose/syntastic'
Plug 'tomasr/molokai'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround' | Plug 'tpope/vim-repeat'
Plug 'vim-latex/vim-latex'
Plug 'vim-pandoc/vim-pandoc' | Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'vim-scripts/JavaScript-Indent'
Plug 'vim-scripts/fakeclip'
Plug 'wincent/Command-T', {'on': ['CommandT', 'CommandTBuffer'], 'do': 'cd ruby/command-t; ruby extconf.rb && make'}

if !has('win32')
    Plug 'tpope/vim-eunuch'
endif
if has('mac')
    Plug 'Floobits/floobits-vim', {'on': ['FlooJoinWorkspace', 'FlooShareDirPublic', 'FlooShareDirPrivate']}
    Plug 'rizzatti/dash.vim', {'on': 'Dash'}
    Plug 'rust-lang/rust.vim'
endif

call plug#end()
