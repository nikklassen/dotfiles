return {
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
            -- preselect = function(_) return not require('blink.cmp').snippet_active({ direction = 1 }) end
          }
        },

        menu = {
          auto_show = true,
          draw = {
            components = {
              kind_icon = require('nikklassen.plugin_config.blink').kind_icon
            },
          },
        },

        accept = {
          auto_brackets = {
            enabled = true,
            blocked_filetypes = { 'kotlin' },
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
}
