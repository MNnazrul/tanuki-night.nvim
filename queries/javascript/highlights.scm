;; extends
; tanuki-day: highlight.js only marks params of functions/arrows, not of object
; methods like `showFeedback(icon, message) {`.
((method_definition
  parameters: (formal_parameters
    [
      (identifier) @tanuki.plain
      (assignment_pattern
        left: (identifier) @tanuki.plain)
    ]))
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

(class_heritage
  (identifier) @tanuki.call)
