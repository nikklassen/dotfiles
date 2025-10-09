local ms = vim.lsp.protocol.Methods

local M = {}

local function accept_completion(item, mode)
  local insert_text = item.insert_text
  if type(insert_text) == 'string' then
    local range = item.range
    if range then
      local lines = vim.split(insert_text, '\n')
      local current_lines = vim.api.nvim_buf_get_text(
        range.start.buf,
        range.start.row,
        range.start.col,
        range.end_.row,
        range.end_.col,
        {}
      )

      if mode == 'word' then
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

        local word = string.match(lines[row]:sub(col), '%s*[^%s]%w*')
        -- vim.print(
        --   range.start.buf,
        --   math.min(range.start.row + row - 1, range.end_.row),
        --   row == #current_lines and math.min(range.start.col + col - 1, range.end_.col)
        --   or math.min(col - 1, range.end_.col),
        --   range.end_.row,
        --   range.end_.col,
        --   { word }
        -- )

        vim.api.nvim_buf_set_text(
          range.start.buf,
          math.min(range.start.row + row - 1, range.end_.row),
          row <= #current_lines and (row == 1 and range.start.col + col - 1 or col - 1) or range.end_.col,
          range.end_.row,
          range.end_.col,
          row <= #current_lines and { word } or { '', word }
        )
        local pos = item.range.start:to_cursor()
        vim.api.nvim_win_set_cursor(vim.fn.bufwinid(range.start.buf), {
          pos[1] + row - 1,
          pos[2] + col - 1 + #lines[1] - 1,
        })
      else
        vim.api.nvim_buf_set_text(
          range.start.buf,
          range.start.row,
          range.start.col,
          range.end_.row,
          range.end_.col,
          lines
        )
        local pos = item.range.start:to_cursor()
        vim.api.nvim_win_set_cursor(vim.fn.bufwinid(range.start.buf), {
          pos[1] + #lines - 1,
          (#lines == 1 and pos[2] or 0) + #lines[#lines],
        })
      end
    else
      vim.api.nvim_paste(insert_text, false, 0)
    end
  elseif insert_text.kind == 'snippet' then
    vim.snippet.expand(insert_text.value)
  end

  -- Execute the command *after* inserting this completion.
  if item.command then
    local client = assert(vim.lsp.get_client_by_id(item.client_id))
    client:exec_cmd(item.command, { bufnr = item.range.start.buf })
  end
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
          on_accept = accept_completion,
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
          on_accept = function(item)
            accept_completion(item, 'word')
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
