local M = {}

local function open_completion()
  if vim.fn.pumvisible() == 1 then
    return
  end
  local trigger_characters = vim.b.trigger_characters or {}
  if vim.tbl_isempty(trigger_characters) then
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
      vim.list_extend(trigger_characters, client.server_capabilities.completionProvider.triggerCharacters)
    end
  end
  for _, tc in ipairs(trigger_characters) do
    if vim.v.char == tc then
      vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-x><C-o>', true, true, true), "n")
      return
    end
  end
end

function M.setup()
  vim.api.nvim_create_autocmd({ 'InsertCharPre' }, {
    pattern = '*',
    callback = open_completion
  })
  vim.keymap.set('i', '<C-Space>', '<C-x><C-o>')
  vim.keymap.set('i', '<Tab>', function()
    return vim.fn.pumvisible() == 1 and '<C-y>' or '<Tab>'
  end, { expr = true })
end

return M
