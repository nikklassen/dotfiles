local finders = require('nikklassen.treesitter.finders')

vim.bo.ts = 2
vim.bo.sw = 2
vim.bo.sts = 2
vim.wo.list = false

local function find_containing_function()
  local n = finders.parent_by_type(vim.treesitter.get_node(), 'function_declaration')
  if n == nil then
    return
  end
  local name = n:named_child(0)
  return vim.treesitter.get_node_text(name, 0)
end

---@param func boolean Test the specific function
local function go_test(func)
  local cmd = 'go test'
  if func then
    local test_name = find_containing_function()
    cmd = cmd .. string.format([[ -test.run="%s"]], test_name)
  end
  local dir_name = vim.fn.expand('%:.:h')
  cmd = cmd .. string.format([[ "./%s"]], dir_name)
  vim.system({ 'tmux', 'send', '-t', ':.!', cmd .. '\n' })
end

vim.api.nvim_buf_create_user_command(0, 'GoTest', function()
  go_test(false)
end, {})
vim.api.nvim_buf_create_user_command(0, 'GoTestCurrentFunction', function()
  go_test(true)
end, {})
