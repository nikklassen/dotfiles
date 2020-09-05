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
