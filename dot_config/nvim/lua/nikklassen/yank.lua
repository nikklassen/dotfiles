local M = {}

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

function M.configure()
  vim.keymap.set('n', '<leader>y', function()
    local next = vim.fn.getcharstr()
    local op = M.keys[next]
    if op == nil then
      print('No mapping found for ' .. next)
      return
    end
    local to_yank = op()
    vim.fn.setreg('+', op())
    vim.notify('Yanked ' .. to_yank, vim.log.levels.INFO)
  end)
end

return M
