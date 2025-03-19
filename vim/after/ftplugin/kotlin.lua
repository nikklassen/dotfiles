vim.api.nvim_create_user_command('FixGetter', function()
  local n = vim.treesitter.get_node()
  if n == nil or n:type() ~= 'simple_identifier' then
    return
  end
  local value = vim.treesitter.get_node_text(n, 0)
  if not string.match(value, [[^get%u%w+]]) then
    return
  end
  local new_value = value:sub(4, 4):lower() .. value:sub(5)
  local start_row, start_col, _ = n:start()
  local end_row, end_col, _ = n:end_()
  vim.api.nvim_buf_set_text(0, start_row, start_col, end_row, end_col + 2, { new_value })
end, {
  nargs = 0
})

---@param n TSNode|nil
---@param type string
---@return TSNode?
local function find_parent_by_type(n, type)
  while true do
    if n == nil then
      return nil
    end
    if n:type() == type then
      return n
    end
    n = n:parent()
  end
end

vim.api.nvim_create_user_command('FixSetter', function()
  local setter = vim.treesitter.get_node()
  if setter == nil or setter:type() ~= 'simple_identifier' then
    return
  end

  local value = vim.treesitter.get_node_text(setter, 0)
  if not string.match(value, [[^set%u%w+]]) then
    return
  end

  local setter_end_row, setter_end_col, _ = setter:end_()

  local n = find_parent_by_type(vim.treesitter.get_node({
    pos = { setter_end_row, setter_end_col + 1 },
  }), 'call_suffix')
  if n == nil then
    return
  end

  local property = value:sub(4, 4):lower() .. value:sub(5)

  local start_row, start_col, _ = setter:start()
  local parens_start_row, parens_start_col, _ = n:start()
  local parens_end_row, parens_end_col, _ = n:end_()

  local set_value = vim.api.nvim_buf_get_text(0, parens_start_row, parens_start_col + 1, parens_end_row,
    parens_end_col - 1, {})
  set_value[1] = property .. ' = ' .. set_value[1]

  vim.api.nvim_buf_set_text(0, start_row, start_col - 1 --[[subtract 1 to include the .]], parens_end_row, parens_end_col,
    set_value)
end, {
  nargs = 0
})
