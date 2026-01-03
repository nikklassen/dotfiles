local capabilities = require('nikklassen.lsp.capabilities')
local ms = vim.lsp.protocol.Methods

require('nikklassen.lsp.gopls')
require('nikklassen.lsp.jsonls')
require('nikklassen.lsp.lua_ls')
require('nikklassen.lsp.typescript')
require('nikklassen.lsp.svelte')

vim.diagnostic.config({
  virtual_lines = { current_line = true },
  signs = true,
  update_in_insert = false,
  underline = true,
  severity_sort = true,
})

if capabilities.DEBUG then
  if vim.fn.has('nvim-0.12.0') then
    vim.lsp.log.set_level('debug')
  else
    vim.lsp.set_log_level('debug')
  end
end

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then
      return
    end
    capabilities.on_attach(client, ev.buf)
  end,
})
vim.api.nvim_create_autocmd('LspDetach', {
  callback = function(ev)
    -- Get the detaching client
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then
      return
    end
    capabilities.on_detach(client, ev.buf)
  end,
})


vim.lsp.config('*', {
  capabilities = require('blink.cmp').get_lsp_capabilities()
})

vim.lsp.handlers[ms.client_registerCapability] = (function(overridden)
  return function(err, res, ctx)
    local result = overridden(err, res, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if not client then
      return
    end
    capabilities.on_attach(client, vim.api.nvim_get_current_buf())
    return result
  end
end)(vim.lsp.handlers[ms.client_registerCapability])

local servers = {
  eslint = {},
  vimls = {},
  cssls = {},
  bashls = {
    filetypes = { 'sh', 'zsh', 'bash' },
  },
  -- rust_analyzer = {
  --   cmd = { 'rustup', 'run', 'nightly', 'rust-analyzer' }
  -- },
  pyright = {},
  sqls = {
    cmd = { 'sqls', '-config', '.sqls-config.yml' },
    root_dir = function(start)
      local lsputil = require 'lspconfig.util'
      return lsputil.root_pattern('.sqls-config.yml')(start)
    end
  },
}
for server, server_config in pairs(servers) do
  vim.lsp.config(server, server_config)
  vim.lsp.enable(server)
end
