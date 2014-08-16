let b:tex_flavor = 'latex'
compiler tex
set makeprg=pdflatex\ \-file\-line\-error\ \-interaction=nonstopmode\ \-output\-directory\ %:p:h\ %
set errorformat=%f:%l:\ %m

setlocal spell spelllang=en_ca
