local function configure_treesitter(_, opts)
  local ts = require('nvim-treesitter')
  -- local queries = require 'nvim-treesitter.query'
  -- require 'nvim-treesitter'.define_modules {
  --   bulk_fold = {
  --     module_path = 'nikklassen.bulk-folds',
  --     is_supported = function(lang)
  --       return queries.has_query_files(lang, 'bulk_folds')
  --     end
  --   }
  -- }
  local file_types = {
    'bash',
    'cpp',
    'css',
    'dockerfile',
    'go',
    'gomod',
    'gotmpl',
    'html',
    'http',
    'java',
    'javascript',
    'jq',
    'json',
    'kotlin',
    'latex',
    'markdown',
    'proto',
    'python',
    'rust',
    'scss',
    'sql',
    'svelte',
    'terraform',
    'textproto',
    'toml',
    'tsx',
    'typescript',
    'yaml',
    'zsh',
  }
  ts.setup(opts)
  ts.install(file_types)
  vim.api.nvim_create_autocmd('FileType', {
    pattern = file_types,
    callback = function()
      vim.treesitter.start()
      vim.cmd('setlocal spell')
    end,
  })
end

local function configure_textobjects(_, opts)
  require('nvim-treesitter-textobjects').setup(opts)
  vim.api.nvim_create_autocmd('FileType', {
    callback = function(ev)
      local bufnr = ev.buf
      local lang = ev.match
      if vim.fn.bufloaded(bufnr) == 0 then
        return
      end
      local parser = vim.treesitter.get_parser(bufnr, lang, {
        error = false
      })
      if not parser then
        return
      end
      local select_keymaps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ia'] = '@parameter.inner',
        ['aa'] = '@parameter.outer',
        ['ii'] = '@field.inner',
        ['ai'] = '@field.outer',
        ['ic'] = '@class.inner',
        ['ac'] = '@class.outer',
        ['i='] = '@assignment.rhs',
        ['a='] = '@assignment.outer',
        ['al'] = '@call.outer',
        ['il'] = '@call.inner',
        ['ap'] = '@block.outer',
        ['ip'] = '@block.inner',
      }
      for keys, selector in pairs(select_keymaps) do
        vim.keymap.set({ 'x', 'o' }, keys, function()
          require('nvim-treesitter-textobjects.select').select_textobject(selector, 'textobjects')
        end, { buffer = bufnr })
      end
      local next_movements = {
        [']m'] = '@function.outer'
      }
      for keys, selector in pairs(next_movements) do
        vim.keymap.set({ 'n', 'x', 'o' }, keys, function()
          require('nvim-treesitter-textobjects.move').goto_next_start(selector, 'textobjects')
        end, { buffer = bufnr })
      end
      local previous_movements = {
        ['[m'] = '@function.outer'
      }
      for keys, selector in pairs(previous_movements) do
        vim.keymap.set({ 'n', 'x', 'o' }, keys, function()
          require('nvim-treesitter-textobjects.move').goto_previous_start(selector, 'textobjects')
        end, { buffer = bufnr })
      end
    end,
  })
end

return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = 'gnn',
          node_incremental = 'gn)',
          scope_incremental = 'gns',
          node_decremental = 'gn(',
        },
      },
      playground = {
        enable = true,
        disable = {},
        updatetime = 25,        -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = false -- Whether the query persists across vim sessions
      },
    },
    config = configure_treesitter,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    config = true,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    event = 'VeryLazy',
    opts = {
      select = {
        enable = true,
        -- include_surrounding_whitespace = true,
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
      },
    },
    config = configure_textobjects,
  },
}
