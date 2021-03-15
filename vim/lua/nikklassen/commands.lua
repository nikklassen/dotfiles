vim.api.nvim_exec([[
" read the output of a shell command into a new scratch buffer
command! -nargs=* -complete=shellcmd R new | setlocal buftype=nofile bufhidden=hide noswapfile | r !<args>

autocmd BufWinEnter,WinEnter term://* startinsert
autocmd BufLeave             term://* stopinsert

command! Vterm vertical belowright split | term
]], false)
