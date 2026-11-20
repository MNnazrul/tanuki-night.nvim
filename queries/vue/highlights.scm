;; extends
; tanuki-day: GitLab (highlight.js xml) shows directive values as plain strings
; (red) and {{ interpolations }} as plain text, over the injected JavaScript.
((directive_attribute
  (quoted_attribute_value
    (attribute_value) @tanuki.string))
  (#set! priority 110))

((interpolation
  (raw_text) @tanuki.plain)
  (#set! priority 110))

; top-level <template> / <script> / <style> tags are plain; inner tags navy
((template_element
  [
    (start_tag
      (tag_name) @tanuki.plain)
    (end_tag
      (tag_name) @tanuki.plain)
  ])
  (#set! priority 105))

((script_element
  [
    (start_tag
      (tag_name) @tanuki.plain)
    (end_tag
      (tag_name) @tanuki.plain)
  ])
  (#set! priority 105))

((style_element
  [
    (start_tag
      (tag_name) @tanuki.plain)
    (end_tag
      (tag_name) @tanuki.plain)
  ])
  (#set! priority 105))
