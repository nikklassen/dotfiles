let g:syntastic_mode_map = { 'passive_filetypes': ['tex', 'haskell'] }
let g:syntastic_auto_loc_list = 1
let g:syntastic_aggregate_errors = 1

let g:syntastic_less_checkers = ['lessc']

let g:syntastic_cpp_checkers = ['clang']
let g:syntastic_cpp_clang_args = "-std=c++11 -isystem ~/Programming/C++/gtest/include"

let g:syntastic_javascript_checkers = ['jshint', 'jscs']

let g:syntastic_typescript_checkers = ['tsc', 'tslint']
let g:syntastic_typescript_tsc_args = ' -t "es5" --noImplicitAny --module commonjs'

let g:syntastic_python_checkers = ['pylint']

let g:syntastic_html_checkers = []

let g:syntastic_scala_checkers = ['fsc']

let g:syntastic_check_on_wq = 0
let g:syntastic_ignore_files = ['\.h$']
