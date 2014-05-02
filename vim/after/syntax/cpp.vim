syn keyword cppType string stringstream map vector pair
syn match cppDefinedClass "\(\s\|(\|<\)\@<=[A-Z]\w*"
syn match cppRawStringLiteral "R\"\(.*\)(\_.\{-})\1\""

hi link cppDefinedClass Identifier
hi link cppRawStringLiteral String
