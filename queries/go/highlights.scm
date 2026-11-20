;; extends
; tanuki-night: GitLab colors type conversions like string(s) as builtin types (yellow).

(call_expression
  function: (identifier) @type.builtin
  (#any-of? @type.builtin
    "string" "bool" "byte" "rune" "error" "any"
    "int" "int8" "int16" "int32" "int64"
    "uint" "uint8" "uint16" "uint32" "uint64" "uintptr"
    "float32" "float64" "complex64" "complex128"))
