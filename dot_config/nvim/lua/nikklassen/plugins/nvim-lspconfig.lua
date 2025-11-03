return {
  {
    'nvimtools/none-ls.nvim',
    event = 'VeryLazy',
    main = 'null-ls',
    opts = function(_, opts)
      local kt_null_ls = require('nikklassen.lsp.kt-null-ls')
      local go_null_ls = require('nikklassen.lsp.go-null-ls')
      opts.sources = { kt_null_ls, go_null_ls }
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
