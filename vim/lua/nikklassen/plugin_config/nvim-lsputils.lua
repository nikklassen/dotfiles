local locations = require'lsputil.locations'
local symbols = require'lsputil.symbols'
local code_action = require'lsputil.codeAction'

local M = {}

function M.configure()
  local h = vim.lsp.handlers
  h['textDocument/codeAction'] = code_action.code_action_handler
  h['textDocument/references'] = locations.references_handler
  h['textDocument/definition'] = locations.definition_handler
  h['textDocument/declaration'] = locations.declaration_handler
  h['textDocument/typeDefinition'] = locations.typeDefinition_handler
  h['textDocument/implementation'] = locations.implementation_handler
  h['textDocument/documentSymbol'] = symbols.document_handler
  h['workspace/symbol'] = symbols.workspace_handler
end

return M
