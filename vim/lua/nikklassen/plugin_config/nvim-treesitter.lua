local M = {}

function M.configure()
    -- local queries = require "nvim-treesitter.query"
    -- require'nvim-treesitter'.define_modules {
    --   bulk_fold = {
    --     module_path = 'nikklassen.bulk-folds',
    --     is_supported = function (lang)
    --       return queries.has_query_files(lang, 'bulk_folds')
    --     end
    --   }
    -- }
    require 'nvim-treesitter'.define_modules {
        spell = {
            attach = function()
                vim.cmd('setlocal spell')
            end,
            detach = function()
            end,
        },
    }
    require 'nvim-treesitter.configs'.setup {
        -- Parsers bundled with nvim are also always installed
        ensure_installed = {
            'css',
            'cpp',
            'dockerfile',
            'go',
            'gomod',
            'html',
            'java',
            'javascript',
            'json',
            'latex',
            'proto',
            'rust',
            'scss',
            'textproto',
            'tsx',
            'typescript',
            'yaml'
        },
        highlight = {
            enable = true,
        },
        indent = {
            enable = false,
        },
        spell = {
            enable = true
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "gnn",
                node_incremental = "v",
                scope_incremental = "gns",
                node_decremental = "V",
            },
        },
        textobjects = {
            select = {
                enable = true,
                include_surrounding_whitespace = true,
                keymaps = {
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ['ia'] = '@parameter.inner',
                    ['aa'] = '@parameter.outer',
                    ['ii'] = '@field.inner',
                    ['ai'] = '@field.outer',
                    ['ic'] = '@class.inner',
                    ['ac'] = '@class.outer',
                    ['i='] = '@assignment.rhs',
                    ['a='] = '@assignment.outer',
                },
            },
            move = {
                enable = true,
                set_jumps = true, -- whether to set jumps in the jumplist
                goto_next_start = {
                    ["]m"] = "@function.outer",
                },
                goto_previous_start = {
                    ["[m"] = "@function.outer",
                },
            },
        },
        playground = {
            enable = true,
            disable = {},
            updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
            persist_queries = false -- Whether the query persists across vim sessions
        }
    }
end

return M
