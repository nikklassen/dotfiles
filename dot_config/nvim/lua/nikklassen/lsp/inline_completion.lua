local ms = vim.lsp.protocol.Methods

local M = {}

---@param item vim.lsp.inline_completion.Item
---@param mode 'word' | 'line'
local function accept_completion(item, mode)
  local insert_text = item.insert_text
  if type(insert_text) ~= 'string' then
    return item
  end
  local range = item.range
  if not range then
    return item
  end
  local lines = vim.split(insert_text, '\n')

  if mode == 'line' and #lines > 0 then
    vim.api.nvim_paste(lines[1], true, -1)
    return nil
  end

  local current_lines = vim.api.nvim_buf_get_text(
    range.buf,
    range.start_row,
    range.start_col,
    range.end_row,
    range.end_col,
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

  local word = string.match(lines[row]:sub(col), '[%s:]*[^%s][%w_]*[(%[]?[)%]]?')
  local text_to_insert = table.concat(vim.list_slice(lines, 1, row - 1), '\n')
      .. (row <= #current_lines and '' or '\n')
      .. (row <= #lines and col <= #lines[row] and lines[row]:sub(1, col - 1) or '')
      .. word

  vim.api.nvim_paste(text_to_insert, true, -1)
  return nil
end

---Configures inline completion for this buffer if the LSP supports it
---@param client vim.lsp.Client
---@param bufnr number
function M.attach(client, bufnr)
  if not client:supports_method(ms.textDocument_inlineCompletion, bufnr) then
    return
  end
  vim.lsp.inline_completion.enable(true, {
    -- client_id = client.id,
    bufnr = bufnr,
  })
  vim.keymap.set('i', '<C-CR>', function()
    if not vim.lsp.inline_completion.get({
          bufnr = bufnr,
          on_accept = function(item)
            local insert_text = item.insert_text
            if type(insert_text) == 'string' then
              vim.api.nvim_paste(insert_text, true, -1)
            else
              vim.api.nvim_paste(insert_text.value, true, -1)
            end
            return nil
          end,
        }) then
      return '<C-CR>'
    end
  end, {
    expr = true,
    replace_keycodes = true,
    desc = 'Get the current inline completion',
    buffer = bufnr,
  })
  vim.keymap.set('i', '<C-S-Right>', function()
    if not vim.lsp.inline_completion.get({
          bufnr = bufnr,
          on_accept = function(item)
            return accept_completion(item, 'line')
          end,
        }) then
      return '<C-S-Right>'
    end
  end, {
    expr = true,
    replace_keycodes = true,
    desc = 'Get the current inline completion word',
    buffer = bufnr,
  })
  vim.keymap.set('i', '<C-Right>', function()
    if not vim.lsp.inline_completion.get({
          bufnr = bufnr,
          on_accept = function(item)
            return accept_completion(item, 'word')
          end,
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
