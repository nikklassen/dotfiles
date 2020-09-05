let $NVIM = 1

tnoremap <M-h> <C-\><C-n><C-w>h
tnoremap <M-j> <C-\><C-n><C-w>j
tnoremap <M-k> <C-\><C-n><C-w>k
tnoremap <M-l> <C-\><C-n><C-w>l

autocmd BufWinEnter,WinEnter term://* startinsert
autocmd BufLeave term://* stopinsert

command! Vterm vertical belowright split | term

set inccommand=nosplit
