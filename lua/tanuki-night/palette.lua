-- tanuki-night palette.
-- Syntax colors: canonical Tomorrow Night (what GitLab's "Dark" syntax theme uses).
-- UI colors: sampled from GitLab dark-mode screenshots (images/, images/round2/).
local M = {
  -- base
  bg = "#1d1f21",
  bg_dark = "#161719",
  bg_alt = "#28272d", -- GitLab file header bar, dropdowns, floats
  bg_alt2 = "#232227", -- inactive bars
  bg_hl = "#3a373e", -- dropdown hover / selected item
  bg_button = "#4f4e53",
  cursorline = "#25272a",
  visual = "#2e3a4a", -- GitLab text selection
  border = "#3a373e",

  fg = "#c5c8c6",
  fg_dim = "#a2a4a2",
  comment = "#969896",
  line_nr = "#616264",
  nontext = "#45474a",
  cursorline_nr_bg = "#453793",
  cursorline_nr_fg = "#7d73b3",

  -- syntax
  red = "#cc6666",
  orange = "#de935f",
  yellow = "#f0c674",
  green = "#b5bd68",
  aqua = "#8abeb7",
  blue = "#81a2be",
  purple = "#b294bb",

  -- accents (GitLab UI)
  accent = "#5d87c3", -- focused input / links in UI
  line_target = "#753217", -- GitLab #L-anchor highlighted line

  -- diff (GitLab diff viewer)
  diff_add = "#283627",
  diff_add_text = "#3a5836",
  diff_delete = "#462627",
  diff_delete_text = "#6b3030",
  diff_change = "#28303a",
  diff_filler = "#28272d",
  hunk_header = "#353638",
}

return M
