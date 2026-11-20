-- tanuki-day palette.
-- Syntax colors: GitLab's "Light" (white) syntax theme, exact values from
-- app/assets/stylesheets/highlight/_white_base.scss (pygments "github" style).
-- UI colors: GitLab Pajamas tokens used by that theme, checked against images/light/.
local M = {
  -- base
  bg = "#ffffff",
  bg_dark = "#f7f7f5", -- neutral-10
  bg_alt = "#fbfbfd", -- file header bar, floats
  bg_alt2 = "#f7f7f5", -- inactive bars
  bg_hl = "#ecebea", -- neutral-50: dropdown hover / selected item, hunk header
  bg_button = "#dcdbd9", -- neutral-100
  cursorline = "#f8f8f8", -- $white-hll-bg
  visual = "#d3e3f4", -- $white-code-mark (GitLab line/text mark)
  border = "#dcdbd9", -- --code-border-color

  fg = "#3a383d", -- $white-code-color (neutral-800)
  fg_dim = "#646163", -- neutral-600
  comment = "#999988", -- $white-c
  line_nr = "#8a8888", -- neutral-400 (diff line numbers)
  nontext = "#c1bfbe", -- neutral-200
  cursorline_nr_bg = "#e1daf7", -- purple-100 (line-number-hover)
  cursorline_nr_fg = "#5b46b8", -- purple-700

  -- UI hues (diagnostics, git signs, plugins), readable on white
  red = "#c52042", -- red-600
  orange = "#c95d2e",
  yellow = "#9e5400",
  green = "#0d8070", -- green-500
  aqua = "#008080",
  blue = "#1f73ca", -- blue-500
  purple = "#6a54c0", -- purple-600

  -- syntax (GitLab white theme)
  syn_keyword = "#3a383d", -- keywords: code color + bold
  syn_preproc = "#999999", -- $white-cp: #include, decorators (bold)
  syn_string = "#dd1144", -- $white-s
  syn_number = "#009999", -- $white-m
  syn_func = "#990000", -- $white-nf (bold)
  syn_type = "#445588", -- $white-kt / $white-nc (bold)
  syn_builtin = "#0086b3", -- $white-nb: params, literals, this/self
  syn_teal = "#008080", -- $white-na / nv / no: attributes, variables, constants
  syn_symbol = "#990073", -- $white-ss
  syn_regex = "#009926", -- $white-sr
  syn_heading = "#800080", -- $white-gh (bold)
  syn_tag = "#000080", -- $white-nt
  syn_namespace = "#555555", -- $white-nn
  syn_quote = "#aa0000", -- $white-gt

  -- accents (GitLab UI)
  accent = "#1f73ca", -- blue-500
  line_target = "#c8e0f9", -- blue-100; blended to blue-50 for the #L line
  search = "#fafe3d", -- $white-highlight (search match)

  -- diff (GitLab diff viewer, framework/variables.scss)
  diff_add = "#ecfdf0", -- $line-added
  diff_add_text = "#c7f0d2", -- $line-added-dark
  diff_delete = "#fbe9eb", -- $line-removed
  diff_delete_text = "#fac5cd", -- $line-removed-dark
  diff_change = "#e8f2fd", -- blue-50
  diff_filler = "#f7f7f5",
  hunk_header = "#ecebea", -- neutral-50
}

return M
