tnoremap <M-h> <C-\><C-n><C-w>h
tnoremap <M-j> <C-\><C-n><C-w>j
tnoremap <M-k> <C-\><C-n><C-w>k
tnoremap <M-l> <C-\><C-n><C-w>l

nnoremap <M-h> <C-w>h
nnoremap <M-j> <C-w>j
nnoremap <M-k> <C-w>k
nnoremap <M-l> <C-w>l

cnoremap <C-A> <Home>

let $NVIM = 1

" Neomake

let g:neomake_open_list = 2

au! BufWritePost * Neomake

let g:neomake_python_enabled_makers = ['pep8', 'pylint']
let g:neomake_python_pylint_cwd = '%:p:h'

let g:neomake_javascript_enabled_makers = ['eslint']
let g:neomake_javascript_eslint_cwd = '%:p:h'

" neovim-editcommand

let g:editcommand_prompt = '»'
