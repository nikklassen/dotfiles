let g:Tex_CompileRule_pdf = "pdflatex -interaction=nonstopmode -file-line-error-style --shell-esc $*"
let g:ycm_min_num_of_chars_for_completion = 99
let g:ycm_min_num_identifier_candidate_chars = 99

omap a$ :<c-u>normal! F$vf$<cr>
omap i$ :<c-u>normal! T$vt$<cr>
