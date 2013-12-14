syn keyword cppType string stringstream map vector pair
syn match cppDefinedClass "\(\s\|(\|<\)\@<=[A-Z]\w*"
hi link cppDefinedClass Identifier
