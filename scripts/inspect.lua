-- Print the final color of each word in a file, as Treesitter + tanuki-night resolve it.
-- nvim --headless -u NONE -l scripts/inspect.lua <file> [extra-rtp]
local file, extra = _G.arg[1], _G.arg[2]
vim.opt.rtp:prepend(vim.fn.getcwd())
if extra then
  vim.opt.rtp:append(extra)
end
vim.cmd("filetype on")
vim.cmd("colorscheme tanuki-night")
vim.cmd("edit " .. file)
local ok = pcall(vim.treesitter.start)
if not ok then
  print("no parser for " .. vim.bo.filetype)
  return
end
vim.treesitter.get_parser():parse(true)

local p = require("tanuki-night.palette")
local names = {}
for k, v in pairs(p) do
  names[v:lower()] = names[v:lower()] or k
end

local function color(group)
  local h = vim.api.nvim_get_hl(0, { name = group, link = false })
  return h.fg and string.format("#%06x", h.fg) or nil
end

for row, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, -1, false)) do
  local parts = {}
  for s, word in line:gmatch("()([%w_#@%.%$:'\"]+)") do
    local caps = vim.treesitter.get_captures_at_pos(0, row - 1, s - 1)
    local fg
    -- highest priority wins; among equal priority the later capture wins
    table.sort(caps, function(a, b)
      return (tonumber(a.metadata.priority) or 100) < (tonumber(b.metadata.priority) or 100)
    end)
    for _, cap in ipairs(caps) do
      local g = "@" .. cap.capture .. "." .. cap.lang
      fg = color(g) or fg
    end
    fg = fg or color("Normal")
    parts[#parts + 1] = word .. "=" .. (names[fg] or fg)
  end
  print(row .. ": " .. table.concat(parts, "  "))
end
