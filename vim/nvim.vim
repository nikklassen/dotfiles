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

hi NeomakeErrorSign ctermfg=white
hi NeomakeError term=underline ctermfg=darkgrey

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

" Deoplete
let g:deoplete#enable_at_startup = 1

" Language Service
let g:LanguageClient_serverCommands = {
    \ 'rust': ['rustup', 'run', 'stable', 'rls'],
    \ }

nnoremap <F5> :call LanguageClient_contextMenu()<CR>
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
let g:LanguageClient_hasSnippetSupport = 0

" Neoformat
augroup fmt
    autocmd!
    autocmd BufWritePre * undojoin | Neoformat
augroup END

let g:neoformat_rust_rustfmt = {
            \ 'exe': 'rustfmt',
            \ 'args': ['--emit stdout'],
            \ 'stdin': 1,
            \ 'no_append': 1,
            \ }

let g:neoformat_enabled_rust = ['rustfmt']
let g:neoformat_enabled_typescript = ['clang-format']
