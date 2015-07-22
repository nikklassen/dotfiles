if !exists('g:build_less')
    let g:build_less = 1
endif

if g:build_less
    au BufWritePost *.less silent! !lessc % > %:r.css
endif

setlocal foldmethod=syntax
