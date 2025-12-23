vim.api.nvim_create_autocmd('LspAttach', {
  pattern = '*.go',
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then
      return
    end

    local bufnr = ev.buf
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)
    if lines ~= nil and #lines > 0 and lines[1] == '//go:build js' then
      print('Setting GOARCH to wasm')
      client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
        gopls = {
          env = {
            GOOS = 'js',
            GOARCH = 'wasm',
          },
        },
      })
    end

    client:notify('workspace/didChangeConfiguration', { settings = client.config.settings })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'gotmpl',
  callback = function()
    --- Disable the 'macro' highlight group coming from gopls (which highlights all the tokens)
    vim.cmd([[
      hi link @lsp.type.macro.gotmpl NONE
    ]])
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
      codelenses = {
        gc_details = false,
        generate = true,
        regenerate_cgo = true,
        run_govulncheck = true,
        test = true,
        tidy = true,
        upgrade_dependency = true,
        vendor = true,
      },
      semanticTokens = true,
      usePlaceholders = true,
      templateExtensions = { 'tmpl' },
    },
  },
})
vim.lsp.enable('gopls')
