;; extends
; tanuki-day: `function utils.print()` - the whole name is a title (dark red bold).
((function_declaration
  name: (_) @tanuki.title)
  (#set! priority 105))

; highlight.js marks these names as built-ins wherever they appear.
((identifier) @tanuki.builtin
  (#any-of? @tanuki.builtin
    "assert" "collectgarbage" "dofile" "error" "getmetatable" "ipairs" "load" "loadfile" "next"
    "pairs" "pcall" "print" "rawequal" "rawget" "rawset" "require" "select" "setmetatable" "tonumber"
    "tostring" "type" "unpack" "xpcall" "coroutine" "debug" "io" "math" "os" "package" "string"
    "table" "close" "flush" "lines" "open" "output" "input" "read" "write" "stderr" "stdin" "stdout"
    "popen" "tmpfile" "abs" "ceil" "floor" "huge" "max" "min" "pi" "random" "sqrt" "clock" "date"
    "difftime" "execute" "exit" "getenv" "remove" "rename" "time" "byte" "char" "find" "format"
    "gmatch" "gsub" "len" "lower" "match" "rep" "reverse" "sub" "upper" "concat" "insert" "sort"))
