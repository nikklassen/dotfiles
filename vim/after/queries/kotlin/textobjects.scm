;; extends

(call_expression
  (navigation_expression (_) (navigation_suffix) @_start)
  (call_suffix) @_end
  (#make-range! "call.outer" @_start @_end))

(call_expression (simple_identifier) (call_suffix)) @call.outer

(call_suffix (value_arguments (value_argument _ @call.inner)))
(call_suffix (annotated_lambda (lambda_literal _ @call.inner)))

(property_declaration _ _ ["*=" "+=" "-=" "="] _ @assignment.rhs) @assignment.outer
(assignment _ ["*=" "+=" "-=" "="] _ @assignment.rhs) @assignment.outer
