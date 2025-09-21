vim.api.nvim_create_autocmd('LspAttach', {
  pattern = '*.ts',
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then
      return
    end
    local bufnr = ev.buf
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)
    if lines == nil and #lines == 0 then
      return
    end
    if lines[1] ~= '//go:build js' then
      return
    end
    print('Setting GOARCH to wasm')
    client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
      gopls = {
        env = {
          GOOS = 'js',
          GOARCH = 'wasm',
        },
      },
    })

    client:notify('workspace/didChangeConfiguration', { settings = client.config.settings })
  end,
})

vim.lsp.config('gopls', {
  init_options = {
    usePlaceholders = true,
  },
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
        unusedwrite = true,
        nilness = true,
      },
      staticcheck = true,
      gofumpt = true,
      -- Doesn't highlight properties yet
      -- semanticTokens = true,
      usePlaceholders = true,
      templateExtensions = { 'tmpl' },
    },
  },
  on_attach = function(client, bufnr)
  end
})
vim.lsp.enable('gopls')
