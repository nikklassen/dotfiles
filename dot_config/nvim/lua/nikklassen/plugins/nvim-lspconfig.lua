return {
  {
    'nvimtools/none-ls.nvim',
    event = 'VeryLazy',
    main = 'null-ls',
    opts = function(_, opts)
      local kt_null_ls = require('nikklassen.lsp.kt-null-ls')
      opts.sources = { kt_null_ls }
      return opts
    end,
  },
  {
    'neovim/nvim-lspconfig',
    config = function()
      -- no-op, no setup function
    end,
  },
}
