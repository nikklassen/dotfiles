let b:tex_flavor = 'pdflatex'
compiler tex
set makeprg=pdflatex\ \-file\-line\-error\ \-interaction=nonstopmode\ \-output\-directory\ %:p:h\ %
set errorformat=%f:%l:\ %m

noremap <C-J> 1z=
setlocal spell spelllang=en_ca
