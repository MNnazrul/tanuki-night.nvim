-- Smoke tests. Run from repo root:  nvim --headless -u NONE -l tests/run.lua
vim.opt.rtp:prepend(vim.fn.getcwd())

local failures = 0
local function check(name, cond, msg)
  if cond then
    print("ok   " .. name)
  else
    failures = failures + 1
    print("FAIL " .. name .. (msg and (": " .. msg) or ""))
  end
end

local function fg(group)
  local h = vim.api.nvim_get_hl(0, { name = group, link = false })
  return h.fg and ("#%06x"):format(h.fg)
end
local function bg(group)
  local h = vim.api.nvim_get_hl(0, { name = group, link = false })
  return h.bg and ("#%06x"):format(h.bg)
end

-- loads without errors
local ok, err = pcall(vim.cmd.colorscheme, "tanuki-night")
check("colorscheme loads", ok, err)
check("colors_name", vim.g.colors_name == "tanuki-night")

-- GitLab dark mapping
local c = require("tanuki-night").colors()
check("Normal bg", bg("Normal") == c.bg)
check("Normal fg", fg("Normal") == c.fg)
check("@keyword purple", fg("@keyword") == c.purple)
check("@function blue", fg("@function") == c.blue)
check("@type yellow", fg("@type") == c.yellow)
check("@string green", fg("@string") == c.green)
check("@number orange", fg("@number") == c.orange)
check("@comment grey", fg("@comment") == c.comment)
check("C modifier yellow", fg("@keyword.modifier.c") == c.yellow)
check("CursorLineNr GitLab purple", bg("CursorLineNr") == c.cursorline_nr_bg)
check("LSP semantic tokens cleared", vim.tbl_isempty(vim.api.nvim_get_hl(0, { name = "@lsp.type.variable" })))
check("terminal colors", vim.g.terminal_color_1 == c.red)

-- options
require("tanuki-night").setup({ transparent = true, styles = { comments = { italic = true } } })
vim.cmd.colorscheme("tanuki-night")
check("transparent", bg("Normal") == nil)
check("italic comments", vim.api.nvim_get_hl(0, { name = "Comment", link = false }).italic == true)
require("tanuki-night").setup({
  on_colors = function(col)
    col.red = "#ff0000"
  end,
})
vim.cmd.colorscheme("tanuki-night")
check("on_colors", fg("@constant") == "#ff0000")
require("tanuki-night").setup({})

-- extras load
check("lualine theme", pcall(require, "lualine.themes.tanuki-night"))
local nvchad = loadfile("extras/nvchad/tanuki-night.lua")
check("nvchad theme parses", nvchad ~= nil)

-- every group spec is valid
local hl = require("tanuki-night").highlights()
local bad = {}
for name, spec in pairs(hl) do
  if type(spec) ~= "string" and type(spec) ~= "table" then
    bad[#bad + 1] = name
  end
end
check("group specs valid", #bad == 0, table.concat(bad, ", "))

print(("\n%d failure(s)"):format(failures))
if failures > 0 then
  os.exit(1)
end
