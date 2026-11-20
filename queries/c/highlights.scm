;; extends
; tanuki: @tanuki.* captures are only colored by tanuki-day (GitLab "Light");
; tanuki-night leaves them undefined, so they change nothing there.
; C++ inherits these through `; inherits: c`.

; GitLab colors a whole #define / #ifdef / #undef line as "meta" (grey bold).
((preproc_def) @tanuki.preproc
  (#set! priority 110))

((preproc_function_def) @tanuki.preproc
  (#set! priority 110))

((preproc_ifdef
  name: (identifier) @tanuki.preproc)
  (#set! priority 110))

((preproc_call) @tanuki.preproc
  (#set! priority 110))

; `struct name` and the names declared right after a bodiless struct type are
; highlight.js "titles" (dark red bold): struct char_class *cc;
(struct_specifier
  name: (type_identifier) @tanuki.title)

(union_specifier
  name: (type_identifier) @tanuki.title)

(enum_specifier
  name: (type_identifier) @tanuki.title)

(declaration
  type: [
    (struct_specifier !body)
    (union_specifier !body)
    (enum_specifier !body)
  ]
  declarator: [
    (identifier) @tanuki.title
    (pointer_declarator
      declarator: (identifier) @tanuki.title)
    (array_declarator
      declarator: (identifier) @tanuki.title)
    (init_declarator
      declarator: [
        (identifier) @tanuki.title
        (pointer_declarator
          declarator: (identifier) @tanuki.title)
        (array_declarator
          declarator: (identifier) @tanuki.title)
      ])
  ])

; libc functions are highlight.js built-ins.
(call_expression
  function: (identifier) @tanuki.builtin
  (#any-of? @tanuki.builtin
    "abort" "abs" "acos" "asin" "atan" "atan2" "calloc" "ceil" "cos" "cosh" "exit" "exp" "fabs"
    "floor" "fmod" "fprintf" "fputs" "free" "frexp" "fscanf" "isalnum" "isalpha" "iscntrl" "isdigit"
    "isgraph" "islower" "isprint" "ispunct" "isspace" "isupper" "isxdigit" "labs" "ldexp" "log"
    "log10" "malloc" "memchr" "memcmp" "memcpy" "memset" "modf" "pow" "printf" "putchar" "puts"
    "realloc" "scanf" "sin" "sinh" "snprintf" "sprintf" "sqrt" "sscanf" "strcat" "strchr" "strcmp"
    "strcpy" "strcspn" "strlen" "strncat" "strncmp" "strncpy" "strpbrk" "strrchr" "strspn" "strstr"
    "tan" "tanh" "tolower" "toupper" "vfprintf" "vprintf" "vsprintf"))

; tanuki-day: params behind pointers (`const char **sp`) are params too.
(parameter_declaration
  declarator: (pointer_declarator
    declarator: [
      (identifier) @tanuki.params
      (pointer_declarator
        declarator: (identifier) @tanuki.params)
    ]))
