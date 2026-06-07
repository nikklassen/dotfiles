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
  if #lines == 0 then
    return nil
  end

  local bufnr = range.buf
  if bufnr == 0 then
    bufnr = vim.api.nvim_get_current_buf()
  end

  local start_row, start_col, end_row, end_col = range:to_extmark()

  local lines_to_insert
  local replace_to_row
  local replace_to_col

  if mode == 'line' then
    lines_to_insert = { lines[1] }
    if end_row == start_row then
      replace_to_row = end_row
      replace_to_col = end_col
    else
      replace_to_row = start_row
      local line_text = vim.api.nvim_buf_get_lines(bufnr, start_row, start_row + 1, false)[1] or ''
      replace_to_col = #line_text
    end
  else
    -- word mode
    local current_lines = vim.api.nvim_buf_get_text(
      bufnr,
      start_row,
      start_col,
      end_row,
      end_col,
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
      and lines[row]:sub(col, col) == current_lines[row]:sub(col, col)
    do
      col = col + 1
    end

    if row > #lines then
      return nil
    end

    local word = string.match(lines[row]:sub(col), '[%s:]*[^%s][%w_]*[(%[]?[)%]]?')
    if not word then
      word = lines[row]:sub(col)
    end

    lines_to_insert = vim.list_slice(lines, 1, row - 1)
    local last_line = lines[row]:sub(1, col - 1) .. word
    table.insert(lines_to_insert, last_line)

    replace_to_row = start_row + row - 1
    replace_to_col = (row == 1 and start_col or 0) + col - 1

    if replace_to_row > end_row then
      replace_to_row = end_row
      replace_to_col = end_col
    elseif replace_to_row == end_row and replace_to_col > end_col then
      replace_to_col = end_col
    end
  end

  -- Atomic replace/insert
  vim.api.nvim_buf_set_text(bufnr, start_row, start_col, replace_to_row, replace_to_col, lines_to_insert)

  -- Move cursor to the end of the inserted text
  local win = vim.api.nvim_get_current_win()
  if vim.api.nvim_win_get_buf(win) == bufnr then
    local last_line_len = #lines_to_insert[#lines_to_insert]
    local new_row = start_row + #lines_to_insert
    local new_col = (#lines_to_insert == 1 and start_col or 0) + last_line_len
    vim.api.nvim_win_set_cursor(win, { new_row, new_col })
  end

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
    if not vim.lsp.inline_completion.get({ bufnr = bufnr }) then
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
