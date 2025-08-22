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
    -- 'mhinz/vim-signify',
    'vim-signify',
    url = 'https://github.com/eyvind/vim-signify',
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
      { 'ga', '<Plug>(abolish-coerce-word)', mode = { 'n' }, desc = 'coerce word' },
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
  {
    'jremmen/vim-ripgrep',
    cmd = 'Rg',
  },

  {
    'ludovicchabant/vim-lawrencium',
    cond = function()
      return utils.is_cwd_readable() and not vim.tbl_isempty(vim.fs.find('.hg', { upward = true }))
    end,
    cmd = { 'Hg' }
  },

  -- Rust
  { 'rust-lang/rust.vim', ft = 'rust' },

  -------------------
  -- Other plugins --
  -------------------
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    config = function()
      require 'nikklassen.plugin_config.nvim-treesitter'.configure()
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile' },
  },
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
    'ii14/neorepl.nvim',
    cmd = { 'Repl' },
    config = function()
      require('neorepl').config({
        lang = 'lua'
      })
      vim.api.nvim_create_user_command('Repl', function()
        -- create a new split for the repl
        vim.cmd('split')
        -- spawn repl and set the context to our buffer
        require('neorepl').new {
          buffer = 0,
          window = 0,
        }
        -- resize repl window and make it fixed height
        vim.cmd('resize 10 | setl winfixheight')
      end, { bang = true })
    end
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
      disabled_filetypes = { 'qf', 'NvimTree', 'lazy', 'hunk' },
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
    'coder/claudecode.nvim',
    enabled = function()
      return vim.env.NVIM_ENABLE_CLAUDE ~= '0'
    end,
    cmd = {
      'ClaudeCode',
      'ClaudeCodeSend',
    },
    keys = {
      { '<leader>as', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Send to Claude' },
    },
    -- config = true,
    opts = {
      -- log_level = 'debug',
      terminal = {
        provider = 'native'
      }
    },
  },
}
