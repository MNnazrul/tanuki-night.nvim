local c = require("tanuki-night").colors()

local function mode(color)
  return {
    a = { fg = c.bg, bg = color, gui = "bold" },
    b = { fg = c.fg, bg = c.bg_hl },
    c = { fg = c.fg, bg = c.bg_alt },
  }
end

return {
  normal = mode(c.blue),
  insert = mode(c.green),
  visual = mode(c.purple),
  replace = mode(c.red),
  command = mode(c.yellow),
  terminal = mode(c.aqua),
  inactive = {
    a = { fg = c.line_nr, bg = c.bg_alt2 },
    b = { fg = c.line_nr, bg = c.bg_alt2 },
    c = { fg = c.line_nr, bg = c.bg_alt2 },
  },
}
