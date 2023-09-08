return {

    'tpope/vim-sensible',
    {
        'navarasu/onedark.nvim',
        lazy = false,
        priority = 1000,
        config = function() require 'nikklassen.plugin_config.onedark'.configure() end,
    },
    'tpope/vim-fugitive',
    'tpope/vim-repeat',
    'tpope/vim-commentary',
    'tpope/vim-abolish',
    {
        'whiteinge/diffconflicts',
        cmd = { 'DiffConflicts' },
    },
    'vim-scripts/ReplaceWithRegister',

    {
        'ibhagwan/fzf-lua',
        dependencies = { 'junegunn/fzf', build = './install --bin' },
        config = function() require 'nikklassen.plugin_config.fzf_lua'.configure() end,
    },

    {
        'jremmen/vim-ripgrep',
        cmd = 'Rg',
    },

    'ludovicchabant/vim-lawrencium',

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
        config = function() require 'nikklassen.plugin_config.vim-table-mode'.configure() end,
    },

    -- HTML
    { 'mattn/emmet-vim',  ft = { 'html', 'htmldjango', 'xml', 'eruby' } },
    { 'othree/xml.vim',   ft = { 'xml', 'html', 'eruby' } },
    { 'othree/html5.vim', ft = { 'html', 'eruby' } },

    -- Go
    {
        'mfussenegger/nvim-dap',
        dependencies = {
            {
                'leoluz/nvim-dap-go',
                ft = { 'go' },
                main = 'dap-go',
                config = function() require('dap-go').setup() end,
            },
            {
                'rcarriga/nvim-dap-ui',
                dependencies = {
                    'mfussenegger/nvim-dap',
                },
                config = function() require 'nikklassen.plugin_config.nvim-dap'.configure() end,
            },
        },
    },

    -------------------
    -- Other plugins --
    -------------------

    {
        'brettanomyces/nvim-editcommand',
        config = function()
            require 'nikklassen.plugin_config.nvim-editcommand'
                .configure()
        end
    },

    {
        'windwp/nvim-autopairs',
        config = function() require 'nikklassen.plugin_config.nvim-autopairs'.configure() end,
    },
    {
        'hrsh7th/nvim-cmp',
        branch = 'main',
        event = "InsertEnter",
        config = function() require 'nikklassen.plugin_config.nvim-cmp'.configure() end,
        dependencies = {
            { 'hrsh7th/cmp-nvim-lsp', branch = 'main' },
            {
                'hrsh7th/cmp-vsnip',
                branch = 'main',
            },
            'hrsh7th/vim-vsnip',
            'ray-x/lsp_signature.nvim',
            { 'onsails/lspkind.nvim' },
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
        dependencies = {
            {
                'nvim-treesitter/nvim-treesitter-textobjects',
                config = function()
                    require 'nikklassen.plugin_config.nvim-treesitter'.configure()
                end,
            },
        }
    },
    'nvim-treesitter/playground',
    { 'kylechui/nvim-surround', config = function() require('nvim-surround').setup({}) end },
    { 'ojroques/vim-oscyank',   branch = 'main' },

    'RishabhRD/popfix',
    'RishabhRD/nvim-lsputils',

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
        config = function() require 'nikklassen.plugin_config.other_nvim'.configure() end,
        keys = { '<M-r>' },
    },

    -- TODO
    -- local vimrc_local = vim.fn.expand('~') .. '/.vimrc.local.lua'
    -- if vim.fn.filereadable(vimrc_local) == 1 then
    --     dofile(vimrc_local).startup(use)
    -- end
}
-- config = {
--     luarocks = {
--         python_cmd = 'python3'
--     }
-- },
-- })
