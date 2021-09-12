setlocal omnifunc=necoghc#omnifunc
setlocal keywordprg=hoogle
setlocal tabstop=8
autocmd BufNewFile,BufRead *.hs normal zR
hi Conceal ctermbg=NONE

" Extend what Vim considers a keyword (to include . )
set iskeyword=a-z,A-Z,_,.,39

" autocmd BufWritePost *.hs GhcModCheckAndLintAsync

let &l:statusline = '%{empty(getqflist()) ? "[No Errors]" : "[Errors Found]"}' . (empty(&l:statusline) ? &statusline : &l:statusline)

nmap <Up> :cprev<CR>
nmap <Down> :cnext<CR>

nmap <silent> <C-G>c :GhcModCheckAsync<CR>
nmap <silent> <C-G>t :GhcModType!<CR>
nmap <silent> <C-G>i :GhcModInfo!<CR>
nmap <silent> <C-G>s :GhcModTypeInsert!<CR>
nmap <silent> <C-G>e :GhcModExpand!<CR>

nmap <C-L> :nohl \| redraw \| GhcModTypeClear<CR>
