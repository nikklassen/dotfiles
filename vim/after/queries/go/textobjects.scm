;; extends

(literal_value
  "," @_field_start .
  (keyed_element
      _
      (_) @field.inner) @_field_end
  (#make-range! "field.outer" @_field_start @_field_end))

(literal_value
  (keyed_element
      _
      (_) @field.inner) @_field_start
  . ","? @_field_end
  (#make-range! "field.outer" @_field_start @_field_end))

(method_spec) @field.inner @field.outer

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
