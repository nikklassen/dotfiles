vim.bo.ts = 2
vim.bo.sw = 2
vim.bo.sts = 2
vim.wo.list = false

local function go_test()
  local test_name = vim.fn.expand('<cword>')
  local dir_name = vim.fn.expand('%:.:h')
  vim.system({ 'tmux', 'send', '-t', ':.!', string.format([[go test -test.run="%s" "./%s"]] .. "\n", test_name, dir_name) })
end

vim.api.nvim_buf_create_user_command(0, 'GoTest', go_test, {})
