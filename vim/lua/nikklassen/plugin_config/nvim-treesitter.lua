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
            'gomod',
            'html',
            'java',
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
                    ['i:'] = '@element.inner',
                    ['a:'] = '@element.outer',
                    ['ao'] = '@struct',
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

    local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"
    vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
    vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

    vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
    vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
    vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
    vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)
end

return M
