syn keyword cppType string stringstream map vector pair
syn match cppDefinedClass "\(\s\|(\|<\)\@<=[A-Z]\w*"
syn match cppRawStringLiteral "R\"\(.*\)(\_.\{-})\1\""

highlight cppMember ctermfg=78 guifg=#5fd787
syn match cppMember "\<\(m_\w\+\|\w\+_\w\@!\)\>"

hi link cppDefinedClass Identifier
hi link cppRawStringLiteral String
