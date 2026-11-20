;; extends
; tanuki-day: highlight.js treats shell built-ins and GNU coreutils as built-ins (blue);
; a `for` loop variable stays plain.
((declaration_command
  [
    "local"
    "export"
    "declare"
    "readonly"
    "typeset"
  ] @tanuki.blue)
  (#set! priority 105))

((command_name
  (word) @tanuki.blue)
  (#any-of? @tanuki.blue
    "alias" "bind" "builtin" "caller" "cd" "command" "declare" "echo" "enable" "eval" "exec" "exit"
    "getopts" "hash" "help" "let" "printf" "pwd" "read" "readarray" "set" "shift" "source"
    "test" "times" "trap" "type" "ulimit" "umask" "unalias" "unset" "wait" "basename" "cat" "chmod"
    "chown" "cp" "cut" "date" "dirname" "du" "env" "expr" "false" "head" "id" "ln" "ls" "mkdir"
    "mktemp" "mv" "nproc" "printenv" "readlink" "realpath" "rm" "rmdir" "seq" "sleep" "sort" "split"
    "stat" "tail" "tee" "touch" "tr" "true" "uname" "uniq" "wc" "whoami" "yes")
  (#set! priority 105))

((for_statement
  variable: (variable_name) @tanuki.plain)
  (#set! priority 105))

