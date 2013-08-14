syn keyword cppType string
syn match cppDefinedClass "\(\s\|(\|<\)\@<=[A-Z]\w*"
hi link cppDefinedClass Identifier
