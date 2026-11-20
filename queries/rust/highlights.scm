;; extends
; tanuki-night: GitLab colors Rust prelude types like builtins (yellow),
; `let` bindings red, and Some/None/Ok/Err red.

((type_identifier) @type.builtin
  (#any-of? @type.builtin "Option" "Result" "Vec" "String" "Box" "HashMap" "HashSet"))

(let_declaration
  pattern: (identifier) @variable.let)

(let_declaration
  pattern: (mut_pattern (identifier) @variable.let))

(struct_item
  name: (type_identifier) @type.definition)

(enum_item
  name: (type_identifier) @type.definition)

((identifier) @variable.builtin
  (#any-of? @variable.builtin "Some" "None" "Ok" "Err"))

; Whole attribute grey like a comment (GitLab), above inner captures.
((attribute_item) @attribute
  (#set! priority 105))

((inner_attribute_item) @attribute
  (#set! priority 105))

((type_identifier) @keyword
  (#eq? @keyword "Self"))
