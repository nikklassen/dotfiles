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
    cmd = 'S',
    keys = { 'cr' }
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
      'nvim-tree/nvim-web-devicons',
    },
  },
  {
    'vim-scripts/ReplaceWithRegister',
    dependencies = { 'tpope/vim-repeat' },
    keys = { 'gr' }
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
    'saghen/blink.cmp',
    lazy = false, -- lazy loading handled internally
    -- optional: provides snippets for the snippet source
    -- dependencies = 'rafamadriz/friendly-snippets',

    -- use a release tag to download pre-built binaries
    -- version = 'v0.*',
    -- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    build = 'cargo build --release',
    -- enabled = false,

    opts = {
      highlight = {
        -- sets the fallback highlight groups to nvim-cmp's highlight groups
        -- useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release, assuming themes add support
        use_nvim_cmp_as_default = true,
      },
      -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'normal',

      -- experimental auto-brackets support
      accept = {
        auto_brackets = {
          enabled = true,
          blocked_filetypes = { 'kotlin' },
        },
      },

      -- experimental signature help support
      trigger = { signature_help = { enabled = true } },

      keymap = {
        accept = { '<Tab>', '<CR>' },
      },
    },
  },
  {
    'hrsh7th/nvim-cmp',
    enabled = false,
    branch = 'main',
    event = 'InsertEnter',
    opts = {},
    main = 'nikklassen.plugin_config.nvim-cmp',
    dependencies = {
      {
        'hrsh7th/cmp-nvim-lsp',
        branch = 'main',
      },
      'ray-x/lsp_signature.nvim',
      'onsails/lspkind.nvim',
      {
        "zbirenbaum/copilot-cmp",
        event = 'LspAttach',
        cond = function()
          return vim.env.NVIM_DISABLE_COPILOT ~= '1'
        end,
        config = function()
          local copilot_cmp = require('copilot_cmp')
          copilot_cmp.setup {}
          vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
              local client = vim.lsp.get_client_by_id(args.data.client_id)
              if client.name == "copilot" then
                copilot_cmp._on_insert_enter({})
              end
            end,
          })
          vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
        end,
        dependencies = {
          {
            "zbirenbaum/copilot.lua",
            cmd = "Copilot",
            cond = function()
              return vim.env.NVIM_DISABLE_COPILOT ~= '1'
            end,
            event = "InsertEnter",
            main = 'copilot',
            opts = {
              suggestion = { enabled = true, auto_trigger = false },
              panel = { enabled = false },
            },
          },
        },
      },
    },
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
      vim.notify = require("notify")
    end,
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
  }
}
