local utils = require 'nikklassen.utils'

return {
    {
        'tpope/vim-sensible',
        lazy = false,
        priority = 1001,
    },
    {
        'tpope/vim-fugitive',
        cmd = { 'G', 'Git' },
        cond = function()
            return utils.is_cwd_readable() and not vim.tbl_isempty(vim.fs.find('.git', { upward = true }))
        end,
    },
    'tpope/vim-repeat',
    'tpope/vim-commentary',
    'tpope/vim-abolish',
    {
        'whiteinge/diffconflicts',
        cmd = { 'DiffConflicts' },
    },
    'vim-scripts/ReplaceWithRegister',

    {
        'jremmen/vim-ripgrep',
        cmd = 'Rg',
    },

    {
        'ludovicchabant/vim-lawrencium',
        cond = function()
            return utils.is_cwd_readable() and not vim.tbl_isempty(vim.fs.find('.hg', { upward = true }))
        end,
    },

    ---------------------
    -- Language plugins -
    ---------------------

    -- JQ
    { 'vito-c/jq.vim' },

    -- Rust
    { 'rust-lang/rust.vim', ft = 'rust' },

    -------------------
    -- Other plugins --
    -------------------

    {
        'hrsh7th/nvim-cmp',
        branch = 'main',
        event = 'InsertEnter',
        opts = {},
        main = 'nikklassen.plugin_config.nvim-cmp',
        dependencies = {
            {
                'hrsh7th/cmp-nvim-lsp',
                branch = 'main',
            },
            {
                'hrsh7th/cmp-vsnip',
                branch = 'main',
            },
            'hrsh7th/vim-vsnip',
            'ray-x/lsp_signature.nvim',
            'onsails/lspkind.nvim',
        },
    },
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        event = { "BufReadPost", "BufNewFile" },
        dependencies = {
            {
                'nvim-treesitter/nvim-treesitter-textobjects',
                config = function()
                    require 'nikklassen.plugin_config.nvim-treesitter'.configure()
                end,
            },
            'nvim-treesitter/playground'
        }
    },
    {
        'kylechui/nvim-surround',
        opts = {},
    },
    {
        'tpope/vim-eunuch',
        cond = function() return vim.fn.has('win32') == 0 end,
    },
    {
        'nvim-lua/plenary.nvim',
        lazy = true,
    },
    {
        'rgroli/other.nvim',
        keys = { '<M-r>' },
        opts = {
            mappings = {
                'golang'
            },
        },
        main = 'nikklassen.plugin_config.other_nvim',
    },
}
