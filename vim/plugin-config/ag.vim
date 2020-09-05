nnoremap <silent> <leader>ag :Ag <C-R><C-W><CR>
vnoremap <silent> <leader>ag "gy:Ag -Q "<C-R>=substitute(@g, '\\\@<!"', '\\"', 'g')<CR>"<CR>
