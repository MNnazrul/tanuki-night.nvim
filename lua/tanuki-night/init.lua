local config = require("tanuki-night.config")

local M = {}

--- Current release, updated by release-please.
M.version = "1.0.0" -- x-release-please-version

function M.setup(opts)
  config.setup(opts)
end

M.styles = { night = true, day = true }

local function resolve(style)
  style = style or config.options.style or (vim.g.colors_name == "tanuki-day" and "day" or "night")
  assert(M.styles[style], "tanuki-night: unknown style " .. tostring(style))
  return style
end

--- Palette after user `on_colors` hook. style: "night" (default) or "day".
function M.colors(style)
  style = resolve(style)
  local c = vim.deepcopy(require(style == "day" and "tanuki-night.palette_day" or "tanuki-night.palette"))
  if config.options.on_colors then
    config.options.on_colors(c, style)
  end
  return c
end

--- Full highlight table { Group = spec } for a style.
function M.highlights(style)
  style = resolve(style)
  local o = config.options
  local c = M.colors(style)
  local suffix = style == "day" and "_day" or ""
  local hl = {}
  for _, mod in ipairs({ "editor", "syntax" .. suffix, "treesitter" .. suffix, "languages" .. suffix, "lsp", "plugins" }) do
    for k, v in pairs(require("tanuki-night.groups." .. mod)(c, o)) do
      hl[k] = v
    end
  end
  if o.on_highlights then
    o.on_highlights(hl, c, style)
  end
  return hl, c
end

--- The 16 ANSI colors (also used by extras/ terminal themes).
function M.terminal_colors(c, style)
  style = resolve(style)
  c = c or M.colors(style)
  if style == "day" then
    -- light: ANSI black must stay dark, white light
    return {
      c.fg,
      c.red,
      c.green,
      c.yellow,
      c.blue,
      c.purple,
      c.aqua,
      c.bg_button,
      c.fg_dim,
      c.red,
      c.green,
      c.yellow,
      c.blue,
      c.purple,
      c.aqua,
      c.bg_dark,
    }
  end
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

--- Apply the colorscheme. style: "night" (tanuki-night) or "day" (tanuki-day).
function M.load(style)
  style = resolve(style)
  if vim.g.colors_name then
    vim.cmd("hi clear")
  end
  vim.o.termguicolors = true
  vim.o.background = style == "day" and "light" or "dark"
  vim.g.colors_name = style == "day" and "tanuki-day" or "tanuki-night"

  local hl, c = M.highlights(style)
  require("tanuki-night.util").apply(hl)
  if config.options.terminal_colors then
    for i, col in ipairs(M.terminal_colors(c, style)) do
      vim.g["terminal_color_" .. (i - 1)] = col
    end
  end
end

return M
