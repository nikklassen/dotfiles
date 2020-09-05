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
let g:neoformat_enabled_go = ['goimports']
