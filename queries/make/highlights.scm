;; extends
; tanuki-day: a rule line (targets: prerequisites) is a highlight.js "section"
; (purple bold), .PHONY lines are "meta" (grey bold), $(VARS) stay teal on top.
((rule
  (targets) @tanuki.section)
  (#set! priority 105))

((rule
  (prerequisites) @tanuki.section)
  (#set! priority 105))

((rule
  (targets
    (word) @tanuki.preproc))
  (#eq? @tanuki.preproc ".PHONY")
  (#set! priority 106))

((rule
  (targets
    (word) @_target)
  (prerequisites) @tanuki.preproc)
  (#eq? @_target ".PHONY")
  (#set! priority 106))

((variable_reference) @tanuki.var
  (#set! priority 107))

((function_call) @tanuki.var
  (#set! priority 107))

; recipes are plain text in GitLab (no shell highlighting), $(VARS) still teal
((shell_text) @tanuki.plain
  (#set! priority 106))
