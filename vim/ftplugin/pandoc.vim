setlocal cole=0
setlocal sw=4 ts=4

function! ClipPic()
    let fname = input('Image name: ')
    call system('pngpaste ' . fname . '.png')
    let line = getline('.')
    call setline('.', line . ' ![](' . fname . '.png)')
endfunction

let s:sdir = expand('<sfile>:p:h')
function! NextPage()
    call system('osascript ' . s:sdir . '/advance_page.applescript +')
endfunction

function! PrevPage()
    call system('osascript ' . s:sdir . '/advance_page.applescript -')
endfunction

nmap <leader>cp :call ClipPic()<CR>

imap <silent> <F6> :call PrevPage()<CR><Right>
imap <silent> <F7> :call NextPage()<CR><Right>

nmap <silent> <F6> :call PrevPage()<CR>
nmap <silent> <F7> :call NextPage()<CR>

setlocal comments=b:*,b:-,b:+,n:>
setlocal formatoptions+=ro
