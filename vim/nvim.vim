let $NVIM = 1

tnoremap <M-h> <C-\><C-n><C-w>h
tnoremap <M-j> <C-\><C-n><C-w>j
tnoremap <M-k> <C-\><C-n><C-w>k
tnoremap <M-l> <C-\><C-n><C-w>l

autocmd BufWinEnter,WinEnter term://* startinsert
autocmd BufLeave term://* stopinsert

command! Vterm vertical belowright split | term

set inccommand=nosplit

" Neomake

let g:neomake_open_list = 2
let g:neomake_list_height = 3

au! BufWritePost * Neomake

let g:neomake_python_enabled_makers = ['pylint']
let g:neomake_python_pylint_cwd = '%:p:h'

let g:neomake_javascript_enabled_makers = ['eslint']
let g:neomake_javascript_eslint_cwd = '%:p:h'

let g:neomake_typescript_tsc_args = ['--noEmit']

let g:neomake_rust_cargo_maker = {
            \ 'exe': 'cargo',
            \ 'args': ['build'],
            \ 'errorformat':
                \ '%-G%.%#help%.%#,'.
                \ '%-G%.%#note%.%#,'.
                \ '%A%f:%l:%c: %*\d:%*\d %t%*[^:]: %m,' .
                \ '%f:%l:%c: %t%*[^:]: %m[%.%*\d],' .
                \ '%+C%*[ ]expected %s,' .
                \ '%+Z%*[ ]found %s,' .
                \ '%-G%.%#',
            \ 'append_file': 0
            \ }
let g:neomake_rust_enabled_makers = ['cargo']
let g:neomake_cpp_enabled_makers = []
let g:neomake_tex_enabled_makers = []
let g:neomake_java_enabled_makers = []
let g:neomake_html_enabled_makers = []

" neovim-editcommand

let g:editcommand_prompt = '»'

" nvim-parinfer.js
function! ToggleParinfer()
    if g:parinfer_mode == "indent"
        echo "Switch to paren mode"
        let g:parinfer_mode = "paren"
    else
        echo "Switch to indent mode"
        let g:parinfer_mode = "indent"
    endif
endf

nnoremap <F6> :call ToggleParinfer()<CR>
