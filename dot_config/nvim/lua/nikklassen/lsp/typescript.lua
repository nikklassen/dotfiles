-- local lsp = 'tsgo'
local lsp = 'ts_ls'

vim.api.nvim_create_autocmd('LspAttach', {
  pattern = { '*.ts', '*.js' },
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then
      return
    end
    local common_options = {
      format = {
        semicolons = 'remove',
        indentSize = 2,
      },
      inlayHints = {
        includeInlayVariableTypeHints = true,
      },
    }
    client:notify('workspace/didChangeConfiguration', {
      settings = {
        typescript = common_options,
        javascript = common_options,
      },
    })
  end,
})

vim.lsp.config(lsp, {
  init_options = {
    preferences = {
      quotePreference = 'single',
      importModuleSpecifierPreference = 'project-relative'
    },
  },
})
vim.lsp.enable(lsp)
