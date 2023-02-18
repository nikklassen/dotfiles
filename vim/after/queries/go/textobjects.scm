(literal_value
  "," @_start .
  (keyed_element
      _
      (_) @element.inner) @_end
  (#make-range! "element.outer" @_start @_end))

(literal_value
  . (keyed_element
      _
      (_) @element.inner) @_start
  . ","? @_end
  (#make-range! "element.outer" @_start @_end))
