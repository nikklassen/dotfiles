;; extends

((field_identifier) @property (#set! priority 128))

(call_expression
  function: (selector_expression
    field: (field_identifier) @function.method.call) (#set! priority 128))

(method_declaration
  name: (field_identifier) @function.method (#set! priority 128))

(method_elem
  name: (field_identifier) @function.method (#set! priority 128))
