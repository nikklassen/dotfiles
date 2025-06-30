;; extends

; Override LSP priority
((identifier)
 @variable.builtin (#eq? @variable.builtin "self") (#set! priority 128))
