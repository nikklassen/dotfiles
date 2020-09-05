autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
let NERDTreeIgnore = ['pyc$']
let NERDTreeQuitOnOpen = 1
let NERDTreeWinSize = 20

nmap <leader>n :NERDTreeToggle<CR>
nmap <leader>nf :NERDTreeFind<CR>
