vim.api.nvim_create_autocmd({ 'BufWinEnter', 'WinEnter' }, {
  pattern = 'term://*',
  command = 'startinsert',
})
vim.api.nvim_create_autocmd('BufLeave', {
  pattern = 'term://*',
  command = 'stopinsert',
})

vim.api.nvim_create_autocmd('BufRead', {
  pattern = '*',
  command = 'if &diff | set wrap | endif',
})

-- read the output of a shell command into a new scratch buffer
vim.api.nvim_create_user_command('R', 'new | setlocal buftype=nofile bufhidden=hide noswapfile | r !<args>', {
  nargs = '*',
  complete = 'shellcmd',
})
vim.api.nvim_create_user_command('Vterm', 'vertical belowright split | term', {})

local function go_test()
  local test_name = vim.fn.expand('<cword>')
  local dir_name = vim.fn.expand('%:.:h')
  vim.system({ 'tmux', 'send', '-t', ':.!', string.format([[go test -test.run="%s" "./%s"]], test_name, dir_name) })
end

vim.api.nvim_create_user_command('GoTest', go_test, {})

vim.api.nvim_create_autocmd('LspProgress', {
  pattern = '*',
  command = 'redrawstatus',
})
