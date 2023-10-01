local utils = require 'nikklassen.utils'

return {
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = {
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        },
        opts = {
            defaults = {
                layout_strategy = 'vertical',
                mappings = {
                    i = {
                        ["<esc>"] = function(opts)
                            require('telescope.actions').close(opts)
                        end,
                        ["<C-a>"] = function() vim.cmd('normal! I') end,
                        ["<C-e>"] = function() vim.cmd('normal! A') end,
                    },
                },
            },
        },
        keys = function(_, keys)
            return utils.merge_keys('keep', keys or {}, {
                { '<c-p>',   utils.lazy_require('nikklassen.telescope').files },
                { '<c-s-p>', utils.lazy_require('telescope.builtin').commands },
                { '<leader>b', function()
                    require('telescope.builtin').buffers {
                        sort_mru = true,
                        ignore_current_buffer = true,
                    }
                end },
                { '<leader>f', function()
                    require('telescope.builtin').lsp_document_symbols {
                        symbols = 'function'
                    }
                end },
                { '<leader>d', utils.lazy_require('nikklassen.telescope').directory_files },
            })
        end,
        config = function(_, opts)
            local telescope = require 'telescope'
            telescope.setup(opts)
            telescope.load_extension('fzf')
        end
    },
}
