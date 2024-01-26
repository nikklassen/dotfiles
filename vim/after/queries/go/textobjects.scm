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

(composite_literal
  type: (slice_type)
  body: (literal_value "," @_start . (literal_element) @field.inner)
(#make-range! "field.outer" @_start @field.inner))

(composite_literal
  type: (slice_type)
  body: (literal_value (literal_element) @field.inner . ","? @_end)
(#make-range! "field.outer" @field.inner @_end))

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
