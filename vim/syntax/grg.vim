if exists("b:current_syntax")
  finish
endif

syntax match grgComment /%.*/
syntax match grgPragma /#[uaq] .*/
syntax match grgPragma /#check/
syntax keyword grgType PROP PRED TP ND ST

" Transformation Proof
syntax keyword grgLaw   comm assoc contr lem impl
syntax keyword grgLaw   contrapos simp1 distr dm
syntax keyword grgLaw   neg equiv idemp simp2

" Natural Deduction
syntax keyword grgLaw   and_i and_e or_i or_e lem cases
syntax keyword grgLaw   imp_i imp_e raa not_e not_not_i not_not_e
syntax keyword grgLaw   iff_i iff_e iff_mp trans

" Semantic Tableau
syntax keyword grgLaw   and_nb not_and_br or_br not_or_nb
syntax keyword grgLaw   imp_br not_imp_nb not_not_nb iff_br not_iff_br
syntax keyword grgLaw   closed

syntax keyword grgStruct case assume disprove

syntax region braces start="{" end="}" fold transparent

let b:current_syntax = "grg"

hi def link grgComment  Comment
hi def link grgPragma   PreProc
hi def link grgStruct   Statement
hi def link grgType     Type
hi def link grgLaw      Special
