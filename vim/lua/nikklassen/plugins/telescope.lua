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
        keys = {
            { '<c-p>' },
            { '<c-s-p>',   utils.lazy_require('telescope.builtin').commands },
            { '<leader>b', utils.lazy_require('telescope.builtin').buffers },
            { '<leader>f', utils.lazy_require('telescope.builtin').lsp_document_symbols },
            { '<leader>d', utils.lazy_require('nikklassen.telescope').directory_files },
        },
        config = function(_, opts)
            local telescope = require 'telescope'
            telescope.setup(opts)
            telescope.load_extension('fzf')

            local files = opts.files or require('nikklassen.telescope').files
            vim.keymap.set('n', '<c-p>', files)
        end
    },
}
