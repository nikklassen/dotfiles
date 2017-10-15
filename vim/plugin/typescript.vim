if exists('g:loaded_nik_typescript')
  finish
endif
let g:loaded_nik_typescript = 1

function! TSEdit(extension, split)
    if a:split
        let edit_cmd = 'rightbelow vsplit'
    else
        let edit_cmd = 'edit'
    endif
    if expand('%:t:r') =~ 'component'
        let new_file = substitute(expand('%'), 'component\.\zs.*$', a:extension, '')
        exec edit_cmd . ' ' . new_file
    else
        echoerr 'File is not part of a typescript component'
    endif
endfunction

function! TSFindComponent()
    let selector = expand('<cword>')
    let comp = system("ag -l \"selector:\\s*['\\\"]" . selector . '"')
    if comp != ''
        exec 'edit ' . comp
    else
        echom "No component found for selector: " . selector
    endif
endfunction

command! -nargs=0 TSView call TSEdit('html', 0)
command! -nargs=0 VTSView call TSEdit('html', 1)
command! -nargs=0 TSSpec call TSEdit('spec.ts', 0)
command! -nargs=0 VTSSpec call TSEdit('spec.ts', 1)
command! -nargs=0 TSComp call TSEdit('ts', 0)
command! -nargs=0 VTSComp call TSEdit('ts', 1)
command! -nargs=0 TSStyle call TSEdit('scss', 0)
command! -nargs=0 VTSStyle call TSEdit('scss', 1)
nnoremap <leader>tv :TSView<CR>
nnoremap <leader>tt :TSSpec<CR>
nnoremap <leader>tc :TSComp<CR>
nnoremap <leader>ts :TSStyle<CR>

au BufRead,BufNewFile *.html nnoremap <silent> gd :call TSFindComponent()<CR>
