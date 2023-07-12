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
