return {
  {
    'saghen/blink.cmp',
    lazy = false, -- lazy loading handled internally

    version = 'v1.*',

    opts = {
      sources = {
        -- default = { 'lsp', 'path', 'snippets', 'buffer' },
        default = { 'lsp', 'path' },
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

      cmdline = {
        enabled = false,
        keymap = {
          preset = 'cmdline',
          ['<C-e>'] = { 'cancel', 'fallback' },
        },
      },

      -- fuzzy = {
      --   sorts = {
      --     -- Blink default is reversed, sort_text seems better for Go. May need to customize this per language
      --     'sort_text',
      --     'score',
      --   },
      -- },
    },
    -- allows extending the providers array elsewhere in your config
    -- without having to redefine it
    opts_extend = { 'sources.default' }
  },
}
