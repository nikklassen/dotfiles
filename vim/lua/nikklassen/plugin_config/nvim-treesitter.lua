
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
  require'nvim-treesitter'.define_modules {
      spell = {
          attach = function ()
              vim.cmd('setlocal spell')
          end,
          detach = function () end,
      },
  }
  require'nvim-treesitter.configs'.setup {
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
      custom_captures = {
        -- ['include'] = 'Keyword',
        -- ['constant.builtin'] = 'Constant'
      },
      -- disable = function(lang, bufnr) -- Disable in large Go buffers
      --   -- return lang == "go" and vim.api.nvim_buf_line_count(bufnr) > 3000
      -- end,
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
          ["a>"] = "@block.outer",
          ["i>"] = "@block.inner",
          ['ia'] = '@parameter.inner',
          ['aa'] = '@parameter.outer',
          ['i:'] = '@element.inner',
          ['a:'] = '@element.outer',
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
