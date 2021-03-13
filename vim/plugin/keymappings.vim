map Y y$

" Reindent whole file
nmap \=      mrgg=G`r

nmap <C-S> <cmd>w<CR>

nnoremap <silent> <expr> <space> foldlevel('.') ? 'za' : '<space>'

vnoremap <          <gv
vnoremap <leader><  <

vnoremap >          >gv
vnoremap <leader>>  >

nnoremap gp `[v`]

nnoremap <Left>     gT
nnoremap <Right>    gt

nnoremap <F4> :cnext<CR>
" Shift F4
nnoremap <F16> :cprevious<CR>

nnoremap <M-Down>   ddp
nnoremap <M-Up>     ddkP

vnoremap <M-Down>   dpgv
vnoremap <M-Up>     dkPgv

nmap <leader>v  <cmd>exe 'tabe ' . stdpath('config') . '/init.lua'<CR>
nmap <leader>vp <cmd>exe 'tabe ' . stdpath('config') . '/lua/nikklassen/plugins.lua'<CR>

nnoremap <M-h> <C-W>h
nnoremap <M-j> <C-W>j
nnoremap <M-k> <C-W>k
nnoremap <M-l> <C-W>l
nnoremap <M-c> <C-w>c

set pastetoggle=<F5>

noremap <F10> 1z=

" build
nnoremap <leader>m <cmd>w \| make<CR>

function! ExtendedHome()
    let column = col('.')
    normal! ^
    if column == col('.')
        normal! 0
    endif
endfunction

" Smart home
noremap <silent> <D-Left> <cmd>call ExtendedHome()<CR>

" 'Home' and 'End' for insert mode
inoremap <silent> <C-a> <cmd>call ExtendedHome()<CR>
inoremap <expr> <C-e> pumvisible() ? '<C-e>' : '<C-O>A'

cnoremap <C-A> <Home>
cnoremap <M-b> <S-Left>
cnoremap <M-f> <S-Right>

noremap <leader>c :cd %:p:h<CR><CR>

function! ReplaceCurrentWord()
    let new_word = input('New word: ')
    if new_word == ''
        return
    endif

    let w = expand('<cword>')
    let new_line = substitute(getline('.'), w, new_word, 'gI')
    call setline('.', new_line)
endfunction

nnoremap <leader>s <cmd>call ReplaceCurrentWord()<CR>

vnoremap <silent> <C-S> <cmd>'<,'>sort<CR>

" Run selected lines
vnoremap <silent> <f2> <cmd>exe join(getline("'<","'>"), "\n")<cr>

function! NumberToggle()
    if(&relativenumber == 1)
        set number
    else
        set relativenumber
    endif
endfunc

noremap <silent> <f3> <cmd>call NumberToggle()<CR>

nnoremap <BS> <c-^>

nnoremap ZA <cmd>wqa<CR>
