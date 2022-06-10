vim.api.nvim_create_autocmd({'BufWinEnter', 'WinEnter'}, {
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
