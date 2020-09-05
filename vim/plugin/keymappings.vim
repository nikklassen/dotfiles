map Y y$

nmap \<CR>   mrO<ESC>`r
imap \<CR>   <ESC>o

" Reindent whole file
nmap \=      mrgg=G`r

" Replace word under cursor with last yanked
nmap <leader>r      viw"0p
nmap <leader>R      V"0p

nmap <C-S> :w<CR>

nnoremap <silent> <space> @=(foldlevel('.') ? 'za' : "\<space>")<CR>

vnoremap <          <gv
vnoremap <leader><  <

vnoremap >          >gv
vnoremap <leader>>  >

nnoremap gp `[v`]

nnoremap <Left>     gT
nnoremap <Right>    gt
nnoremap <silent> <Up>   :if len(getqflist()) \| cprevious \| else \| lprevious \| endif<CR>
nnoremap <silent> <Down> :if len(getqflist()) \| cnext \| else \| lnext \| endif<CR>

nnoremap [q        :cprevious<CR>
nnoremap ]q        :cnext<CR>

nnoremap <M-Down>   ddp
nnoremap <M-Up>     ddkP

vnoremap <M-Down>   dpgv
vnoremap <M-Up>     dkPgv

nmap <leader>v      :tabe $MYVIMRC<CR>
nmap <leader>vn      :tabe $XDG_CONFIG_HOME/nvim/nvim.vim<CR>
exec "nmap <leader>vp :tabe " . g:PLUGINS_FILE . "<CR>"

nnoremap <M-h> <C-W>h
nnoremap <M-j> <C-W>j
nnoremap <M-k> <C-W>k
nnoremap <M-l> <C-W>l
nnoremap <M-c> <C-w>c

set pastetoggle=<F5>

noremap <F10> 1z=

" build
nnoremap <leader>m :w \| make<CR>

function! ExtendedHome()
    let column = col('.')
    normal! ^
    if column == col('.')
        normal! 0
    endif
endfunction

" Smart home
noremap <silent> <D-Left> :call ExtendedHome()<CR>

" 'Home' and 'End' for insert mode
inoremap <silent> <C-a> <C-O>:call ExtendedHome()<CR>
inoremap <C-e> <C-O>A

cnoremap <C-A> <Home>
cnoremap <M-b> <S-Left>
cnoremap <M-f> <S-Right>

noremap <leader>c :cd %:p:h<CR><CR>
noremap <leader>p :!open -a Skim '%:p:r.pdf'<CR><CR>

" Search for the currently selected text
vnoremap // "sy/<C-R>s<CR>

function! ReplaceCurrentWord()
    let new_word = input('New word: ')
    if new_word == ''
        return
    endif

    let w = expand('<cword>')
    let new_line = substitute(getline('.'), w, new_word, 'gI')
    call setline('.', new_line)
endfunction

nnoremap <leader>s :call ReplaceCurrentWord()<CR>

vnoremap <silent> <C-S> :sort<CR>

" Run selected lines
vnoremap <silent> <f2> :<c-u>exe join(getline("'<","'>"), "\n")<cr>

function! NumberToggle()
    if(&relativenumber == 1)
        set number
    else
        set relativenumber
    endif
endfunc

noremap <silent> <f3> :call NumberToggle()

nnoremap <BS> <c-^>
