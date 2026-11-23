-- Generate extras/nvchad/tanuki-night.lua and tanuki-day.lua (base46 themes).
-- Run from repo root:  nvim --headless -u NONE -l scripts/gen_nvchad.lua
vim.opt.rtp:prepend(vim.fn.getcwd())

-- base46 slots that have no direct palette entry
local EXTRA = {
  night = {
    darker_black = "#191a1c",
    grey_fg2 = "#7a7b7d",
    baby_pink = "#d98080",
    pink = "#e6a0a0",
    line = "#313335",
    vibrant_green = "#c3cb74",
    sun = "#f5d48f",
    dark_purple = "#9a7da3",
    base04 = "#b4b7b4",
    base06 = "#e0e0e0",
    base07 = "#ffffff",
    base0F = "#a3685a",
  },
  day = {
    darker_black = "#f7f7f5",
    grey_fg2 = "#747273",
    baby_pink = "#e0566f",
    pink = "#f15168",
    line = "#ecebea",
    vibrant_green = "#129c84",
    sun = "#c27c00",
    dark_purple = "#5b46b8",
    base04 = "#646163",
    base06 = "#28272d",
    base07 = "#050408",
    base0F = "#990073",
  },
}

-- Default link a syntax file gives a legacy group (rustFuncCall -> Function).
local sourced = {}
local function default_link(group)
  local ft = group:match("^(%l+)%u")
  if ft and not sourced[ft] then
    sourced[ft] = true
    vim.cmd.runtime("syntax/" .. ft .. ".vim")
  end
  return vim.api.nvim_get_hl(0, { name = group, link = true }).link
end

for _, style in ipairs({ "night", "day" }) do
  local name = "tanuki-" .. style
  local x = EXTRA[style]
  local hl, c = require("tanuki-night").highlights(style)

  -- base46's <leader>tt sets the new theme's groups over the old ones without
  -- `hi clear`, so a group only the other style sets would keep its color after
  -- the toggle. Set it here to what this style shows without it: the nearest
  -- @capture parent (@function.call.c -> @function.call), or the syntax file's
  -- default link (rustFuncCall -> Function). Nothing to fall back to: clear it.
  local filled, cleared = {}, {}
  for k in pairs(require("tanuki-night").highlights(style == "night" and "day" or "night")) do
    if hl[k] == nil then
      local parent = k
      repeat
        parent = parent:match("^(@.+)%.[^.]+$") or default_link(parent)
      until not parent or hl[parent] ~= nil
      hl[k] = parent or {}
      filled[k], cleared[k] = true, parent == nil
    end
  end

  -- Resolve string links to concrete specs (base46 compiles plain tables).
  local function resolve(spec, depth)
    depth = depth or 0
    if type(spec) == "string" then
      return depth < 10 and resolve(hl[spec] or {}, depth + 1) or {}
    end
    if spec.link then
      return resolve(spec.link, depth + 1)
    end
    return spec
  end

  local editor_keep = {
    "Normal",
    "Visual",
    "LineNr",
    "CursorLineNr",
    "CursorLine",
    "Search",
    "IncSearch",
    "CurSearch",
    "MatchParen",
    "DiffAdd",
    "DiffDelete",
    "DiffChange",
    "DiffText",
    "Added",
    "Removed",
    "Changed",
    "WinSeparator",
    "Folded",
    "NonText",
    "Comment",
  }
  local syntax_keys = {
    "Comment",
    "Constant",
    "String",
    "Character",
    "Number",
    "Float",
    "Boolean",
    "Identifier",
    "Function",
    "Statement",
    "Conditional",
    "Repeat",
    "Label",
    "Keyword",
    "Exception",
    "Operator",
    "PreProc",
    "Include",
    "Define",
    "PreCondit",
    "Macro",
    "Type",
    "StorageClass",
    "Structure",
    "Typedef",
    "Special",
    "SpecialChar",
    "Tag",
    "Delimiter",
    "Debug",
    "Todo",
  }

  local function serialize(tbl, indent)
    local keys = vim.tbl_keys(tbl)
    table.sort(keys)
    local out = {}
    for _, k in ipairs(keys) do
      local spec = resolve(tbl[k])
      local fields = {}
      for _, f in ipairs({ "fg", "bg", "sp" }) do
        if spec[f] then
          fields[#fields + 1] = ("%s = %q"):format(f, spec[f])
        end
      end
      for _, f in ipairs({ "bold", "italic", "underline", "undercurl", "strikethrough", "nocombine" }) do
        if spec[f] then
          fields[#fields + 1] = f .. " = true"
        end
      end
      if #fields == 0 and (k:find("^@lsp") or k:find("^@tanuki") or cleared[k]) then
        fields[1] = 'link = "@none"' -- base46 merges tables, so an empty spec can't clear
      end
      out[#out + 1] = ("%s[%q] = { %s },"):format(indent, k, table.concat(fields, ", "))
    end
    return table.concat(out, "\n")
  end

  local treesitter, syntax, defaults, semantic = {}, {}, {}, {}
  for k, v in pairs(hl) do
    if k:find("^@lsp") then
      semantic[k] = v
      treesitter[k] = v -- semantic_tokens integration is opt-in in base46
    elseif k:find("^@") then
      treesitter[k] = v
    end
  end
  for _, k in ipairs(syntax_keys) do
    syntax[k] = hl[k]
  end
  -- legacy per-language groups (rustAttribute, ...) from groups/languages.lua
  for k in pairs(require("tanuki-night.groups.languages" .. (style == "day" and "_day" or ""))(c)) do
    if not k:find("^@") then
      syntax[k] = hl[k]
    end
  end
  -- ...and the other style's legacy groups filled in above
  for k in pairs(filled) do
    if not k:find("^@") then
      syntax[k] = hl[k]
    end
  end
  for _, k in ipairs(editor_keep) do
    defaults[k] = hl[k]
  end

  local lines = {
    ("-- %s for NvChad (base46). GENERATED by scripts/gen_nvchad.lua."):format(name),
    ("-- Copy to ~/.config/nvim/lua/themes/%s.lua, then pick it with <leader>th"):format(name),
    ('-- or set M.base46.theme = "%s" in chadrc.lua.'):format(name),
    "local M = {}",
    "",
    "M.base_30 = {",
    ("  white = %q,"):format(c.fg),
    ("  darker_black = %q,"):format(x.darker_black),
    ("  black = %q,"):format(c.bg),
    ("  black2 = %q,"):format(c.bg_alt2),
    ("  one_bg = %q,"):format(c.bg_alt),
    ("  one_bg2 = %q,"):format(c.bg_hl),
    ("  one_bg3 = %q,"):format(c.bg_button),
    ("  grey = %q,"):format(c.nontext),
    ("  grey_fg = %q,"):format(c.line_nr),
    ("  grey_fg2 = %q,"):format(x.grey_fg2),
    ("  light_grey = %q,"):format(c.comment),
    ("  red = %q,"):format(c.red),
    ("  baby_pink = %q,"):format(x.baby_pink),
    ("  pink = %q,"):format(x.pink),
    ("  line = %q,"):format(x.line),
    ("  green = %q,"):format(c.green),
    ("  vibrant_green = %q,"):format(x.vibrant_green),
    ("  nord_blue = %q,"):format(c.accent),
    ("  blue = %q,"):format(c.blue),
    ("  yellow = %q,"):format(c.yellow),
    ("  sun = %q,"):format(x.sun),
    ("  purple = %q,"):format(c.purple),
    ("  dark_purple = %q,"):format(x.dark_purple),
    ("  teal = %q,"):format(c.aqua),
    ("  orange = %q,"):format(c.orange),
    ("  cyan = %q,"):format(c.aqua),
    ("  statusline_bg = %q,"):format(c.bg_alt2),
    ("  lightbg = %q,"):format(c.bg_hl),
    ("  pmenu_bg = %q,"):format(c.accent),
    ("  folder_bg = %q,"):format(c.blue),
    "}",
    "",
    "M.base_16 = {",
    ("  base00 = %q,"):format(c.bg),
    ("  base01 = %q,"):format(c.bg_alt),
    ("  base02 = %q,"):format(c.visual),
    ("  base03 = %q,"):format(c.comment),
    ("  base04 = %q,"):format(x.base04),
    ("  base05 = %q,"):format(c.fg),
    ("  base06 = %q,"):format(x.base06),
    ("  base07 = %q,"):format(x.base07),
    ("  base08 = %q,"):format(c.red),
    ("  base09 = %q,"):format(c.orange),
    ("  base0A = %q,"):format(c.yellow),
    ("  base0B = %q,"):format(c.green),
    ("  base0C = %q,"):format(c.aqua),
    ("  base0D = %q,"):format(c.blue),
    ("  base0E = %q,"):format(c.purple),
    ("  base0F = %q,"):format(x.base0F),
    "}",
    "",
    ('M.type = "%s"'):format(style == "day" and "light" or "dark"),
    "",
    "M.polish_hl = {",
    "  defaults = {",
    serialize(defaults, "    "),
    "  },",
    "  syntax = {",
    serialize(syntax, "    "),
    "  },",
    "  treesitter = {",
    serialize(treesitter, "    "),
    "  },",
    "  semantic_tokens = {",
    serialize(semantic, "    "),
    "  },",
    "}",
    "",
    ('M = require("base46").override_theme(M, "%s")'):format(name),
    "",
    "return M",
  }

  vim.fn.mkdir("extras/nvchad", "p")
  vim.fn.writefile(vim.split(table.concat(lines, "\n"), "\n"), "extras/nvchad/" .. name .. ".lua")
  print("wrote extras/nvchad/" .. name .. ".lua")
end
