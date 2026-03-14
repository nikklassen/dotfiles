local kt_null_ls = require('nikklassen.lsp.kt-null-ls')
local go_null_ls = require('nikklassen.lsp.go-null-ls')

require('null-ls').setup({
  sources = {
    kt_null_ls,
    go_null_ls,
  },
})
