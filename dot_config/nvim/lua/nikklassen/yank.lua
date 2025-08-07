local M = {
  _buffer_keys = {}
}

M.keys = {
  -- "yank to clipboard"
  ['c'] = function()
    return vim.fn.getreg('"')
  end,
  -- "yank filename"
  ['f'] = function()
    return vim.fn.fnamemodify(vim.fn.expand('%'), ':~:.')
  end,
}

function M.set_buffer_key(key, op)
  local bufnr = vim.fn.bufnr()
  local keys = M._buffer_keys[bufnr]
  if keys == nil then
    keys = {}
    M._buffer_keys[bufnr] = keys
  end
  keys[key] = op
end

function M.configure()
  vim.keymap.set('n', '<leader>y', function()
    local next = vim.fn.getcharstr()

    local op
    local bufnr = vim.fn.bufnr()
    local keys = M._buffer_keys[bufnr]
    if keys ~= nil and keys[next] ~= nil then
      op = keys[next]
    else
      op = M.keys[next]
    end
    if op == nil then
      vim.notify('No yank mapping found for ' .. next, vim.log.levels.ERROR)
      return
    end
    local to_yank = op()
    if to_yank == nil then
      vim.notify('Mapping for ' .. next .. ' did not return a value', vim.log.levels.ERROR)
      return
    end
    vim.fn.setreg('+', to_yank)
    vim.notify('Yanked ' .. to_yank, vim.log.levels.INFO)
  end)
end

return M
