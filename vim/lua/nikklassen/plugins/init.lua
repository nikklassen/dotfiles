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
            return not vim.tbl_isempty(vim.fs.find({ '.git' }, { upward = true }))
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
            return not vim.tbl_isempty(vim.fs.find('.hg', { upward = true }))
        end,
    },

    ---------------------
    -- Language plugins -
    ---------------------

    -- JQ
    { 'vito-c/jq.vim',      ft = 'jq' },

    -- Rust
    { 'rust-lang/rust.vim', ft = 'rust' },

    -- Markdown
    {
        'dhruvasagar/vim-table-mode',
        ft = { 'pandoc', 'markdown' },
        config = function()
            vim.g.table_mode_corner_corner = '+'
            vim.g.table_mode_header_fillchar = '='
            vim.g.table_mode_align_char = ':'
        end,
    },

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
            -- VSCode plugin, imported just for the snippets
            {
                'golang/vscode-go',
                ft = { 'go' }
            },
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
    { 'ojroques/vim-oscyank', branch = 'main' },
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
