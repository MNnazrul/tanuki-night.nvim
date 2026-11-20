;; extends
; tanuki-day: a parameter with a type annotation is "attr" (teal) in highlight.js;
; untyped parameters stay "params" (blue).
((required_parameter
  pattern: (identifier) @tanuki.var
  type: (_))
  (#set! priority 105))

((optional_parameter
  pattern: (identifier) @tanuki.var
  type: (_))
  (#set! priority 105))

; tanuki-day: highlight.js colors PascalCase class references (imports, `new X`,
; `extends X`) slate, not bold.
((import_specifier
  name: (identifier) @tanuki.call)
  (#lua-match? @tanuki.call "^%u%l"))

((import_clause
  (identifier) @tanuki.call)
  (#lua-match? @tanuki.call "^%u%l"))

(new_expression
  constructor: (identifier) @tanuki.call)

(extends_clause
  value: (identifier) @tanuki.call)
