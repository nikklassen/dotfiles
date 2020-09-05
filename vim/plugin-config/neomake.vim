let g:neomake_open_list = 2
let g:neomake_list_height = 3

au! BufWritePost * Neomake

" let g:neomake_python_enabled_makers = ['pylint']
let g:neomake_python_pylint_cwd = '%:p:h'
let g:neomake_python_glint_maker = {
  \ 'exe': 'glint'
  \ }
let g:neomake_python_enabled_makers = ['glint']

let g:neomake_javascript_enabled_makers = ['eslint']
let g:neomake_javascript_eslint_cwd = '%:p:h'

" let g:neomake_typescript_tsc_args = ['--noEmit']

let g:neomake_rust_cargo_maker = {
            \ 'exe': 'cargo',
            \ 'args': ['build'],
            \ 'errorformat':
                \ '%-G%.%#help%.%#,'.
                \ '%-G%.%#note%.%#,'.
                \ '%A%f:%l:%c: %*\d:%*\d %t%*[^:]: %m,' .
                \ '%f:%l:%c: %t%*[^:]: %m[%.%*\d],' .
                \ '%+C%*[ ]expected %s,' .
                \ '%+Z%*[ ]found %s,' .
                \ '%-G%.%#',
            \ 'append_file': 0
            \ }
let g:neomake_rust_enabled_makers = ['cargo']
let g:neomake_cpp_enabled_makers = []
let g:neomake_tex_enabled_makers = []
let g:neomake_java_enabled_makers = []
let g:neomake_html_enabled_makers = []
let g:neomake_go_enabled_makers = ['golint']

hi NeomakeErrorSign ctermfg=white
hi NeomakeError term=underline ctermfg=darkgrey
