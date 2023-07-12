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
        ensure_installed = {
            'bash',
            'css',
            'dockerfile',
            'go',
            'html',
            'javascript',
            'json',
            'latex',
            'lua',
            'markdown',
            'markdown_inline',
            'python',
            'rust',
            'scss',
            'tsx',
            'typescript',
            'vim',
            'query',
            'yaml'
        },
        highlight = {
            enable = true,
            custom_captures = {},
        },
        indent = {
            disable = true
        },
        spell = {
            enable = true
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "gnn",
                node_incremental = "<M-Up>",
                scope_incremental = "gns",
                node_decremental = "<M-Down>",
            },
        },
        textobjects = {
            select = {
                enable = true,
                keymaps = {
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ['ia'] = '@parameter.inner',
                    ['aa'] = '@parameter.outer',
                    ['ik'] = '@element.inner',
                    ['ak'] = '@element.outer',
                    ['ao'] = '@struct',
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
