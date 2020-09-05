call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sensible'

Plug 'Raimondi/delimitMate'
if !has('nvim')
    Plug 'Shougo/vimproc.vim', {'do': 'make'}
endif
if has('python3')
  Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
endif

Plug 'embear/vim-localvimrc'
Plug 'scrooloose/nerdtree', {'on': ['NERDTreeToggle', 'NERDTreeFind']}
Plug 'tomasr/molokai'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround' | Plug 'tpope/vim-repeat'
Plug 'tpope/vim-abolish' " Abbreviations and cross-product replacements
Plug 'scrooloose/nerdcommenter'
Plug 'wellle/targets.vim' " Text objects, mostly for 'argument' text object
Plug 'whiteinge/diffconflicts', {'on': ['DiffConflicts']}

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } | Plug 'junegunn/fzf.vim'
" Load ag.vim after fzf so that fzf's Ag command is overridden
Plug 'rking/ag.vim'

" --------------------
" - Language plugins -
" --------------------

" Haskell
Plug 'dag/vim2hs', {'for': 'haskell'}
Plug 'eagletmt/ghcmod-vim', {'for': 'haskell'}

" JSON
Plug 'elzr/vim-json', {'for': 'json'}

" JS/TS
Plug 'leafgarland/typescript-vim', {'for': 'typescript'}
Plug 'pangloss/vim-javascript', {'for': ['js', 'jsx']} | Plug 'mxw/vim-jsx', {'for': ['jsx']}

" Ruby
Plug 'vim-ruby/vim-ruby', {'for': ['ruby', 'eruby']}
Plug 'tpope/vim-rails', {'for': ['ruby', 'eruby']}

" JQ
Plug 'vito-c/jq.vim', {'for': 'jq'}

" nginx
Plug 'chr4/nginx.vim'

" Rust
Plug 'rust-lang/rust.vim', {'for': 'rust'}

" Markdown
" Plug 'vim-pandoc/vim-pandoc', {'for': ['markdown', 'pandoc']} | Plug 'vim-pandoc/vim-pandoc-syntax', {'for': ['markdown', 'pandoc']}
Plug 'dhruvasagar/vim-table-mode', {'for': ['pandoc', 'markdown']}

" LaTeX
Plug 'LaTeX-Box-Team/LaTeX-Box', {'for': 'tex'}

" Ansible
Plug 'chase/vim-ansible-yaml', {'for': 'ansible'}

" HTML
Plug 'mattn/emmet-vim', {'for': ['html', 'htmldjango', 'xml', 'eruby']}
Plug 'othree/xml.vim', {'for': ['xml', 'html', 'eruby']}
Plug 'othree/html5.vim', {'for': ['html', 'eruby']}

" LESS
Plug 'groenewege/vim-less', {'for': 'less'}

" Python
Plug 'fs111/pydoc.vim', {'for': 'python'}

if has('nvim')
    Plug 'benekastah/neomake'
    Plug 'brettanomyces/nvim-editcommand'
    Plug 'neovim/node-host' | Plug 'snoe/nvim-parinfer.js', {
        \ 'for': 'clojure',
        \ 'do': 'ln -s rplugin/node/nvim-parinfer.js ../../rplugin/node/nvim-parinfer.js'}

    " Plug 'autozimu/LanguageClient-neovim', {
    "     \ 'branch': 'next',
    "     \ 'do': 'bash install.sh',
    "     \ }
    " Plug 'natebosch/vim-lsc'
    " Plug 'dhruvasagar/vim-markify'

    Plug 'prabirshrestha/async.vim'
    Plug 'prabirshrestha/vim-lsp'
    Plug 'prabirshrestha/asyncomplete.vim'
    Plug 'prabirshrestha/asyncomplete-lsp.vim'

    " Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    Plug 'sbdchd/neoformat'
else
    Plug 'Valloric/YouCompleteMe', { 'do': '~/.vim/install_ycm.sh' }
    Plug 'scrooloose/syntastic'
    Plug 'vim-scripts/fakeclip'
endif
if !has('win32')
    Plug 'tpope/vim-eunuch'
endif
if has('mac')
    Plug 'rizzatti/dash.vim', {'on': 'Dash'}
endif

call plug#end()
