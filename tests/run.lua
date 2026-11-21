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
check(
  "version is semver",
  type(require("tanuki-night").version) == "string" and require("tanuki-night").version:match("^%d+%.%d+%.%d+$") ~= nil
)

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

-- tanuki-day (GitLab "Light")
ok, err = pcall(vim.cmd.colorscheme, "tanuki-day")
check("day loads", ok, err)
check("day colors_name", vim.g.colors_name == "tanuki-day")
check("day background", vim.o.background == "light")
local d = require("tanuki-night").colors("day")
local function bold(group)
  return vim.api.nvim_get_hl(0, { name = group, link = false }).bold == true
end
check("day Normal", bg("Normal") == "#ffffff" and fg("Normal") == d.fg)
check("day keyword bold text color", fg("@keyword") == d.fg and bold("@keyword"))
check("day function #900 bold", fg("@function") == "#990000" and bold("@function"))
check("day type #458 bold", fg("@type") == "#445588" and bold("@type"))
check("day string #d14", fg("@string") == "#dd1144")
check("day number #099", fg("@number") == "#009999")
check("day comment #998 italic", fg("@comment") == "#999988")
check("day param #0086b3", fg("@variable.parameter") == "#0086b3")
check("day C static is a type", fg("@keyword.modifier.c") == "#445588")
check("day #define meta", fg("@tanuki.preproc") == "#999999" and bold("@tanuki.preproc"))
check("day diff added", bg("DiffAdd") == "#ecfdf0")
check("day terminal black is dark", vim.g.terminal_color_0 == d.fg)

-- :set background switches between the two
vim.o.background = "dark"
check("bg=dark -> night", vim.g.colors_name == "tanuki-night" and bg("Normal") == c.bg)
vim.o.background = "light"
check("bg=light -> day", vim.g.colors_name == "tanuki-day")
check(
  "night leaves @tanuki.* empty",
  (function()
    vim.cmd.colorscheme("tanuki-night")
    return vim.tbl_isempty(vim.api.nvim_get_hl(0, { name = "@tanuki.preproc" }))
  end)()
)

-- extras load
check("lualine theme", pcall(require, "lualine.themes.tanuki-night"))
check("lualine day theme", pcall(require, "lualine.themes.tanuki-day"))
check("nvchad theme parses", loadfile("extras/nvchad/tanuki-night.lua") ~= nil)
check("nvchad day theme parses", loadfile("extras/nvchad/tanuki-day.lua") ~= nil)

-- nearest xterm-256 colors (used for cterm colors in colors/*.vim)
do
  local to_256 = require("tanuki-night.util").to_256
  check("to_256 black and white", to_256("#000000") == 16 and to_256("#ffffff") == 231)
  check("to_256 grey stays grey", to_256("#808080") == 244)
  check("to_256 tinted stays tinted", to_256("#ecfdf0") == 194 and to_256("#283627") < 232)
  check("to_256 avoid", to_256("#ffffff", 231) ~= 231 and to_256("#ffffff", { [231] = true }) ~= 231)
end

-- every group spec is valid, every link target exists
for _, style in ipairs({ "night", "day" }) do
  local hl = require("tanuki-night").highlights(style)
  local bad = {}
  for name, spec in pairs(hl) do
    local target = type(spec) == "string" and spec or (type(spec) == "table" and spec.link)
    if type(spec) ~= "string" and type(spec) ~= "table" then
      bad[#bad + 1] = name
    elseif target and not hl[target] and vim.tbl_isempty(vim.api.nvim_get_hl(0, { name = target })) then
      bad[#bad + 1] = name .. "->" .. target
    end
  end
  check(style .. " group specs valid", #bad == 0, table.concat(bad, ", "))
end

-- every @tanuki.* capture used in queries/ has a tanuki-day group
do
  local day = require("tanuki-night").highlights("day")
  local missing = {}
  for _, file in ipairs(vim.fn.glob("queries/*/highlights.scm", true, true)) do
    for line in io.lines(file) do
      if not line:match("^%s*;") then
        for cap in line:gmatch("@(tanuki[%w%._]*)") do
          local name, found = cap, false
          while name do -- Neovim falls back from @a.b.c to @a.b to @a
            if day["@" .. name] then
              found = true
              break
            end
            name = name:match("^(.*)%.[^.]+$")
          end
          if not found and not vim.tbl_contains(missing, cap) then
            missing[#missing + 1] = cap
          end
        end
      end
    end
  end
  check("day colors every @tanuki capture", #missing == 0, table.concat(missing, ", "))
end

print(("\n%d failure(s)"):format(failures))
if failures > 0 then
  os.exit(1)
end
