if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

function! ToggleMaker()
    if len(g:neomake_rust_enabled_makers) > 0
        let g:neomake_rust_enabled_makers = []
    else
        let g:neomake_rust_enabled_makers = ['cargo']
    endif
endf

au filetype rust nmap <local> <leader>m :call ToggleMaker()<CR>

au BufRead *.rs :setlocal tags=./rusty-tags.vi;/,$RUST_SRC_PATH/rusty-tags.vi
au BufWrite *.rs :silent! exec "!rusty-tags vi --quiet --start-dir=" . expand('%:p:h') . "&"
