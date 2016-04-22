let s:abbrevs = [
            \ ['functioN', 'function'],
            \ ['widht', 'width'],
            \ ['heigth', 'height'],
            \ ]

for [lhs, rhs] in s:abbrevs
    exe "abbrev" lhs rhs
endfor
