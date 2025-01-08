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
    "julienvincent/hunk.nvim",
    cmd = { "DiffEditor" },
    main = 'hunk',
    opts = {
      keys = {
        tree = {
          toggle_file = { '<Space>' }
        },
        diff = {
          toggle_line = { '<Space>' }
        }
      },
      hooks = {
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
    dependencies = {
      'MunifTanjim/nui.nvim',
    },
  },
  {
    'nvim-tree/nvim-web-devicons',
    lazy = true,
  },
  -- {
  --   'vim-scripts/ReplaceWithRegister',
  --   dependencies = { 'tpope/vim-repeat' },
  --   keys = { 'gr' },
  --   config = function()
  --     -- Neovim defaults that conflict with ReplaceWithRegister
  --     if vim.fn.maparg('gri', 'n') ~= '' then
  --       vim.keymap.del('n', 'gri')
  --     end
  --     if vim.fn.maparg('gra', 'n') ~= '' then
  --       vim.keymap.del('n', 'gra')
  --     end
  --   end,
  -- },
  {
    'echasnovski/mini.operators',
    keys = { 'cr', 'gx', 'g=', 'gs', 'gm' },
    opts = {
      replace = {
        prefix = 'cr'
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
    'saghen/blink.compat',
    version = '*',
    lazy = true,
    opts = {
      impersonate_nvim_cmp = true,
      debug = true,
    },
  },
  {
    'saghen/blink.cmp',
    lazy = false, -- lazy loading handled internally

    version = 'v0.*',
    -- build = 'cargo build --release',

    opts = {
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },

      appearance = {
        -- sets the fallback highlight groups to nvim-cmp's highlight groups
        -- useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release, assuming themes add support
        use_nvim_cmp_as_default = true,
      },

      completion = {
        list = {
          selection = {
            preselect = false,
          },
        },

        menu = {
          auto_show = true,
        },

        accept = {
          auto_brackets = {
            enabled = true,
            -- blocked_filetypes = { 'kotlin' },
          },
        },
      },

      keymap = {
        preset = 'super-tab',
        ['<C-y>'] = { 'select_and_accept' },
      },

      signature = {
        enabled = true,
      },
    },
    -- allows extending the providers array elsewhere in your config
    -- without having to redefine it
    opts_extend = { "sources.default" }
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      {
        'nvim-treesitter/nvim-treesitter-textobjects',
        config = function()
          require 'nikklassen.plugin_config.nvim-treesitter'.configure()
        end,
      },
    },
  },
  {
    'kylechui/nvim-surround',
    opts = {},
    event = "InsertEnter"
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
      render = "compact",
      stages = "fade",
      top_down = false,
    },
  },
  {
    'ii14/neorepl.nvim',
    cmd = { 'Repl' },
    config = function()
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
}
