local queries = require "nvim-treesitter.query"

local M = {}

function M.configure()
  require'nvim-treesitter'.define_modules {
    bulk_fold = {
      module_path = 'nikklassen.bulk-folds',
      is_supported = function (lang)
        return queries.has_query_files(lang, 'bulk_folds')
      end
    }
  }
  require'nvim-treesitter.configs'.setup {
    ensure_installed = "maintained",
    highlight = {
      enable = true,
      custom_captures = {
        ['include'] = 'Keyword',
        ['constant.builtin'] = 'Constant'
      }
    },
    bulk_fold = {
      enable = true,
    },
    indent = {
      enable = false
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
          ["a{"] = "@block.outer",
          ["i{"] = "@block.inner",
          ['ia'] = '@parameter.inner',
          ['aa'] = '@parameter.outer',
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

  vim.wo.foldmethod='expr'
  vim.wo.foldexpr='nvim_treesitter#foldexpr()'
end

return M
