setlocal cole=0
setlocal sw=4 ts=4

function! ClipPic()
    let fname = input('Image name: ')
    call system('pngpaste ' . fname . '.png')
    let line = getline('.')
    call setline('.', line . ' ![](' . fname . '.png)')
endfunction

nmap <leader>cp :call ClipPic()<CR>

setlocal comments=b:*,b:-,b:+,n:>
setlocal formatoptions+=ro
