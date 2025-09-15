;; extends

(literal_value
  "," @field.outer
  .
  (keyed_element
      _
      (_) @field.inner) @field.outer)

(literal_value
  (keyed_element
      _
      (_) @field.inner) @field.outer
  . ","? @field.outer)

(method_elem) @field.inner @field.outer

(composite_literal
  type: (slice_type)
  body: (literal_value "," @field.outer . (literal_element) @field.inner @field.outer))

(composite_literal
  type: (slice_type)
  body: (literal_value (literal_element) @field.inner @field.outer . ","? @field.outer))

(return_statement
  (expression_list
    "," @parameter.outer .
    _ @parameter.outer))

(return_statement
  (expression_list
    . _ @parameter.outer
    . ","? @parameter.outer))

(unary_expression "&" (composite_literal)) @struct
(composite_literal) @struct

(
 (comment)+
 . (function_declaration)
) @function.outer

(generic_type type: (_) type_arguments: (_) @type.inner) @type.outer
