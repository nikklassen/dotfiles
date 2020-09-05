nnoremap gd   :LspDefinition<CR>  " gd in Normal mode triggers gotodefinition
nnoremap <F4> :LspReferences<CR>  " F4 in Normal mode shows all references

" Send async completion requests.
" WARNING: Might interfere with other completion plugins.
let g:lsp_async_completion = 1

" Enable UI for diagnostics
let g:lsp_signs_enabled = 1           " enable diagnostics signs in the gutter
let g:lsp_diagnostics_echo_cursor = 1 " enable echo under cursor when in normal mode

" Enabling fuzzy completion
let g:asyncomplete_smart_completion = 1
let g:asyncomplete_auto_popup = 1
let g:asyncomplete_default_refresh_pattern = '\k\+\.\k*$'
