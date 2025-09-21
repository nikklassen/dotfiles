vim.api.nvim_create_autocmd('LspAttach', {
  pattern = '*.ts',
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then
      return
    end
    client:notify('workspace/didChangeConfiguration', {
      settings = {
        typescript = {
          format = {
            semicolons = 'remove',
          },
        },
      },
    })
  end,
})

vim.lsp.config('ts_ls', {
  init_options = {
    preferences = {
      quotePreference = 'single',
      importModuleSpecifierPreference = 'project-relative'
    },
  },
})
vim.lsp.enable('ts_ls')
