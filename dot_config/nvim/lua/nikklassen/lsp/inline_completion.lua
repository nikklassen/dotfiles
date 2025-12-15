local ms = vim.lsp.protocol.Methods

local M = {}

local function accept_completion(item)
  local insert_text = item.insert_text
  if type(insert_text) ~= 'string' then
    return item
  end
  local range = item.range
  if not range then
    return item
  end
  local lines = vim.split(insert_text, '\n')
  local current_lines = vim.api.nvim_buf_get_text(
    range.start.buf,
    range.start.row,
    range.start.col,
    range.end_.row,
    range.end_.col,
    {}
  )

  local row = 1
  while row <= #lines and row <= #current_lines and lines[row] == current_lines[row] do
    row = row + 1
  end

  local col = 1
  while
    row <= #lines
    and col <= #lines[row]
    and row <= #current_lines
    and col <= #current_lines[row]
    and lines[row][col] == current_lines[row][col]
  do
    col = col + 1
  end

  local word = string.match(lines[row]:sub(col), '%s*[^%s][%w_]*[(%[]?[)%]]?')
  item.insert_text = table.concat(vim.list_slice(lines, 1, row - 1), '\n')
      .. (row <= #current_lines and '' or '\n')
      .. (row <= #lines and col <= #lines[row] and lines[row]:sub(1, col - 1) or '')
      .. word

  return item
end

---Configures inline completion for this buffer if the LSP supports it
---@param client vim.lsp.Client
---@param bufnr number
function M.attach(client, bufnr)
  if not vim.fn.has('nvim-0.12.0') or not client:supports_method(ms.textDocument_inlineCompletion, bufnr) then
    return
  end
  vim.lsp.inline_completion.enable(true, {
    -- client_id = client.id,
    bufnr = bufnr,
  })
  vim.keymap.set('i', '<C-CR>', function()
    if not vim.lsp.inline_completion.get({
          bufnr = bufnr,
        }) then
      return '<C-CR>'
    end
  end, {
    expr = true,
    replace_keycodes = true,
    desc = 'Get the current inline completion',
    buffer = bufnr,
  })
  vim.keymap.set('i', '<C-Right>', function()
    if not vim.lsp.inline_completion.get({
          bufnr = bufnr,
          on_accept = accept_completion,
        }) then
      return '<C-Right>'
    end
  end, {
    expr = true,
    replace_keycodes = true,
    desc = 'Get the current inline completion word',
    buffer = bufnr,
  })
end

return M
