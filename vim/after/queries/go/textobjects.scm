;; extends

(literal_value
  "," @_element_start .
  (keyed_element
      _
      (_) @element.inner) @_element_end
  (#make-range! "element.outer" @_element_start @_element_end))

(literal_value
  . (keyed_element
      _
      (_) @element.inner) @_element_start
  . ","? @_element_end
  (#make-range! "element.outer" @_element_start @_element_end))

(return_statement
  (expression_list
    "," @_start .
    _ @_end
    (#make-range! "parameter.outer" @_start @_end)))

(return_statement
  (expression_list
    . _ @_start
    . ","? @_end
    (#make-range! "parameter.outer" @_start @_end)))

(unary_expression "&" (composite_literal)) @struct
(composite_literal) @struct

;; assignments
(short_var_declaration
  left: (_) @assignment.lhs
  right: (_) @assignment.rhs @assignment.inner) @assignment.outer
(assignment_statement
  left: (_) @assignment.lhs
  right: (_) @assignment.rhs @assignment.inner) @assignment.outer
(var_spec
  name: (_) @assignment.lhs
  value: (_) @assignment.rhs @assignment.inner)
(var_spec
  name: (_) @assignment.inner
  type: (_))
(var_spec) @assignment.outer
(const_spec
  name: (_) @assignment.lhs
  value: (_) @assignment.rhs @assignment.inner)
(const_spec
  name: (_) @assignment.inner
  type: (_))
(const_spec) @assignment.outer
