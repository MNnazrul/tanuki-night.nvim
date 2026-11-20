local config = require("tanuki-night.config")

local M = {}

function M.setup(opts)
  config.setup(opts)
end

--- Palette after user `on_colors` hook.
function M.colors()
  local c = vim.deepcopy(require("tanuki-night.palette"))
  if config.options.on_colors then
    config.options.on_colors(c)
  end
  return c
end

--- Full highlight table { Group = spec }.
function M.highlights()
  local o = config.options
  local c = M.colors()
  local hl = {}
  for _, mod in ipairs({ "editor", "syntax", "treesitter", "languages", "lsp", "plugins" }) do
    for k, v in pairs(require("tanuki-night.groups." .. mod)(c, o)) do
      hl[k] = v
    end
  end
  if o.on_highlights then
    o.on_highlights(hl, c)
  end
  return hl, c
end

--- The 16 ANSI colors (also used by extras/ terminal themes).
function M.terminal_colors(c)
  c = c or M.colors()
  return {
    c.bg_alt,
    c.red,
    c.green,
    c.yellow,
    c.blue,
    c.purple,
    c.aqua,
    c.fg,
    c.line_nr,
    c.red,
    c.green,
    c.yellow,
    c.blue,
    c.purple,
    c.aqua,
    "#eaeaea",
  }
end

function M.load()
  if vim.g.colors_name then
    vim.cmd("hi clear")
  end
  vim.o.termguicolors = true
  vim.o.background = "dark"
  vim.g.colors_name = "tanuki-night"

  local hl, c = M.highlights()
  require("tanuki-night.util").apply(hl)
  if config.options.terminal_colors then
    for i, col in ipairs(M.terminal_colors(c)) do
      vim.g["terminal_color_" .. (i - 1)] = col
    end
  end
end

return M
