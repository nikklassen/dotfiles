local packer_install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
local packer_did_bootstrap = false
if vim.fn.isdirectory(packer_install_path) == 0 then
    packer_did_bootstrap = vim.fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim',
        packer_install_path })
end

local packer_user_config_ag = vim.api.nvim_create_augroup('packer_user_config', {})
vim.api.nvim_create_autocmd('BufWritePost', {
    group = packer_user_config_ag,
    pattern = { 'plugins.lua' },
    command = 'source <afile> | PackerCompile'
})

vim.cmd [[packadd packer.nvim]]

local packer = require 'packer'
packer.startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use 'tpope/vim-sensible'

    use { 'embear/vim-localvimrc', config = function() require 'nikklassen.plugin_config.vim-localvimrc'.configure() end }
    use {
        'preservim/nerdtree',
        cmd = { 'NERDTreeToggle', 'NERDTreeFind' },
        keys = '<leader>nf',
        config = function() require 'nikklassen.plugin_config.nerdtree'.configure() end,
    }

    use { 'navarasu/onedark.nvim', config = function() require 'nikklassen.plugin_config.onedark'.configure() end }
    use 'tpope/vim-fugitive'
    use 'tpope/vim-repeat'
    use 'tpope/vim-commentary'
    use 'tpope/vim-abolish'
    use { 'whiteinge/diffconflicts', opt = true, cmd = { 'DiffConflicts' } }
    use 'vim-scripts/ReplaceWithRegister'

    use {
        'ibhagwan/fzf-lua',
        requires = { 'junegunn/fzf', run = './install --bin' },
        config = function() require 'nikklassen.plugin_config.fzf_lua'.configure() end,
    }

    use {
        'jremmen/vim-ripgrep',
        cmd = 'Rg',
    }

    use 'ludovicchabant/vim-lawrencium'

    ---------------------
    -- Language plugins -
    ---------------------

    -- JQ
    use { 'vito-c/jq.vim', ft = 'jq' }

    -- Rust
    use { 'rust-lang/rust.vim', ft = 'rust' }

    -- Markdown
    use {
        'dhruvasagar/vim-table-mode',
        ft = { 'pandoc', 'markdown' },
        config = function() require 'nikklassen.plugin_config.vim-table-mode'.configure() end,
    }

    -- HTML
    use { 'mattn/emmet-vim', ft = { 'html', 'htmldjango', 'xml', 'eruby' } }
    use { 'othree/xml.vim', ft = { 'xml', 'html', 'eruby' } }
    use { 'othree/html5.vim', ft = { 'html', 'eruby' } }

    -- Go
    use 'mfussenegger/nvim-dap'
    use {
        'leoluz/nvim-dap-go',
        ft = { 'go' },
        config = function() require('dap-go').setup() end,
        after = 'nvim-dap'
    }
    -- (optional) for TUI support
    use {
        'rcarriga/nvim-dap-ui',
        requires = {
            'mfussenegger/nvim-dap',
        },
        config = function() require 'nikklassen.plugin_config.nvim-dap'.configure() end,
    }

    -------------------
    -- Other plugins --
    -------------------

    use { 'brettanomyces/nvim-editcommand', config = function()
        require 'nikklassen.plugin_config.nvim-editcommand'
            .configure()
    end }

    use {
        'nvim-lua/lsp-status.nvim',
        config = function() require 'nikklassen.plugin_config.lsp-status'.configure() end,
    }
    use {
        'neovim/nvim-lspconfig',
        config = function() require 'nikklassen.plugin_config.nvim-lspconfig'.configure() end,
        after = { 'lsp-status.nvim' },
    }

    use { 'windwp/nvim-autopairs', config = function() require 'nikklassen.plugin_config.nvim-autopairs'.configure() end }
    use { 'hrsh7th/cmp-nvim-lsp', branch = 'main' }
    use {
        'hrsh7th/cmp-vsnip',
        branch = 'main',
        requires = { 'hrsh7th/nvim-cmp' },
    }
    use 'hrsh7th/vim-vsnip'
    use 'ray-x/lsp_signature.nvim'
    use { 'onsails/lspkind.nvim' }
    use {
        'hrsh7th/nvim-cmp',
        branch = 'main',
        config = function() require 'nikklassen.plugin_config.nvim-cmp'.configure() end,
        after = { 'nvim-autopairs' }
    }

    -- VSCode plugin, imported just for the snippets
    use {
        'golang/vscode-go',
        ft = { 'go' }
    }

    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
    }
    use {
        'nvim-treesitter/nvim-treesitter-textobjects',
        config = function()
            require 'nikklassen.plugin_config.nvim-treesitter'.configure()
        end,
        after = { 'nvim-treesitter' }
    }
    use 'nvim-treesitter/playground'
    use { 'kylechui/nvim-surround', config = function() require('nvim-surround').setup({}) end }

    use { 'ojroques/vim-oscyank', branch = 'main' }

    use 'RishabhRD/popfix'
    use 'RishabhRD/nvim-lsputils'

    if vim.fn.has('win32') == 0 then
        use 'tpope/vim-eunuch'
    end

    use 'nvim-lua/plenary.nvim'
    use {
        'rgroli/other.nvim',
        config = function() require'nikklassen.plugin_config.other_nvim'.configure() end,
    }

    local vimrc_local = vim.fn.expand('~') .. '/.vimrc.local.lua'
    if vim.fn.filereadable(vimrc_local) == 1 then
        dofile(vimrc_local).startup(use)
    end

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_did_bootstrap then
        packer.sync()
    end
end)
