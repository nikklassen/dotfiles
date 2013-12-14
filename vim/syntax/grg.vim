if exists("b:current_syntax")
  finish
endif

syntax match grgComment /%.*/
syntax match grgPragma /#[uaq] .*/
syntax match grgPragma /#check/
syntax match grgPragma /@/

syntax keyword grgType PROP PRED TP ND ST Z PC NONE

" Transformation Proof
syntax keyword grgLaw   comm assoc contr lem impl
syntax keyword grgLaw   contrapos simp1 distr dm
syntax keyword grgLaw   neg equiv idemp simp2
syntax keyword grgLaw   forall_over_and exists_over_or move_exists move_forall

" Natural Deduction
syntax keyword grgLaw   and_i and_e or_i or_e lem cases
syntax keyword grgLaw   imp_i imp_e raa not_e not_not_i not_not_e
syntax keyword grgLaw   iff_i iff_e iff_mp trans
syntax keyword grgLaw   forall_e forall_i exists_e exists_i

" Semantic Tableau
syntax keyword grgLaw   and_nb not_and_br or_br not_or_nb
syntax keyword grgLaw   imp_br not_imp_nb not_not_nb iff_br not_iff_br
syntax keyword grgLaw   closed
syntax keyword grgLaw   forall_nb not_forall_nb exists_nb not_exists_nb

" Assorted
syntax keyword grgLaw   set arith

syntax keyword grgStruct case assume disprove

syntax keyword grgOperator v U I
syntax match grgOperator "&"
syntax match grgOperator "<=>"
syntax match grgOperator "<==>"
syntax match grgOperator "<=\|>="
syntax match grgOperator "|="
syntax match grgOperator "=="
syntax match grgOperator "\."
syntax match grgOperator "|>\|<|"
syntax match grgOperator "(+)"
syntax match grgOperator "<-|\|-\@<!|->"

syntax region braces start="{" end="}" fold transparent
syntax cluster grg contains=ALL

syntax include @Z syntax/z.vim
syntax region zSnip start="#check Z" end="\%$" contains=@Z,@grg transparent


let b:current_syntax = "grg"

hi def link zSnip       Comment
hi def link grgComment  Comment
hi def link grgPragma   PreProc
hi def link grgStruct   Statement
hi def link grgType     Type
hi def link grgLaw      Special
hi def link grgOperator Operator
