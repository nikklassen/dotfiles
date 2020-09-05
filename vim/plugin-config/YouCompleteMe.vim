let g:ycm_server_python_interpreter = '/usr/bin/python'
let g:ycm_semantic_triggers = {
  \ 'html' : ['<'],
  \ 'js,typescript,haskell,go' : ['.'],
  \ 'rust': ['::'],
  \ 'tex': ['{', '\'],
  \ }
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_complete_in_comments = 0
let g:ycm_complete_in_strings = 0
let g:ycm_add_preview_to_completeopt = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_min_num_of_chars_for_completion = 2
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
let g:ycm_confirm_extra_conf = 0
let g:ycm_filetype_blacklist = {
        \ 'pandoc' : 1,
        \ 'markdown' : 1,
        \ 'text': 1,
        \ 'gitcommit': 1,
        \ 'log': 1,
        \ 'tex': 1,
        \ 'less': 1,
        \ 'html': 1,
        \}
let g:ycm_rust_src_path = $RUST_SRC_PATH

nnoremap <F12> :YcmCompleter GoToDefinition<CR>
nnoremap gd <F12>
nnoremap K :YcmCompleter GetDoc<CR>
