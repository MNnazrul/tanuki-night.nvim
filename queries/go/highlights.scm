;; extends
; tanuki-night: GitLab colors type conversions like string(s) as builtin types (yellow).

(call_expression
  function: (identifier) @type.builtin
  (#any-of? @type.builtin
    "string" "bool" "byte" "rune" "error" "any"
    "int" "int8" "int16" "int32" "int64"
    "uint" "uint8" "uint16" "uint32" "uint64" "uintptr"
    "float32" "float64" "complex64" "complex128"))

; tanuki-day: in a method, highlight.js colors only the receiver as params; the
; method name and its parameters stay plain.
((method_declaration
  receiver: (parameter_list) @tanuki.params)
  (#set! priority 105))

((method_declaration
  name: (field_identifier) @tanuki.plain)
  (#set! priority 105))

((method_declaration
  parameters: (parameter_list
    (parameter_declaration
      name: (identifier) @tanuki.plain)))
  (#set! priority 105))
