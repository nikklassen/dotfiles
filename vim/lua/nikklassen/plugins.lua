function plug(...)
    return vim.fn['plug#'](...)
end

vim.fn['plug#begin'](vim.fn.stdpath('config') .. '/plugged')

plug('tpope/vim-sensible')

plug('Raimondi/delimitMate')

plug('embear/vim-localvimrc')
plug('scrooloose/nerdtree', {on = {'NERDTreeToggle', 'NERDTreeFind'}})
-- plug('tomasr/molokai')
plug('joshdick/onedark.vim')
plug('tpope/vim-fugitive')
plug('tpope/vim-surround')
plug('tpope/vim-repeat')
plug('tpope/vim-commentary')
plug('whiteinge/diffconflicts', {on = {'DiffConflicts'}})
plug('vim-scripts/ReplaceWithRegister')

plug('junegunn/fzf', { dir = '~/.fzf', ['do'] = ':call fzf#install()' })
plug('junegunn/fzf.vim')

-- Load ag.vim after fzf so that fzf's Ag command is overridden
plug('rking/ag.vim')

---------------------
-- Language plugins -
---------------------

-- JS/TS
plug('leafgarland/typescript-vim', {['for'] = 'typescript'})
plug('pangloss/vim-javascript', {['for'] = {'js', 'jsx'}})
plug('mxw/vim-jsx', {['for'] = {'jsx'}})

-- JQ
plug('vito-c/jq.vim', {['for'] = 'jq'})

-- nginx
plug('chr4/nginx.vim')

-- Rust
plug('rust-lang/rust.vim', {['for'] = 'rust'})

-- Markdown
plug('vim-pandoc/vim-pandoc', {['for'] = {'markdown', 'pandoc'}})
plug('vim-pandoc/vim-pandoc-syntax', {['for'] = {'markdown', 'pandoc'}})
plug('dhruvasagar/vim-table-mode', {['for'] = {'pandoc', 'markdown'}})

-- HTML
plug('mattn/emmet-vim', {['for'] = {'html', 'htmldjango', 'xml', 'eruby'}})
plug('othree/xml.vim', {['for'] = {'xml', 'html', 'eruby'}})
plug('othree/html5.vim', {['for'] = {'html', 'eruby'}})

-- Go
plug('sebdah/vim-delve', {['for'] = 'go'})

-------------------
-- Other plugins --
-------------------

plug('brettanomyces/nvim-editcommand')

plug('neovim/nvim-lspconfig')

plug('hrsh7th/nvim-compe')
plug('hrsh7th/vim-vsnip')
plug('hrsh7th/vim-vsnip-integ')

plug('nvim-treesitter/nvim-treesitter', {['do'] = ':TSUpdate'})
plug('nvim-treesitter/playground')
plug('nvim-treesitter/nvim-treesitter-textobjects')

plug('RishabhRD/popfix')
plug('RishabhRD/nvim-lsputils')

if vim.fn.has('win32') == 0 then
    plug('tpope/vim-eunuch')
end

vim.fn['plug#end']()
