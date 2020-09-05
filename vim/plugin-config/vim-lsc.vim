let g:lsc_auto_map = {
  \ 'GoToDefinition': 'gd',
  \ }
inoremap <M-k> <C-o>:LSClientSignatureHelp<CR>
autocmd InsertLeave * pclose
let g:lsc_server_commands = {
    \ 'rust': 'rustup run stable rls',
    \ 'sh': 'bash-language-server start',
    \ 'typescript': 'typescript-language-server --stdio'
    \ }

let g:lsc_enable_autocomplete = v:false
set omnifunc=lsc#complete#complete
