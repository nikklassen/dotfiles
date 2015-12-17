call plug#begin('~/.vim/plugged')

Plug 'Lokaltog/vim-easymotion'
Plug 'Raimondi/delimitMate'
Plug 'Shougo/vimproc.vim', {'do': 'make'}
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'Valloric/YouCompleteMe', { 'do': './install.sh --clang-completer' }
Plug 'altercation/vim-colors-solarized'
Plug 'dag/vim2hs', {'for': 'haskell'}
Plug 'eagletmt/ghcmod-vim', {'for': 'haskell'}
Plug 'eagletmt/neco-ghc', {'for': 'haskell'}
Plug 'elzr/vim-json', {'for': 'json'}
Plug 'embear/vim-localvimrc'
Plug 'fs111/pydoc.vim', {'for': 'python'}
Plug 'groenewege/vim-less', {'for': 'less'}
Plug 'leafgarland/typescript-vim', {'for': 'typescript'}
" Remove node_modules since tern_for_vim doesn't update the required version
" of tern in package.json
Plug 'marijnh/tern_for_vim', {'for': 'javascript', 'do': 'rm -rf node_modules; npm install'}
Plug 'mattn/emmet-vim', {'for': 'html'}
Plug 'othree/xml.vim'
Plug 'pangloss/vim-javascript', {'for': 'javascript'}
Plug 'rking/ag.vim', {'on': 'Ag'}
Plug 'scrooloose/nerdtree', {'on': ['NERDTreeToggle', 'NERDTreeFind']}
Plug 'scrooloose/syntastic'
Plug 'tomasr/molokai'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround' | Plug 'tpope/vim-repeat'
Plug 'LaTeX-Box-Team/LaTeX-Box', {'for': 'tex'}
Plug 'vim-pandoc/vim-pandoc', {'for': ['markdown', 'pandoc']} | Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'vim-scripts/JavaScript-Indent', {'for': 'javascript'}
Plug 'vim-scripts/fakeclip'
Plug 'wincent/Command-T', {'on': ['CommandT', 'CommandTBuffer'], 'do': 'cd ruby/command-t; ruby extconf.rb && make'}
Plug 'chase/vim-ansible-yaml', {'for': 'ansible'}
Plug 'derekwyatt/vim-scala', {'for': 'scala'}
Plug 'dhruvasagar/vim-table-mode', {'on': 'TableModeToggle'}

if !has('win32')
    Plug 'tpope/vim-eunuch'
endif
if has('mac')
    Plug 'Floobits/floobits-vim', {'on': ['FlooJoinWorkspace', 'FlooShareDirPublic', 'FlooShareDirPrivate']}
    Plug 'rizzatti/dash.vim', {'on': 'Dash'}
    Plug 'rust-lang/rust.vim'
endif

call plug#end()
