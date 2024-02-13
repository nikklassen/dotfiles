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
            {
                "zbirenbaum/copilot-cmp",
                event = 'LspAttach',
                cond = function()
                    return vim.env.NVIM_DISABLE_COPILOT ~= '1'
                end,
                config = function()
                    local copilot_cmp = require('copilot_cmp')
                    copilot_cmp.setup {}
                    vim.api.nvim_create_autocmd("LspAttach", {
                        callback = function(args)
                            local client = vim.lsp.get_client_by_id(args.data.client_id)
                            if client.name == "copilot" then
                                copilot_cmp._on_insert_enter({})
                            end
                        end,
                    })
                    vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
                end,
                dependencies = {
                    {
                        "zbirenbaum/copilot.lua",
                        cmd = "Copilot",
                        cond = function()
                            return vim.env.NVIM_DISABLE_COPILOT ~= '1'
                        end,
                        event = "InsertEnter",
                        main = 'copilot',
                        opts = {
                            suggestion = { enabled = true, auto_trigger = false },
                            panel = { enabled = false },
                            copilot_node_command = 'node-lazy',
                        },
                    },
                },
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
    {
        'tpope/vim-eunuch',
        cond = function() return vim.fn.has('win32') == 0 end,
        config = function()
            vim.g.eunuch_no_maps = true
        end,
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
