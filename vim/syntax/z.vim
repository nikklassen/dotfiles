syntax keyword zRegion begin end pred schema

syntax match zVar "\v[a-zA-Z]+(\?|\!)"

syntax match zOperator "@"
syntax match zOperator ">\?-|\?->>\?"

syntax keyword zType Delta Chi Xi

hi def link zRegion     PreProc
hi def link zVar        Identifier
hi def link zOperator   Operator
hi def link zComment    Comment
hi def link zType       Type
