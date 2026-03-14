local M = {
  lsp_icons = {
    copilot = {
      text = '',
      highlight = 'CmpItemKindCopilot',
    },
  }
}

local function kind_icon_text(ctx)
  local icon = vim.tbl_get(M.lsp_icons, ctx.item.source_id, 'text') or ctx.kind_icon
  return icon .. ctx.icon_gap
end

local function kind_icon_highlight(ctx)
  return vim.tbl_get(M.lsp_icons, ctx.item.source_id, 'highlight') or ctx.kind_hl
end

local opts = {
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
          kind_icon = {
            text = kind_icon_text,
            highlight = kind_icon_highlight,
          },
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
    -- enabled = false,
    keymap = {
      preset = 'inherit',
      ['<C-e>'] = { 'cancel', 'fallback' },
    },
    completion = { menu = { auto_show = true } },
  },

  -- fuzzy = {
  --   sorts = {
  --     -- Blink default is reversed, sort_text seems better for Go. May need to customize this per language
  --     'sort_text',
  --     'score',
  --   },
  -- },
}

require('blink.cmp').setup(opts)

vim.lsp.config('*', {
  capabilities = require('blink.cmp').get_lsp_capabilities()
})
