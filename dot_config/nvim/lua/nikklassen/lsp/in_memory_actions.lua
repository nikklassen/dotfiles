local InMemoryClient = require('nikklassen.lsp.in_memory_client')
local go_code_actions = require('nikklassen.lsp.go_code_actions')
local kt_code_actions = require('nikklassen.lsp.kt_code_actions')

local function _handle_code_action(params)
  local uri = params.textDocument.uri
  local bufnr = vim.uri_to_bufnr(uri)
  if not vim.api.nvim_buf_is_loaded(bufnr) then
    return {}
  end

  local ft = vim.bo[bufnr].filetype

  if ft == 'go' then
    return go_code_actions.actions(bufnr, params)
  elseif ft == 'kotlin' then
    return kt_code_actions.actions(bufnr, params)
  end
end

return {
  cmd = function(dispatchers)
    local client = InMemoryClient.new(dispatchers, {
      capabilities = {
        codeActionProvider = true,
      },
    }, {
      ['textDocument/codeAction'] = _handle_code_action
    })
    return client:cmd()
  end,
  filetypes = { 'go', 'kotlin' },
}
