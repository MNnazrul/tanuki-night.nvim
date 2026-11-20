local M = {}

M.defaults = {
  -- Don't set a background on Normal / NormalNC / SignColumn etc.
  transparent = false,
  -- Set vim.g.terminal_color_* for :terminal.
  terminal_colors = true,
  -- Highlight styles (any nvim_set_hl attrs: italic, bold, underline...).
  styles = {
    comments = {},
    keywords = {},
    functions = {},
    strings = {},
  },
  -- Use GitLab's orange "#L anchor" color for the cursor line instead of a subtle grey.
  gitlab_cursorline = false,
  -- Dim inactive windows (uses bg_dark for NormalNC).
  dim_inactive = false,
  -- fun(colors) -> nil : mutate the palette before highlights are built.
  on_colors = nil,
  -- fun(hl, colors) -> nil : mutate/extend the highlight table.
  on_highlights = nil,
}

M.options = vim.deepcopy(M.defaults)

function M.setup(opts)
  M.options = vim.tbl_deep_extend("force", vim.deepcopy(M.defaults), opts or {})
end

return M
