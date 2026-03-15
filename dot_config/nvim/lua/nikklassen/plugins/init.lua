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
  {
    'mhinz/vim-signify',
    config = function()
      vim.g.signify_number_highlight = 1
      vim.g.signify_sign_change = '~'
    end,
    event = 'VeryLazy'
  },
  -- Abolish provides the :S command, and case coercion
  {
    'tpope/vim-abolish',
    cmd = { 'S' },
    keys = {
      { 'ga', '<Plug>(abolish-coerce-word)', mode = { 'n', 'v' }, desc = 'coerce word' },
    },
    init = function()
      vim.g.abolish_no_mappings = 1
    end,
  },
  {
    'whiteinge/diffconflicts',
    cmd = { 'DiffConflicts' },
  },
  {
    'MunifTanjim/nui.nvim',
    lazy = true,
  },
  {
    'julienvincent/hunk.nvim',
    cmd = { 'DiffEditor' },
    main = 'hunk',
    opts = {
      keys = {
        global = {
          -- "hunk accept"
          accept = { '<leader>ha' },
        },
        tree = {
          toggle_file = { '<Space>' }
        },
        diff = {
          toggle_line = { '<Space>' }
        }
      },
      hooks = {
        on_tree_mount = function()
          vim.bo.ft = 'hunk'
        end,
        on_diff_mount = function(context)
          vim.keymap.set('n', '<Up>', '[c', {
            buffer = context.buf
          })
          vim.keymap.set('n', '<Down>', ']c', {
            buffer = context.buf
          })
          vim.cmd('normal ]c')
        end,
      },
    },
  },
  {
    'nvim-tree/nvim-web-devicons',
    lazy = true,
  },
  {
    'echasnovski/mini.operators',
    keys = {
      { 'cr', mode = { 'n', 'v' } },
      { 'gx', mode = { 'n', 'v' } },
      { 'g=', mode = { 'n', 'v' } },
      { 'gs', mode = { 'n', 'v' } },
      { 'gm', mode = { 'n', 'v' } },
    },
    opts = {
      replace = {
        prefix = 'cr',
      },
    },
  },

  -------------------
  -- Other plugins --
  -------------------
  {
    'kylechui/nvim-surround',
    opts = require('nikklassen.plugin_config.nvim-surround'),
    event = 'InsertEnter',
    keys = { 'ds', 'ys' }
  },
  {
    'tpope/vim-eunuch',
    cond = function() return vim.fn.has('win32') == 0 end,
    config = function()
      vim.g.eunuch_no_maps = true
    end,
    cmd = { 'Move', 'Rename', 'Copy', 'Remove', 'Mkdir', 'Chmod', 'Chown' }
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
  {
    'rcarriga/nvim-notify',
    config = function()
      vim.notify = require('notify')
    end,
    opts = {
      timeout = 3000,
      render = 'compact',
      stages = 'fade',
      top_down = false,
    },
  },
  {
    'gregorias/coop.nvim',
  },
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      keymaps = {
        ['<C-s>'] = false,
        ['<C-v>'] = { 'actions.select', opts = { vertical = true } },
      }
    },
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
    keys = {
      { '<leader>o', '<cmd>execute "edit " .. expand("%:h")<CR>', desc = 'Edit current file\'s directory with oil' },
    },
  },
  {
    'phelipetls/jsonpath.nvim',
    ft = { 'json' },
  },
  {
    'm4xshen/hardtime.nvim',
    opts = {
      disabled_filetypes = { 'qf', 'NvimTree', 'lazy', 'hunk', 'TelescopePrompt' },
      disabled_keys = {
        ['<Up>'] = false,
        ['<Down>'] = false,
      },
      hints = {
        ['d%$'] = nil,
        ['[^g]d%$'] = {
          message = function()
            return 'Use D instead of d$'
          end,
          length = 3,
        },
      },
    },
  },
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { '`',     mode = { 'n', 'x', 'o' }, function() require('flash').jump() end,              desc = 'Flash' },
      { 'S',     mode = { 'n', 'x', 'o' }, function() require('flash').treesitter() end,        desc = 'Flash Treesitter' },
      { 'r',     mode = 'o',               function() require('flash').remote() end,            desc = 'Remote Flash' },
      { 'R',     mode = { 'o', 'x' },      function() require('flash').treesitter_search() end, desc = 'Treesitter Search' },
      { '<c-s>', mode = { 'c' },           function() require('flash').toggle() end,            desc = 'Toggle Flash Search' },
    },
  },
  {
    'esmuellert/codediff.nvim',
    branch = 'next',
    cmd = 'CodeDiff',
  }
}
