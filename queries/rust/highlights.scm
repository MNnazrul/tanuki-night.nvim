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

; tanuki-day: names after impl / type / trait are classes (bold slate) in Rouge.
(impl_item
  trait: (type_identifier) @tanuki.class)

(impl_item
  type: (type_identifier) @tanuki.class)

(type_item
  name: (type_identifier) @tanuki.class)

(trait_item
  name: (type_identifier) @tanuki.class)

(abstract_type
  trait: (type_identifier) @tanuki.class)

; tanuki-day: Rouge's Rust built-in traits and types (bold slate) wherever they appear.
([
  (identifier)
  (type_identifier)
] @tanuki.class
  (#any-of? @tanuki.class
    "Copy" "Send" "Sized" "Sync" "Drop" "Fn" "FnMut" "FnOnce" "ToOwned" "Clone" "PartialEq"
    "PartialOrd" "Eq" "Ord" "AsRef" "AsMut" "Into" "From" "Default" "Iterator" "Extend"
    "IntoIterator" "DoubleEndedIterator" "ExactSizeIterator" "ToString"))

; tanuki-day: the whole #[...] attribute is grey bold, above the built-in names inside it.
((attribute_item) @tanuki.attribute
  (#set! priority 120))

((inner_attribute_item) @tanuki.attribute
  (#set! priority 120))
