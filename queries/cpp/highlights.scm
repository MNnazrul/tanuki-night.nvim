;; extends
; tanuki-day: `Application::create(` is one title (dark red bold); `auto` is a keyword;
; `new Foo(` is a call (slate).
((function_declarator
  declarator: (qualified_identifier) @tanuki.title)
  (#set! priority 105))

((auto) @tanuki.keyword
  (#set! priority 105))

((new_expression
  type: (type_identifier) @tanuki.call)
  (#set! priority 105))
