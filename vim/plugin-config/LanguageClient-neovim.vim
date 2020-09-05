let g:LanguageClient_serverCommands = {
    \ 'rust': ['rustup', 'run', 'stable', 'rls'],
    \ 'sh': ['bash-language-server', 'start'],
    \ 'typescript': ['typescript-language-server', '--stdio']
    \ }

nnoremap <F5> :call LanguageClient_contextMenu()<CR>
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
inoremap <silent> <M-k> <C-o>:call LanguageClient#textDocument_signatureHelp()<CR>
let g:LanguageClient_hasSnippetSupport = 0
