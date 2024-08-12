;; extends

; Override LSP priority
((simple_identifier) @constant
  (#lua-match? @constant "^[A-Z][A-Z0-9_]*$") (#set! priority 128))

